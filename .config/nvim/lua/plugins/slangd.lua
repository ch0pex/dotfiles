return {
  cmd = { "slangd" },
  filetypes = { "hlsl", "shaderslang", "slang" },
  root_markers = { ".git" },
  settings = {
    slang = {
      predefinedMacros = { "DEBUG=1" },
      inlayHints = {
        deducedTypes = true,
        parameterNames = true,
      },
    },
  },
}
