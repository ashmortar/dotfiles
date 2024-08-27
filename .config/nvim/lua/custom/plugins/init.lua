-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = { enabled = false },
        panel = { auto_refresh = true, position = 'right' },
      }
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    config = function()
      require('copilot_cmp').setup()
    end,
  },
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },
  {
    'OXY2DEV/markview.nvim',
    lazy = false, -- Recommended
    -- ft = "markdown" -- If you decide to lazy-load anyway

    dependencies = {
      -- You will not need this if you installed the
      -- parsers manually
      -- Or if the parsers are in your $RUNTIMEPATH
      'nvim-treesitter/nvim-treesitter',

      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local markview = require 'markview'
      local presets = require 'markview.presets'
      markview.setup {
        modes = { 'n', 'i', 'no', 'c' },
        hybrid_modes = { 'i' },
        highlight_groups = presets.highlight_groups.h_decorated,
        headings = presets.headings.decorated_labels,
        tables = presets.tables.border_single_corners,
        horizontal_rules = {
          parts = {
            {
              type = 'repeating',
              text = '─',

              direction = 'left',
              hl = {
                'Gradient1',
                'Gradient2',
                'Gradient3',
                'Gradient4',
                'Gradient5',
                'Gradient6',
                'Gradient7',
                'Gradient8',
                'Gradient9',
                'Gradient10',
              },

              repeat_amount = function()
                local w = vim.api.nvim_win_get_width(0)
                local l = vim.api.nvim_buf_line_count(0)

                l = vim.fn.strchars(tostring(l)) + 4

                return math.floor((w - (l + 3)) / 2)
              end,
            },
            {
              type = 'text',
              text = '  ',
            },
            {
              type = 'repeating',
              text = '─',

              direction = 'right',
              hl = {
                'Gradient1',
                'Gradient2',
                'Gradient3',
                'Gradient4',
                'Gradient5',
                'Gradient6',
                'Gradient7',
                'Gradient8',
                'Gradient9',
                'Gradient10',
              },

              repeat_amount = function()
                local w = vim.api.nvim_win_get_width(0)
                local l = vim.api.nvim_buf_line_count(0)

                l = vim.fn.strchars(tostring(l)) + 4

                return math.ceil((w - (l + 3)) / 2)
              end,
            },
          },
        },
        Checkboxes = {
          enable = true,
          checked = {
            text = '✔',
            hl = 'TabLineSel',
          },
          unchecked = {},
          pending = {},
          custom = {
            {
              match = '~',
              text = '◕',
              hl = 'CheckboxProgress',
            },
          },
        },
        callbacks = {
          on_enable = function(_, win)
            vim.wo[win].conceallevel = 2
            vim.wo[win].concealcursor = 'nc'
          end,
        },
      }
    end,
  },
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
}
