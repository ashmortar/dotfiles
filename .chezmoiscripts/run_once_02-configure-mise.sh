#!/bin/bash
set -eufo pipefail

echo "🔧 Setting up mise..."

# Install mise if not present
if ! command -v mise &>/dev/null; then
  curl https://mise.run | sh
fi

# Add mise to path for this script
export PATH="$HOME/.local/bin:$PATH"

# Configure global tools
mise use -g node@lts
mise use -g python@3.12
mise use -g go@latest
mise use -g rust@latest

# Install global packages after tools are ready
echo "📦 Installing global npm packages..."
mise exec -- npm install -g typescript typescript-language-server prettier eslint neovim

echo "📦 Installing Python tools..."
mise exec -- pip install --user poetry mypy ruff pynvim

echo "📦 Installing Rust/Cargo tools..."
# Install htmx-lsp for Neovim
mise exec -- cargo install htmx-lsp

echo "✅ Mise configuration complete!"
