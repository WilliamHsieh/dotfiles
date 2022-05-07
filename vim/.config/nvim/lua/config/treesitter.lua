require("nvim-treesitter.configs").setup {
	sync_install = false,
	ensure_installed = "all",
	ignore_install = { "" },
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	autopairs = {
		enable = true,
	},
	indent = { enable = true, disable = { "python", "css" } },
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
	autotag = {
		enable = true,
		disable = { "xml" },
	},
	rainbow = {
		enable = true,
		colors = {
			"Gold",
			"Orchid",
			"DodgerBlue",
			-- "Cornsilk",
			-- "Salmon",
			-- "LawnGreen",
		},
		disable = { "html" },
    extended_mode = false,
    max_file_lines = nil,
	},
  matchup = {
    enable = true,
  },
}
