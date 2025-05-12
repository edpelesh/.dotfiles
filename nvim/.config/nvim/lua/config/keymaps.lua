local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Telescope find project files" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })

vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", { desc = "Neotree filesystem reveal toggle" })

vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format code" })
