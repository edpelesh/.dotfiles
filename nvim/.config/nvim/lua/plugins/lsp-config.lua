return {
	{
		"mason-org/mason.nvim",
		dependencies = {
			"mason-org/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			local mason = require("mason")
			local lspconfig = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")

			mason.setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			mason_lspconfig.setup({
				ensure_installed = {
					"lua_ls",
					"gopls",
				},
				automatic_installation = true,
				automatic_enable = true,
			})

			local servers = {
				clangd = {},
				sourcekit = {
					capabilities = {
						workspace = {
							didChangeWatchedFiles = {
								dynamicRegistration = true,
							},
						},
					},
				},
			}

			for server, setup in pairs(servers) do
				-- setup.handlers = handlers
				lspconfig[server].setup(setup)
			end

			local noice = require("noice.lsp")
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP Actions",
				callback = function()
					vim.keymap.set("n", "K", noice.hover, {})
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
					vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, {})
					vim.keymap.set("n", "g]", vim.diagnostic.goto_next, {})
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
				end,
			})
		end,
	},
}
