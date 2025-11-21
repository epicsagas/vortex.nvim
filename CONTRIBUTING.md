# Contributing to Neovim Multi-Language Configuration

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## 🎯 How Can I Contribute?

### 1. Reporting Bugs

**Before submitting a bug report:**
- Check the [Troubleshooting Guide](TROUBLESHOOTING.md)
- Search [existing issues](https://github.com/epicsagas/vortex.nvim/issues)
- Test with the latest version

**Good Bug Report Includes:**
- Clear title and description
- Steps to reproduce
- Expected vs. actual behavior
- Neovim version (`:version`)
- OS and version
- Relevant configuration files
- Error messages/logs

**Example:**
```markdown
## Bug: LSP not starting for Rust files

**Environment:**
- Neovim: 0.10.0
- OS: macOS 14.0
- Rust version: 1.75.0

**Steps to Reproduce:**
1. Open a .rs file
2. Run `:LspInfo`
3. See "No clients attached"

**Expected:** rust-analyzer should attach
**Actual:** No LSP client starts

**Error Log:**
[Paste error from `:messages`]
```

### 2. Suggesting Features

**Before suggesting:**
- Check if it already exists
- Search [existing issues](https://github.com/epicsagas/vortex.nvim/issues)

**Good Feature Request Includes:**
- Clear use case
- Expected behavior
- Alternative solutions considered
- Impact on existing features

### 3. Adding Language Support

We love new language support! Follow this structure:

**Required Files:**
```
lua/plugins/
└── your-language.lua    # Main plugin file
```

**Template:**
```lua
-- lua/plugins/your-language.lua
return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        your_lsp = {
          -- LSP settings
        },
      },
    },
  },

  -- Language-specific plugins
  {
    "author/plugin-name",
    ft = "your-filetype",
    config = function()
      -- Plugin configuration
    end,
  },
}
```

**Update Documentation:**
1. Add to [LANGUAGES.md](LANGUAGES.md)
2. Update README.md feature list
3. Add keybindings section

**Submit PR with:**
- Working LSP configuration
- Formatter integration
- F5/F6 quick run support
- Debug configuration (if applicable)
- Language-specific documentation

### 4. Improving AI Integration

**nvim-ai CLI Improvements:**
- Add new AI providers
- Improve context extraction
- Add new commands
- Enhance error handling

**CodeCompanion Improvements:**
- Add custom prompts
- Improve slash commands
- Better model selection

### 5. Fixing Documentation

Documentation improvements are always welcome:
- Fix typos and grammar
- Add examples
- Improve clarity
- Add translations (Korean/English)
- Update outdated information

## 📝 Pull Request Process

### 1. Fork and Clone

```bash
# Fork on GitHub, then:
git clone https://github.com/YOUR_USERNAME/vortex.nvim.git
cd vortex.nvim
git remote add upstream https://github.com/epicsagas/vortex.nvim.git
```

### 2. Create Branch

```bash
# Use descriptive branch names
git checkout -b feat/add-haskell-support
git checkout -b fix/rust-debugger-config
git checkout -b docs/improve-quickstart
```

**Branch Naming:**
- `feat/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation
- `refactor/` - Code refactoring
- `test/` - Test additions
- `chore/` - Maintenance tasks

### 3. Make Changes

**Code Style:**
- Follow existing Lua style
- Use 2-space indentation
- Keep lines under 120 characters
- Comment complex logic
- Use meaningful variable names

**Commit Messages:**
```bash
# Good commits
git commit -m "feat(rust): add rustfmt on save"
git commit -m "fix(lsp): resolve gopls initialization error"
git commit -m "docs: update AI CLI installation steps"

# Bad commits
git commit -m "updates"
git commit -m "fix stuff"
git commit -m "wip"
```

**Commit Format:**
```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Tests
- `chore`: Maintenance

**Example:**
```
feat(python): add pyright LSP support

- Configure pyright with type checking
- Add black formatter integration
- Set up debugpy for debugging

Closes #123
```

### 4. Test Changes

**Manual Testing:**
```bash
# Test in clean environment
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim

# Launch Neovim
nvim

# Test your changes
:checkhealth
:LspInfo
:Mason
```

**Language-Specific Testing:**
```bash
# Open test file
nvim test.rs  # or test.go, test.py, etc.

# Test LSP
:LspInfo

# Test formatting
:Format

# Test quick run
# Press F5

# Test debugging
# Press F9
```

### 5. Update Documentation

**Always Update:**
- README.md (if adding features)
- LANGUAGES.md (if adding language support)
- Relevant .md files

**Add Examples:**
```markdown
### New Feature

**Usage:**
\`\`\`lua
-- Example configuration
require('your-plugin').setup({
  option = value,
})
\`\`\`

**Keybindings:**
| Key | Action |
|-----|--------|
| `<Space>x` | Do something |
```

### 6. Submit Pull Request

**PR Title:**
```
feat(rust): add enhanced debugging support
fix(lsp): resolve Python import errors
docs: improve AI CLI installation guide
```

**PR Description Template:**
```markdown
## Changes
Brief description of changes

## Motivation
Why this change is needed

## Testing
How you tested this change

## Screenshots (if applicable)
[Add screenshots]

## Checklist
- [ ] Code tested manually
- [ ] Documentation updated
- [ ] No breaking changes
- [ ] Follows code style
- [ ] Commit messages follow convention

## Related Issues
Closes #123
Fixes #456
```

### 7. Review Process

**What Happens Next:**
1. Automated checks run
2. Maintainer reviews code
3. Feedback provided (if needed)
4. You make requested changes
5. PR merged!

**Response Time:**
- Initial review: 1-3 days
- Follow-up: 1-2 days
- Merge: After approval

## 🎨 Code Style Guide

### Lua Style

```lua
-- Good
local function setup_lsp(server_name, opts)
  local lspconfig = require("lspconfig")
  lspconfig[server_name].setup(vim.tbl_extend("force", {
    capabilities = capabilities,
  }, opts or {}))
end

-- Bad
local function setup_lsp(server,opts)
local lspconfig=require("lspconfig")
lspconfig[server].setup(vim.tbl_extend("force",{capabilities=capabilities},opts or {}))
end
```

### Configuration Files

```lua
-- lua/plugins/example.lua
return {
  {
    "author/plugin-name",
    event = "VeryLazy",  -- Load strategy
    dependencies = {
      "required/plugin",
    },
    opts = {
      -- Plugin options
      enable = true,
    },
    config = function(_, opts)
      require("plugin-name").setup(opts)
    end,
  },
}
```

### Keybinding Conventions

```lua
-- Use consistent leader key
vim.g.mapleader = " "

-- Group related keybindings
keymap("n", "<leader>ff", telescope.find_files, { desc = "Find files" })
keymap("n", "<leader>fg", telescope.live_grep, { desc = "Live grep" })

-- Language-specific: <leader> + first letter
keymap("n", "<leader>rr", rust.runnables, { desc = "Rust runnables" })
keymap("n", "<leader>gr", go.run, { desc = "Go run" })
```

## 🏆 Recognition

Contributors will be:
- Listed in CHANGELOG.md
- Mentioned in release notes
- Added to Contributors section (if significant contribution)

## 📞 Getting Help

**Questions?**
- Open a [Discussion](https://github.com/epicsagas/vortex.nvim/discussions)
- Check [Troubleshooting](TROUBLESHOOTING.md)
- Review existing [Issues](https://github.com/epicsagas/vortex.nvim/issues)

**Need guidance?**
- Comment on the issue you want to work on
- Ask for clarification before starting
- Request feedback early and often

## 📜 Code of Conduct

This project follows the [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you agree to uphold this code.

## 🎉 Thank You!

Your contributions make this project better for everyone. We appreciate your time and effort!

---

**Happy Contributing! 🚀**
