-- Neo-tree
require('neo-tree').setup({
  close_if_last_window = true,
  popup_border_style = 'rounded',
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
    },
    follow_current_file = { enabled = true },
  },
  window = {
    mappings = {
      ['<space>'] = 'none',
    },
  },
})

vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<cr>', { desc = 'Toggle file explorer' })
vim.keymap.set('n', '<leader>E', '<cmd>Neotree reveal<cr>', { desc = 'Reveal in explorer' })

-- Oil
require('oil').setup({
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ['g?'] = 'actions.show_help',
    ['<CR>'] = 'actions.select',
    ['<C-v>'] = 'actions.select_vsplit',
    ['<C-s>'] = 'actions.select_split',
    ['<C-t>'] = 'actions.select_tab',
    ['<C-p>'] = 'actions.preview',
    ['<C-c>'] = 'actions.close',
    ['<C-r>'] = 'actions.refresh',
    ['-'] = 'actions.parent',
    ['_'] = 'actions.open_cwd',
    ['`'] = 'actions.cd',
    ['~'] = 'actions.tcd',
    ['gs'] = 'actions.change_sort',
    ['gx'] = 'actions.open_external',
    ['g.'] = 'actions.toggle_hidden',
  },
})

vim.keymap.set('n', '<leader>o', '<cmd>Oil<cr>', { desc = 'Open Oil' })
vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory' })
