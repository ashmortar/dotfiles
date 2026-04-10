local o = vim.o

-- Line numbers
o.number = true
o.relativenumber = true

-- Indentation
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

-- Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = true

-- UI
o.termguicolors = true
o.signcolumn = 'yes'
o.cursorline = true
o.wrap = false
o.scrolloff = 8
o.sidescrolloff = 8
o.showmode = false

-- Folding (treesitter-based)
o.foldmethod = 'expr'
o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
o.foldlevelstart = 99  -- start with all folds open
o.foldtext = ''         -- 0.12: empty string shows first line of fold

-- Splits
o.splitright = true
o.splitbelow = true

-- Performance
o.updatetime = 250
o.timeoutlen = 300

-- Persistence
o.undofile = true
o.swapfile = false

-- Mouse
o.mouse = 'a'

-- Clipboard
o.clipboard = 'unnamedplus'

-- Completion
o.completeopt = 'menu,menuone,noselect'

-- Disable unused providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Neovim 0.12: ui2 (replaces noice.nvim)
o.cmdheight = 0
require('vim._core.ui2').enable({
  enable = true,
  msg = {
    targets = {
      [''] = 'msg',
      empty = 'cmd',
      bufwrite = 'msg',
      confirm = 'cmd',
      emsg = 'pager',
      echo = 'msg',
      echomsg = 'msg',
      echoerr = 'pager',
      completion = 'cmd',
      list_cmd = 'pager',
      lua_error = 'pager',
      lua_print = 'msg',
      progress = 'pager',
      rpc_error = 'pager',
      quickfix = 'msg',
      search_cmd = 'cmd',
      search_count = 'cmd',
      shell_cmd = 'pager',
      shell_err = 'pager',
      shell_out = 'pager',
      shell_ret = 'msg',
      undo = 'msg',
      verbose = 'pager',
      wildlist = 'cmd',
      wmsg = 'msg',
      typed_cmd = 'cmd',
    },
    cmd = {
      height = 0.5,
    },
    dialog = {
      height = 0.5,
    },
    msg = {
      height = 0.3,
      timeout = 5000,
    },
    pager = {
      height = 0.5,
    },
  },
})
