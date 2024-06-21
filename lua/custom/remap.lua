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
