vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' })

local colors = {
  bg = "None",
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

local config = {
  options = {
    component_separators = "",
    section_separators = "",
    extensions = { 'nvim-tree' },
    globalstatus = true,
    theme = "auto",
    disabled_filetypes = {
      statusline = { "dashboard", "alpha" },
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

local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left({
  function() return "" end,
  color = function()
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
  icon = "",
  color = { fg = colors.violet, gui = "bold" },
})

ins_left({
  "diagnostics",
  cond = conditions.buffer_not_empty,
  sources = { "nvim_diagnostic" },
  symbols = { error = " ", warn = " ", info = " " },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.cyan },
  },
})

ins_right({
  function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then return '' end
    return ' ' .. table.concat(vim.tbl_map(function(c) return c.name end, clients), ', ')
  end,
  cond = function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end,
  color = { fg = colors.blue },
})
ins_right({
  function() return vim.lsp.status() end,
  cond = function() return vim.lsp.status() ~= '' end,
  color = { fg = colors.cyan },
})
ins_right({ "encoding" })
ins_right({ "location" })
ins_right({ "progress", color = { fg = colors.fg, gui = "bold" } })

require("lualine").setup(config)
