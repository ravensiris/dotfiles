require'nvim-treesitter.configs'.setup {
    ensure_installed = {"elixir", "heex", "eex"}, -- only install parsers for elixir and heex
    -- ensure_installed = "all", -- install parsers for all supported languages
    sync_install = false,
    ignore_install = { },
    highlight = {
      enable = true,
      disable = { },
    },
}
