return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>lf',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        desc = 'Format buffer',
      },
    },
    config = function()
      -- Function to get python path from virtual environment
      local function get_python_path()
        local function find_venv_path(path)
          local venv_path = path .. '/.venv'
          if vim.fn.isdirectory(venv_path) == 1 then
            return venv_path
          end

          local parent = vim.fn.fnamemodify(path, ':h')
          if parent == path then
            return nil
          end
          return find_venv_path(parent)
        end

        local cwd = vim.fn.getcwd()
        local venv_path = find_venv_path(cwd)

        if venv_path then
          local python_path
          if vim.fn.has 'win32' == 1 then
            python_path = venv_path .. '/Scripts/python'
          else
            python_path = venv_path .. '/bin/python'
          end

          if vim.fn.executable(python_path) == 1 then
            return python_path
          end
        end

        return 'python3'
      end

      require('conform').setup {
        formatters_by_ft = {
          python = { 'ruff_format', 'ruff_fix' },
          javascript = { 'prettier' },
          typescript = { 'prettier' },
          javascriptreact = { 'prettier' },
          typescriptreact = { 'prettier' },
          json = { 'prettier' },
          yaml = { 'prettier' },
          markdown = { 'prettier' },
          html = { 'prettier' },
          css = { 'prettier' },
          go = { 'goimports', 'gofumpt' },
          lua = { 'stylua' },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
        formatters = {
          ruff_format = {
            command = function()
              local python_path = get_python_path()
              return python_path
            end,
            args = { '-m', 'ruff', 'format', '--stdin-filename', '$FILENAME', '-' },
          },
          ruff_fix = {
            command = function()
              local python_path = get_python_path()
              return python_path
            end,
            args = { '-m', 'ruff', 'check', '--stdin-filename', '$FILENAME', '--fix', '-' },
          },
        },
      }
    end,
  },

  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      -- Function to get python path from virtual environment
      local function get_python_path()
        local function find_venv_path(path)
          local venv_path = path .. '/.venv'
          if vim.fn.isdirectory(venv_path) == 1 then
            return venv_path
          end

          local parent = vim.fn.fnamemodify(path, ':h')
          if parent == path then
            return nil
          end
          return find_venv_path(parent)
        end

        local cwd = vim.fn.getcwd()
        local venv_path = find_venv_path(cwd)

        if venv_path then
          local python_path
          if vim.fn.has 'win32' == 1 then
            python_path = venv_path .. '/Scripts/python'
          else
            python_path = venv_path .. '/bin/python'
          end

          if vim.fn.executable(python_path) == 1 then
            return python_path
          end
        end

        return 'python3'
      end

      -- Configure linters to use virtual environment
      lint.linters.mypy.cmd = get_python_path()
      lint.linters.mypy.args = { '-m', 'mypy', '--show-column-numbers', '--show-error-end' }

      lint.linters.ruff.cmd = get_python_path()
      lint.linters.ruff.args = { '-m', 'ruff', 'check', '--output-format', 'json', '--stdin-filename' }

      lint.linters_by_ft = {
        python = { 'mypy', 'ruff' },
        javascript = { 'eslint' },
        typescript = { 'eslint' },
        javascriptreact = { 'eslint' },
        typescriptreact = { 'eslint' },
        go = { 'golangcilint' },
      }

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('lint', { clear = true }),
        callback = function()
          -- Update linter commands when entering a buffer (in case venv changed)
          lint.linters.mypy.cmd = get_python_path()
          lint.linters.ruff.cmd = get_python_path()
          lint.try_lint()
        end,
      })
    end,
  },
}
