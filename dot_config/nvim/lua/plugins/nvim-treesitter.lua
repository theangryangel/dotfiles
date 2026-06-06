vim.pack.add({ 'https://github.com/JoosepAlviste/nvim-ts-context-commentstring' })
vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' })

vim.api.nvim_create_autocmd('User', {
  pattern = 'PackUpdate',
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' and
       (ev.data.kind == 'install' or ev.data.kind == 'update') then
      vim.cmd('TSUpdate')
    end
  end,
})

require('nvim-treesitter').setup()
