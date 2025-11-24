#!/bin/bash
# Neovim Configuration Installer for Rust & Go Development
# Usage: curl -fsSL https://raw.githubusercontent.com/epicsagas/vortex.nvim/main/scripts/install.sh | bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Neovim Configuration Installer ===${NC}"
echo ""

# Check Neovim version
if ! command -v nvim &> /dev/null; then
    echo -e "${RED}✗ Neovim not found${NC}"
    echo "Please install Neovim 0.10+ from: https://github.com/neovim/neovim/releases"
    exit 1
fi

NVIM_VERSION=$(nvim --version | head -n1 | grep -oE '[0-9]+\.[0-9]+')
echo -e "${GREEN}✓ Neovim $NVIM_VERSION found${NC}"

# Backup existing config
if [ -d "$HOME/.config/nvim" ]; then
    BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}⚠ Backing up existing config to: $BACKUP_DIR${NC}"
    mv "$HOME/.config/nvim" "$BACKUP_DIR"
fi

# Clone or copy config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"
if [ "$CONFIG_DIR" = "$HOME/.config/nvim" ]; then
    echo -e "${GREEN}✓ Already in nvim config directory${NC}"
else
    echo "Copying configuration files..."
    mkdir -p "$HOME/.config"
    cp -r "$CONFIG_DIR" "$HOME/.config/nvim"
fi

# Check system dependencies
echo ""
echo "Checking system dependencies..."

check_tool() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓ $1${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠ $1 not found${NC}"
        return 1
    fi
}

check_tool git
check_tool gcc || check_tool clang
check_tool make
check_tool curl

# Check language toolchains
echo ""
echo "Checking language toolchains..."

RUST_INSTALLED=false
GO_INSTALLED=false

if command -v rustc &> /dev/null; then
    RUST_VERSION=$(rustc --version | awk '{print $2}')
    echo -e "${GREEN}✓ Rust $RUST_VERSION${NC}"
    RUST_INSTALLED=true
else
    echo -e "${YELLOW}⚠ Rust not found${NC}"
    echo "  Install from: https://rustup.rs"
fi

if command -v go &> /dev/null; then
    GO_VERSION=$(go version | awk '{print $3}')
    echo -e "${GREEN}✓ Go $GO_VERSION${NC}"
    GO_INSTALLED=true
else
    echo -e "${YELLOW}⚠ Go not found${NC}"
    echo "  Install from: https://go.dev/dl"
fi

# Check and install Nerd Fonts
echo ""
echo "Checking Nerd Fonts installation..."

install_nerd_fonts_macos() {
    if command -v brew &> /dev/null; then
        echo "Installing Nerd Fonts via Homebrew..."
        brew tap homebrew/cask-fonts
        brew install --cask font-hack-nerd-font font-fira-code-nerd-font || {
            echo -e "${YELLOW}⚠ Failed to install via Homebrew, trying manual download...${NC}"
            return 1
        }
        echo -e "${GREEN}✓ Nerd Fonts installed${NC}"
        echo -e "${YELLOW}⚠ Please set your terminal font to 'Hack Nerd Font' or 'FiraCode Nerd Font' in terminal settings${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠ Homebrew not found. Please install Homebrew first:${NC}"
        echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        return 1
    fi
}

install_nerd_fonts_linux() {
    # Check if fonts are already installed
    if [ -d "$HOME/.local/share/fonts" ] && find "$HOME/.local/share/fonts" -name "*Nerd*" -o -name "*nerd*" | grep -q .; then
        echo -e "${GREEN}✓ Nerd Fonts already installed${NC}"
        return 0
    fi

    echo "Downloading Nerd Fonts..."
    mkdir -p "$HOME/.local/share/fonts"
    
    FONT_NAME="Hack"
    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME}.zip"
    
    if command -v curl &> /dev/null; then
        curl -L "$FONT_URL" -o /tmp/nerd-font.zip || {
            echo -e "${YELLOW}⚠ Failed to download Nerd Fonts${NC}"
            return 1
        }
    elif command -v wget &> /dev/null; then
        wget "$FONT_URL" -O /tmp/nerd-font.zip || {
            echo -e "${YELLOW}⚠ Failed to download Nerd Fonts${NC}"
            return 1
        }
    else
        echo -e "${YELLOW}⚠ curl or wget required to download fonts${NC}"
        return 1
    fi

    if command -v unzip &> /dev/null; then
        unzip -q /tmp/nerd-font.zip -d /tmp/nerd-font/ || {
            echo -e "${YELLOW}⚠ Failed to extract fonts${NC}"
            return 1
        }
        cp /tmp/nerd-font/*.ttf "$HOME/.local/share/fonts/" 2>/dev/null || true
        fc-cache -fv "$HOME/.local/share/fonts" 2>/dev/null || true
        rm -rf /tmp/nerd-font /tmp/nerd-font.zip
        echo -e "${GREEN}✓ Nerd Fonts installed${NC}"
        echo -e "${YELLOW}⚠ Please set your terminal font to 'Hack Nerd Font' in terminal settings${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠ unzip required to extract fonts${NC}"
        return 1
    fi
}

check_nerd_fonts() {
    # Check macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if [ -d "$HOME/Library/Fonts" ] && find "$HOME/Library/Fonts" -name "*Nerd*" -o -name "*nerd*" | grep -q .; then
            echo -e "${GREEN}✓ Nerd Fonts found${NC}"
            return 0
        fi
        
        echo -e "${YELLOW}⚠ Nerd Fonts not found${NC}"
        read -p "Install Nerd Fonts now? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_nerd_fonts_macos
        else
            echo -e "${YELLOW}⚠ Skipping Nerd Fonts installation${NC}"
            echo "  You can install manually: https://www.nerdfonts.com/font-downloads"
        fi
    
    # Check Linux
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -d "$HOME/.local/share/fonts" ] && find "$HOME/.local/share/fonts" -name "*Nerd*" -o -name "*nerd*" | grep -q .; then
            echo -e "${GREEN}✓ Nerd Fonts found${NC}"
            return 0
        fi
        
        echo -e "${YELLOW}⚠ Nerd Fonts not found${NC}"
        read -p "Install Nerd Fonts now? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_nerd_fonts_linux
        else
            echo -e "${YELLOW}⚠ Skipping Nerd Fonts installation${NC}"
            echo "  You can install manually: https://www.nerdfonts.com/font-downloads"
        fi
    
    # Other OS
    else
        echo -e "${YELLOW}⚠ Automatic Nerd Fonts installation not supported for this OS${NC}"
        echo "  Please install manually from: https://www.nerdfonts.com/font-downloads"
        echo "  Recommended fonts: Hack Nerd Font, FiraCode Nerd Font, JetBrains Mono Nerd Font"
    fi
}

check_nerd_fonts

# Install optional tools
echo ""
echo "Checking optional tools for better experience..."

if ! command -v rg &> /dev/null; then
    echo -e "${YELLOW}⚠ ripgrep not found (recommended for Telescope)${NC}"
    echo "  Install: brew install ripgrep  # macOS"
    echo "           apt install ripgrep   # Ubuntu/Debian"
fi

if ! command -v fd &> /dev/null; then
    echo -e "${YELLOW}⚠ fd not found (optional for Telescope)${NC}"
    echo "  Install: brew install fd  # macOS"
    echo "           apt install fd-find  # Ubuntu/Debian"
fi

# Install Rust tools
if [ "$RUST_INSTALLED" = true ]; then
    echo ""
    read -p "Install Rust development tools (rust-analyzer, rustfmt, clippy)? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Installing Rust development tools..."
        rustup component add rust-analyzer rustfmt clippy 2>/dev/null || true
        echo -e "${GREEN}✓ Rust tools configured${NC}"
    else
        echo -e "${YELLOW}⚠ Skipping Rust tools installation${NC}"
        echo "  You can install later by running: rustup component add rust-analyzer rustfmt clippy"
    fi
fi

# Install Go tools
if [ "$GO_INSTALLED" = true ]; then
    echo ""
    read -p "Install Go development tools (gopls, delve, gofumpt, goimports)? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Installing Go development tools..."
        go install golang.org/x/tools/gopls@latest
        go install github.com/go-delve/delve/cmd/dlv@latest
        go install mvdan.cc/gofumpt@latest
        go install golang.org/x/tools/cmd/goimports@latest
        echo -e "${GREEN}✓ Go tools installed${NC}"
    else
        echo -e "${YELLOW}⚠ Skipping Go tools installation${NC}"
        echo "  You can install later with these commands:"
        echo "    go install golang.org/x/tools/gopls@latest"
        echo "    go install github.com/go-delve/delve/cmd/dlv@latest"
        echo "    go install mvdan.cc/gofumpt@latest"
        echo "    go install golang.org/x/tools/cmd/goimports@latest"
    fi
fi

# Launch Neovim to install plugins
echo ""
echo "Installing Neovim plugins..."
echo "This may take 1-2 minutes..."

nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

echo ""
echo -e "${GREEN}=== Installation Complete! ===${NC}"
echo ""
echo "Next steps:"
echo "1. ${YELLOW}Set your terminal font to a Nerd Font${NC} (if installed):"
echo "   - macOS: Terminal > Preferences > Profiles > Text > Font"
echo "   - Linux: Terminal Settings > Font"
echo "   - Recommended: 'Hack Nerd Font' or 'FiraCode Nerd Font'"
echo "2. Restart your terminal to apply font changes"
echo "3. Launch Neovim: nvim"
echo "4. Wait for any remaining plugin installations"
echo "5. Restart Neovim if needed"
echo "6. Open a Rust or Go file to test"
echo ""
echo "Key bindings:"
echo "  Space      - Leader key (show all commands)"
echo "  Space e    - File explorer"
echo "  Space ff   - Find files"
echo "  Space fg   - Grep in files"
echo "  gd         - Go to definition"
echo "  K          - Hover documentation"
echo ""
echo "Full documentation: cat ~/.config/nvim/README.md"
echo ""

# Optional: Install nvim-ai CLI integration
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}Optional: AI CLI Integration${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Would you like to install nvim-ai CLI integration?"
echo "This enables AI-powered features (Claude, Gemini, OpenAI, etc.) in Neovim."
echo ""
read -p "Install nvim-ai CLI integration now? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [ -f "$SCRIPT_DIR/install-nvai.sh" ]; then
        echo ""
        echo "Starting nvim-ai CLI integration setup..."
        bash "$SCRIPT_DIR/install-nvai.sh"
    else
        echo -e "${RED}✗ install-nvai.sh not found${NC}"
        echo "  You can install it later from: https://github.com/epicsagas/vortex.nvim"
    fi
else
    echo -e "${YELLOW}⚠ Skipping nvim-ai CLI integration${NC}"
    echo "  You can install it later by running: scripts/install-nvai.sh"
fi

echo ""
echo "Happy coding! 🚀"

