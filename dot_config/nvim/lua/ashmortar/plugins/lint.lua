return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      -- Configure mypy specifically
      lint.linters.mypy.args = {
        '--show-column-numbers',
        '--hide-error-context',
        '--no-error-summary',
        '--no-pretty',
        '--ignore-missing-imports',
      }

      lint.linters_by_ft = {
        -- ... other linters ...
        python = { 'mypy', 'ruff' },
      }

      -- Create an autocommand that triggers more aggressively for Python files
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave', 'TextChanged' }, {
        group = lint_augroup,
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          local ft = vim.bo[bufnr].filetype
          if ft == 'python' then
            require('lint').try_lint()
          end
        end,
      })

      -- Add a command to manually trigger linting
      vim.api.nvim_create_user_command('Lint', function()
        require('lint').try_lint()
      end, {})
    end,
  },
}
