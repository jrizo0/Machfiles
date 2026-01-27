return {
  -- {
  --   -- Theme inspired by Atom
  --   'navarasu/onedark.nvim',
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'onedark'
  --   end,
  -- },

  -- {
  --   'folke/tokyonight.nvim',
  --   lazy = false,
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   opts = {},
  --   config = function()
  --     require('tokyonight').setup {
  --       style = 'moon',
  --       transparent = true,
  --     }
  --     vim.cmd 'colorscheme tokyonight'
  --   end,
  -- },

  -- {
  --   'rose-pine/neovim',
  --   name = 'rose-pine',
  --   config = function()
  --     vim.cmd('colorscheme rose-pine-moon')
  --     function ColorMyPencils(color)
  --       color = color or "rose-pine"
  --       vim.cmd.colorscheme(color)
  --       vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  --       vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  --     end
  --     -- ColorMyPencils()
  --   end
  -- },

  {
    'oxfist/night-owl.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    name = 'night-owl',
    config = function()
      require('night-owl').setup()
      vim.cmd.colorscheme 'night-owl'

      vim.cmd 'highlight Normal guibg=None guifg=None'
      vim.cmd 'highlight NonText guibg=None guifg=None'
      vim.cmd 'highlight SignColumn guibg=None guifg=None'
      vim.cmd 'highlight EndOfBuffer guifg=#001728'
      -- vim.cmd('highlight VertSplit ctermbg=NONE ctermfg=15')
      vim.cmd 'highlight VertSplit guibg=#011627 guifg=#011627'
      vim.cmd 'highlight GitGutterAdd guibg=NONE guifg=#22da6e'
      vim.cmd 'highlight GitGutterChange guibg=NONE guifg=#21c7a8'
      vim.cmd 'highlight GitGutterChangeDelete guibg=NONE guifg=#ef5350'
      vim.cmd 'highlight GitGutterDelete guibg=NONE guifg=#ef5350'
      vim.cmd 'highlight DiagnosticSignError guibg=NONE guifg=#e27878'
      vim.cmd 'highlight DiagnosticSignWarn guibg=NONE guifg=#e27878'
      vim.cmd 'highlight DiagnosticSignHint guibg=NONE'
      vim.cmd 'highlight IblIndent guifg=#4b6479 gui=nocombine'
      vim.cmd 'highlight FloatermBorder guibg=NONE guifg=#44657b'
      vim.cmd 'highlight FloatBorder guibg=None guifg=#44657b'
      vim.cmd 'highlight SignifySignAdd guibg=none guifg=#22da6e'
      vim.cmd 'highlight SignifySignChange guibg=none guifg=#ffeb95'
      vim.cmd 'highlight SignifySignDelete guibg=none guifg=#ef5350'
      vim.cmd 'highlight BufferLineSeparator guibg=None guifg=#161821'
      vim.cmd 'highlight TroubleSignOther guibg=None guifg=green'
      vim.cmd 'highlight TroubleFoldIcon guifg=None'
      vim.cmd 'highlight TroubleCount guibg=None'
      vim.cmd 'highlight TelescopeBorder guifg=#44657b'
      vim.cmd 'highlight TelescopePromptBorder guifg=#44657b'
      vim.cmd 'highlight TelescopeResultsBorder guifg=#44657b'
      vim.cmd 'highlight FPerson guifg=#4c5375 guibg=#1E2132'
      vim.cmd 'highlight Pmenu guibg=#161821'
      vim.cmd 'highlight CmpPmenu guifg=#8ab8c2'
      vim.cmd 'highlight CmpPmenuBorder guifg=#44657b'
      -- these statusline bg colors are different because thus way it hides the caret
      vim.cmd 'highlight StatusLine guifg=#001625 guibg=#001625'
      vim.cmd 'highlight StatusLineNC guifg=#001625 guibg=#001624'
      vim.cmd 'highlight NvimTreeIndentMarker guifg=#4b6479'
      vim.cmd 'highlight NvimTreeEndOfBuffer guifg=#011627'
      vim.cmd 'highlight NvimTreeFolderArrowOpen guifg=#4b6479'
      vim.cmd 'highlight NvimTreeFolderArrowClosed guifg=#4b6479'
      vim.cmd 'highlight NvimTreeNormal guifg=#5f7e97'
      vim.cmd 'highlight NvimTreeCursorLine guibg=None'
      -- vim.cmd('highlight WinSeparator guifg=#4b6479')
      vim.cmd 'highlight WinSeparator guifg=#011627'

      vim.cmd 'highlight NeoTreeIndentMarker guifg=#4b6479'
      vim.cmd 'highlight NeoTreeGitIgnored guifg=#4b6479'
      vim.cmd 'highlight NeoTreeDimText guifg=#4b6479'
      vim.cmd 'highlight NeoTreeStats guifg=#4b6479'
      vim.cmd 'highlight NeoTreeStatsHeader guifg=#4b6479'
      vim.cmd 'highlight NeoTreeWinSeparator guibg=NONE ctermfg=15'
      vim.cmd 'highlight NeoTreeTabInactive guifg=#4b6479'
      vim.cmd 'highlight NeoTreeTabSeparatorInactive guifg=#011627'
      vim.cmd 'highlight NeoTreeTabSeparatorActive guifg=#011627'
      vim.cmd 'highlight NeoTreeNormal guibg=None guifg=None'
    end,
  },

  -- {
  --   'projekt0n/github-nvim-theme',
  --   name = 'github-theme',
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     require('github-theme').setup {
  --       -- ...
  --     }
  --
  --     vim.cmd 'colorscheme github_light'
  --   end,
  -- },

  -- {
  --   "catppuccin/nvim",
  --   priority = 1000,
  --   name = "catppuccin",
  --   config = function()
  --     require("catppuccin").setup({
  --       flavour = "latte", -- latte, frappe, macchiato, mocha
  --       background = {     -- :h background
  --         light = "latte",
  --         dark = "mocha",
  --       },
  --     })
  --     vim.cmd.colorscheme "catppuccin"
  --   end,
  -- },

  -- {
  --   "sainnhe/everforest",
  --   priority = 1000,
  --   name = "everforest",
  --   opts = {
  --     background = "light",
  --     everforest_background = "soft"
  --   },
  --   config = function()
  --     -- run vim script:
  --     vim.cmd [[
  --       set background=light
  --       let g:everforest_background = 'soft'
  --       colorscheme everforest
  --     ]]
  --   end,
  -- },

  -- {
  --   'sainnhe/gruvbox-material',
  --   config = function()
  --     vim.g.gruvbox_material_foreground = 'grey'
  --     vim.g.gruvbox_material_better_performance = 1
  --     vim.g.gruvbox_material_enable_bold = 1
  --     vim.g.gruvbox_material_enable_italic = 0
  --     vim.g.gruvbox_material_transparent_background = 0
  --     vim.g.gruvbox_material_visual = 'grey background'
  --     vim.g.gruvbox_material_background = 'soft'
  --     vim.g.gruvbox_material_current_word = 'grey background'
  --     vim.g.gruvbox_material_menu_selection_background = 'aqua'
  --     vim.g.gruvbox_material_ui_contrast = 'high'
  --     vim.g.gruvbox_material_diagnostic_text_highlight = 0
  --     vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
  --     vim.g.gruvbox_material_diagnostic_line_highlight = 0 -- not working
  --   end
  -- },
  {
    'folke/lsp-colors.nvim',
    opts = {
      Error = '#db4b4b',
      Warning = '#e0af68',
      Information = '#0db9d7',
      Hint = '#10B981',
    },
  },
  -- { 'projekt0n/github-nvim-theme', version = 'v0.0.7' },
  -- 'lunarvim/darkplus.nvim',
}
