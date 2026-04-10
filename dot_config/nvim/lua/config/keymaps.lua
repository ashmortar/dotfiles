local map = vim.keymap.set

-- Clear search highlights
map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlights' })

-- Save / Quit
map('n', '<leader>w', '<cmd>w<cr>', { desc = 'Save' })
map('n', '<leader>q', '<cmd>q<cr>', { desc = 'Quit' })
map('n', '<leader>Q', '<cmd>qa<cr>', { desc = 'Quit all' })

-- Buffers
map('n', '<leader>bn', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '<leader>bp', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
map('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Delete buffer' })

-- Window navigation (tmux-nav overrides these)
map('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Resize windows
map('n', '<M-h>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease width' })
map('n', '<M-j>', '<cmd>resize -2<cr>', { desc = 'Decrease height' })
map('n', '<M-k>', '<cmd>resize +2<cr>', { desc = 'Increase height' })
map('n', '<M-l>', '<cmd>vertical resize +2<cr>', { desc = 'Increase width' })

-- Move lines
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move line down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move line up' })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move selection down' })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move selection up' })

-- Better indenting (keep selection)
map('v', '<', '<gv', { desc = 'Indent left' })
map('v', '>', '>gv', { desc = 'Indent right' })

-- Diagnostic navigation
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
map('n', '<leader>xd', vim.diagnostic.open_float, { desc = 'Line diagnostics' })
map('n', '<leader>xq', vim.diagnostic.setloclist, { desc = 'Diagnostics to loclist' })
