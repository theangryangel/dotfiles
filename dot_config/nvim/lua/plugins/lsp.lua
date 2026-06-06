vim.pack.add({ { src = 'https://github.com/j-hui/fidget.nvim', version = 'v1.6.1' } })
vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })

require('fidget').setup {}

-- Register blink.cmp capabilities globally so all servers get snippet/completion support
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- XXX: Assumes that we've manually installed all of these
vim.lsp.enable("cssls") -- npm install -g vscode-langservers-extracted
vim.lsp.enable("dockerls")  -- npm install -g
vim.lsp.enable("eslint") -- npm install -g vscode-langservers-extracted
vim.lsp.enable("marksman") -- brew/cargo install marksman
vim.lsp.enable("pyright")   -- uv tool install pyright debugpy
vim.lsp.enable("ruff") -- uv tool install ruff
vim.lsp.enable('rust_analyzer') -- rustup
vim.lsp.enable("ts_ls") -- npm install -g
vim.lsp.enable("yamlls") -- npm install -g
-- vim.lsp.enable("ty") -- uv tool install ty

vim.diagnostic.config({
  virtual_lines = { current_line = true },
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
})

vim.lsp.document_color.enable(true)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('dot-config_lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('gd', function() Snacks.picker.lsp_definitions() end, '[G]oto [D]efinition')
    map('gr', function() Snacks.picker.lsp_references() end, '[G]oto [R]eferences')
    map('gI', function() Snacks.picker.lsp_implementations() end, '[G]oto [I]mplementation')
    map('<leader>lD', function() Snacks.picker.lsp_type_definitions() end, 'Type [D]efinition')
    map('<leader>ds', function() Snacks.picker.lsp_symbols() end, '[D]ocument [S]ymbols')
    map('<leader>ws', function() Snacks.picker.lsp_workspace_symbols() end, '[W]orkspace [S]ymbols')
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
    map('<leader>ih', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
    end, 'Toggle [I]nlay [H]ints')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method('textDocument/documentHighlight') then
      vim.api.nvim_create_autocmd('CursorHold', {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd('CursorMoved', {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end
})
