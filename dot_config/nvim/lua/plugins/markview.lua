return {
  'OXY2DEV/markview.nvim',
  lazy = false,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'echasnovski/mini.icons',
  },
  config = function()
    local markview = require 'markview'
    local presets = require 'markview.presets'

    markview.setup {
      experimental = {
        link_open_alerts = false,
        prefer_nvim = true,
        check_rtp_message = false, -- Hide the warning
      },
      preview = {
        enable = true,
        filetypes = { 'md', 'rmd', 'quarto' },
        ignore_buftypes = { 'nofile' },
        modes = { 'n', 'no', 'c' },
        hybrid_modes = { 'n' },
        icon_provider = 'mini',
        debounce = 50,
        draw_range = { vim.o.lines, vim.o.lines },
        edit_range = { 1, 0 },
      },
      markdown = {
        enable = true,
        headings = presets.headings.slanted,
        tables = presets.tables.rounded,
        block_quotes = {
          enable = true,
          default = { border = '▌' },
        },
        code_blocks = {
          enable = true,
          style = 'minimal',
          min_width = 60,
          language_direction = 'right',
          sign = false,
        },
        list_items = {
          enable = true,
          marker_plus = { text = '•' },
          marker_minus = { text = '•' },
          marker_star = { text = '•' },
        },
      },
      markdown_inline = {
        enable = true,
        checkboxes = {
          enable = true,
          checked = { text = '✓', hl = 'MarkviewCheckboxChecked' },
          unchecked = { text = '✗', hl = 'MarkviewCheckboxUnchecked' },
          pending = { text = '•', hl = 'MarkviewCheckboxPending' },
        },
        inline_codes = { enable = true, hl = 'MarkviewInlineCode' },
        hyperlinks = { enable = true, hl = 'MarkviewHyperlink' },
        images = { enable = true, hl = 'MarkviewImage' },
      },
      latex = { enable = true, symbols = { enable = true } },
      yaml = { enable = true, properties = { enable = true } },
    }

    vim.keymap.set('n', '<leader>mp', ':Markview toggle<CR>', { desc = 'Toggle Markview' })
    vim.keymap.set('n', '<leader>ms', ':Markview splitToggle<CR>', { desc = 'Toggle Split View' })
    vim.keymap.set('n', '<leader>mh', ':Markview hybridToggle<CR>', { desc = 'Toggle Hybrid Mode' })
  end,
}
