return {
    -- mason: install binaries
    {
        'mason-org/mason.nvim',
        opts = {},
    },
    -- mason-lspconfig: enure/install LSP servers and bridge names
    {
        'mason-org/mason-lspconfig.nvim',
        dependencies = {
            'mason-org/mason.nvim',
            'neovim/nvim-lspconfig',
        },
        opts = {
            ensure_installed = {
                'lua_ls',
                'rust_analyzer',
                -- 'pyright',
                'ts_ls',
            },
        },
    },
    -- nvim-lspconfig: configurations
    {
        'neovim/nvim-lspconfig',
        config = function()
            -- diagnostics UI
            vim.diagnostic.config({
                virtual_text = true,
                underline = true,
                signs = true,
                severity_sort = true,
                update_in_insert = false,
                float = {
                    border = 'rounded',
                    source = 'if_many',
                },
            })

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local bufnr = args.buf
                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                    end

                    map('n', 'K', vim.lsp.buf.hover, 'Hover')
                    map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
                    map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
                    map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
                    map('n', 'r', vim.lsp.buf.references, 'References')
                    map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
                    map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'Code action')
                    map('n', '<leader>fd', vim.diagnostic.open_float, 'Line diagnostics')
                    map('n', '[d', vim.diagnostic.goto_prev, 'Prev diagnostic')
                    map('n', ']d', vim.diagnostic.goto_prev, 'Next diagnostic')
                    map('n', '<leader>fws', vim.lsp.buf.workspace_symbol, 'Workspace symbols')
                end
            })

            -- capabilities:
            local capabilities = vim.tbl_deep_extend(
                'force',
                {},
                vim.lsp.protocol.make_client_capabilities(),
                require('cmp_nvim_lsp').default_capabilities())

            -- Lua
            vim.lsp.config('lua_ls', {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { 'vim' } },
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                    },
                },
            })

            -- Rust
            vim.lsp.config('rust_analyzer', {
                capabilities = capabilities,
                settings = {
                    ['rust-analyzer'] = {
                        cargo = { allFeatures = true },
                    },
                },
            })

            -- TypeScript / JavaScript
            vim.lsp.config('ts_ls', {
                capabilities = capabilities,
            })

            -- Enable the configs
            vim.lsp.enable('lua_ls')
            vim.lsp.enable('rust_analyzer')
            -- vim.lsp.enable('pyright')
            vim.lsp.enable('ts_ls')
        end,
    },
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),

                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                    { name = 'buffer' },
                }),
            })
        end,
    },
    -- formatter
    {
        'stevearc/conform.nvim',
        config = function()
            local cf = require('conform')
            cf.setup({
                formatters_by_ft = {
                    lua = { 'stylua' },
                    rust = { 'rustfmt', lsp_format = 'fallback' },
                    javascript = { 'prettierd', 'prettier', stop_after_first = true },
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_format = 'fallback',
                },
            })
            vim.keymap.set({ 'n', 'v' }, '<leader>fm', function()
                cf.format({
                    async = true,
                    lsp_format = 'fallback',
                })
            end, { desc = 'Format Buffer & Format Selection' })
        end,
    },
    -- LSP progress, notification messages
    {
        'j-hui/fidget.nvim',
        config = function()
            require('fidget').setup({})
        end,
    },
}
