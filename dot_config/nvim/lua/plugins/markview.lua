require('markview').setup({
  headings = {
    enable = true,
    heading_1 = { style = 'slanted' },
    heading_2 = { style = 'slanted' },
    heading_3 = { style = 'slanted' },
  },
  tables = {
    enable = true,
    style = 'rounded',
  },
  block_quotes = {
    enable = true,
    default = { border = '▌' },
  },
  code_blocks = {
    enable = true,
    style = 'minimal',
    min_width = 60,
  },
  list_items = {
    enable = true,
    marker_dot = { text = '•' },
    marker_minus = { text = '•' },
    marker_plus = { text = '•' },
  },
  checkboxes = {
    enable = true,
    checked = { text = '✓' },
    unchecked = { text = '✗' },
    pending = { text = '•' },
  },
  inline_codes = { enable = true },
  hyperlinks = { enable = true },
  latex = { enable = true },
})

vim.keymap.set('n', '<leader>mt', '<cmd>Markview toggle<cr>', { desc = 'Toggle markdown preview' })
vim.keymap.set('n', '<leader>ms', '<cmd>Markview splitToggle<cr>', { desc = 'Toggle split view' })
vim.keymap.set('n', '<leader>mh', '<cmd>Markview hybridToggle<cr>', { desc = 'Toggle hybrid mode' })
