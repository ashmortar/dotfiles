-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank { timeout = 200 }
  end,
})

-- Check if file changed outside of Neovim
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = vim.api.nvim_create_augroup('checktime', { clear = true }),
  command = 'checktime',
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = vim.api.nvim_create_augroup('resize_splits', { clear = true }),
  callback = function()
    vim.cmd 'tabdo wincmd ='
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('close_with_q', { clear = true }),
  pattern = {
    'help',
    'lspinfo',
    'man',
    'notify',
    'qf',
    'startuptime',
    'checkhealth',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- Virtual Environment Detection and Setup
local venv_group = vim.api.nvim_create_augroup('python_venv', { clear = true })

-- Function to find and set virtual environment
local function setup_python_venv()
  local function find_venv_path(path)
    local venv_path = path .. '/.venv'
    if vim.fn.isdirectory(venv_path) == 1 then
      return venv_path
    end

    local parent = vim.fn.fnamemodify(path, ':h')
    if parent == path then
      return nil
    end
    return find_venv_path(parent)
  end

  local cwd = vim.fn.getcwd()
  local venv_path = find_venv_path(cwd)

  if venv_path then
    -- Set VIRTUAL_ENV environment variable
    vim.env.VIRTUAL_ENV = venv_path

    -- Determine python executable path based on OS
    local python_path
    if vim.fn.has 'win32' == 1 then
      python_path = venv_path .. '/Scripts/python.exe'
    else
      python_path = venv_path .. '/bin/python'
    end

    if vim.fn.executable(python_path) == 1 then
      -- Set python path for current session
      vim.g.python3_host_prog = python_path

      -- Update PATH to include venv
      local venv_bin = venv_path .. (vim.fn.has 'win32' == 1 and '/Scripts' or '/bin')
      local current_path = vim.env.PATH or ''
      if not string.find(current_path, venv_bin, 1, true) then
        vim.env.PATH = venv_bin .. ':' .. current_path
      end

      -- Show which venv is active (optional notification)
      local project_name = vim.fn.fnamemodify(vim.fn.fnamemodify(venv_path, ':h'), ':t')
      vim.notify('Activated virtual environment for: ' .. project_name, vim.log.levels.INFO, { title = 'Python Venv' })
    end
  else
    -- Clear venv if we're not in a project with a virtual environment
    vim.env.VIRTUAL_ENV = nil
  end
end

-- Set up virtual environment when entering Python files
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufNewFile' }, {
  group = venv_group,
  pattern = '*.py',
  callback = setup_python_venv,
})

-- Set up virtual environment when changing directories
vim.api.nvim_create_autocmd('DirChanged', {
  group = venv_group,
  callback = setup_python_venv,
})

-- Initialize virtual environment on startup if we're in a Python project
vim.api.nvim_create_autocmd('VimEnter', {
  group = venv_group,
  callback = function()
    -- Check if we're opening a Python file or in a directory with Python files
    local current_file = vim.fn.expand '%'
    if current_file:match '%.py$' or vim.fn.glob '*.py' ~= '' or vim.fn.isdirectory '.venv' == 1 then
      setup_python_venv()
    end
  end,
})
