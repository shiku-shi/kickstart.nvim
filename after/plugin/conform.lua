require('conform').formatters.double_indent = {
  inherit = false,
  command = 'double-indent',
  args = { '$FILENAME' },
  stdin = false,
  tmpfile_format = '.conform.$RANDOM.$FILENAME',
  exit_codes = { 0, 1 },
}

require('conform').formatters.isort = {
  inherit = true,
  prepend_args = { '--profile', 'black' },
}

require('conform').formatters.yamlfmt = {
  inherit = true,
  prepend_args = { '-formatter', 'retain_line_breaks=true' },
}
