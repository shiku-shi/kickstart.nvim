require('conform').formatters.black = {
  inherit = true,
  prepend_args = { '--line-length', '80' },
}

require('conform').formatters.isort = {
  inherit = true,
  prepend_args = { '--profile', 'black' },
}

require('conform').formatters.yamlfmt = {
  inherit = true,
  prepend_args = { '-formatter', 'retain_line_breaks=true' },
}
