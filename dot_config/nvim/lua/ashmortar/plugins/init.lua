return {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  { 'stevearc/dressing.nvim', opts = {} },
  {
    'f-person/git-blame.nvim',
    event = 'VeryLazy',
    opts = {
      enable = true,
      message_template = '<summary> • <date> • <author> • <sha>',
      date_format = '%r',
      virtual_text_column = 1,
    },
  },
  {
    'ellisonleao/gruvbox.nvim',
    -- priority = 1000,
    config = true,
    init = function()
      vim.o.background = 'dark'
      -- vim.cmd.colorscheme 'gruvbox'
    end,
  },
  {
    'gmr458/vscode_modern_theme.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('vscode_modern').setup {
        cursorline = true,
        transparent_background = false,
        nvim_tree_darker = true,
      }
      vim.cmd.colorscheme 'vscode_modern'
    end,
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup()
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local custom_theme = require 'lualine.themes.onedark'
      require('lualine').setup {
        options = { theme = custom_theme },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
      }
    end,
  },
}
