-- return {}
-- return {
--   "ThePrimeagen/git-worktree.nvim",
--   dependencies = {
--     "nvim-telescope/telescope.nvim",
--     "nvim-lua/plenary.nvim",
--   },
--   keys = {
--     {
--       "<leader>gw",
--       function()
--         require("telescope").extensions.git_worktree.git_worktrees()
--       end,
--       desc = "Switch Git Worktree",
--     },
--     {
--       "<leader>gc",
--       function()
--         require("telescope").extensions.git_worktree.create_git_worktree()
--       end,
--       desc = "Create Git Worktree",
--     },
--   },
--   config = function()
--     require("telescope").load_extension("git_worktree")
--   end,
-- }
-- return {
--   "ThePrimeagen/git-worktree.nvim",
--   dependencies = {
--     "nvim-telescope/telescope.nvim",
--     "nvim-lua/plenary.nvim",
--   },
--   config = function()
--     require("telescope").load_extension("git_worktree")
--   end,
-- }
return {
  {
    "ThePrimeagen/git-worktree.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("git-worktree").setup()
      require("telescope").load_extension("git_worktree")
    end,
    keys = {
      {
        "<leader>gwl",
        function()
          require("telescope").extensions.git_worktree.git_worktrees()
        end,
        desc = "List worktrees",
      },
      {
        "<leader>gwc",
        function()
          require("telescope").extensions.git_worktree.create_git_worktree()
        end,
        desc = "Create worktree",
      },
    },
  },
}
