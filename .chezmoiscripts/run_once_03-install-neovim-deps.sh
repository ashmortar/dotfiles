#!/bin/bash
set -eufo pipefail

echo "📝 Setting up Neovim dependencies..."

# Ensure Neovim config directory exists
mkdir -p ~/.config/nvim

# Install vim-plug (keeping it simple for initial setup)
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo "✅ Neovim dependencies installed!"
