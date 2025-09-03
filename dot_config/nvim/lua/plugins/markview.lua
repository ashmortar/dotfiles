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
      -- Preview configuration - ALL preview settings go here
      preview = {
        enable = true,  -- Start with preview enabled (replaces initial_state)
        modes = { 'n', 'no', 'c' },  -- Show preview in these modes
        hybrid_modes = { 'i' },  -- Auto-hide in insert mode
        icon_provider = 'mini',  -- Use mini icons since you have it
        filetypes = { 'markdown', 'md', 'rmd', 'quarto' },
        buf_ignore = { 'nofile' },
        debounce = 50,
      },
      
      -- Hide the load order warning
      experimental = {
        check_rtp_message = false,
        link_open_alerts = false,
        prefer_nvim = true,
      },
      
      -- Markdown rendering options
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
      latex = { enable = true },
      yaml = { enable = true },
    }
    
    -- Keybindings using the correct commands
    vim.keymap.set('n', '<leader>mt', function()
      vim.cmd('Markview toggle')
    end, { desc = 'Toggle Markdown Preview' })
    
    vim.keymap.set('n', '<leader>ms', function()
      vim.cmd('Markview splitToggle')
    end, { desc = 'Toggle Split View' })
    
    vim.keymap.set('n', '<leader>mh', function()
      vim.cmd('Markview hybridToggle')
    end, { desc = 'Toggle Hybrid Mode' })
  end,
}
