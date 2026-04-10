#!/bin/bash
set -eufo pipefail

echo "📝 Setting up Neovim dependencies..."

# Ensure directories exist
mkdir -p ~/.config/nvim
mkdir -p ~/.local/share/nvim
mkdir -p ~/.local/bin

# Verify tools needed by Neovim plugins
echo "🔍 Checking Neovim dependencies..."

if command -v tree-sitter &>/dev/null; then
  echo "✓ tree-sitter-cli is installed (required for treesitter parsers)"
else
  echo "⚠️  tree-sitter-cli not found. Treesitter parsers won't compile."
fi

if command -v rg &>/dev/null; then
  echo "✓ ripgrep is installed (required for Telescope live grep)"
else
  echo "⚠️  ripgrep not found. Install it for Telescope grep."
fi

if command -v fd &>/dev/null; then
  echo "✓ fd is installed (improves Telescope file finding)"
else
  echo "⚠️  fd not found. Install it for better Telescope performance."
fi

if command -v nvim &>/dev/null; then
  echo "✓ Neovim $(nvim --version | head -1)"
else
  echo "⚠️  Neovim not found in PATH. Check ~/.local/bin is in PATH."
fi

# Build telescope-fzf-native (requires make + gcc)
FZF_NATIVE_DIR="$HOME/.local/share/nvim/site/pack/core/opt/telescope-fzf-native.nvim"
if [[ -d "$FZF_NATIVE_DIR" ]] && [[ ! -f "$FZF_NATIVE_DIR/build/libfzf.so" ]] && [[ ! -f "$FZF_NATIVE_DIR/build/libfzf.dylib" ]]; then
  echo "🔨 Building telescope-fzf-native..."
  make -C "$FZF_NATIVE_DIR"
fi

echo "✅ Neovim dependencies check complete!"
