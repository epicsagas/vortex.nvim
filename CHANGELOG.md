# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- nvim-ai CLI integration with multi-provider support (Claude, Gemini, Cursor)
- Comprehensive documentation in English and Korean
- GitHub templates for issues and pull requests
- Security policy (SECURITY.md)
- Buy Me a Coffee sponsorship link

### Changed
- Reorganized documentation structure (docs/ folder)
- Consolidated nvim-ai config into main nvim folder
- Updated all documentation paths

## [1.0.0] - 2024-11-20

### Added
- Initial release with support for 24 programming languages
- Full LSP integration via Mason
- Debugging support (DAP) for all major languages
- AI integration with CodeCompanion (Claude, Gemini, xAI)
- Quick run functionality (F5/F6) for all languages
- Comprehensive language-specific configurations:
  - **Systems Languages**: Rust, Go, C/C++, Zig, Nim
  - **JVM Languages**: Java, Kotlin, Scala
  - **Mobile**: Swift, Dart/Flutter
  - **Web**: TypeScript, JavaScript, PHP
  - **Scripting**: Python, Ruby, Bash, Lua, R
  - **Functional**: Haskell, Elixir, Lisp
  - **Enterprise**: C#
  - **Query**: SQL
- Git integration (LazyGit, Neogit, Diffview)
- Markdown and diagram preview support (Mermaid, PlantUML)
- Undo tree with persistent undo
- Automatic plugin management with lazy.nvim
- Telescope for fuzzy finding
- Treesitter for syntax highlighting
- nvim-cmp for completion
- Auto-formatting on save for all languages
- Installation scripts for easy setup

### Documentation
- Quick start guide
- Language-specific guides
- Troubleshooting guide
- AI setup guide
- Deployment guide
- Contributing guidelines
- Code of Conduct
- Markdown and diagrams guide

### Languages Supported
24 languages with full IDE features:
- Rust, Go, Python, C/C++, Java, TypeScript, JavaScript, PHP
- Swift, Kotlin, Dart/Flutter, C#, Zig, Nim
- Elixir, Haskell, Scala, Lisp (Common Lisp & Scheme)
- Lua, Ruby, R, Bash, SQL

---

## Release Types

- **Major version** (X.0.0): Breaking changes or major new features
- **Minor version** (0.X.0): New features, backward compatible
- **Patch version** (0.0.X): Bug fixes and minor improvements

## Categories

- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security improvements

[Unreleased]: https://github.com/epicsagas/vortex.nvim/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/epicsagas/vortex.nvim/releases/tag/v1.0.0
