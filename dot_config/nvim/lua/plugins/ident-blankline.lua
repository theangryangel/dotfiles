vim.pack.add({ 'https://github.com/lukas-reineke/indent-blankline.nvim' })

require('ibl').setup({
  exclude = {
    buftypes = {
      "nofile",
      "prompt",
      "quickfix",
      "terminal",
    },
    filetypes = {
      "help",
      "neo-tree",
    },
  },
})
