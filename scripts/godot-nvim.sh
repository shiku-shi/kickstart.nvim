#!/bin/sh
# Godot external editor hook (macOS/Linux). Exec Flags: {file} {line} {col}
# Opens the file in the Neovim instance listening on /tmp/godot.pipe,
# or starts a new one in a terminal if none is running.
file="$1"
line="${2:-1}"
col="${3:-1}"
pipe=/tmp/godot.pipe
# Apps started from Finder/Dock don't get the shell's PATH, so Homebrew's nvim isn't found
PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

if [ -S "$pipe" ] && nvim --server "$pipe" --remote-send "<C-\\><C-N>:execute 'edit' fnameescape('$file')<CR>:call cursor($line,$col)<CR>" >/dev/null 2>&1; then
  exit 0
fi

dir=$(dirname "$file")
if [ "$(uname)" = Darwin ]; then
  # Terminal.app is the only terminal guaranteed to exist; it runs the command in a new window
  osascript -e "tell application \"Terminal\" to do script \"cd '$dir' && nvim '$file' '+call cursor($line,$col)'\"" -e 'tell application "Terminal" to activate' >/dev/null
else
  ${TERMINAL:-x-terminal-emulator} -e sh -c "cd '$dir' && nvim '$file' '+call cursor($line,$col)'" &
fi
