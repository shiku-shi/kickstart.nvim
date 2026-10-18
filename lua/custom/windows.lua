-- [[ Windows build toolchain ]]
--
-- Treesitter parsers (`tree-sitter build`) and telescope-fzf-native need a C compiler.
-- We use MinGW gcc (`scoop install mingw`), but Git for Windows puts its own older
-- `libwinpthread-1.dll` on PATH, which makes gcc's cc1.exe crash with 0xC0000139.
-- Putting gcc's own directory first lets it load its matching DLLs.

if vim.fn.has 'win32' == 0 then return end

local gcc = vim.fn.exepath 'gcc'
if gcc == '' then return end

local bin = vim.fs.dirname(gcc)
vim.env.PATH = bin .. ';' .. vim.env.PATH
vim.env.CC = vim.env.CC or 'gcc' -- tree-sitter CLI looks for MSVC's cl.exe otherwise
