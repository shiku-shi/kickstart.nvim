require('conform').formatters.isort = {
  inherit = true,
  prepend_args = { '--profile', 'black' },
}

require('conform').formatters.yamlfmt = {
  inherit = true,
  prepend_args = { '-formatter', 'retain_line_breaks=true' },
}

require('conform').formatters.stylua = {
  inherit = true,
  prepend_args = { '--indent-type', 'Spaces', '--indent-width', '2' },
}
