-- Add Mason bin to PATH
vim.env.PATH = vim.fn.stdpath('data') .. '/mason/bin:' .. vim.env.PATH

-- 1. Mason: install LSP servers and tools
require('mason').setup({
  ui = {
    icons = {
      package_installed = '✓',
      package_pending = '➜',
      package_uninstalled = '✗',
    },
  },
})

-- 2. mason-tool-installer: ensure all tools are installed
require('mason-tool-installer').setup({
  ensure_installed = {
    -- LSP servers
    'basedpyright',
    'ruff',
    'ts_ls',
    'gopls',
    'lua_ls',
    'templ',
    'html',
    -- Formatters
    'prettier',
    'stylua',
    'goimports',
    'gofumpt',
    -- Linters
    'mypy',
    'eslint_d',
    'golangci-lint',
  },
})

-- 3. Define server configurations (merged with nvim-lspconfig defaults)
vim.lsp.config('basedpyright', {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = 'standard',
        autoImportCompletions = true,
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

vim.lsp.config('ruff', {})

vim.lsp.config('ts_ls', {})

vim.lsp.config('gopls', {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config('templ', {})

vim.lsp.config('html', {
  filetypes = { 'html', 'templ' },
})

-- 4. mason-lspconfig: bridges Mason installs with vim.lsp.config
--    automatic_enable auto-calls vim.lsp.enable() for installed servers
--    exclude pyright since we use basedpyright
require('mason-lspconfig').setup({
  automatic_enable = {
    exclude = { 'pyright' },
  },
})

-- 5. Diagnostic configuration
vim.diagnostic.config({
  virtual_text = { source = true },
  float = { border = 'rounded', source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.HINT] = '',
      [vim.diagnostic.severity.INFO] = '',
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- 6. LSP keybinds and capability overrides (on attach)
-- 0.12 built-ins: grd (definition), grr (references), gri (implementation),
-- grn (rename), gra (code action), gO (document symbols), K (hover)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_keymaps', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- Disable ruff hover in favor of basedpyright (per official ruff docs)
    if client and client.name == 'ruff' then
      client.server_capabilities.hoverProvider = false
    end

    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    local builtin = require('telescope.builtin')

    -- Override built-in LSP keybinds with Telescope pickers
    map('grr', builtin.lsp_references, 'References')
    map('grd', builtin.lsp_definitions, 'Definition')
    map('gri', builtin.lsp_implementations, 'Implementation')
    map('gO', builtin.lsp_document_symbols, 'Document symbols')

    map('gD', vim.lsp.buf.declaration, 'Go to declaration')
    map('<leader>ld', builtin.lsp_type_definitions, 'Type definition')
    map('<leader>lw', builtin.lsp_workspace_symbols, 'Workspace symbols')
    map('<leader>lf', function()
      vim.lsp.buf.format({ async = true })
    end, 'Format buffer')

    -- Toggle inlay hints if supported
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>lh', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, 'Toggle inlay hints')
    end
  end,
})
