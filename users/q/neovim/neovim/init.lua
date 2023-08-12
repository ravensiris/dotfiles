local set = vim.opt
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>bb", "<cmd>bprevious<cr>")
vim.keymap.set("n", "<leader>aa", "<cmd>lua vim.lsp.buf.code_action()<CR>")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

require("lazy").setup({
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            local lualine = require("lualine")
            lualine.setup({ options = { theme = "tokyonight" } })
        end,
        dependencies = {
            "folke/tokyonight.nvim",
        },
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end,
        opts = {},
    },
    { "folke/neoconf.nvim", cmd = "Neoconf" },
    "folke/neodev.nvim",
    {
        "folke/tokyonight.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            vim.cmd([[colorscheme tokyonight]])
        end,
    },
    { "nvim-tree/nvim-web-devicons", lazy = true },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            lspconfig.rust_analyzer.setup({})
            lspconfig.pyright.setup({})
            lspconfig.tsserver.setup({})
            lspconfig.html.setup({
                filetypes = { "html", "heex" },
                capabilities = capabilities,
            })
            lspconfig.emmet_language_server.setup({
                filetypes = {
                    "astro",
                    "css",
                    "eruby",
                    "html",
                    "htmldjango",
                    "javascriptreact",
                    "less",
                    "pug",
                    "sass",
                    "scss",
                    "svelte",
                    "typescriptreact",
                    "vue",
                    "heex",
                },
            })
            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        format = {
                            enable = true,
                            indent_style = "space",
                            indent_size = "2",
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        config = function()
            local treesitter = require("nvim-treesitter.configs")
            vim.cmd([[TSUpdate]])
            treesitter.setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "nix", "elixir", "heex", "eex" },
                auto_install = true,
                highlight = {
                    enable = true,
                },
            })
        end,
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            local lsp_formatting = function(bufnr)
                vim.lsp.buf.format({
                    filter = function(client)
                        -- apply whatever logic you want (in this example, we'll only use null-ls)
                        return client.name == "null-ls"
                    end,
                    bufnr = bufnr,
                })
            end

            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            local on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            lsp_formatting(bufnr)
                        end,
                    })
                end
            end

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.stylua.with({ extra_args = { "--indent-type", "Spaces" } }),
                    null_ls.builtins.formatting.mix,
                    null_ls.builtins.formatting.alejandra,
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.isort,
                    null_ls.builtins.formatting.ruff,
                    null_ls.builtins.diagnostics.mypy,
                    null_ls.builtins.formatting.prettier.with({
                        prefer_local = "node_modules/.bin",
                    }),
                    null_ls.builtins.formatting.rustfmt,
                },
                on_attach = on_attach,
            })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        -- load cmp on InsertEnter
        event = "InsertEnter",
        -- these dependencies will only be loaded when cmp loads
        -- dependencies are always lazy-loaded unless specified otherwise
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                }),
                experimental = { ghost_text = true },
            })
        end,
    },
    {
        "elixir-tools/elixir-tools.nvim",
        version = "*",
        lazy = false,
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local elixir = require("elixir")
            local elixirls = require("elixir.elixirls")

            elixir.setup({
                nextls = { enable = false },
                credo = { enable = true },
                elixirls = {
                    enable = true,
                    settings = elixirls.settings({
                        dialyzerEnabled = true,
                        enableTestLenses = false,
                    }),

                    on_attach = function(client, bufnr)
                        vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
                        vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
                        vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
                    end,
                },
            })
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.1",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
            "xiyaowong/telescope-emoji.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                extensions = {
                    file_browser = {
                        theme = "ivy",
                        hijack_netrw = true,
                    },
                    emoji = {
                        action = function(emoji)
                            vim.api.nvim_put({ emoji.value }, "c", false, true)
                        end,
                    },
                },
            })
            telescope.load_extension("file_browser")
            telescope.load_extension("emoji")
            telescope.load_extension("ui-select")
            telescope.load_extension("fzf")
        end,
        keys = {
            { "<leader><leader>", "<cmd>Telescope find_files<cr>", desc = "Find file" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep files" },
            { "<leader>fd", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", desc = "File browser" },
            { "<leader>bb", "<cmd>Telescope buffers sort_lastused=true<cr>", desc = "Buffer search" },
            { "<leader>ie", "<cmd>Telescope emoji<cr>", desc = "Emoji insert" },
        },
    },
    {
        "TimUntersberger/neogit",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            local neogit = require("neogit")

            neogit.setup({
                use_magit_keybindings = true,
            })
        end,
        keys = { { "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit" } },
    },
    {
        "ray-x/lsp_signature.nvim",
        config = function()
            local lsp_signature = require("lsp_signature")
            lsp_signature.setup({})
        end,
    },
})
