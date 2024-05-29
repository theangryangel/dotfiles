return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require('neo-tree').setup({
      sources = { "filesystem", "buffers", "git_status" },
      source_selector = {
        winbar = true,
        statusline = false
      },

      filesystem = {
        filtered_items = {
          visible = true, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false, -- only works on Windows for hidden files/directories
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
    vim.api.nvim_set_keymap("", "<Leader>nt", "<cmd>Neotree toggle<CR>", { })
  end
}
