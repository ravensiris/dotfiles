local set = vim.opt
set.tabstop = 4
set.expandtab = true
set.smartindent = true
set.softtabstop = 4
set.shiftwidth = 4
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("n", "<leader>bb", "<cmd>bprevious<cr>")

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
    {
        "direnv/direnv.vim",
        lazy = false,
        priority = 1500,
        config = function() end,
    },
    {
        "ray-x/navigator.lua",
        config = function()
            local navigator = require("navigator")
            navigator.setup({
                lsp = {
                    format_on_save = { disable = { "elixir" } },
                    disable_lsp = { "elixirls" },
                },
            })
        end,
        dependencies = {
            { "ray-x/guihua.lua", build = "cd lua/fzy && make" },
            { "neovim/nvim-lspconfig" },
        },
    },
    { "nvim-tree/nvim-web-devicons", lazy = true },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.pyright.setup({})
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
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "2.0.0", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            local ls = require("luasnip")
            local s = ls.snippet
            local sn = ls.snippet_node
            local t = ls.text_node
            local i = ls.insert_node
            local f = ls.function_node
            local c = ls.choice_node
            local d = ls.dynamic_node
            local r = ls.restore_node
            local l = require("luasnip.extras").lambda
            local rep = require("luasnip.extras").rep
            local p = require("luasnip.extras").partial
            local m = require("luasnip.extras").match
            local n = require("luasnip.extras").nonempty
            local dl = require("luasnip.extras").dynamic_lambda
            local fmt = require("luasnip.extras.fmt").fmt
            local fmta = require("luasnip.extras.fmt").fmta
            local types = require("luasnip.util.types")
            local conds = require("luasnip.extras.conditions")
            local conds_expand = require("luasnip.extras.conditions.expand")
            ls.setup({})
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
                    null_ls.builtins.formatting.alejandra,
                    null_ls.builtins.formatting.mix,
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.isort,
                    null_ls.builtins.formatting.ruff,
                    null_ls.builtins.diagnostics.mypy,
                    null_ls.builtins.formatting.prettier,
                    null_ls.builtins.diagnostics.eslint,
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

            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local luasnip = require("luasnip")

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
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                            -- they way you will only jump inside the snippet region
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }),
                experimental = { ghost_text = true },
            })
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
            "xiyaowong/telescope-emoji.nvim",
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
            telescope.load_extension("fzf")
        end,
        keys = {
            { "<leader><leader>", "<cmd>Telescope find_files<cr>", desc = "Find file" },
            {
                "<leader>fg",
                "<cmd>Telescope live_grep<cr>",
                desc = "Grep files",
            },
            {
                "<leader>fd",
                "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>",
                desc = "File browser",
            },
            {
                "<leader>bb",
                "<cmd>Telescope buffers sort_lastused=true<cr>",
                desc = "Buffer search",
            },
            {
                "<leader>ie",
                "<cmd>Telescope emoji<cr>",
                desc = "Emoji insert",
            },
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
    {
        "elixir-tools/elixir-tools.nvim",
        version = "*",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local elixir = require("elixir")
            local elixirls = require("elixir.elixirls")

            elixir.setup({
                nextls = { enable = false },
                credo = {},
                elixirls = {
                    enable = true,
                    settings = elixirls.settings({
                        dialyzerEnabled = false,
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
    { "akinsho/git-conflict.nvim", version = "*", config = true },
    {
        "nvim-lualine/lualine.nvim",
        version = "*",
        config = function()
            local lualine = require("lualine")
            -- Color table for highlights
            -- stylua: ignore
            local colors = {
                bg       = '#202328',
                fg       = '#bbc2cf',
                yellow   = '#ECBE7B',
                cyan     = '#008080',
                darkblue = '#081633',
                green    = '#98be65',
                orange   = '#FF8800',
                violet   = '#a9a1e1',
                magenta  = '#c678dd',
                blue     = '#51afef',
                red      = '#ec5f67',
            }

            local conditions = {
                buffer_not_empty = function()
                    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
                end,
                hide_in_width = function()
                    return vim.fn.winwidth(0) > 80
                end,
                check_git_workspace = function()
                    local filepath = vim.fn.expand("%:p:h")
                    local gitdir = vim.fn.finddir(".git", filepath .. ";")
                    return gitdir and #gitdir > 0 and #gitdir < #filepath
                end,
            }

            -- Config
            local config = {
                options = {
                    -- Disable sections and component separators
                    component_separators = "",
                    section_separators = "",
                    theme = "palenight",
                    globalstatus = true,
                },
                sections = {
                    -- these are to remove the defaults
                    lualine_a = {},
                    lualine_b = {},
                    lualine_y = {},
                    lualine_z = {},
                    -- These will be filled later
                    lualine_c = {},
                    lualine_x = {},
                },
                inactive_sections = {
                    -- these are to remove the defaults
                    lualine_a = {},
                    lualine_b = {},
                    lualine_y = {},
                    lualine_z = {},
                    lualine_c = {},
                    lualine_x = {},
                },
            }

            -- Inserts a component in lualine_c at left section
            local function ins_left(component)
                table.insert(config.sections.lualine_c, component)
            end

            -- Inserts a component in lualine_x at right section
            local function ins_right(component)
                table.insert(config.sections.lualine_x, component)
            end

            ins_left({
                function()
                    return "▊"
                end,
                color = { fg = colors.blue }, -- Sets highlighting of component
                padding = { left = 0, right = 1 }, -- We don't need space before this
            })

            ins_left({
                -- mode component
                function()
                    return ""
                end,
                color = function()
                    -- auto change color according to neovims mode
                    local mode_color = {
                        n = colors.red,
                        i = colors.green,
                        v = colors.blue,
                        [""] = colors.blue,
                        V = colors.blue,
                        c = colors.magenta,
                        no = colors.red,
                        s = colors.orange,
                        S = colors.orange,
                        [""] = colors.orange,
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
                padding = { right = 1 },
            })

            ins_left({
                -- filesize component
                "filesize",
                cond = conditions.buffer_not_empty,
            })

            ins_left({
                "filename",
                cond = conditions.buffer_not_empty,
                color = { fg = colors.magenta, gui = "bold" },
            })

            ins_left({ "location" })

            ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

            ins_left({
                "diagnostics",
                sources = { "nvim_diagnostic" },
                symbols = { error = " ", warn = " ", info = " " },
                diagnostics_color = {
                    color_error = { fg = colors.red },
                    color_warn = { fg = colors.yellow },
                    color_info = { fg = colors.cyan },
                },
            })

            -- Insert mid section. You can make any number of sections in neovim :)
            -- for lualine it's any number greater then 2
            ins_left({
                function()
                    return "%="
                end,
            })

            ins_left({
                -- Lsp server name .
                function()
                    local msg = "No Active Lsp"
                    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
                    local clients = vim.lsp.get_active_clients()
                    if next(clients) == nil then
                        return msg
                    end
                    for _, client in ipairs(clients) do
                        local filetypes = client.config.filetypes
                        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                            return client.name
                        end
                    end
                    return msg
                end,
                icon = " LSP:",
                color = { fg = "#ffffff", gui = "bold" },
            })

            -- Add components to right sections
            ins_right({
                "o:encoding", -- option component same as &encoding in viml
                fmt = string.upper, -- I'm not sure why it's upper case either ;)
                cond = conditions.hide_in_width,
                color = { fg = colors.green, gui = "bold" },
            })

            ins_right({
                "fileformat",
                fmt = string.upper,
                icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
                color = { fg = colors.green, gui = "bold" },
            })

            ins_right({
                "branch",
                icon = "",
                color = { fg = colors.violet, gui = "bold" },
            })

            ins_right({
                "diff",
                -- Is it me or the symbol for modified us really weird
                symbols = { added = " ", modified = "󰝤 ", removed = " " },
                diff_color = {
                    added = { fg = colors.green },
                    modified = { fg = colors.orange },
                    removed = { fg = colors.red },
                },
                cond = conditions.hide_in_width,
            })

            ins_right({
                function()
                    return "▊"
                end,
                color = { fg = colors.blue },
                padding = { left = 1 },
            })

            -- Now don't forget to initialize lualine
            lualine.setup(config)
        end,
    },
    {
        "yorickpeterse/nvim-window",
        version = "*",
        config = function()
            local nvim_window = require("nvim-window")
            nvim_window.setup({
                -- The characters available for hinting windows.
                chars = {
                    "n",
                    "e",
                    "i",
                    "o",
                    "l",
                    "u",
                    "y",
                },

                -- A group to use for overwriting the Normal highlight group in the floating
                -- window. This can be used to change the background color.
                normal_hl = "Normal",

                -- The highlight group to apply to the line that contains the hint characters.
                -- This is used to make them stand out more.
                hint_hl = "Bold",

                -- The border style to use for the floating window.
                border = "single",
            })
        end,
        keys = {
            {
                "<C-w><C-w>",
                function()
                    local nvim_window = require("nvim-window")
                    nvim_window.pick()
                end,
                desc = "Switch window",
            },
        },
    },
})
