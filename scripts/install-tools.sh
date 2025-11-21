#!/bin/bash
# Install additional development tools for Rust and Go

echo "Installing Rust tools..."
if command -v rustup &> /dev/null; then
    rustup component add rust-analyzer rustfmt clippy
    echo "✓ Rust tools installed"
else
    echo "⚠ Rust not found. Install from https://rustup.rs"
fi

echo ""
echo "Installing Go tools..."
if command -v go &> /dev/null; then
    go install golang.org/x/tools/gopls@latest
    go install github.com/go-delve/delve/cmd/dlv@latest
    go install mvdan.cc/gofumpt@latest
    go install golang.org/x/tools/cmd/goimports@latest
    echo "✓ Go tools installed"
else
    echo "⚠ Go not found. Install from https://go.dev"
fi

echo ""
echo "Checking optional dependencies..."
if ! command -v rg &> /dev/null; then
    echo "⚠ ripgrep not found (recommended for Telescope grep)"
    echo "  Install: brew install ripgrep"
fi

if ! command -v fd &> /dev/null; then
    echo "⚠ fd not found (optional for Telescope find)"
    echo "  Install: brew install fd"
fi

echo ""
echo "All done! Launch Neovim with: nvim"

