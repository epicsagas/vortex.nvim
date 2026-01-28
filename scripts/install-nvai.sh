#!/usr/bin/env bash
#
# install-nvai.sh - Install and configure nvim-ai CLI integration
#
# This script helps you set up the nvim-ai system with your preferred AI providers

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Functions
print_header() {
  echo -e "\n${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}$1${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() { echo -e "${GREEN}✓${NC} $*"; }
print_info() { echo -e "${BLUE}ℹ${NC} $*"; }
print_warn() { echo -e "${YELLOW}⚠${NC} $*"; }
print_error() { echo -e "${RED}✗${NC} $*"; }

prompt_yn() {
  local prompt="$1"
  local default="${2:-n}"

  if [[ "$default" == "y" ]]; then
    read -p "$(echo -e "${prompt} [Y/n]: ")" -n 1 -r
  else
    read -p "$(echo -e "${prompt} [y/N]: ")" -n 1 -r
  fi
  echo

  if [[ -z "$REPLY" ]]; then
    [[ "$default" == "y" ]]
  else
    [[ $REPLY =~ ^[Yy]$ ]]
  fi
}

check_command() {
  command -v "$1" &> /dev/null
}

# Main installation
print_header "nvim-ai CLI Integration Setup"

# Step 1: Check prerequisites
print_info "Checking prerequisites..."

if ! check_command nvim; then
  print_error "Neovim not found. Please install Neovim first."
  exit 1
fi
print_success "Neovim found"

# Check for jq (required for JSON processing)
if ! check_command jq; then
  print_warn "jq not found (recommended for API mode)"
  if prompt_yn "Install jq?"; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
      brew install jq
    elif [[ -f /etc/debian_version ]]; then
      sudo apt-get install -y jq
    else
      print_error "Please install jq manually"
    fi
  fi
fi

# Install ACP adapters by default (enables CLI mode for supported providers)
print_header "Installing ACP Adapters"

# Claude Code ACP adapter
if ! check_command claude-code-acp; then
  print_info "Installing Claude Code ACP adapter..."
  npm install -g @zed-industries/claude-code-acp || {
    print_warn "Failed to install claude-code-acp (non-critical)"
  }
else
  print_success "Claude Code ACP adapter already installed"
fi

# Gemini CLI with native ACP support
if ! check_command gemini; then
  print_info "Installing Gemini CLI with ACP support..."
  npm install -g @google/gemini-cli || {
    print_warn "Failed to install gemini-cli (non-critical)"
  }
else
  print_success "Gemini CLI already installed"
fi

# Step 2: Initialize configuration
print_header "Configuration Setup"

NVIM_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
NVAI_SCRIPT="$NVIM_CONFIG/scripts/nvai"

if [[ ! -x "$NVAI_SCRIPT" ]]; then
  print_error "nvai script not found or not executable"
  print_info "Expected location: $NVAI_SCRIPT"
  exit 1
fi

CONFIG_FILE="$NVIM_CONFIG/config/nvim-ai-config.yaml"
CONFIG_TEMPLATE="$NVIM_CONFIG/config/nvim-ai-config.yaml.default"

# Try to find template in repo
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_TEMPLATE=""
if [[ -f "$SCRIPT_DIR/../config/nvim-ai-config.yaml.default" ]]; then
  REPO_TEMPLATE="$SCRIPT_DIR/../config/nvim-ai-config.yaml.default"
elif [[ -f "$CONFIG_TEMPLATE" ]]; then
  REPO_TEMPLATE="$CONFIG_TEMPLATE"
fi

if prompt_yn "Initialize nvai configuration?" "y"; then
  if [[ -f "$CONFIG_FILE" ]]; then
    print_warn "Config file already exists: $CONFIG_FILE"
    if ! prompt_yn "Overwrite?"; then
      print_info "Keeping existing config"
    else
      if [[ -n "$REPO_TEMPLATE" && -f "$REPO_TEMPLATE" ]]; then
        mkdir -p "$(dirname "$CONFIG_FILE")"
        cp "$REPO_TEMPLATE" "$CONFIG_FILE"
        print_success "Configuration created from template: $CONFIG_FILE"
      else
        "$NVAI_SCRIPT" --init
        print_success "Configuration initialized"
      fi
    fi
  else
    if [[ -n "$REPO_TEMPLATE" && -f "$REPO_TEMPLATE" ]]; then
      mkdir -p "$(dirname "$CONFIG_FILE")"
      cp "$REPO_TEMPLATE" "$CONFIG_FILE"
      print_success "Configuration created from template: $CONFIG_FILE"
      print_info "Edit this file to customize settings"
    else
      "$NVAI_SCRIPT" --init
      print_success "Configuration initialized"
    fi
  fi
fi

# Step 3: Provider setup
print_header "AI Provider Setup"

print_info "Available providers:"
echo "  1. Claude (CLI or API) - Recommended"
echo "  2. Gemini (CLI or API)"
echo "  3. OpenAI (API only)"
echo "  4. xAI (API only)"
echo "  5. Cursor AI (API only)"
echo "  6. Codex (CLI only)"
echo "  7. Skip for now"

read -p "Select providers to configure (e.g., 1 2 3): " -a PROVIDERS

# Track the first selected provider as default
SELECTED_DEFAULT_PROVIDER=""

# Debug: Show selected providers
if [[ ${#PROVIDERS[@]} -eq 0 ]]; then
  print_warn "No providers selected. Skipping provider setup."
else
  print_info "Selected providers: ${PROVIDERS[*]}"
fi

for provider in "${PROVIDERS[@]}"; do
  case $provider in
    1)
      print_header "Claude Setup"

      # Ask whether to use CLI or API mode
      if prompt_yn "Use Claude CLI mode? (API key based, no OAuth)"; then
        # CLI mode: claude-code-acp with API key
        if [[ -z "$SELECTED_DEFAULT_PROVIDER" ]]; then
          SELECTED_DEFAULT_PROVIDER="claude"
        fi
        print_success "CLI mode selected: using claude-code-acp with ANTHROPIC_API_KEY"
        print_info "Note: Uses API key instead of OAuth for security"
      else
        # Use API adapter
        if [[ -z "$SELECTED_DEFAULT_PROVIDER" ]]; then
          SELECTED_DEFAULT_PROVIDER="anthropic"
        fi
        print_success "API mode selected: using Anthropic HTTP API"
      fi
        
      if prompt_yn "Configure Claude API key?"; then
        read -p "Enter your Anthropic API key (sk-ant-...): " ANTHROPIC_KEY

        # Detect shell
        if [[ -n "${ZSH_VERSION:-}" ]]; then
          SHELL_RC="$HOME/.zshrc"
        else
          SHELL_RC="$HOME/.bashrc"
        fi

        # Add to shell RC
        if ! grep -q "ANTHROPIC_API_KEY" "$SHELL_RC"; then
          echo "" >> "$SHELL_RC"
          echo "# Anthropic Claude API" >> "$SHELL_RC"
          echo "export ANTHROPIC_API_KEY=\"$ANTHROPIC_KEY\"" >> "$SHELL_RC"
          print_success "API key added to $SHELL_RC"
        fi

        # Set for current session
        export ANTHROPIC_API_KEY="$ANTHROPIC_KEY"
      fi
      ;;

    2)
      print_header "Gemini Setup"
      
      # Ask whether to use CLI or API
      if prompt_yn "Use Gemini CLI mode? (already installed with ACP support)"; then
        # CLI mode: Gemini CLI with native ACP support was installed earlier
        if [[ -z "$SELECTED_DEFAULT_PROVIDER" ]]; then
          SELECTED_DEFAULT_PROVIDER="gemini_cli"
        fi
        print_success "CLI mode selected: using Gemini CLI with native ACP support"

        # Gemini authentication setup
        print_header "Gemini Authentication Setup"
        print_info "Gemini CLI supports multiple authentication methods:"
        echo "  1. Google OAuth (oauth-personal) - Recommended"
        echo "  2. API Key (gemini-api-key)"
        echo "  3. Vertex AI (vertex-ai)"
        echo ""

        read -p "Select authentication method (1-3): " -n 1 -r GEMINI_AUTH_CHOICE
        echo ""

        case $GEMINI_AUTH_CHOICE in
          1)
            print_info "Google OAuth selected"
            print_info "The Gemini CLI will prompt for Google authentication on first use"
            print_success "OAuth mode configured (will authenticate on first run)"
            ;;
          2)
            if prompt_yn "Configure Gemini API key now?"; then
              read -p "Enter your Gemini API key (AIza...): " GEMINI_KEY

              # Detect shell
              if [[ -n "${ZSH_VERSION:-}" ]]; then
                SHELL_RC="$HOME/.zshrc"
              else
                SHELL_RC="$HOME/.bashrc"
              fi

              # Add to shell RC
              if ! grep -q "GEMINI_API_KEY" "$SHELL_RC"; then
                echo "" >> "$SHELL_RC"
                echo "# Google Gemini API" >> "$SHELL_RC"
                echo "export GEMINI_API_KEY=\"$GEMINI_KEY\"" >> "$SHELL_RC"
                print_success "API key added to $SHELL_RC"
              fi

              # Set for current session
              export GEMINI_API_KEY="$GEMINI_KEY"
              print_success "Gemini API key configured"
            fi
            ;;
          3)
            print_info "Vertex AI selected"
            print_warn "Please configure Vertex AI credentials manually"
            print_info "See: https://cloud.google.com/vertex-ai/docs/authentication"
            ;;
          *)
            print_warn "Invalid selection. Skipping authentication setup"
            ;;
        esac
      else
        # Use API adapter
        if [[ -z "$SELECTED_DEFAULT_PROVIDER" ]]; then
          SELECTED_DEFAULT_PROVIDER="gemini"
        fi
        
        if prompt_yn "Configure Gemini API key?"; then
          read -p "Enter your Google AI API key (AIza...): " GEMINI_KEY

          # Detect shell
          if [[ -n "${ZSH_VERSION:-}" ]]; then
            SHELL_RC="$HOME/.zshrc"
          else
            SHELL_RC="$HOME/.bashrc"
          fi

          # Add to shell RC
          if ! grep -q "GEMINI_API_KEY" "$SHELL_RC"; then
            echo "" >> "$SHELL_RC"
            echo "# Google Gemini API" >> "$SHELL_RC"
            echo "export GEMINI_API_KEY=\"$GEMINI_KEY\"" >> "$SHELL_RC"
            print_success "API key added to $SHELL_RC"
          fi

          # Set for current session
          export GEMINI_API_KEY="$GEMINI_KEY"
        fi
      fi
      ;;

    3)
      # Set first selected provider as default
      if [[ -z "$SELECTED_DEFAULT_PROVIDER" ]]; then
        SELECTED_DEFAULT_PROVIDER="openai"
      fi
      
      print_header "OpenAI Setup"

      if prompt_yn "Configure OpenAI API key?"; then
        read -p "Enter your OpenAI API key (sk-...): " OPENAI_KEY

        # Detect shell
        if [[ -n "${ZSH_VERSION:-}" ]]; then
          SHELL_RC="$HOME/.zshrc"
        else
          SHELL_RC="$HOME/.bashrc"
        fi

        # Add to shell RC
        if ! grep -q "OPENAI_API_KEY" "$SHELL_RC"; then
          echo "" >> "$SHELL_RC"
          echo "# OpenAI API" >> "$SHELL_RC"
          echo "export OPENAI_API_KEY=\"$OPENAI_KEY\"" >> "$SHELL_RC"
          print_success "API key added to $SHELL_RC"
        fi

        # Set for current session
        export OPENAI_API_KEY="$OPENAI_KEY"
      fi
      ;;

    4)
      # Set first selected provider as default
      if [[ -z "$SELECTED_DEFAULT_PROVIDER" ]]; then
        SELECTED_DEFAULT_PROVIDER="xai"
      fi
      
      print_header "xAI (Grok) Setup"

      if prompt_yn "Configure xAI API key?"; then
        read -p "Enter your xAI API key: " XAI_KEY

        # Detect shell
        if [[ -n "${ZSH_VERSION:-}" ]]; then
          SHELL_RC="$HOME/.zshrc"
        else
          SHELL_RC="$HOME/.bashrc"
        fi

        # Add to shell RC
        if ! grep -q "XAI_API_KEY" "$SHELL_RC"; then
          echo "" >> "$SHELL_RC"
          echo "# xAI (Grok) API" >> "$SHELL_RC"
          echo "export XAI_API_KEY=\"$XAI_KEY\"" >> "$SHELL_RC"
          print_success "API key added to $SHELL_RC"
        fi

        # Set for current session
        export XAI_API_KEY="$XAI_KEY"
      fi
      ;;

    5)
      # Set first selected provider as default
      if [[ -z "$SELECTED_DEFAULT_PROVIDER" ]]; then
        SELECTED_DEFAULT_PROVIDER="cursor"
      fi
      
      print_header "Cursor Setup"

      if prompt_yn "Configure Cursor API key?"; then
        read -p "Enter your Cursor API key (cur_...): " CURSOR_KEY

        # Detect shell
        if [[ -n "${ZSH_VERSION:-}" ]]; then
          SHELL_RC="$HOME/.zshrc"
        else
          SHELL_RC="$HOME/.bashrc"
        fi

        # Add to shell RC
        if ! grep -q "CURSOR_API_KEY" "$SHELL_RC"; then
          echo "" >> "$SHELL_RC"
          echo "# Cursor AI API" >> "$SHELL_RC"
          echo "export CURSOR_API_KEY=\"$CURSOR_KEY\"" >> "$SHELL_RC"
          print_success "API key added to $SHELL_RC"
        fi

        # Set for current session
        export CURSOR_API_KEY="$CURSOR_KEY"
      fi
      ;;

    6)
      print_header "Codex Setup"

      # Set first selected provider as default
      if [[ -z "$SELECTED_DEFAULT_PROVIDER" ]]; then
        SELECTED_DEFAULT_PROVIDER="codex"
      fi

      # Codex authentication setup
      print_info "Codex (via ACP) supports multiple authentication methods:"
      echo "  1. ChatGPT OAuth - Recommended"
      echo "  2. OpenAI API Key"
      echo "  3. Codex API Key"
      echo ""

      read -p "Select authentication method (1-3): " -n 1 -r CODEX_AUTH_CHOICE
      echo ""

      case $CODEX_AUTH_CHOICE in
        1)
          print_info "ChatGPT OAuth selected"
          print_info "The Codex adapter will prompt for ChatGPT authentication on first use"
          print_success "ChatGPT OAuth mode configured"
          ;;
        2)
          if prompt_yn "Configure OpenAI API key now?"; then
            read -p "Enter your OpenAI API key (sk-...): " OPENAI_KEY

            # Detect shell
            if [[ -n "${ZSH_VERSION:-}" ]]; then
              SHELL_RC="$HOME/.zshrc"
            else
              SHELL_RC="$HOME/.bashrc"
            fi

            # Add to shell RC
            if ! grep -q "OPENAI_API_KEY" "$SHELL_RC"; then
              echo "" >> "$SHELL_RC"
              echo "# OpenAI API (for Codex)" >> "$SHELL_RC"
              echo "export OPENAI_API_KEY=\"$OPENAI_KEY\"" >> "$SHELL_RC"
              print_success "API key added to $SHELL_RC"
            fi

            # Set for current session
            export OPENAI_API_KEY="$OPENAI_KEY"
            print_success "OpenAI API key configured"
          fi
          ;;
        3)
          if prompt_yn "Configure Codex API key now?"; then
            read -p "Enter your Codex API key: " CODEX_KEY

            # Detect shell
            if [[ -n "${ZSH_VERSION:-}" ]]; then
              SHELL_RC="$HOME/.zshrc"
            else
              SHELL_RC="$HOME/.bashrc"
            fi

            # Add to shell RC
            if ! grep -q "CODEX_API_KEY" "$SHELL_RC"; then
              echo "" >> "$SHELL_RC"
              echo "# Codex API Key" >> "$SHELL_RC"
              echo "export CODEX_API_KEY=\"$CODEX_KEY\"" >> "$SHELL_RC"
              print_success "API key added to $SHELL_RC"
            fi

            # Set for current session
            export CODEX_API_KEY="$CODEX_KEY"
            print_success "Codex API key configured"
          fi
          ;;
        *)
          print_warn "Invalid selection. Skipping authentication setup"
          ;;
      esac
      ;;

    7)
      print_info "Skipping provider configuration"
      ;;
  esac
done

# Update config.yaml with selected default provider
if [[ -n "$SELECTED_DEFAULT_PROVIDER" ]]; then
  # Create config from template if it doesn't exist
  if [[ ! -f "$CONFIG_FILE" ]]; then
    if [[ -n "$REPO_TEMPLATE" && -f "$REPO_TEMPLATE" ]]; then
      mkdir -p "$(dirname "$CONFIG_FILE")"
      cp "$REPO_TEMPLATE" "$CONFIG_FILE"
      print_success "Created config from template: $CONFIG_FILE"
    else
      print_warn "Config template not found. Run 'nvai --init' to create config."
    fi
  fi
  if [[ -f "$CONFIG_FILE" ]]; then
    print_info "Updating config.yaml default_provider to: $SELECTED_DEFAULT_PROVIDER"
    
    # Update default_provider in config.yaml
    if command -v yq &> /dev/null; then
      if yq eval -i ".default_provider = \"$SELECTED_DEFAULT_PROVIDER\"" "$CONFIG_FILE" 2>/dev/null; then
        print_success "Set default provider to: $SELECTED_DEFAULT_PROVIDER"
      else
        print_warn "Failed to update config with yq, trying fallback..."
        sed -i.bak "s/^default_provider:.*/default_provider: $SELECTED_DEFAULT_PROVIDER/" "$CONFIG_FILE" 2>/dev/null || true
        rm -f "$CONFIG_FILE.bak" 2>/dev/null || true
        print_success "Set default provider to: $SELECTED_DEFAULT_PROVIDER (via sed)"
      fi
    elif command -v python3 &> /dev/null && python3 -c "import yaml" 2>/dev/null; then
      if python3 <<EOF 2>/dev/null; then
import yaml
with open('$CONFIG_FILE', 'r') as f:
    config = yaml.safe_load(f)
config['default_provider'] = '$SELECTED_DEFAULT_PROVIDER'
with open('$CONFIG_FILE', 'w') as f:
    yaml.dump(config, f, default_flow_style=False, sort_keys=False)
EOF
        print_success "Set default provider to: $SELECTED_DEFAULT_PROVIDER"
      else
        print_warn "Failed to update config with python, trying fallback..."
        sed -i.bak "s/^default_provider:.*/default_provider: $SELECTED_DEFAULT_PROVIDER/" "$CONFIG_FILE" 2>/dev/null || true
        rm -f "$CONFIG_FILE.bak" 2>/dev/null || true
        print_success "Set default provider to: $SELECTED_DEFAULT_PROVIDER (via sed)"
      fi
    else
      # Fallback: use sed (less reliable but works)
      if sed -i.bak "s/^default_provider:.*/default_provider: $SELECTED_DEFAULT_PROVIDER/" "$CONFIG_FILE" 2>/dev/null; then
        rm -f "$CONFIG_FILE.bak" 2>/dev/null || true
        print_success "Set default provider to: $SELECTED_DEFAULT_PROVIDER (via sed)"
      else
        print_warn "Failed to update config.yaml. Please manually set default_provider to: $SELECTED_DEFAULT_PROVIDER"
      fi
    fi
  else
    print_warn "Config file not found: $CONFIG_FILE"
  fi
else
  print_info "No provider selected, keeping default config"
fi

# Step 4: Optional - Add nvai to PATH
print_header "PATH Configuration"

if prompt_yn "Add nvai to PATH for system-wide access?"; then
  # Detect shell
  if [[ -n "${ZSH_VERSION:-}" ]]; then
    SHELL_RC="$HOME/.zshrc"
  else
    SHELL_RC="$HOME/.bashrc"
  fi

  # Add to PATH
  if ! grep -q "$NVIM_CONFIG/scripts" "$SHELL_RC"; then
    echo "" >> "$SHELL_RC"
    echo "# nvim-ai CLI" >> "$SHELL_RC"
    echo "export PATH=\"\$PATH:$NVIM_CONFIG/scripts\"" >> "$SHELL_RC"
    print_success "Added to PATH in $SHELL_RC"
  fi

  export PATH="$PATH:$NVIM_CONFIG/scripts"
fi

# Step 5: Test installation
print_header "Testing Installation"

if prompt_yn "Run test command?" "y"; then
  print_info "Testing nvai..."

  # Debug: Show what provider will be used
  if [[ -n "$SELECTED_DEFAULT_PROVIDER" ]]; then
    print_info "SELECTED_DEFAULT_PROVIDER is set to: $SELECTED_DEFAULT_PROVIDER"
    print_info "Testing with selected provider: $SELECTED_DEFAULT_PROVIDER"
    if "$NVAI_SCRIPT" --provider "$SELECTED_DEFAULT_PROVIDER" "Hello, AI!" 2>&1 | head -5; then
      print_success "✓ nvai is working with $SELECTED_DEFAULT_PROVIDER!"
    else
      print_warn "Test might have failed. Check configuration."
    fi
  else
    print_info "SELECTED_DEFAULT_PROVIDER is empty, reading from config.yaml..."
    # Read from config.yaml if no provider was selected
    CONFIG_FILE="$NVIM_CONFIG/config/nvim-ai-config.yaml"
    if [[ -f "$CONFIG_FILE" ]]; then
      # Try to read default_provider from config
      if command -v yq &> /dev/null; then
        CONFIG_PROVIDER=$(yq eval ".default_provider // \"auto\"" "$CONFIG_FILE" 2>/dev/null)
      elif command -v python3 &> /dev/null && python3 -c "import yaml" 2>/dev/null; then
        CONFIG_PROVIDER=$(python3 -c "import yaml; f=open('$CONFIG_FILE'); c=yaml.safe_load(f); f.close(); print(c.get('default_provider', 'auto'))" 2>/dev/null)
      else
        CONFIG_PROVIDER=$(grep "^default_provider:" "$CONFIG_FILE" 2>/dev/null | sed 's/^default_provider: *//' | sed 's/ *#.*$//' || echo "auto")
      fi
      
      if [[ -n "$CONFIG_PROVIDER" && "$CONFIG_PROVIDER" != "auto" ]]; then
        print_info "Testing with configured provider: $CONFIG_PROVIDER"
        if "$NVAI_SCRIPT" --provider "$CONFIG_PROVIDER" "Hello, AI!" 2>&1 | head -5; then
          print_success "✓ nvai is working with $CONFIG_PROVIDER!"
        else
          print_warn "Test might have failed. Check configuration."
        fi
      else
        print_info "Testing with auto-detection..."
        if "$NVAI_SCRIPT" "Hello, AI!" 2>&1 | head -5; then
          print_success "✓ nvai is working!"
        else
          print_warn "Test might have failed. Check configuration."
        fi
      fi
    else
      print_info "Testing with auto-detection..."
      if "$NVAI_SCRIPT" "Hello, AI!" 2>&1 | head -5; then
        print_success "✓ nvai is working!"
      else
        print_warn "Test might have failed. Check configuration."
      fi
    fi
  fi
fi

# Step 6: Final instructions
print_header "Setup Complete!"

print_success "nvim-ai CLI integration installed successfully"
echo ""
print_info "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc (or ~/.bashrc)"
echo "  2. Open Neovim and run: :Lazy reload nvim-ai-cli"
echo "  3. Test with: :AIChat"
echo "  4. Read documentation: $NVIM_CONFIG/AI_CLI_INTEGRATION.md"
echo ""
print_info "Quick test:"
echo "  nvai \"Explain design patterns\""
echo "  nvim +\"AIChat Hello\" +q"
echo ""
print_info "Configuration files:"
echo "  Config: ~/.config/nvim/config/nvim-ai-config.yaml"
echo "  Template: config/nvim-ai-config.yaml.default (in repo, do not edit)"
echo "  Script: $NVAI_SCRIPT"
echo ""
print_success "Happy coding with AI! 🚀"
