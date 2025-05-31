return {
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
      hybrid_modes = { 'i', 'v' },
      checkboxes = presets.checkboxes.nerd,
      headings = presets.headings.arrowed,
      horizontal_rules = presets.horizontal_rules.arrowed,
    }
  end,
}
