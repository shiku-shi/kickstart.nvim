-- Headless smoke test for this config, used by .github/workflows/config-check.yml.
-- Run from inside a Godot project: nvim --headless player.gd -c "luafile .github/ci/check.lua"
-- Waits for background installs, then exits non-zero if anything failed.

-- `-c` commands run before VimEnter, so wait for startup (and the config's VimEnter hooks) to finish
if vim.v.vim_did_enter == 0 then
  local this = debug.getinfo(1, 'S').source:sub(2)
  vim.api.nvim_create_autocmd('VimEnter', { once = true, callback = function() vim.schedule(function() dofile(this) end) end })
  return
end

local failures = {}
local function check(name, ok, detail)
  io.stdout:write(('%s %s%s'):format(ok and 'ok  ' or 'FAIL', name, detail and (' (' .. detail .. ')') or '') .. '\n')
  if not ok then table.insert(failures, name) end
end

local function ts_active(buf) return vim.treesitter.highlighter.active[buf] ~= nil end

-- Treesitter parsers compile in the background on first start
local parser_dir = vim.fn.stdpath 'data' .. '/site/parser/'
local function parser(lang) return #vim.fn.glob(parser_dir .. lang .. '.*', false, true) > 0 end
vim.wait(300000, function() return parser 'lua' and parser 'gdscript' and parser 'markdown' end, 1000)
-- Let Mason finish its installs too
vim.wait(300000, function()
  local ok, registry = pcall(require, 'mason-registry')
  if not ok then return true end
  for _, pkg in ipairs(registry.get_installed_packages()) do
    if pkg:is_installing() then return false end
  end
  return vim.fn.executable(vim.fn.stdpath 'data' .. '/mason/bin/gdformat' .. (vim.fn.has 'win32' == 1 and '.cmd' or '')) == 1
end, 2000)

-- Godot buffer (opened on the command line)
local gd = vim.api.nvim_get_current_buf()
check('gdscript filetype', vim.bo[gd].filetype == 'gdscript', vim.bo[gd].filetype)
check('gdscript treesitter', ts_active(gd))
check('gdscript uses tabs', vim.bo[gd].expandtab == false)
check('gdscript formatter', #require('conform').list_formatters(gd) > 0)
check('gdscript lsp enabled', vim.lsp.is_enabled 'gdscript')
local pipe = vim.fn.has 'win32' == 1 and [[\\.\pipe\godot.pipe]] or '/tmp/godot.pipe'
check('godot server pipe', vim.tbl_contains(vim.fn.serverlist(), pipe), table.concat(vim.fn.serverlist(), ', '))
check('cwd is project root', vim.uv.fs_stat(vim.fn.getcwd() .. '/project.godot') ~= nil, vim.fn.getcwd())

for _, f in ipairs { 'test.py', 'test.md', 'test.lua' } do
  vim.cmd.edit(vim.fn.fnameescape(vim.fs.joinpath(vim.fs.root(gd, 'project.godot') or '.', f)))
  check(f .. ' treesitter', ts_active(vim.api.nvim_get_current_buf()), vim.bo.filetype)
end

check('colorscheme', vim.g.colors_name == 'rose-pine', vim.g.colors_name)
check('telescope fzf', (pcall(require('telescope').load_extension, 'fzf')))
for _, lhs in ipairs { '<leader>op', '<leader>wz', '<leader>og', 'zR' } do
  check('keymap ' .. lhs, vim.fn.maparg(lhs, 'n') ~= '')
end

-- Any error printed during startup or the checks above
vim.wait(2000)
local messages = vim.api.nvim_exec2('messages', { output = true }).output
local bad = {}
for line in vim.gsplit(messages, '\n') do
  -- Godot isn't running in CI, so the GDScript LSP can't connect
  if (line:match 'E%d+:' or line:match '[Ee]rror' or line:match '[Ff]ailed') and not line:match '6005' and not line:match 'GDScript' then table.insert(bad, line) end
end
check('no errors in :messages', #bad == 0, table.concat(bad, ' | '))

if #failures > 0 then
  io.stdout:write(('\n%d check(s) failed\n'):format(#failures))
  vim.cmd 'cquit 1'
end
io.stdout:write '\nall checks passed\n'
vim.cmd 'qall!'
