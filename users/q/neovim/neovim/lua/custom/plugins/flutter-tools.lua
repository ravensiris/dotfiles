return {
  {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = function()
      local flutterTools = require 'flutter-tools'
      flutterTools.setup {
        flutter_lookup_cmd = 'dirname $(which flutter)',
        lsp = {
          cmd = { 'dart', 'language-server', '--protocol=lsp' },
          init_options = {
            closingLabels = true,
            flutterOutline = true,
            onlyAnalyzeProjectsWithOpenFiles = true,
            outline = true,
            suggestFromUnimportedLibraries = true,
          },
          root_markers = { 'pubspec.yaml' },
          settings = {
            dart = {
              completeFunctionCalls = true,
              showTodos = true,
              enableSdkFormatter = true,
            },
          },
        },
      }
    end,
  },
}
