vim.pack.add({ 'https://github.com/nvim-lua/plenary.nvim' })
vim.pack.add({ 'https://github.com/nvim-tree/nvim-web-devicons' })
vim.pack.add({ 'https://github.com/MunifTanjim/nui.nvim' })
vim.pack.add({ { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = 'v3.x' } })

require('neo-tree').setup({
  sources = { "filesystem", "buffers", "git_status" },
  source_selector = {
    winbar = true,
    statusline = false
  },

  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_hidden = false,
    },
    follow_current_file = {
      enabled = true,
    },
    use_libuv_file_watcher = true,
  },

  window = {
    position = "right"
  },
})

vim.api.nvim_set_keymap("", "<Leader>nt", "<cmd>Neotree toggle<CR>", {})
