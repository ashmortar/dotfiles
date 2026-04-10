-- Neovim 0.12 Configuration
-- Leader must be set before any plugin loads
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Enable faster Lua module loading
vim.loader.enable()

-- Core configuration
require('config.options')
require('config.packs')
require('config.autocmds')

-- Plugin configurations
require('plugins.colorscheme')
require('plugins.lsp')
require('plugins.completion')
require('plugins.telescope')
require('plugins.treesitter')
require('plugins.formatting')
require('plugins.git')
require('plugins.navigation')
require('plugins.explorer')
require('plugins.mini')
require('plugins.venv')
require('plugins.editing')
require('plugins.which-key')
require('plugins.markview')
require('plugins.tmux-nav')

-- Keymaps last (after all plugins are loaded)
require('config.keymaps')
