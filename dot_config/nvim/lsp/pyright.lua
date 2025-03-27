return {
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json', '.git' },
  cmd = { 'pyright-langserver', '--stdio' },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
  -- settings = {
  --   python = {
  --     analysis = {
  --       autoSearchPaths = true,
  --       diagnosticMode = 'workspace',
  --       useLibraryCodeForTypes = true,
  --     },
  --     completion = {
  --       autoImportCompletions = true,
  --       completeFunctionParens = true,
  --       completeStrings = true,
  --       enabled = true,
  --     },
  --     codeLens = {
  --       enabled = true,
  --     },
  --     formatting = {
  --       autopep8 = true,
  --       black = true,
  --       yapf = true,
  --     },
  --     interpreter = {
  --       globalEnvs = {
  --         'PYTHONPATH',
  --         'PATH',
  --       },
  --     },
  --   },
  -- },
}
