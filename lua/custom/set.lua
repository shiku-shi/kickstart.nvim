vim.opt.spell = true
vim.opt.spelllang = { 'en_us', 'ru_ru' }
vim.opt.relativenumber = true

vim.cmd 'language en_US.UTF-8'

local patterns = {}
for _, dir in ipairs { 'ansible', 'roles', 'playbooks', 'inventory' } do
  for _, ext in ipairs { 'yml', 'yaml' } do
    table.insert(patterns, '**/' .. dir .. '/*.' .. ext)
    table.insert(patterns, '**/' .. dir .. '/**/*.' .. ext)
  end
end
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = patterns,
  callback = function()
    vim.bo.filetype = 'yaml.ansible'
  end,
})

vim.filetype.add {
  extension = {
    jinja = 'jinja',
    jinja2 = 'jinja',
    j2 = 'jinja',
  },
}
