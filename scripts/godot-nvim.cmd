@echo off
rem Godot external editor hook. Exec Flags: {file} {line} {col}
rem Opens the file in the Neovim instance listening on \\.\pipe\godot.pipe,
rem or starts a new one in Windows Terminal if none is running.
nvim --server \\.\pipe\godot.pipe --remote-send "<C-\><C-N>:execute 'edit' fnameescape('%~f1')<CR>:call cursor(%2,%3)<CR>" >nul 2>&1 || start "" wt.exe -d "%~dp1" nvim "%~f1" "+call cursor(%2,%3)"
