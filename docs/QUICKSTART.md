# Neovim Quick Start Guide (5 Minutes)

> 🌏 **한국어**: [빠른 시작 가이드](../translations/ko/docs/QUICKSTART.md)

Set up a complete development environment supporting 24 languages in just 5 minutes!

## Step 1: Installation (2 minutes)

### Automatic Installation (Recommended)
```bash
# Backup existing config (optional)
mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d)

# Clone repository
git clone https://github.com/epicsagas/vortex.nvim.git ~/.config/nvim

# Run automatic installation
cd ~/.config/nvim
./scripts/install.sh
```

### First Run
```bash
nvim
```

Plugins will install automatically (takes 1-2 minutes). Restart Neovim when complete.

## Step 2: Install Essential Tools (2 minutes)

### macOS
```bash
# Latest Neovim
brew install neovim

# Basic tools
brew install git ripgrep fd

# Tree-sitter CLI (for Swift support)
brew install tree-sitter-cli

# File preview (images, GIF, PDF, Excel)
brew install imagemagick chafa poppler xlsx2csv
```

> **Note**: Additional language tools (Rust/Go development tools) will be prompted during `install.sh` execution.
> `imagemagick` is required for inline image rendering. `chafa` enables animated GIF playback.
> See [Preview Guide](PREVIEW.md) for full details.

### Linux (Ubuntu/Debian)
```bash
# Latest Neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim

# Basic tools
sudo apt install git ripgrep fd-find

# Tree-sitter CLI
npm install -g tree-sitter-cli

# File preview (images, GIF, PDF, Excel)
sudo apt install imagemagick chafa poppler-utils
pip3 install xlsx2csv
```

## Step 3: Write Your First Code (1 minute)

### Rust Project
```bash
# Create new project
cargo new hello-rust
cd hello-rust

# Open with Neovim
nvim src/main.rs

# Write code and press F5 to run!
```

### Go Project
```bash
# New project
mkdir hello-go && cd hello-go
go mod init hello

# Create main.go
nvim main.go

# Press F5 to run!
```

### Python Project
```bash
# Create script
nvim hello.py

# Press F5 to run!
```

## Essential Keybindings (Learn These!)

### Must Know (3)
- `F5` - **Run code** (all languages)
- `F6` - **Run tests**
- `<Space>e` - **File explorer**

### Frequently Used (5)
- `<Space>ff` - Find files
- `<Space>fg` - Search code
- `gd` - Go to definition
- `K` - Show documentation
- `<Space>ca` - Code actions

### Debugging (3)
- `<Space>db` - Set breakpoint
- `F9` - Start debugging
- `F10` - Step over

### Git (3)
- `<Space>gg` - Open LazyGit
- `<Space>gs` - Neogit status
- `<Space>u` - Undo tree

**All Keybindings**: Press `<Space>` and wait for the menu to appear!

## Language-Specific Quick Start

### Rust
```bash
brew install rustup
rustup-init
# F5: cargo run
# F6: cargo test
```

### Go
```bash
brew install go
# F5: go run
# F6: go test
```

### Python
```bash
brew install python
# F5: run python3
# F6: pytest
# <Space>vs: select virtual environment
```

### TypeScript/JavaScript
```bash
brew install node
# F5: run node/tsx
# F6: npm test
```

### Java
```bash
brew install openjdk
# F5: javac + java
# F6: Maven test
```

### C/C++
```bash
brew install llvm
# F5: compile with gcc/g++ & run
# F6: compile with debug info
```

## Troubleshooting

### LSP Not Working
```vim
:Mason
```
Press `i` to install from server list

### Plugin Errors
```vim
:Lazy sync
```
Resync plugins

### tree-sitter Errors (Swift)
```bash
brew install tree-sitter-cli
```

### Check Overall Status
```vim
:checkhealth
```

## Step 4: AI Setup (Optional, 3 minutes)

### Quick AI Setup

Choose **one** AI provider to get started:

#### Option A: Claude (Anthropic)
```bash
# 1. Get API key: https://console.anthropic.com/
# 2. Add to ~/.zshrc or ~/.bashrc:
export ANTHROPIC_API_KEY="sk-ant-..."

# 3. Reload terminal
source ~/.zshrc
```

#### Option B: OpenAI (GPT)
```bash
# 1. Get API key: https://platform.openai.com/
# 2. Add to ~/.zshrc or ~/.bashrc:
export OPENAI_API_KEY="sk-..."

# 3. Reload terminal
source ~/.zshrc
```

#### Option C: Gemini (Google)
```bash
# 1. Get API key: https://ai.google.dev/
# 2. Add to ~/.zshrc or ~/.bashrc:
export GEMINI_API_KEY="AIza..."

# 3. Reload terminal
source ~/.zshrc
```

### AI Keybindings (After Setup)
- `<Space>ac` - Open AI chat
- `<Space>ae` - Explain code
- `<Space>af` - Fix bugs
- `<Space>am` - Switch AI model

**More AI providers and advanced setup**: See [AI Integration Guide](AI_INTEGRATION.md)

---

## Next Steps

1. **[AI Integration Guide](AI_INTEGRATION.md)** - Advanced AI setup and features
2. **[Language Guide](LANGUAGES.md)** - Detailed language setup
3. **[Troubleshooting](TROUBLESHOOTING.md)** - Problem-solving guide
4. **[README.md](../README.md)** - Full features and keybindings

## Help

- GitHub Issues: https://github.com/epicsagas/vortex.nvim/issues
- Neovim Help: `:help`
- Check Keybindings: Press `<Space>` and wait

---

**Congratulations! 🎉** You now have a complete IDE supporting 24 languages!
