--[[
Installation:
Run:

```sh
  npm install --global vscode-langservers-extracted
```

Url: https://github.com/hrsh7th/vscode-langservers-extracted
]] --

local function apply_all_fixes()
  local bufnr = 0
  local clients = vim.lsp.get_clients({
    bufnr = bufnr,
    name = "eslint",
  })

  if #clients == 0 then
    vim.notify("Failed to find eslint lsp client", vim.log.levels.WARN)
    return
  end

  local eslint = clients[1]

  eslint.request_sync(eslint, "workspace/executeCommand", {
    command = 'eslint.applyAllFixes',
    arguments = {
      {
        uri = vim.uri_from_bufnr(bufnr),
        version = vim.lsp.util.buf_versions[bufnr],
      },
    },
  }, nil, bufnr)
end

return {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = { "javascript", "typescript" },
  root_markers = {
    "eslint.config.js",
    "eslint.config.ts",
  },

  on_attach = function(_, buffer)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = buffer,
      callback = apply_all_fixes
    })
  end,

  handlers = {
    ["eslint/noConfig"] = function()
      vim.notify("Unable to find eslint config!", vim.log.levels.WARN)

      return {}
    end,
    ["eslint/noLibrary"] = function()
      vim.notify("Unable to find eslint lib!", vim.log.levels.WARN)

      return {}
    end,
    ["eslint/openDoc"] = function(_, result)
      if result then
        vim.ui.open(result.url)
      end

      return {}
    end,
  },
  on_new_config = function(config, new_root_dir)
    -- The "workspaceFolder" is a VSCode concept. It limits how far the
    -- server will traverse the file system when locating the ESLint config
    -- file (e.g., .eslintrc).
    config.settings.workspaceFolder = {
      uri = new_root_dir,
      name = vim.fn.fnamemodify(new_root_dir, ':t'),
    }
  end,
  -- See: https://github.com/Microsoft/vscode-eslint#settings-options
  settings = {
    validate = "on",
    experimental = {
      -- Can be removed once eslint is >8.57.0
      useFlatConfig = false,
    },
    codeActionOnSave = {
      enable = false,
      mode = "all",
    },
    format = true,
    quiet = false,
    rulesCustomizations = {},
    problems = {
      shortenToSingleLine = false,
    },
    -- nodePath configures the directory in which the eslint server should
    -- start its node_modules resolution. This path is relative to the
    -- workspace folder (root dir) of the server instance.
    nodePath = "",
    -- use the workspace folder location or the file location (if no workspace
    -- folder is open) as the working directory
    workingDirectory = { mode = "location" },
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = "separateLine",
      },
      showDocumentation = {
        enable = true,
      },
    },
  }
}
