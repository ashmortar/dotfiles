-- Autopairs
require('nvim-autopairs').setup({
  check_ts = true,
})

-- TODO comments
require('todo-comments').setup({})

vim.keymap.set('n', ']t', function() require('todo-comments').jump_next() end, { desc = 'Next TODO' })
vim.keymap.set('n', '[t', function() require('todo-comments').jump_prev() end, { desc = 'Previous TODO' })
vim.keymap.set('n', '<leader>xt', '<cmd>TodoTelescope<cr>', { desc = 'Search TODOs' })
