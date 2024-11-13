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
      { '<leader>dc', dap.continue, desc = 'Debug: [c]ontinue' },
      { '<leader>do', dap.step_over, desc = 'Debug: Step [o]ver' },
      { '<leader>di', dap.step_into, desc = 'Debug: Step [i]nto' },
      { '<leader>dO', dap.step_out, desc = 'Debug: Step [O]ut' },
      { '<leader>db', dap.toggle_breakpoint, desc = 'Debug: Toggle [b]reakpoint' },
      {
        '<leader>dB',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set [B]reakpoint Condition',
      },
      { '<leader>dr', dapui.toggle, desc = 'Debug: Toggle [r]epl UI' },
      {
        '<leader>de',
        function()
          dapui.eval()
        end,
        desc = 'Debug: [e]valuate Expression',
      },
      {
        '<leader>df',
        function()
          dapui.float_element()
        end,
        desc = 'Debug: [f]loat Element',
      },
      {
        '<leader>dI',
        function()
          local config = dap.configurations.python[1]
          print('Current Python path: ' .. vim.fn.system(config.pythonPath()))
          print('debugpy path: ' .. require('mason-registry').get_package('debugpy'):get_install_path())
        end,
        desc = 'Debug: Show [I]nfo',
      },
      {
        '<leader>dt',
        function()
          dap.configurations.python = dap.configurations.python or {}
          vim.ui.select({ 'Python: Current File (Debug)', 'Python: pytest' }, {
            prompt = 'Select debug configuration:',
          }, function(choice)
            if choice then
              for _, config in ipairs(dap.configurations.python) do
                if config.name == choice then
                  vim.notify('Selected debug config: ' .. choice, vim.log.levels.INFO)
                  dap.run(config)
                  break
                end
              end
            end
          end)
        end,
        desc = 'Debug: Select [t]est Config',
      },
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
      floating = {
        max_height = nil,
        max_width = nil,
        border = 'single',
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
    }

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

    -- Python configuration
    local function setup_python_adapter()
      local debugpy_path = require('mason-registry').get_package('debugpy'):get_install_path()
      require('dap-python').setup(debugpy_path .. '/venv/bin/python')

      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = 'Python: Current File (Debug)',
          program = '${file}',
          console = 'integratedTerminal',
          pythonPath = function()
            local venv_path = vim.fn.getcwd() .. '/.venv/bin/python'
            if vim.fn.filereadable(venv_path) == 1 then
              vim.notify('Using venv python: ' .. venv_path, vim.log.levels.INFO)
              return venv_path
            end
            local python_path = vim.fn.exepath 'python3' or vim.fn.exepath 'python' or 'python'
            vim.notify('Using system python: ' .. python_path, vim.log.levels.INFO)
            return python_path
          end,
          justMyCode = false,
          env = {
            PYTHONPATH = vim.fn.getcwd(),
          },
        },
        {
          type = 'python',
          request = 'launch',
          name = 'Python: pytest',
          module = 'pytest',
          args = {
            '-v',
            '${file}',
            '--no-cov', -- Disable coverage to avoid interference
          },
          console = 'integratedTerminal',
          pythonPath = function()
            local venv_path = vim.fn.getcwd() .. '/.venv/bin/python'
            if vim.fn.filereadable(venv_path) == 1 then
              vim.notify('Using venv python: ' .. venv_path, vim.log.levels.INFO)
              return venv_path
            end
            local python_path = vim.fn.exepath 'python3' or vim.fn.exepath 'python' or 'python'
            vim.notify('Using system python: ' .. python_path, vim.log.levels.INFO)
            return python_path
          end,
          justMyCode = false,
          env = {
            PYTHONPATH = vim.fn.getcwd(),
          },
        },
      }
    end

    setup_python_adapter()

    -- Go configuration
    require('dap-go').setup()

    -- Add error logging
    dap.listeners.after['event_initialized']['custom'] = function()
      vim.notify('Debug session initialized', vim.log.levels.INFO)
    end

    dap.listeners.before['event_terminated']['custom'] = function()
      vim.notify('Debug session about to terminate', vim.log.levels.WARN)
    end

    dap.listeners.after['event_terminated']['custom'] = function()
      vim.notify('Debug session terminated', vim.log.levels.WARN)
    end

    dap.listeners.before['event_exited']['custom'] = function(session, body)
      vim.notify(string.format('Debug session exited with code: %s', body.exitCode or 'unknown'), vim.log.levels.WARN)
    end

    -- Test debug logging
    dap.listeners.before['test_start'] = dap.listeners.before['test_start'] or {}
    dap.listeners.before['test_start']['custom'] = function(session)
      vim.notify('Starting test debug session for: ' .. vim.inspect(session.config.args), vim.log.levels.INFO)
    end

    -- Load environment variables before starting debug session
    dap.listeners.before.launch.load_env = function(_, _)
      load_env_file()
    end

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
