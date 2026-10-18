vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = 'Open file explorer' })

vim.cmd 'set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'

vim.keymap.set('n', '<leader>nf', function() require('neogen').generate { type = 'func' } end, { desc = 'Generate function docstring' })

vim.keymap.set('n', '<leader>wz', function()
  require('zen-mode').toggle {
    window = {
      width = 120,
    },
  }
end, { desc = 'Toggle Zen Mode' })

-- toggleterm

local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new { cmd = 'lazygit', hidden = true, direction = 'float' }

vim.keymap.set('n', '<leader>og', function() lazygit:toggle() end, { desc = '[O]pen Lazy[G]it' })

-- Use the project's virtualenv interpreter directly (no shell-specific `activate` needed)
local function python_cmd()
  local is_win = vim.fn.has 'win32' == 1
  for _, venv in ipairs { '.venv', 'venv' } do
    local python = is_win and venv .. '/Scripts/python.exe' or venv .. '/bin/python'
    if vim.fn.executable(python) == 1 then return vim.fn.fnamemodify(python, ':p') end
  end
  -- On Windows `python3` is usually the Microsoft Store stub
  if is_win or vim.fn.executable 'python3' == 0 then return 'python' end
  return 'python3'
end

vim.keymap.set(
  'n',
  '<leader>op',
  function()
    Terminal:new({
      cmd = python_cmd(),
      env = { PYTHONPATH = vim.fn.getcwd() },
    }):toggle()
  end,
  { desc = '[O]pen [P]ython console' }
)

vim.keymap.set('n', '<leader>oc', function()
  Terminal:new({
    env = { PYTHONPATH = vim.fn.getcwd() },
  }):toggle()
end, { desc = '[O]pen [C]onsole' })

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-n>', [[<C-\><C-n>]], opts)
end

vim.cmd 'autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()'
