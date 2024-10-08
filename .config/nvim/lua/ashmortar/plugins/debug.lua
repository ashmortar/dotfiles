-- debug.lua
-- Debugger configuration using nvim-dap
-- Supports Go, Python, Flask, Node.js (JavaScript/TypeScript), and Chrome (for PWA debugging)

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  keys = function()
    local dap, dapui = require 'dap', require 'dapui'
    return {
      { '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
      { '<F10>', dap.step_over, desc = 'Debug: Step Over' },
      { '<F11>', dap.step_into, desc = 'Debug: Step Into' },
      { '<F12>', dap.step_out, desc = 'Debug: Step Out' },
      { '<Leader>b', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
      {
        '<Leader>B',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Conditional Breakpoint',
      },
      { '<Leader>dr', dapui.toggle, desc = 'Debug: Toggle UI' },
    }
  end,
  config = function()
    local dap, dapui = require 'dap', require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      ensure_installed = { 'delve', 'debugpy', 'js-debug-adapter' },
    }

    -- UI configuration
    dapui.setup {
      icons = {
        expanded = '▾',
        collapsed = '▸',
        current_frame = '▸',
      },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
      mappings = {
        expand = { '<CR>', '<2-LeftMouse>' },
        open = 'o',
        remove = 'd',
        edit = 'e',
        repl = 'r',
        toggle = 't',
      },
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.25 },
            'breakpoints',
            'stacks',
            'watches',
          },
          size = 40,
          position = 'left',
        },
        {
          elements = {
            'repl',
            'console',
          },
          size = 0.25,
          position = 'bottom',
        },
      },
    }

    -- Python configuration
    require('dap-python').setup 'python'
    table.insert(dap.configurations.python, {
      type = 'python',
      request = 'launch',
      name = 'Python: Current File',
      program = '${file}',
      pythonPath = function()
        local venv_path = vim.fn.getcwd() .. '/.venv/bin/python'
        if vim.fn.filereadable(venv_path) == 1 then
          return venv_path
        end
        return vim.fn.exepath 'python3' or vim.fn.exepath 'python' or 'python'
      end,
    })

    -- Custom Flask configuration
    table.insert(dap.configurations.python, {
      type = 'python',
      request = 'launch',
      name = 'Flask: mercury_flask',
      module = 'flask',
      env = {
        FLASK_APP = 'mercury.api:get_app()',
        FLASK_ENV = 'development',
        FLASK_DEBUG = '1',
      },
      args = {
        'run',
        '--host=localhost',
        '--no-reload',
        '--without-threads',
      },
      pythonPath = function()
        local venv_path = vim.fn.getcwd() .. '/.venv/bin/python'
        if vim.fn.filereadable(venv_path) == 1 then
          return venv_path
        end
        return vim.fn.exepath 'python3' or vim.fn.exepath 'python' or 'python'
      end,
      cwd = '${workspaceFolder}/services/ge_cloud',
      jinja = true,
    })

    -- Function to load environment variables from .env file
    local function load_env_file()
      local env_file = io.open(vim.fn.getcwd() .. '/.env', 'r')
      if env_file then
        for line in env_file:lines() do
          local key, value = line:match '^(%S+)%s*=%s*(.+)$'
          if key and value then
            vim.fn.setenv(key, value)
          end
        end
        env_file:close()
      end
    end

    -- Load environment variables before starting debug session
    dap.listeners.before.launch.load_env = function(session, config)
      load_env_file()
    end

    -- Go configuration
    require('dap-go').setup()

    -- Node.js configuration for JavaScript and TypeScript
    dap.adapters.node2 = {
      type = 'executable',
      command = 'node',
      args = { vim.fn.stdpath 'data' .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
    }

    dap.configurations.javascript = {
      {
        name = 'Launch',
        type = 'node2',
        request = 'launch',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal',
      },
      {
        -- For this to work you need to make sure the node process is started with the `--inspect` flag.
        name = 'Attach to process',
        type = 'node2',
        request = 'attach',
        processId = require('dap.utils').pick_process,
      },
    }

    dap.configurations.typescript = {
      {
        name = 'ts-node (Node.js)',
        type = 'node2',
        request = 'launch',
        cwd = vim.loop.cwd(),
        runtimeArgs = { '-r', 'ts-node/register' },
        runtimeExecutable = 'node',
        args = { '--inspect', '${file}' },
        sourceMaps = true,
        skipFiles = { '<node_internals>/**', 'node_modules/**' },
      },
      {
        name = 'Jest (Node.js)',
        type = 'node2',
        request = 'launch',
        cwd = vim.loop.cwd(),
        runtimeArgs = { '--inspect-brk', '${workspaceFolder}/node_modules/.bin/jest' },
        runtimeExecutable = 'node',
        args = { '${file}', '--runInBand', '--coverage', 'false' },
        sourceMaps = true,
        port = 9229,
        skipFiles = { '<node_internals>/**', 'node_modules/**' },
      },
    }

    -- Chrome configuration (for PWA debugging)
    dap.adapters.chrome = {
      type = 'executable',
      command = 'node',
      args = { vim.fn.stdpath 'data' .. '/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js' },
    }

    dap.configurations.javascriptreact = { -- change this to javascript if needed
      {
        type = 'chrome',
        request = 'attach',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        port = 9222,
        webRoot = '${workspaceFolder}',
      },
    }

    dap.configurations.typescriptreact = { -- change this to typescript if needed
      {
        type = 'chrome',
        request = 'attach',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        port = 9222,
        webRoot = '${workspaceFolder}',
      },
    }

    -- Automatically open UI
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Custom signs
    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticSignWarn', linehl = '', numhl = '' })
    vim.fn.sign_define('DapLogPoint', { text = '■', texthl = 'DiagnosticSignInfo', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticSignWarn', linehl = 'Visual', numhl = 'DiagnosticSignWarn' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '○', texthl = 'DiagnosticSignHint', linehl = '', numhl = '' })
  end,
}
