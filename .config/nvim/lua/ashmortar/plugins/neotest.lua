-- neotest.lua
return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-neotest/neotest-python',
    'marilari88/neotest-vitest',
    'nvim-neotest/neotest-go',
  },
  config = function()
    local neotest = require 'neotest'

    -- Utility functions
    local function path_join(...)
      return table.concat({ ... }, '/')
    end

    local function dir_exists(path)
      return vim.fn.isdirectory(path) == 1
    end

    -- Function to get the project root
    local function get_project_root()
      local current_path = vim.fn.expand '%:p:h'
      while current_path ~= '/' do
        if dir_exists(path_join(current_path, '.git')) or dir_exists(path_join(current_path, 'services')) then
          return current_path
        end
        current_path = vim.fn.fnamemodify(current_path, ':h')
      end
      return vim.fn.getcwd()
    end

    -- Function to get the Python interpreter path
    local function get_python_path()
      local root = get_project_root()
      local venv_path = path_join(root, '.venv', 'bin', 'python')
      if vim.fn.executable(venv_path) == 1 then
        return venv_path
      end
      return vim.fn.exepath 'python3' or vim.fn.exepath 'python' or 'python'
    end

    -- Function to setup Python path
    local function setup_python_path()
      local root = get_project_root()
      local common_path = path_join(root, 'services', 'common')
      local ge_cloud_path = path_join(root, 'services', 'ge_cloud')

      local python_path = os.getenv 'PYTHONPATH' or ''
      return table.concat({ common_path, ge_cloud_path, python_path }, ':')
    end

    local python_adapter = require 'neotest-python' {
      dap = { justMyCode = false },
      runner = 'pytest',
      args = { '-vv' },
      root = get_project_root,
      python = get_python_path(),
    }

    neotest.setup {
      adapters = {
        python_adapter,
        require 'neotest-vitest',
        require 'neotest-go',
      },
    }

    local function map(mode, lhs, rhs, opts)
      opts = vim.tbl_extend('force', { silent = true, noremap = true }, opts or {})
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    local function run_tests(test_type)
      return function()
        local root = get_project_root()
        local config = {
          env = {
            TEST_ENV = 'true',
            PYTHONPATH = setup_python_path(),
          },
        }

        if test_type == 'unit' then
          config.cwd = path_join(root, 'services', 'ge_cloud', 'tests', 'unit')
          neotest.run.run(path_join(config.cwd, '**', 'test_*.py'))
        elseif test_type == 'integration' then
          config.cwd = path_join(root, 'services', 'ge_cloud', 'tests', 'integration')
          neotest.run.run(path_join(config.cwd, '**', 'test_*.py'))
        elseif test_type == 'e2e' then
          config.cwd = path_join(root, 'services', 'ge_cloud', 'tests', 'end_to_end')
          neotest.run.run(path_join(config.cwd, '**', 'test_*.py'))
        elseif test_type == 'file' then
          neotest.run.run(vim.fn.expand '%')
        elseif test_type == 'nearest' then
          neotest.run.run()
        else
          vim.api.nvim_err_writeln("Error: Unknown test type '" .. test_type .. "'")
        end
      end
    end

    -- Test running
    map('n', '<leader>tu', run_tests 'unit', { desc = '[T]est: Run [U]nit Tests' })
    map('n', '<leader>ti', run_tests 'integration', { desc = '[T]est: Run [I]ntegration Tests' })
    map('n', '<leader>te', run_tests 'e2e', { desc = '[T]est: Run [E]2E Tests' })
    map('n', '<leader>tr', run_tests 'nearest', { desc = '[T]est: [R]un Nearest' })
    map('n', '<leader>tf', run_tests 'file', { desc = '[T]est: Run [F]ile' })
    map('n', '<leader>td', function()
      neotest.run.run { strategy = 'dap' }
    end, { desc = '[T]est: [D]ebug Nearest' })

    -- UI controls
    map('n', '<leader>ts', neotest.summary.toggle, { desc = '[T]est: Toggle [S]ummary' })
    map('n', '<leader>to', function()
      neotest.output.open { enter = true }
    end, { desc = '[T]est: Show [O]utput' })

    -- Watch mode (for Vitest)
    map('n', '<leader>tw', function()
      neotest.run.run { vitestCommand = 'vitest --watch' }
    end, { desc = '[T]est: [W]atch Mode' })
    map('n', '<leader>tW', function()
      neotest.run.run { vim.fn.expand '%', vitestCommand = 'vitest --watch' }
    end, { desc = '[T]est: [W]atch File' })
  end,
}
