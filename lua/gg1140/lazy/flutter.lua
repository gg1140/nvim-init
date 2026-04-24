return {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    ft = { 'dart' },
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- 'stevearc/dressing.nvim', -- optional, for vim.ui.select
    },
    config = function()
        require("flutter-tools").setup({
            flutter_lookup_cmd = 'asdf where flutter',
            lsp = {
                color = {
                    enabled = true,
                },
            },
        })
        require("telescope").load_extension("flutter")
    end
}
