vim.pack.add({ 'https://github.com/folke/snacks.nvim' })

require('snacks').setup({})

vim.api.nvim_create_user_command('Snacks', function()
  Snacks.picker.pickers()
end, {})

-- Shim :Telescope find_files and :Telescope live_grep to snacks picker
vim.api.nvim_create_user_command('Telescope', function(opts)
  local sub = vim.split(opts.args, '%s+', { trimempty = true })[1]
  if sub == 'find_files' then
    Snacks.picker.files()
  elseif sub == 'live_grep' then
    Snacks.picker.grep()
  else
    Snacks.picker.pickers()
  end
end, {
  nargs = '*',
  complete = function() return { 'find_files', 'live_grep' } end,
})
