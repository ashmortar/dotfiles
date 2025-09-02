#!/bin/bash
set -eufo pipefail

echo "📝 Setting up Neovim dependencies..."

# Ensure Neovim config directory exists
mkdir -p ~/.config/nvim

# Ensure lazy.nvim will be bootstrapped on first run
# (Your init.lua already handles the bootstrap, so we just need the directory)
mkdir -p ~/.local/share/nvim

# Verify language tools needed by Neovim are available
echo "🔍 Checking Neovim language tools..."

# Check if htmx-lsp is installed (should be installed by mise script)
if command -v htmx-lsp &>/dev/null; then
  echo "✓ htmx-lsp is installed"
else
  echo "⚠️  htmx-lsp not found. Run 'mise exec -- cargo install htmx-lsp' to install."
fi

# Check for other optional tools
if command -v rg &>/dev/null; then
  echo "✓ ripgrep is installed (required for Telescope live grep)"
else
  echo "⚠️  ripgrep not found. Install it for better Telescope functionality."
fi

if command -v fd &>/dev/null; then
  echo "✓ fd is installed (improves Telescope file finding)"
else
  echo "⚠️  fd not found. Install it for better Telescope performance."
fi

echo "✅ Neovim dependencies check complete!"
