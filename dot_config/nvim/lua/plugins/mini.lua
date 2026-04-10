-- Extended text objects
require('mini.ai').setup({
  n_lines = 500,
})

-- Surround operations (sa = add, sd = delete, sr = replace)
require('mini.surround').setup()

-- Session management (autowrite on exit, manual pick from starter)
require('mini.sessions').setup({
  autowrite = true,
  autoread = false,
})

-- Start screen
require('mini.starter').setup({
  items = {
    require('mini.starter').sections.sessions(5, true),
    require('mini.starter').sections.recent_files(10, false),
    require('mini.starter').sections.builtin_actions(),
  },
  header = table.concat({
    '███╗   ██╗██╗   ██╗██╗███╗   ███╗',
    '████╗  ██║██║   ██║██║████╗ ████║',
    '██╔██╗ ██║██║   ██║██║██╔████╔██║',
    '██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║',
    '██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║',
    '╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝',
  }, '\n'),
  footer = '',
})
