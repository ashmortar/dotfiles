-- neotest.lua
return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-python',
    'marilari88/neotest-vitest',
    'nvim-neotest/neotest-go',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-python' {
          dap = { justMyCode = false },
          args = { '--verbose' },
          runner = 'pytest',
        },
        require 'neotest-vitest' {},
        require 'neotest-go' {},
      },
    }

    vim.keymap.set('n', '<leader>tt', function()
      require('neotest').run.run()
    end, { desc = 'Test: Run Nearest' })

    vim.keymap.set('n', '<leader>tf', function()
      require('neotest').run.run(vim.fn.expand '%')
    end, { desc = 'Test: Run File' })

    vim.keymap.set('n', '<leader>td', function()
      require('neotest').run.run { strategy = 'dap' }
    end, { desc = 'Test: Debug Nearest' })

    vim.keymap.set('n', '<leader>ts', function()
      require('neotest').summary.toggle()
    end, { desc = 'Test: Toggle Summary' })

    vim.keymap.set('n', '<leader>to', function()
      require('neotest').output.open { enter = true }
    end, { desc = 'Test: Show Output' })
    vim.keymap.set('n', '<leader>twr', function()
      require('neotest').run.run { vitestCommand = 'vitest --watch' }
    end, { desc = '[T]est [Watch] [R]un: Run all tests in watch mode' })
    vim.keymap.set('n', '<leader>twf', function()
      require('neotest').run.run { vim.fn.expand '%', vitestCommand = 'vitest --watch' }
    end, { desc = '[T]est [Watch] [F]ile: Run file in watch mode' })
  end,
}
