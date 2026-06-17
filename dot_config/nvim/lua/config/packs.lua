local gh = function(repo)
  return 'https://github.com/' .. repo
end

vim.pack.add({
  -- Dependencies
  gh('nvim-lua/plenary.nvim'),
  gh('MunifTanjim/nui.nvim'),
  gh('nvim-tree/nvim-web-devicons'),

  -- Colorscheme
  gh('navarasu/onedark.nvim'),

  -- LSP & Completion
  gh('neovim/nvim-lspconfig'),
  gh('mason-org/mason.nvim'),
  gh('mason-org/mason-lspconfig.nvim'),
  gh('WhoIsSethDaniel/mason-tool-installer.nvim'),
  gh('saghen/blink.lib'),
  gh('saghen/blink.cmp'),

  -- Treesitter (archived repo, main branch for 0.12)
  { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' },

  -- Fuzzy finding
  gh('nvim-telescope/telescope.nvim'),
  gh('nvim-telescope/telescope-fzf-native.nvim'),
  gh('debugloop/telescope-undo.nvim'),

  -- File explorer
  gh('nvim-neo-tree/neo-tree.nvim'),
  gh('stevearc/oil.nvim'),

  -- Navigation
  gh('folke/flash.nvim'),

  -- Git
  gh('lewis6991/gitsigns.nvim'),
  gh('NeogitOrg/neogit'),
  gh('sindrets/diffview.nvim'),

  -- Formatting & Linting
  gh('stevearc/conform.nvim'),
  gh('mfussenegger/nvim-lint'),

  -- Mini modules
  gh('echasnovski/mini.nvim'),

  -- Editing
  gh('windwp/nvim-autopairs'),
  gh('folke/todo-comments.nvim'),

  -- UI
  gh('folke/which-key.nvim'),

  -- Python
  gh('linux-cultist/venv-selector.nvim'),

  -- Markdown
  gh('OXY2DEV/markview.nvim'),

  -- Tmux
  gh('christoomey/vim-tmux-navigator'),

  -- Splash screen
  gh('Amansingh-afk/milli.nvim'),
}, { confirm = false })

-- vim.pack does not run plugin build steps, so drive them off PackChanged
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind, path = ev.data.spec.name, ev.data.kind, ev.data.path
    if kind ~= 'install' and kind ~= 'update' then return end
    if name == 'blink.cmp' then
      require('blink.cmp').build():pwait()
    elseif name == 'telescope-fzf-native.nvim' then
      vim.system({ 'make' }, { cwd = path }):wait()
    end
  end,
})
