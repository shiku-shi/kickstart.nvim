-- Build step: install the preview server's node dependencies (needs npm on PATH).
-- Registered before vim.pack.add so it also runs on first install.
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name ~= 'markdown-preview.nvim' or (ev.data.kind ~= 'install' and ev.data.kind ~= 'update') then return end
    local npm = vim.fn.exepath 'npm'
    if npm == '' then return vim.notify('markdown-preview.nvim: npm not found, skipping build', vim.log.levels.WARN) end
    local result = vim.system({ npm, 'install' }, { cwd = vim.fs.joinpath(ev.data.path, 'app') }):wait()
    if result.code ~= 0 then vim.notify('Build failed for markdown-preview.nvim:\n' .. (result.stderr or ''), vim.log.levels.ERROR) end
  end,
})

vim.pack.add { 'https://github.com/iamcco/markdown-preview.nvim' }
