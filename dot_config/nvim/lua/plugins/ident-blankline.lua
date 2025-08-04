return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    exclude = {
      buftypes = {
        "nofile",
        "prompt",
        "quickfix",
        "terminal",
      },
      filetypes = {
        "help",
        "lazy",
        "neo-tree",
      },
    },
  },
}
