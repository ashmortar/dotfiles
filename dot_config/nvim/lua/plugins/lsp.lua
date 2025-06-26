return {
  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'folke/neodev.nvim',
    },
    config = function()
      -- Enhanced diagnostic configuration
      vim.diagnostic.config {
        virtual_text = {
          enabled = true,
          source = 'if_many',
          prefix = '●', -- Could be '■', '▎', 'x'
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = 'always',
          header = '',
          prefix = '',
        },
      }

      -- Define diagnostic signs
      local signs = {
        { name = 'DiagnosticSignError', text = '' },
        { name = 'DiagnosticSignWarn', text = '' },
        { name = 'DiagnosticSignHint', text = '' },
        { name = 'DiagnosticSignInfo', text = '' },
      }

      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
      end

      -- Helper function to find virtual environment
      local function find_venv()
        -- Check for .venv in current directory and parent directories
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
          -- Determine python executable path based on OS
          local python_path
          if vim.fn.has 'win32' == 1 then
            python_path = venv_path .. '/Scripts/python.exe'
          else
            python_path = venv_path .. '/bin/python'
          end

          if vim.fn.executable(python_path) == 1 then
            return python_path, venv_path
          end
        end

        -- Fallback to system python
        return vim.fn.exepath 'python3' or vim.fn.exepath 'python', nil
      end

      -- Setup mason first
      require('mason').setup {
        ui = {
          border = 'rounded',
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
          },
        },
      }

      require('mason-lspconfig').setup {
        ensure_installed = {
          'basedpyright',
          'ruff',
          'ts_ls',
          'gopls',
          'lua_ls',
        },
        automatic_installation = true,
      }

      -- Setup neodev for Neovim lua development
      require('neodev').setup()

      -- LSP settings
      local lspconfig = require 'lspconfig'
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Enhanced on_attach function with diagnostic keybindings
      local on_attach = function(client, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
        end

        -- LSP navigation
        map('gd', vim.lsp.buf.definition, 'Goto Definition')
        map('gr', vim.lsp.buf.references, 'Goto References')
        map('gI', vim.lsp.buf.implementation, 'Goto Implementation')
        map('<leader>ld', vim.lsp.buf.type_definition, 'Type Definition')
        map('<leader>ls', vim.lsp.buf.document_symbol, 'Document Symbols')
        map('<leader>lw', vim.lsp.buf.workspace_symbol, 'Workspace Symbols')
        map('<leader>lr', vim.lsp.buf.rename, 'Rename')
        map('<leader>la', vim.lsp.buf.code_action, 'Code Action')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

        -- Diagnostic navigation and viewing
        map('<leader>lD', vim.diagnostic.open_float, 'Show Line Diagnostics')
        map('<leader>lq', vim.diagnostic.setloclist, 'Add Buffer Diagnostics to Location List')
        map('[d', vim.diagnostic.goto_prev, 'Previous Diagnostic')
        map(']d', vim.diagnostic.goto_next, 'Next Diagnostic')
        map('[e', function()
          vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
        end, 'Previous Error')
        map(']e', function()
          vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
        end, 'Next Error')
        map('[w', function()
          vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.WARN }
        end, 'Previous Warning')
        map(']w', function()
          vim.diagnostic.goto_next { severity = vim.diagnostic.severity.WARN }
        end, 'Next Warning')

        -- Additional diagnostic commands
        map('<leader>lL', function()
          vim.diagnostic.setqflist { severity = { min = vim.diagnostic.severity.WARN } }
        end, 'Add Workspace Diagnostics to Quickfix')
      end

      -- Get python path and venv for current project
      local python_path, venv_path = find_venv()

      -- Python
      lspconfig.basedpyright.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = 'basic',
              autoImportCompletions = true,
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
          python = {
            pythonPath = python_path,
            venvPath = venv_path,
          },
        },
      }

      lspconfig.ruff.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        init_options = {
          settings = {
            -- Use the python path from virtual environment
            interpreter = { python_path },
          },
        },
      }

      -- TypeScript
      require('typescript-tools').setup {
        on_attach = on_attach,
        settings = {
          complete_function_calls = true,
          include_completions_with_insert_text = true,
        },
      }

      -- Go
      lspconfig.gopls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      }

      -- Lua
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }
    end,
  },

  -- TypeScript tools
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  },
}
