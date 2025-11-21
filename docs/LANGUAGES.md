# Language-Specific Guide

> 🌏 **한국어**: [언어별 가이드](../translations/ko/docs/LANGUAGES.md)

Configuration requirements, installation methods, and usage tips for 24 programming languages.

## Table of Contents
- [Systems Languages](#systems-languages): Rust, Go, C/C++, Zig, Nim
- [JVM Languages](#jvm-languages): Java, Kotlin, Scala
- [Mobile Development](#mobile-development): Swift, Dart/Flutter
- [Web Development](#web-development): TypeScript, JavaScript, PHP
- [Scripting Languages](#scripting-languages): Python, Ruby, Bash, Lua, R
- [Functional Languages](#functional-languages): Haskell, Elixir, Lisp
- [Enterprise Languages](#enterprise-languages): C#
- [Query Languages](#query-languages): SQL

---

## Systems Languages

### Rust

**Required Tools**:
```bash
# macOS/Linux
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup component add rust-analyzer rustfmt clippy
```

**LSP**: rust-analyzer (auto-installed by Mason)
**Formatter**: rustfmt
**Debugger**: codelldb
**Plugins**: rustaceanvim, crates.nvim

**Keybindings**:
- `F5`: cargo run
- `F6`: cargo test
- `<Space>rr`: Runnables menu
- `<Space>rt`: Testables menu
- `<Space>rd`: Debuggables
- `<Space>re`: Expand macro
- `<Space>rc`: Open Cargo.toml

**Tips**:
- `crates.nvim` provides version autocompletion in Cargo.toml
- rustaceanvim automatically optimizes rust-analyzer settings
- clippy hints are displayed automatically

---

### Go

**Required Tools**:
```bash
# macOS
brew install go

# Linux
wget https://go.dev/dl/go1.21.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.linux-amd64.tar.gz

# Additional tools (auto-installed)
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
```

**LSP**: gopls
**Formatter**: goimports + gofumpt
**Debugger**: Delve
**Plugins**: go.nvim

**Keybindings**:
- `F5`: go run
- `F6`: go test
- `<Space>gr`: Go run
- `<Space>gt`: Test all
- `<Space>gT`: Test function
- `<Space>gc`: Test coverage
- `<Space>gi`: Add if err block
- `<Space>gf`: Fill struct
- `<Space>ga`: Alternate file (test ↔ impl)

**Tips**:
- go.nvim automatically organizes imports
- `:GoAddTag json` - add struct tags
- `:GoFillStruct` - auto-fill struct fields

---

### C/C++

**Required Tools**:
```bash
# macOS
xcode-select --install
brew install llvm

# Linux
sudo apt install build-essential clang clangd clang-format
```

**LSP**: clangd
**Formatter**: clang-format
**Debugger**: codelldb
**Plugins**: clangd_extensions.nvim

**Keybindings**:
- `F5`: Compile & run (gcc/g++)
- `F6`: Compile with debug info
- `<Space>ch`: Switch header/source

**Tips**:
- Improve LSP by generating `compile_commands.json`:
  ```bash
  cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .
  ```
- Customize style with `.clang-format` file

---

### Zig

**Required Tools**:
```bash
# macOS
brew install zig zls

# Linux
# Download from https://ziglang.org/download/
```

**LSP**: zls
**Formatter**: zig fmt (built-in)
**Plugins**: zig.vim

**Keybindings**:
- `F5`: zig build run
- `F6`: zig test
- `<Space>zr`: Run
- `<Space>zb`: Build
- `<Space>zt`: Test
- `<Space>zf`: Format
- `<Space>zd`: Debug build
- `<Space>zR`: Release build

---

### Nim

**Required Tools**:
```bash
# macOS
brew install nim

# Linux - using choosenim is recommended
curl https://nim-lang.org/choosenim/init.sh -sSf | sh
```

**LSP**: nim_langserver
**Formatter**: nimpretty
**Plugins**: nim.nvim

**Keybindings**:
- `F5`: nim compile --run
- `F6`: nimble test
- `<Space>nr`: Run
- `<Space>nb`: Build
- `<Space>nc`: Check
- `<Space>nf`: Format
- `<Space>nd`: Generate docs

**Tips**:
- Automatically uses nimble if `.nimble` file exists
- Quick syntax check with `nim check`

---

## JVM Languages

### Java

**Required Tools**:
```bash
# macOS
brew install openjdk maven

# Linux
sudo apt install openjdk-17-jdk maven
```

**LSP**: jdtls (Eclipse JDT)
**Formatter**: google-java-format
**Debugger**: java-debug-adapter
**Plugins**: nvim-java

**Keybindings**:
- `F5`: javac + java
- `F6`: Maven test
- `<Space>jc`: Run main class
- `<Space>jt`: Test class
- `<Space>jT`: Test method
- `<Space>jd`: Debug test

**Tips**:
- jdtls automatically detects project setup (Maven/Gradle)
- First startup may be slow (workspace initialization)

---

### Kotlin

**Required Tools**:
```bash
# macOS
brew install kotlin ktlint

# Gradle projects recommended
```

**LSP**: kotlin-language-server
**Formatter**: ktlint
**Debugger**: Java debug adapter

**Keybindings**:
- `F5`: kotlinc + kotlin
- `F6`: Gradle test
- `<Space>kr`: Run
- `<Space>kb`: Build (Gradle)
- `<Space>kt`: Test
- `<Space>kc`: Format

---

### Scala

**Required Tools**:
```bash
# macOS
brew install scala sbt scalafmt

# Installing Coursier is recommended
curl -fL https://github.com/coursier/launchers/raw/master/cs-x86_64-apple-darwin.gz | gzip -d > cs && chmod +x cs && ./cs setup
```

**LSP**: Metals (nvim-metals)
**Formatter**: scalafmt
**Plugins**: nvim-metals

**Keybindings**:
- `F5`: sbt run
- `F6`: sbt test
- `<Space>mc`: Compile cascade
- `<Space>mt`: Test
- `<Space>mf`: Format
- `<Space>mR`: REPL

**Tips**:
- Metals requires project import on first startup
- Set format style with `.scalafmt.conf`

---

## Mobile Development

### Swift

**Required Tools**:
```bash
# macOS only
xcode-select --install

# Additional tools
brew install swiftformat swiftlint
```

**LSP**: sourcekit-lsp
**Formatter**: swiftformat
**Debugger**: LLDB
**Plugins**: xcodebuild.nvim

**Keybindings**:
- `F5`: swift run
- `F6`: swift test
- `<Space>Sr`: Run
- `<Space>Sb`: Build
- `<Space>St`: Test
- `<Space>SX`: Xcode picker
- `<Space>SD`: Select device

**Tips**:
- Supports both Package.swift and Xcode projects
- Full Xcode integration with xcodebuild.nvim

---

### Dart/Flutter

**Required Tools**:
```bash
# Install Flutter SDK
# https://docs.flutter.dev/get-started/install

# macOS
brew install --cask flutter

# Set PATH
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
```

**LSP**: dartls (included in Flutter SDK)
**Formatter**: dart format
**Debugger**: Dart debug adapter
**Plugins**: flutter-tools.nvim

**Keybindings**:
- `F5`: Flutter run
- `F6`: Flutter test
- `<Space>dr`: Flutter run
- `<Space>dh`: Hot reload
- `<Space>dR`: Flutter restart
- `<Space>dd`: Devices
- `<Space>de`: Emulators
- `<Space>dt`: DevTools

**Tips**:
- `flutter pub get` runs automatically
- Fast development with hot reload
- Widget guides displayed automatically

---

## Web Development

### TypeScript/JavaScript

**Required Tools**:
```bash
# macOS
brew install node

# Linux
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install nodejs

# Global tools
npm install -g typescript tsx prettier eslint
```

**LSP**: typescript-language-server (typescript-tools.nvim)
**Formatter**: prettier
**Linter**: eslint_d
**Debugger**: js-debug-adapter

**Keybindings**:
- `F5`: Run with node/tsx
- `F6`: npm test
- `<Space>to`: Organize imports
- `<Space>ts`: Sort imports
- `<Space>tu`: Remove unused
- `<Space>ti`: Add missing imports
- `<Space>tf`: Fix all

**Tips**:
- typescript-tools provides inlay hints
- ESLint auto-fix: `<Space>ca` → Fix ESLint
- `tsconfig.json` settings auto-detected

---

### PHP

**Required Tools**:
```bash
# macOS
brew install php composer

# Linux
sudo apt install php php-cli composer

# Additional tools
composer global require friendsofphp/php-cs-fixer
composer global require phpstan/phpstan
```

**LSP**: intelephense
**Formatter**: php-cs-fixer
**Linter**: phpstan
**Debugger**: Xdebug
**Plugins**: phpactor

**Keybindings**:
- `F5`: Run php
- `F6`: phpunit
- `<Space>pm`: Context menu
- `<Space>pn`: New class
- `<Space>pu`: Import class
- `<Space>pa`: Import missing classes

**Tips**:
- Composer autoload auto-detected
- Class creation and import with phpactor

---

## Scripting Languages

### Python

**Required Tools**:
```bash
# macOS
brew install python

# Linux
sudo apt install python3 python3-pip python3-venv

# Additional tools
pip install black isort debugpy pytest
```

**LSP**: pyright
**Formatter**: black + isort
**Debugger**: debugpy
**Plugins**: venv-selector.nvim

**Keybindings**:
- `F5`: Run with python3
- `F6`: pytest
- `<Space>vs`: Select venv
- `<Space>pc`: Syntax check
- `<Space>pi`: Install requirements

**Tips**:
- Virtual environment auto-detected (.venv, venv)
- Manual selection with `<Space>vs`
- Better autocompletion with type hints

---

### Ruby

**Required Tools**:
```bash
# macOS
brew install ruby rubocop

# Linux
sudo apt install ruby-full

# Bundler
gem install bundler rubocop
```

**LSP**: ruby-lsp
**Formatter**: rubocop
**Debugger**: Ruby debug adapter
**Plugins**: vim-ruby

**Keybindings**:
- `F5`: Run ruby
- `F6`: rspec
- `<Space>Rr`: Run
- `<Space>Rt`: Test (RSpec)
- `<Space>Rb`: Bundle install
- `<Space>Rf`: Format
- `<Space>Ri`: IRB REPL

---

### Bash

**Required Tools**:
```bash
# macOS
brew install shellcheck shfmt

# Linux
sudo apt install shellcheck
go install mvdan.cc/sh/v3/cmd/shfmt@latest
```

**LSP**: bash-language-server
**Formatter**: shfmt
**Linter**: shellcheck

**Keybindings**:
- `F5`: Run script
- `F6`: shellcheck
- `<Space>br`: Run
- `<Space>bx`: chmod +x
- `<Space>bc`: Shellcheck
- `<Space>bf`: Format
- `<Space>bd`: Debug mode (bash -x)

**Tips**:
- shellcheck auto-detects common mistakes
- `#!/bin/bash` shebang required

---

### Lua

**Required Tools**:
```bash
# macOS
brew install lua stylua luacheck

# Linux
sudo apt install lua5.4
```

**LSP**: lua_ls
**Formatter**: stylua
**Linter**: luacheck
**Plugins**: lazydev.nvim

**Keybindings**:
- `F5`: Run lua
- `F6`: Source (Neovim)
- `<Space>Lr`: Run
- `<Space>Ls`: Source
- `<Space>Lf`: Format
- `<Space>Lc`: Check

**Tips**:
- lazydev.nvim provides Neovim API autocompletion
- Optimized for Neovim configuration development

---

### R

**Required Tools**:
```bash
# macOS
brew install r

# Linux
sudo apt install r-base

# Install in R
R
install.packages("languageserver")
install.packages("styler")
```

**LSP**: r-languageserver
**Formatter**: styler
**Plugins**: R.nvim

**Keybindings**:
- `F5`: Start R console
- `F6`: Send file to R
- `<Space>rr`: Start console
- `<Space>rf`: Send file
- `<Space>rl`: Send line
- `<Space>rs`: Send selection
- `<Space>rv`: View DataFrame

**Tips**:
- R.nvim provides full REPL integration
- RStudio-like workflow

---

## Functional Languages

### Haskell

**Required Tools**:
```bash
# Install GHCup (recommended)
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

# Or Stack
curl -sSL https://get.haskellstack.org/ | sh

# Additional tools
ghcup install hls
cabal install ormolu hlint
```

**LSP**: haskell-language-server
**Formatter**: ormolu
**Linter**: hlint
**Plugins**: haskell-tools.nvim

**Keybindings**:
- `F5`: stack/cabal run
- `F6`: stack test
- `<Space>hr`: GHCi REPL
- `<Space>hb`: Build
- `<Space>hf`: Format
- `<Space>hh`: Hoogle search

**Tips**:
- HLS first startup is slow (project build)
- Search type signatures with Hoogle

---

### Elixir

**Required Tools**:
```bash
# macOS
brew install elixir

# Linux
sudo apt install elixir

# Phoenix (optional)
mix archive.install hex phx_new
```

**LSP**: elixir-ls
**Formatter**: mix format (built-in)
**Debugger**: Elixir debug adapter
**Plugins**: elixir-tools.nvim

**Keybindings**:
- `F5`: mix run
- `F6`: mix test
- `<Space>er`: IEx REPL
- `<Space>et`: Test all
- `<Space>eT`: Test file
- `<Space>ef`: Format
- `<Space>ep`: Phoenix server

**Tips**:
- Mix project auto-detected
- Phoenix LiveView support

---

### Lisp (Common Lisp & Scheme)

**Required Tools**:
```bash
# Common Lisp - SBCL
# macOS
brew install sbcl

# Scheme - Racket
brew install racket
```

**Plugins**: vlime

**Keybindings**:
- `F5`: Run script
- `F6`: Load to REPL
- `<Space>lr`: Start REPL
- `<Space>ll`: Load file
- `<Space>le`: Execute

**Tips**:
- SBCL for Common Lisp
- Racket for Scheme
- REPL-centric development

---

## Enterprise Languages

### C#

**Required Tools**:
```bash
# macOS
brew install dotnet

# Linux
# https://dotnet.microsoft.com/download

# Additional tools
dotnet tool install -g csharpier
```

**LSP**: omnisharp
**Formatter**: csharpier / dotnet format
**Debugger**: netcoredbg
**Plugins**: csharp.nvim

**Keybindings**:
- `F5`: dotnet run
- `F6`: dotnet test
- `<Space>Cr`: Run
- `<Space>Cb`: Build
- `<Space>Ct`: Test
- `<Space>Cf`: Format
- `<Space>Cn`: New project

**Tips**:
- .csproj file auto-detected
- NuGet package management support

---

## Query Languages

### SQL

**Required Tools**:
```bash
# macOS
brew install sqlfluff

# Install via Python
pip install sqlfluff sql-formatter
```

**LSP**: sqlls
**Formatter**: sqlfluff

**Keybindings**:
- `F5`: View SQL
- `F6`: Format SQL
- `<Space>sf`: Format
- `<Space>sl`: Lint

**Tips**:
- sqlfluff supports various SQL dialects
- Use dbext for database connections

---

## General Tips

### LSP Optimization
```lua
-- Set LSP memory in init.lua
vim.lsp.set_log_level("warn")  -- Lower log level
```

### Language Switching
When working with multiple languages:
- Quick file switching with Telescope: `<Space>ff`
- Navigate between buffers: `Shift+h` / `Shift+l`
- Recent files: `<Space>fr`

### Additional Learning Resources
Official documentation for each language:
- `:help lspconfig-all` - All LSP server configurations
- `:Mason` - List available tools
- `:checkhealth` - Check configuration status

---

**Need More Information?**
- README.md - Complete feature overview
- QUICKSTART.md - Quick start guide
- TROUBLESHOOTING.md - Troubleshooting guide
