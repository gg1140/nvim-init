return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")

        -- optional; only if you want a custom install location
        ts.setup({
            install_dir = vim.fn.stdpath("data") .. "/site",
        })

        local parsers = {
            'lua',
            'javascript',
            'typescript',
            'tsx',
            'html',
            'css',
            'json',
            'rust',
            'go',
            'Kotlin', -- unsupported
            'Java', -- unsupported
            'Swift', -- unsupported
            'ruby',
            'query',
            'gitignore',
            'vim',
            'vimdoc',
        }

        ts.install(parsers)

        vim.api.nvim_create_autocmd("FileType", {
            pattern = parsers,
            callback = function()
                vim.treesitter.start()
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
-- return {
-- 	{
-- 		"nvim-treesitter/nvim-treesitter",
-- 		build = ":TSUpdate",
-- 		lazy = false,
-- 		init = function()
-- 			local parsers = {
-- 				"lua",
-- 				"vim",
-- 				"vimdoc",
-- 				"query",
-- 				"javascript",
-- 				"typescript",
-- 				"tsx",
-- 				"html",
-- 				"css",
-- 				"json",
-- 				"gitignore",
-- 				"go",
-- 			}
-- 
-- 			local group = vim.api.nvim_create_augroup("Gg1140Treesitter", { clear = true })
-- 			vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
-- 				group = group,
-- 				callback = function()
-- 					if vim.bo.buftype ~= "" then
-- 						return
-- 					end
-- 
-- 					pcall(vim.treesitter.start, 0)
-- 				end,
-- 			})
-- 
-- 			vim.api.nvim_create_autocmd("User", {
-- 				group = group,
-- 				pattern = "VeryLazy",
-- 				once = true,
-- 				callback = function()
-- 					require("nvim-treesitter").install(parsers)
-- 				end,
-- 			})
-- 		end,
-- 	},
-- 	{
-- 		"nvim-treesitter/nvim-treesitter-textobjects",
-- 		lazy = false,
-- 		config = function()
-- 			require("nvim-treesitter-textobjects").setup({
-- 				select = {
-- 					enable = true,
-- 					lookahead = true,
-- 					keymaps = {
-- 						["af"] = "@function.outer",
-- 						["if"] = "@function.inner",
-- 					},
-- 				},
-- 			})
-- 		end,
-- 	},
-- }
