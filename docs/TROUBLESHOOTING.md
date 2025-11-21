# Troubleshooting Guide

> 🌏 **한국어**: [문제 해결 가이드](../translations/ko/docs//TROUBLESHOOTING.md)

Common issues and solutions you may encounter while using this Neovim configuration.

## Table of Contents
- [Installation Issues](#installation-issues)
- [LSP Issues](#lsp-issues)
- [Plugin Issues](#plugin-issues)
- [Tree-sitter Issues](#tree-sitter-issues)
- [Debugging Issues](#debugging-issues)
- [Git Integration Issues](#git-integration-issues)
- [Language-Specific Issues](#language-specific-issues)

---

## Installation Issues

### Neovim Version Too Old
**Symptom**: `Neovim >= 0.10.0 required`

**Solution**:
```bash
# macOS
brew upgrade neovim

# Linux
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim

# Check version
nvim --version
```

### Plugins Not Installing
**Symptom**: Plugin loading failure, lazy.nvim errors

**Solution**:
```bash
# 1. Manual lazy.nvim installation
rm -rf ~/.local/share/nvim/lazy
nvim --headless "+Lazy! sync" +qa

# 2. Clear cache
rm -rf ~/.local/share/nvim/lazy
rm -rf ~/.cache/nvim

# 3. Restart Neovim
nvim
```

### Git Clone Failure
**Symptom**: `fatal: could not read Username`

**Solution**:
```bash
# Setup SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub
# Add SSH key to GitHub

# Or use HTTPS
git clone https://github.com/epicsagas/vortex.nvim.git ~/.config/nvim
```

---

## LSP Issues

### LSP Server Not Working
**Symptom**: No autocompletion, no error display

**Solution**:
```vim
" 1. Check server in Mason
:Mason

" 2. Install server manually (press 'i' in Mason)
" 3. Check LSP status
:LspInfo

" 4. Restart LSP
:LspRestart
```

### Mason Installation Failed
**Symptom**: `Mason installation failed`

**Solution**:
```bash
# Install required tools
# macOS
brew install node python3 go rust

# Linux
sudo apt install nodejs python3 python3-pip golang rustc

# Remove Mason data and reinstall
rm -rf ~/.local/share/nvim/mason
nvim
:Mason
```

### Specific Language LSP Not Working
**Symptom**: LSP not working for specific language only

**Solution**:
```vim
" 1. Open file for that language
" 2. Check LSP log
:LspLog

" 3. Reinstall server in Mason
:Mason
" Select server → 'X' (remove) → 'i' (reinstall)

" 4. Check status
:checkhealth lspconfig
```

---

## Plugin Issues

### lazy.nvim Error
**Symptom**: `Error in lazy.nvim`

**Solution**:
```vim
" 1. Resync plugins
:Lazy sync

" 2. For specific plugin issues
:Lazy log
" Check error and reinstall the plugin

" 3. Complete reinstall
:Lazy clean
:Lazy sync
```

### Telescope is Slow
**Symptom**: File search is slow

**Solution**:
```bash
# Build fzf-native
cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim
make

# Install ripgrep (faster search)
brew install ripgrep
```

### Treesitter Highlighting Error
**Symptom**: Syntax highlighting broken

**Solution**:
```vim
" 1. Reinstall parsers
:TSInstall! all

" 2. For specific language only
:TSInstall! rust go python

" 3. Check status
:TSInstallInfo
```

---

## Tree-sitter Issues

### Swift: tree-sitter CLI not found
**Symptom**: `tree-sitter CLI not found: tree-sitter is not executable!`

**Cause**: Swift parser requires tree-sitter CLI, but Homebrew's `tree-sitter` package only installs the library

**Solution**:
```bash
# Install correct package
brew install tree-sitter-cli

# Or use npm
npm install -g tree-sitter-cli

# Verify
tree-sitter --version

# Install Swift parser in Neovim
nvim
:TSInstall swift
```

**Alternative**: Disable Swift if you don't use it
```lua
-- Remove "swift" from lua/plugins/treesitter.lua
ensure_installed = {
  "rust", "go", "python", -- ... exclude "swift"
}
```

### Parser Build Failed
**Symptom**: `Parser build failed for [language]`

**Solution**:
```bash
# Install compiler
# macOS
xcode-select --install

# Linux
sudo apt install build-essential

# Rebuild parser
nvim
:TSInstall! [language]
```

---

## Debugging Issues

### Debugger Won't Start
**Symptom**: Pressing F9 doesn't start debugger

**Solution**:
```vim
" 1. Check DAP status
:lua require('dap').status()

" 2. Check adapters
:lua print(vim.inspect(require('dap').adapters))

" 3. Check configuration
:lua print(vim.inspect(require('dap').configurations))
```

### Rust Debugger: codelldb Error
**Solution**:
```bash
# Reinstall codelldb
nvim
:Mason
# Select codelldb → 'X' → 'i'
```

### Go Debugger: Delve Error
**Solution**:
```bash
# Install Delve manually
go install github.com/go-delve/delve/cmd/dlv@latest

# Check PATH
which dlv
```

---

## Git Integration Issues

### Git reset Error: "reset is not a valid function"
**Symptom**: Error when running `<Space>gR` or `<Space>gr`

**Cause**: Missing Fugitive plugin (already fixed)

**Verification**: Update to latest version
```bash
cd ~/.config/nvim
git pull
nvim
```

### LazyGit Won't Open
**Solution**:
```bash
# Install LazyGit
brew install lazygit

# Verify
lazygit --version
```

### Gitsigns Not Working
**Symptom**: Git changes not displayed

**Solution**:
```bash
# Check if it's a Git repository
git status

# Restart Gitsigns
nvim
:Gitsigns toggle_signs
:Gitsigns toggle_signs
```

---

## Language-Specific Issues

### Rust

**Symptom**: rust-analyzer is slow

**Solution**:
```bash
# Update rust-analyzer
rustup update
rustup component add rust-analyzer

# Clean Cargo cache
cargo clean
```

### Go

**Symptom**: gopls is slow or uses excessive memory

**Solution**:
```bash
# Update gopls
go install golang.org/x/tools/gopls@latest

# Initialize workspace
rm -rf ~/go/pkg/mod/cache
```

### Python

**Symptom**: Virtual environment not recognized

**Solution**:
```vim
" Manually select virtual environment
<Space>vs

" Or use command
:VenvSelect
```

**Symptom**: pyright can't find libraries

**Solution**:
```bash
# Install type stubs in virtual environment
pip install types-requests types-PyYAML
```

### TypeScript/JavaScript

**Symptom**: `Cannot find package 'tsserver'`

**Cause**: Using typescript-tools.nvim (already fixed)

**Verification**: Ensure `tsserver = {}` is not in lsp.lua

### Java

**Symptom**: jdtls starts slowly

**Solution**:
```bash
# Check JDK version (17+ recommended)
java --version

# Clean workspace
rm -rf ~/.cache/jdtls-workspace
```

### Nim

**Symptom**: `zsh:1: command not found: nim`

**Solution**:
```bash
# Install Nim
brew install nim

# Or use choosenim (version manager)
curl https://nim-lang.org/choosenim/init.sh -sSf | sh

# Verify
nim --version
nimble --version
```

### Swift

**Symptom**: sourcekit-lsp error

**Solution**:
```bash
# Install Xcode Command Line Tools
xcode-select --install

# Verify sourcekit-lsp
xcrun -f sourcekit-lsp
```

### C/C++

**Symptom**: clangd can't find headers

**Solution**:
```bash
# Generate compile_commands.json
# For CMake projects
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .

# Manual generation
bear -- make
```

---

## Performance Issues

### Neovim Starts Slowly
**Solution**:
```vim
" Profile startup time
nvim --startuptime startup.log
```

Check plugin lazy loading:
```lua
-- In lua/plugins/*.lua
{
  "plugin-name",
  lazy = true,  -- Load only when needed
  ft = "rust",  -- Only for specific filetype
  cmd = "PluginCommand",  -- Only when command is executed
}
```

### High Memory Usage
**Solution**:
```vim
" Check LSP memory usage
:lua print(vim.inspect(vim.lsp.get_active_clients()))

" Stop unused LSP
:LspStop [server_name]
```

---

## General Solutions

### 1. Check Overall Status
```vim
:checkhealth
```

### 2. Check Logs
```vim
:messages
:LspLog
:Lazy log
```

### 3. Clean Start
```bash
# Remove all plugins and cache
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim

# Restart Neovim
nvim
```

### 4. Update to Latest Version
```bash
cd ~/.config/nvim
git pull
nvim
:Lazy sync
```

---

## Additional Help

### Collecting Logs
When reporting issues, include the following information:
```bash
# 1. Neovim version
nvim --version

# 2. Operating system
uname -a

# 3. Checkhealth results
nvim +checkhealth +qa > health.log 2>&1

# 4. Error messages
# Copy contents from :messages
```

### GitHub Issues
https://github.com/epicsagas/vortex.nvim/issues

### Neovim Official Documentation
```vim
:help
:help lsp
:help dap
```

---

**Issue Not Resolved?**
- Create a GitHub Issue with detailed error messages
- Attaching `:checkhealth` results will help you get faster assistance
