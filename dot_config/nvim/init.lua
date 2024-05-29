-- Remapping leader, etc. to ensure that any plugins use the correct
-- configuration
vim.g.mapleader = ','
vim.g.maplocalleader = ','

local options = {
  shortmess = "atIc", -- Don't show the Vim intro message
  backup = false, -- no file system spam pls
  backupcopy = "yes", -- fix file watchers
  title = true,
  expandtab = true,
  tw = 88,
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 2,
  autoindent = true,
  cursorline = true,
  wrap = false,
  splitbelow = true,
  splitright = true,
  termguicolors = true,
  clipboard = 'unnamedplus',
  backspace = "indent,eol,start",
  hlsearch = true,  -- Set highlight on search,
  incsearch = true,
  ignorecase = true, -- Case insensitive searching UNLESS /C or capital in search,
  smartcase = true,
  number = true, -- Make line numbers default,
  mouse = 'a',  -- Enable mouse mode,
  breakindent = true, -- Enable break indent,
  undofile = true, -- Save undo history
  updatetime = 250, -- Decrease update time
  signcolumn = 'yes',
  completeopt = 'menu,menuone,noselect',
}

-- Set options
for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Are we GUI?
if vim.g.neovide then
  require('neovide')
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("plugins", {
	install = {
		missing = true,
	},
	checker = {
		enabled = true,
		notify = true,
    check_pinned = true,
	},
	ui = {
		border = "rounded",
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
