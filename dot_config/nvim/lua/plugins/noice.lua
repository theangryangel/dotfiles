return {
	"folke/noice.nvim",
	event = "VeryLazy",
  -- FIXME: noice interacts with cmp in such a way that I get 2 completion popups. I
  -- don't have time to find out why now.
	enabled = false,
	opts = {
		-- add any options here
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		-- "rcarriga/nvim-notify",
	},
	config = function()
		require("noice").setup({
			views = {
				popupmenu = {
					size = {
						width = 60,
						height = 10,
					},
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "written",
					},
					opts = { skip = true },
				},
			},
			lsp = {
				Progress = {
					enabled = true,
					-- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
					-- See the section on formatting for more details on how to customize.
					format = "lsp_progress",
					format_done = "lsp_progress_done",
					throttle = 1000 / 30, -- frequency to update lsp progress message
					view = "mini",
				},
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			mini = {
				win_options = {
					winblend = 0,
				},
			},
		})
	end,
}
