-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_php_lsp = "intelephense"
-- vim.g.lazyvim_php_lsp = "phpactor"
-- vim.g.lazyvim_ts_lsp = "tsgo"
vim.g.root_spec = { { ".git" }, "lsp", "cwd" }

-- -- Open Telescope picker to view/switch worktrees (or create/delete using Telescope keymaps)
-- vim.keymap.set("n", "<leader>gw", function()
--   require("telescope").extensions.git_worktree.git_worktrees()
-- end, { desc = "Switch Git Worktree" })
--
-- -- Create a new worktree via Telescope prompt
-- vim.keymap.set("n", "<leader>gc", function()
--   require("telescope").extensions.git_worktree.create_git_worktree()
-- end, { desc = "Create Git Worktree" })
