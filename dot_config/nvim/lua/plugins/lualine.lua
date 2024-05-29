return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "meuter/lualine-so-fancy.nvim",
  },
  lazy = false,
  event = { "BufReadPost", "BufNewFile", "VeryLazy" },
  config = function()
    -- New color table and conditions
    local colors = {
      bg = "None", -- Ensure this is a valid color or nil
      fg = "#45657b",
      yellow = "#ecc58d",
      cyan = "#21c7a8",
      darkblue = "#081633",
      green = "#aedb67",
      orange = "#FF8800",
      magenta = "#c792eb",
      blue = "#82aaff",
      red = "#ef5350",
    }

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end,
    }

    -- Configuration for lualine
    local config = {
      options = {
        component_separators = "",
        section_separators = "",
        extensions = { 'nvim-tree' },
        globalstatus = true,
        theme = "auto",
        disabled_filetypes = {
          statusline = { "dashboard", "lazy", "alpha" },
        },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    }

    -- Helper functions for inserting components
    local function ins_left(component)
      table.insert(config.sections.lualine_c, component)
    end

    local function ins_right(component)
      table.insert(config.sections.lualine_x, component)
    end

    -- Component definitions
    -- Add the components setup here following the new configuration

    ins_left({
      -- mode component
      function()
        return ""
      end,
      color = function()
        -- auto change color according to neovims mode
        local mode_color = {
          n = colors.green,
          i = colors.violet,
          v = colors.yellow,
          V = colors.blue,
          c = colors.magenta,
          no = colors.red,
          s = colors.orange,
          S = colors.orange,
          [""] = colors.orange,
          ic = colors.yellow,
          R = colors.violet,
          Rv = colors.violet,
          cv = colors.red,
          ce = colors.red,
          r = colors.cyan,
          rm = colors.cyan,
          ["r?"] = colors.cyan,
          ["!"] = colors.red,
          t = colors.red,
        }
        return { fg = mode_color[vim.fn.mode()] }
      end,
      padding = { right = 1, left = 1 },
    })

    ins_left({
      "filename",
      cond = conditions.buffer_not_empty,
      color = { fg = colors.green, gui = "bold" },
    })

    ins_left({
      "branch",
      icon = "",
      color = { fg = colors.violet, gui = "bold" },
    })

    ins_left({
      "diagnostics",
      cond = conditions.buffer_not_empty,
      sources = { "nvim_diagnostic" },
      symbols = { error = " ", warn = " ", info = " " },
      diagnostics_color = {
        color_error = { fg = colors.red },
        color_warn = { fg = colors.yellow },
        color_info = { fg = colors.cyan },
      },
    })

    ins_right({
      "fancy_lsp_servers",
    })

    ins_right({
      "encoding",
    })

    ins_right({
      "location",
    })

    ins_right({ "progress", color = { fg = colors.fg, gui = "bold" } })

    require("lualine").setup(config)
  end,
}
