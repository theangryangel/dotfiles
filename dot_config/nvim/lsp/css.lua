return {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css' },
  root_markers = { 'package.json' },
  init_options = { provideFormatter = true },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
}
