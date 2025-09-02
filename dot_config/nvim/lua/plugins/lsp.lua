return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      { 'folke/lazydev.nvim', ft = 'lua', opts = {} },
    },
    config = function()
      vim.diagnostic.config {
        virtual_text = {
          enabled = true,
          source = 'if_many',
          prefix = '●',
        },
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
        float = {
          border = 'rounded',
          source = 'if_many',
          header = '',
          prefix = '',
        },
      }

      local function find_venv()
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
            python_path = venv_path .. '/Scripts/python.exe'
          else
            python_path = venv_path .. '/bin/python'
          end

          if vim.fn.executable(python_path) == 1 then
            return python_path, venv_path
          end
        end

        return vim.fn.exepath 'python3' or vim.fn.exepath 'python', nil
      end

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

      local lspconfig = require 'lspconfig'
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      local on_attach = function(_, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
        end

        map('gd', vim.lsp.buf.definition, 'Goto Definition')
        map('gr', vim.lsp.buf.references, 'Goto References')
        map('gI', vim.lsp.buf.implementation, 'Goto Implementation')
        map('<leader>ld', vim.lsp.buf.type_definition, 'Type Definition')
        map('<leader>ls', vim.lsp.buf.document_symbol, 'Document Symbols')
        map('<leader>lw', vim.lsp.buf.workspace_symbol, 'Workspace Symbols')
        map('<leader>lr', vim.lsp.buf.rename, 'Rename')
        map('<leader>la', vim.lsp.buf.code_action, 'Code Action')
        map('<leader>lf', vim.lsp.buf.format, 'Format Document')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

        map('<leader>lD', vim.diagnostic.open_float, 'Show Line Diagnostics')
        map('<leader>lq', vim.diagnostic.setloclist, 'Add Buffer Diagnostics to Location List')
        map('[d', function()
          vim.diagnostic.jump { count = -1, float = true }
        end, 'Previous Diagnostic')
        map(']d', function()
          vim.diagnostic.jump { count = 1, float = true }
        end, 'Next Diagnostic')
        map('[e', function()
          vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR, float = true }
        end, 'Previous Error')
        map(']e', function()
          vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR, float = true }
        end, 'Next Error')
        map('[w', function()
          vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.WARN, float = true }
        end, 'Previous Warning')
        map(']w', function()
          vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.WARN, float = true }
        end, 'Next Warning')

        map('<leader>lL', function()
          vim.diagnostic.setqflist { severity = { min = vim.diagnostic.severity.WARN } }
        end, 'Add Workspace Diagnostics to Quickfix')
      end

      local python_path, venv_path = find_venv()

      require('mason-lspconfig').setup {
        ensure_installed = {
          'basedpyright',
          'ruff',
          'ts_ls',
          'gopls',
          'lua_ls',
          'templ',
          'html-lsp',
        },
        automatic_enable = true,
        automatic_installation = true,
        handlers = {
          function(server_name)
            lspconfig[server_name].setup {
              capabilities = capabilities,
              on_attach = on_attach,
            }
          end,

          ['lua_ls'] = function()
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

          ['basedpyright'] = function()
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
          end,

          ['ruff'] = function()
            lspconfig.ruff.setup {
              capabilities = capabilities,
              on_attach = on_attach,
              init_options = {
                settings = {
                  interpreter = { python_path },
                },
              },
            }
          end,

          ['gopls'] = function()
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
          end,

          ['ts_ls'] = function() end,  -- Handled by typescript-tools

          ['templ'] = function()
            lspconfig.templ.setup {
              capabilities = capabilities,
              on_attach = on_attach,
              filetypes = { 'templ' },
            }
          end,

          ['html-lsp'] = function()
            lspconfig.html.setup {
              capabilities = capabilities,
              on_attach = on_attach,
              filetypes = { 'html', 'templ' },
            }
          end,
        },
      }

      -- HTMX (ThePrimeagen's htmx-lsp, installed via cargo)
      lspconfig.htmx.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { 'htmx-lsp' },
        filetypes = { 'html', 'templ' },
        single_file_support = true,
      }

      -- TypeScript Tools (replaces ts_ls)
      require('typescript-tools').setup {
        on_attach = on_attach,
        settings = {
          complete_function_calls = true,
          include_completions_with_insert_text = true,
        },
      }
    end,
  },

  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  },
}