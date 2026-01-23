return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		options = {
			ensure_installed = {
				"c",
				"cpp",
				"glsl",
				"go",
				"swift",
				"lua",
				"javascript",
				"vim",
				"regex",
				"bash",
				"markdown",
				"markdown_inline",
			},
			sync_install = false,
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		},
	},
}
