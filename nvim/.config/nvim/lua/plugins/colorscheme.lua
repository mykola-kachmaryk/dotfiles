return {
  -- {
  --   "folke/tokyonight.nvim",
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     local bg = "#011628"
  --     local bg_dark = "#011423"
  --     local bg_highlight = "#143652"
  --     local bg_search = "#0A64AC"
  --     local bg_visual = "#275378"
  --     local fg = "#CBE0F0"
  --     local fg_dark = "#B4D0E9"
  --     local fg_gutter = "#627E97"
  --     local border = "#547998"
  --
  --     require("tokyonight").setup({
  --       style = "night",
  --       on_colors = function(colors)
  --         colors.bg = bg
  --         colors.bg_dark = bg_dark
  --         colors.bg_float = bg_dark
  --         colors.bg_highlight = bg_highlight
  --         colors.bg_popup = bg_dark
  --         colors.bg_search = bg_search
  --         colors.bg_sidebar = bg_dark
  --         colors.bg_statusline = bg_dark
  --         colors.bg_visual = bg_visual
  --         colors.border = border
  --         colors.fg = fg
  --         colors.fg_dark = fg_dark
  --         colors.fg_float = fg
  --         colors.fg_gutter = fg_gutter
  --         colors.fg_sidebar = fg_dark
  --       end,
  --     })
  --     -- load the colorscheme here
  --     -- vim.cmd([[colorscheme tokyonight]])
  --   end,
  -- },
  -- {
  --   "catppuccin",
  --   opts = {
  --     -- transparent_background = true,
  --   },
  -- },
  -- {
  --   "shaunsingh/nord.nvim",
  -- },
  -- { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
  -- {
  --   "baliestri/aura-theme",
  --   lazy = false,
  --   priority = 1000,
  --   config = function(plugin)
  --     vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
  --     -- vim.cmd([[colorscheme aura-dark]])
  --   end,
  -- },
  --
  -- {
  --   "navarasu/onedark.nvim",
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     require("onedark").setup({
  --       style = "cool",
  --     })
  --     require("onedark").load()
  --   end,
  -- },
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
  },
  -- { "EdenEast/darker.nvim" },
  -- { "bluz71/vim-nightfly-colors", name = "nightfly", lazy = false, priority = 1000 },
  -- {
  --   "uhs-robert/oasis.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("oasis").setup() -- (see Configuration below for all customization options)
  --     vim.cmd.colorscheme("oasis") -- After setup, apply theme (or any style like "oasis-night")
  --   end,
  -- },
  -- {
  --   "gbprod/nord.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("nord").setup({})
  --     vim.cmd.colorscheme("nord")
  --   end,
  -- },
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   opts = { options = { theme = "nord" } },
  -- },
  { "https://github.com/vague-theme/vague.nvim" },
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    -- config = function()
    --   require("github-theme").setup({
    --     -- ...
    --   })
    --
    --   vim.cmd("colorscheme github_dark")
    -- end,
  },
  {

    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "catppuccin-frappe",
      -- colorscheme = "catppuccin-mocha",
      -- colorscheme = "catppuccin-macchiato",
      -- colorscheme = "onedark_vivid",
      -- colorscheme = "onedark",
      -- colorscheme = "onedark_dark",
      -- colorscheme = "catppuccin",
      -- colorscheme = "default",
      -- colorscheme = "moonfly",
      -- colorscheme = "tokyonight-storm",
      -- colorscheme = "github_dark_default",
      colorscheme = "vague",
    },
  },
}
