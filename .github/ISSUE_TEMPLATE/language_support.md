---
name: Language Support Request
about: Request support for a new programming language
title: '[LANG] Add support for [Language Name]'
labels: enhancement, language
assignees: ''
---

## Language Information

**Language Name:** ____________

**Official Website:** ____________

**Why Add This Language?**

<!-- Explain popularity, use cases, community size -->

## Language Ecosystem

### LSP Server

**Name:** ____________

**Installation:**
```bash
<!-- How to install the LSP server -->
```

**Configuration:**
```lua
<!-- Basic LSP configuration -->
```

**Documentation:** ____________

### Formatter

**Tool:** ____________ (e.g., prettier, black, rustfmt)

**Installation:**
```bash
<!-- Installation command -->
```

**Configuration:**
```lua
<!-- Format on save config -->
```

### Linter (Optional)

**Tool:** ____________

**Installation:**
```bash
<!-- Installation command -->
```

### Debugger (Optional)

**Tool:** ____________

**Installation:**
```bash
<!-- Installation command -->
```

**DAP Adapter:** ____________

## Popular Plugins

List popular Neovim plugins for this language:

1. **Plugin Name:** ____________
   - Repository: ____________
   - Purpose: ____________

2. **Plugin Name:** ____________
   - Repository: ____________
   - Purpose: ____________

3. **Plugin Name:** ____________
   - Repository: ____________
   - Purpose: ____________

## Quick Run Support

**How to run files?**
```bash
<!-- Command to execute files, e.g., python3 file.py -->
```

**How to run tests?**
```bash
<!-- Command to run tests, e.g., pytest, go test -->
```

**Build system (if applicable):**
- [ ] Cargo (Rust)
- [ ] Go modules
- [ ] Maven/Gradle (Java)
- [ ] npm/yarn (JavaScript)
- [ ] Other: ____________

## Package Manager

**Name:** ____________ (e.g., npm, pip, cargo)

**Install dependencies:**
```bash
<!-- Command to install dependencies -->
```

## File Extensions

Primary extension: `.___`

Additional extensions:
- `.___`
- `.___`

## Treesitter Support

**Parser available?**
- [ ] Yes
- [ ] No
- [ ] Unsure

**Parser name:** `tree-sitter-___`

## Community & Resources

**GitHub Stars:** ____________

**Stack Overflow Questions:** ____________

**Active Development:**
- [ ] Very active
- [ ] Moderately active
- [ ] Maintenance mode

**Learning Resources:**
- Official docs: ____________
- Popular tutorials: ____________
- Community forums: ____________

## Use Cases

**Primary use cases for this language:**

1. ____________
2. ____________
3. ____________

**Target users:**
- [ ] Web development
- [ ] Systems programming
- [ ] Data science
- [ ] Mobile development
- [ ] Game development
- [ ] DevOps/scripting
- [ ] Other: ____________

## Example Configuration

**Proposed `lua/plugins/language.lua`:**

```lua
-- Provide a basic configuration example if you have one
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        language_lsp = {
          -- Configuration
        },
      },
    },
  },
}
```

## Keybinding Suggestions

**Language-specific keybindings:**

| Key | Action | Command |
|-----|--------|---------|
| `<leader>xr` | Run file | `xxx run %` |
| `<leader>xt` | Run tests | `xxx test` |
| `<leader>xb` | Build | `xxx build` |

## Similar Languages

**Similar to:**
- Language 1 (similarity reason)
- Language 2 (similarity reason)

**Can reuse config from:** ____________

## Willingness to Contribute

- [ ] I can help implement this support
- [ ] I can test the implementation
- [ ] I can provide sample projects for testing
- [ ] I can help with documentation

## Additional Context

Add any other context, screenshots, or examples about the language support request.

## Checklist

- [ ] I have provided LSP server information
- [ ] I have listed popular plugins
- [ ] I have explained why this language should be added
- [ ] I have checked if similar requests exist
