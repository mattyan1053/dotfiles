-- packer 読み込み
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'          -- Packer 自身
  use 'nvim-telescope/telescope.nvim'   -- ファイル検索
  use 'nvim-lua/plenary.nvim'           -- telescope依存ライブラリ
  use 'nvim-tree/nvim-tree.lua'         -- ファイルツリー
  use 'nvim-tree/nvim-web-devicons'     -- アイコン表示
  use 'nvim-treesitter/nvim-treesitter' -- 高速シンタックスハイライト
  use 'akinsho/bufferline.nvim'         -- タブ表示
end)

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

require'nvim-tree'.setup {
  view = {
    side = 'left',
    width = 30,
    adaptive_size = true,
  },
  actions = {
    open_file = {
      quit_on_open = false,
    },
  },
}
require'bufferline'.setup {
  options = {
    offsets = {
      {
        filetype = "NvimTree",
	text = "Explorer",
	highlight = "Directory",
	text_align = "left"
      }
    },
    numbers = "none",
    close_command = "bdelete! %d",      -- バッファを閉じる
    right_mouse_command = "bdelete! %d",
    left_mouse_command = "buffer %d", -- クリックで切り替え
    middle_mouse_command = nil,
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = false,
    separator_style = "slant",
    always_show_bufferline = true,
    enforce_regular_tabs = false,
    view = 'multiwindow',
  }
}

require'telescope'.setup {
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
}

-- ファイル検索
vim.api.nvim_set_keymap('n', '<Leader>ff', "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })

-- 文字列検索
vim.api.nvim_set_keymap('n', '<Leader>fg', "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true })

-- バッファ系
vim.api.nvim_set_keymap('n', '<Leader>fb', "<cmd>Telescope buffers<CR>", { noremap = true, silent = true })

-- 検索ヘルプ
vim.api.nvim_set_keymap('n', '<Leader>fh', "<cmd>Telescope help_tags<CR>", { noremap = true, silent = true })

-- ファイルツリーのキーバインド
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- バッファ移動
vim.api.nvim_set_keymap('n', '<S-l>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-h>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })

-- バッファ閉じる
vim.api.nvim_set_keymap('n', '<leader>q', ':bdelete<CR>', { noremap = true, silent = true })
