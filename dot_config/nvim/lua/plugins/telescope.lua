local telescope = require('telescope')

telescope.setup({
  defaults = {
    file_ignore_patterns = { 'node_modules', '.git/' },
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = { preview_width = 0.55 },
    },
  },
  extensions = {
    fzf = {},
    undo = {},
  },
})

-- Load extensions
telescope.load_extension('fzf')
telescope.load_extension('undo')

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent files' })
vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Search current buffer' })
vim.keymap.set('n', '<leader>fu', '<cmd>Telescope undo<cr>', { desc = 'Undo tree' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Search diagnostics' })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Search keymaps' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Find buffers' })
