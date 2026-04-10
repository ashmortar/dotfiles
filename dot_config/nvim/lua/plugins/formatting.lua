-- Formatting with conform.nvim
require('conform').setup({
  formatters_by_ft = {
    python = { 'ruff_format', 'ruff_fix' },
    javascript = { 'prettier' },
    typescript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescriptreact = { 'prettier' },
    go = { 'goimports', 'gofumpt' },
    lua = { 'stylua' },
    templ = { 'templ' },
    html = { 'prettier' },
    css = { 'prettier' },
    json = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = 'fallback',
  },
  formatters = {
    stylua = {
      prepend_args = { '--column-width', '160', '--line-endings', 'Unix' },
    },
  },
})

-- Linting with nvim-lint
require('lint').linters_by_ft = {
  python = { 'mypy', 'ruff' },
  javascript = { 'eslint_d' },
  typescript = { 'eslint_d' },
  go = { 'golangcilint' },
}

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('lint', { clear = true }),
  callback = function()
    require('lint').try_lint()
  end,
})
