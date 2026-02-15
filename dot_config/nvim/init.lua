-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.o.termguicolors = true
vim.cmd('source ~/.vimrc')

vim.cmd[[
  highlight BufferLineTabBackground guibg=#2e2e2e guifg=#888888
  highlight BufferLineTabSelected guibg=#3c3c3c guifg=#ffffff
  highlight BufferLineTabClose guifg=#ff5555
  highlight BufferLineFill guibg=#000000
]]

-- リーダーキーをスペースに
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup({
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<Leader>ff", "<cmd>Telescope find_files<CR>" },
      { "<Leader>fg", "<cmd>Telescope live_grep<CR>" },
      { "<Leader>fb", "<cmd>Telescope buffers<CR>" },
      { "<Leader>fh", "<cmd>Telescope help_tags<CR>" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            "%.git/",
            "%vendor",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      })
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = {
      "NvimTreeToggle",
      "NvimTreeOpen",
      "NvimTreeFindFile",
    },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>" },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        view = {
          side = "left",
          width = 30,
          adaptive_size = true,
        },
        actions = {
          open_file = {
            quit_on_open = false,
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    cmd = {
      "BufferLineCycleNext",
      "BufferLineCyclePrev",
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("bufferline").setup({
        options = {
          offsets = {
            {
              filetype = "NvimTree",
              text = "Explorer",
              highlight = "Directory",
              text_align = "left",
            },
          },
          numbers = "none",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = false,
          separator_style = "slant",
          always_show_bufferline = true,
          enforce_regular_tabs = false,
          view = "multiwindow",
        },
      })
    end,
  },
})

vim.api.nvim_set_keymap("n", "<leader>q", ":bdelete<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-l>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-h>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
