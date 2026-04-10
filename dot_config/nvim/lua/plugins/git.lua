-- Gitsigns
require('gitsigns').setup({
  signs = {
    add = { text = '│' },
    change = { text = '│' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local gs = require('gitsigns')
    local map = function(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
    end

    -- Navigation
    map('n', ']h', gs.next_hunk, 'Next hunk')
    map('n', '[h', gs.prev_hunk, 'Previous hunk')

    -- Actions
    map('n', '<leader>gs', gs.stage_hunk, 'Stage hunk')
    map('n', '<leader>gr', gs.reset_hunk, 'Reset hunk')
    map('v', '<leader>gs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'Stage hunk')
    map('v', '<leader>gr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'Reset hunk')
    map('n', '<leader>gS', gs.stage_buffer, 'Stage buffer')
    map('n', '<leader>gu', gs.undo_stage_hunk, 'Undo stage hunk')
    map('n', '<leader>gR', gs.reset_buffer, 'Reset buffer')
    map('n', '<leader>gp', gs.preview_hunk, 'Preview hunk')
    map('n', '<leader>gb', function() gs.blame_line({ full = true }) end, 'Blame line')
    map('n', '<leader>gd', gs.diffthis, 'Diff this')
  end,
})

-- Neogit
require('neogit').setup({
  integrations = {
    diffview = true,
    telescope = true,
  },
})
vim.keymap.set('n', '<leader>gn', '<cmd>Neogit<cr>', { desc = 'Neogit' })

-- Diffview
require('diffview').setup({})
vim.keymap.set('n', '<leader>gD', '<cmd>DiffviewOpen<cr>', { desc = 'Diffview open' })
vim.keymap.set('n', '<leader>gH', '<cmd>DiffviewFileHistory %<cr>', { desc = 'File history' })
