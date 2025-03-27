return {
  cmd = { "yaml-language-server", "--stdio" },
  root_markers = { '.git' },
  single_file_support = true,
  filetypes = { "yaml", "yaml.docker-compose" },
  settings = {
     yaml = {
       schemas = {
         -- TODO: find all the relevant schemas
         -- ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
       },
      format = {
        enable = false,
      },
      hover = true,
      completion = true,
     },
   },
}
