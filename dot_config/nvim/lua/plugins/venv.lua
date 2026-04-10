require('venv-selector').setup({
  settings = {
    search = {
      -- Search for .venv in workspace (covers uv + standard + poetry in-project)
      workspace_venvs = { enabled = true },
      -- Search poetry centralized venvs
      poetry = { enabled = true },
      -- Search for uv-managed venvs
      uv = { enabled = true },
    },
  },
})

vim.keymap.set('n', '<leader>pv', '<cmd>VenvSelect<cr>', { desc = 'Select Python venv' })
