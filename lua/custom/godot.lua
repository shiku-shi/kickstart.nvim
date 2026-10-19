-- [[ Godot integration ]]
--
-- 1. GDScript LSP: the Godot editor runs a language server on 127.0.0.1:6005
--    (Editor Settings > Network > Language Server). Keep Godot open while editing.
-- 2. External editor: when Neovim is started inside a Godot project it listens on
--    a named pipe (Windows) or socket (macOS/Linux), so Godot can open scripts in
--    this instance. Point Godot at it with Editor Settings > Text Editor > External:
--      Exec Path:  <nvim config>/scripts/godot-nvim.cmd   (Windows)
--                  <nvim config>/scripts/godot-nvim.sh    (macOS/Linux)
--      Exec Flags: {file} {line} {col}

local is_win = vim.fn.has 'win32' == 1
local pipe = is_win and [[\\.\pipe\godot.pipe]] or '/tmp/godot.pipe' -- keep in sync with scripts/godot-nvim.*

vim.lsp.enable 'gdscript' -- config ships with nvim-lspconfig (connects to Godot over TCP)

-- Godot's own style uses tabs
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('custom-godot-ft', { clear = true }),
  pattern = { 'gdscript', 'gdshader' },
  callback = function()
    vim.bo.expandtab = false
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
  end,
})

local function start_server()
  if vim.tbl_contains(vim.fn.serverlist(), pipe) then return end
  if not vim.fs.root(vim.fn.getcwd(), 'project.godot') and not vim.fs.root(0, 'project.godot') then return end
  -- A Neovim that crashed leaves its socket file behind; remove it if nothing answers on it
  if not is_win and vim.uv.fs_stat(pipe) then
    local ok, chan = pcall(vim.fn.sockconnect, 'pipe', pipe)
    if ok and chan > 0 then
      vim.fn.chanclose(chan)
      return
    end
    os.remove(pipe)
  end
  pcall(vim.fn.serverstart, pipe) -- fails quietly if another instance already owns the pipe
end

local group = vim.api.nvim_create_augroup('custom-godot-server', { clear = true })

vim.api.nvim_create_autocmd('VimEnter', {
  group = group,
  callback = function()
    -- Opened from Godot (cwd is the script's folder): move to the project root
    local root = vim.fs.root(0, 'project.godot')
    if root and vim.fs.normalize(vim.fn.getcwd()) ~= vim.fs.normalize(root) then vim.fn.chdir(root) end
    start_server()
  end,
})

vim.api.nvim_create_autocmd('BufEnter', { group = group, callback = start_server })
