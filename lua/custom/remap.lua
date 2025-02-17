vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = 'Open file explorer' })

vim.cmd 'set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'

vim.keymap.set('n', '<leader>nf', function()
  require('neogen').generate { type = 'func' }
end, { desc = 'Generate function docstring' })

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

vim.keymap.set('n', '<leader>og', function()
  lazygit:toggle()
end, { desc = '[O]pen Lazy[G]it' })

local function python_env()
  local cmd
  if vim.fn.isdirectory '.venv' ~= 0 then
    cmd = 'source .venv/bin/activate && '
  elseif vim.fn.isdirectory 'venv' ~= 0 then
    cmd = 'source venv/bin/activate && '
  end
  return cmd
end

vim.keymap.set('n', '<leader>op', function()
  Terminal:new({
    cmd = python_env() .. 'python3',
    env = { PYTHONPATH = vim.fn.getcwd() },
  }):toggle()
end, { desc = '[O]pen [P]ython console' })

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
