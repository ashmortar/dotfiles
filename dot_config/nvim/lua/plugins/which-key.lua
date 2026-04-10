require('which-key').setup({
  delay = 0,
})

require('which-key').add({
  { '<leader>b', group = 'Buffer' },
  { '<leader>f', group = 'Find' },
  { '<leader>g', group = 'Git' },
  { '<leader>l', group = 'LSP (extras)' },
  { 'gr', group = 'LSP (built-in)' },
  { '<leader>m', group = 'Markdown' },
  { '<leader>p', group = 'Python' },
  { '<leader>x', group = 'Diagnostics/TODOs' },
})
