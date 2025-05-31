return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      suggestion = { enabled = false },
      panel = { auto_refresh = true, position = 'right' },
      filetypes = {
        mardown = true,
      },
    }
  end,
}
