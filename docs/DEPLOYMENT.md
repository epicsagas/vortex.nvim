# Deployment Guide

This guide explains how to deploy your Neovim configuration to GitHub and use it across multiple machines.

## Initial Setup on GitHub

### 1. Create GitHub Repository

**Option A: Using GitHub CLI**
```bash
cd ~/.config/nvim
gh repo create vortex.nvim --public --source=. --remote=origin --push
```

**Option B: Manual Setup**
1. Go to https://github.com/new
2. Create a new repository named `vortex.nvim`
3. Don't initialize with README (we already have one)
4. Copy the repository URL

### 2. Push to GitHub

```bash
cd ~/.config/nvim
git remote add origin https://github.com/epicsagas/vortex.nvim.git
git branch -M main
git push -u origin main
```

### 3. Update Repository URL in README

Edit `README.md` and replace all instances of:
```
epicsagas
```
with your actual GitHub username.

## Deploying to New Machines

### Method 1: One-Line Installation

```bash
git clone https://github.com/epicsagas/vortex.nvim.git ~/.config/nvim && cd ~/.config/nvim && ./scripts/install.sh
```

### Method 2: Step-by-Step

```bash
# Backup existing config (if any)
mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)

# Clone your configuration
git clone https://github.com/epicsagas/vortex.nvim.git ~/.config/nvim

# Run installer
cd ~/.config/nvim
./scripts/install.sh

# Launch Neovim
nvim
```

## Keeping Configurations in Sync

### On Any Machine: Pull Latest Changes

```bash
cd ~/.config/nvim
git pull origin main
nvim --headless "+Lazy! sync" +qa  # Update plugins
```

### Making Changes and Pushing

```bash
cd ~/.config/nvim

# Make your changes...
# Edit lua/plugins/yourplugin.lua

# Commit and push
git add .
git commit -m "Description of changes"
git push origin main
```

## Common Workflows

### Adding a New Plugin

1. Create or edit plugin file:
```bash
nvim ~/.config/nvim/lua/plugins/newfeature.lua
```

2. Test locally:
```lua
return {
  {
    "author/plugin-name",
    config = function()
      require("plugin-name").setup({})
    end,
  },
}
```

3. Commit and push:
```bash
git add lua/plugins/newfeature.lua
git commit -m "Add plugin for new feature"
git push origin main
```

4. Pull on other machines:
```bash
cd ~/.config/nvim && git pull
```

### Customizing for Different Machines

**Option 1: Local Configuration File (Not Tracked)**

Create `~/.config/nvim/lua/local.lua` for machine-specific settings:
```lua
-- This file is in .gitignore
return {
  theme = "gruvbox",  -- Different theme on this machine
  font_size = 16,     -- Larger font on high-DPI display
}
```

Then in `init.lua`:
```lua
local ok, local_config = pcall(require, "local")
if ok then
  -- Apply local settings
end
```

**Option 2: Git Branches for Different Setups**
```bash
# Create branch for work machine
git checkout -b work
# Make work-specific changes
git push -u origin work

# On work machine
git clone -b work https://github.com/epicsagas/vortex.nvim.git ~/.config/nvim
```

## Using with Dotfiles Repository

If you manage dotfiles with Git, you can include Neovim config as a submodule:

```bash
cd ~/dotfiles
git submodule add https://github.com/epicsagas/vortex.nvim.git .config/nvim

# To clone dotfiles with submodules
git clone --recursive https://github.com/epicsagas/dotfiles.git ~/
```

## Private Configuration

If your config contains sensitive information:

### 1. Create Private Repository on GitHub

```bash
cd ~/.config/nvim
git remote set-url origin https://github.com/epicsagas/vortex.nvim-private.git
git push -u origin main
```

### 2. Use SSH Authentication

```bash
# Generate SSH key if you don't have one
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add to GitHub: Settings → SSH and GPG keys → New SSH key

# Clone using SSH
git clone git@github.com:epicsagas/vortex.nvim.git ~/.config/nvim
```

## Troubleshooting

### Issue: Plugins Not Syncing

```bash
cd ~/.config/nvim
rm -rf ~/.local/share/nvim/lazy  # Remove plugin cache
nvim --headless "+Lazy! sync" +qa
```

### Issue: LSP Servers Out of Date

```bash
nvim
# Inside Neovim
:Mason
# Press 'U' to update all packages
```

### Issue: Git Conflicts

```bash
cd ~/.config/nvim
git stash  # Save local changes
git pull
git stash pop  # Reapply local changes
# Resolve conflicts manually
```

### Issue: Different Neovim Versions

Add version check to `init.lua`:
```lua
if vim.fn.has('nvim-0.10') ~= 1 then
  vim.notify("Neovim 0.10+ required", vim.log.levels.ERROR)
  return
end
```

## Automation Scripts

### Auto-Sync Script

Create `~/bin/nvim-sync`:
```bash
#!/bin/bash
cd ~/.config/nvim
git pull --rebase origin main
nvim --headless "+Lazy! sync" +qa
echo "Neovim configuration synced!"
```

Make executable:
```bash
chmod +x ~/bin/nvim-sync
```

### Backup Script

Create `~/bin/nvim-backup`:
```bash
#!/bin/bash
BACKUP_DIR="$HOME/.config/nvim-backups"
mkdir -p "$BACKUP_DIR"
cp -r ~/.config/nvim "$BACKUP_DIR/nvim-$(date +%Y%m%d_%H%M%S)"
echo "Backup created in $BACKUP_DIR"
```

## Best Practices

1. **Test before pushing**: Always test configuration changes locally first
2. **Use descriptive commit messages**: Help your future self understand changes
3. **Keep it portable**: Avoid hardcoded paths specific to one machine
4. **Document changes**: Update README when adding significant features
5. **Version lock carefully**: Consider committing `lazy-lock.json` for reproducibility
6. **Regular updates**: Keep plugins and LSP servers updated regularly

## Platform-Specific Considerations

### macOS
- Uses different paths for tools (Homebrew)
- May need to install command line tools: `xcode-select --install`

### Linux
- Package manager varies (apt, dnf, pacman)
- May need to build Neovim from source for latest version

### Windows (WSL)
- Use WSL 2 for best performance
- Clone into Windows path for access from both sides:
  ```bash
  git clone https://github.com/epicsagas/vortex.nvim.git /mnt/c/Users/YOUR_USER/.config/nvim
  ln -s /mnt/c/Users/YOUR_USER/.config/nvim ~/.config/nvim
  ```

## Example: Complete Fresh Setup

```bash
# Install Neovim 0.10+
brew install neovim  # macOS
# or
sudo apt install neovim  # Ubuntu/Debian

# Install language toolchains
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh  # Rust
brew install go  # Go (macOS)

# Clone and install Neovim config
git clone https://github.com/epicsagas/vortex.nvim.git ~/.config/nvim
cd ~/.config/nvim
./scripts/install.sh

# Launch Neovim
nvim

# Open a test file
nvim test.rs  # or test.go
```

Done! Your development environment is now portable and reproducible across all machines. 🚀
