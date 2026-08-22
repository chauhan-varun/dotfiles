-- =============================================================================
-- UI & Aesthetics Plugins
-- lua/plugins/ui.lua
-- =============================================================================

return {

  -- ---------------------------------------------------------------------------
  -- Themes (dark) — switch with <leader>tc or :colorscheme <name>
  --
  --   tokyonight-night  ← currently active
  --   catppuccin-mocha
  --   rose-pine
  --   kanagawa
  --   onedark
  -- ---------------------------------------------------------------------------

  -- Tokyo Night — deep blue/purple (ACTIVE)
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        transparent = true,
        styles = {
          sidebars = 'transparent',
          floats   = 'transparent',
        },
      }
      vim.cmd.colorscheme 'tokyonight-night'

      -- <leader>tc — pick a theme interactively from the installed list
      vim.keymap.set('n', '<leader>tc', function()
        local themes = {
          'tokyonight-night',
          'tokyonight-moon',
          'catppuccin-mocha',
          'rose-pine',
          'kanagawa',
          'onedark',
        }
        vim.ui.select(themes, { prompt = 'Select theme: ' }, function(choice)
          if choice then vim.cmd.colorscheme(choice) end
        end)
      end, { desc = '[T]heme [C]hange' })
    end,
  },

  -- Catppuccin Mocha — warm dark with pastel accents
  {
    'catppuccin/nvim',
    name     = 'catppuccin',
    priority = 900,
    opts = {
      flavour    = 'mocha',
      transparent_background = true,
      no_italic  = true,
    },
  },

  -- Rose Pine — muted, earthy dark
  {
    'rose-pine/neovim',
    name     = 'rose-pine',
    priority = 900,
    opts = {
      variant         = 'main',
      dark_variant    = 'main',
      disable_italics = true,
      styles = { transparency = true },
    },
  },

  -- Kanagawa — Japanese-ink dark with warm tones
  {
    'rebelot/kanagawa.nvim',
    priority = 900,
    opts = {
      transparent = true,
      commentStyle = { italic = false },
      keywordStyle = { italic = false },
    },
  },

  -- OneDark — classic Atom dark (clean and neutral)
  {
    'navarasu/onedark.nvim',
    priority = 900,
    opts = {
      style       = 'dark',
      transparent = true,
      code_style  = { comments = 'none' },
    },
  },

  -- ---------------------------------------------------------------------------
  -- Noice: replaces cmdline, messages, and LSP progress with floating windows
  -- ---------------------------------------------------------------------------
  {
    'folke/noice.nvim',
    event        = 'VeryLazy',
    opts         = {},
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
  },

  -- ---------------------------------------------------------------------------
  -- Bufferline: VS Code-style buffer tabs at the top
  -- Tab / S-Tab to cycle. <leader>1-9 to jump by index.
  -- ---------------------------------------------------------------------------
  {
    'akinsho/bufferline.nvim',
    version      = '*',
    event        = 'VeryLazy',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        mode                  = 'buffers',
        separator_style       = 'slant',
        show_buffer_close_icons = true,
        show_close_icon       = false,
        diagnostics           = 'nvim_lsp',
        always_show_bufferline = true,
      },
    },
    keys = {
      { '<Tab>',      '<cmd>BufferLineCycleNext<cr>',    desc = 'Next buffer' },
      { '<S-Tab>',    '<cmd>BufferLineCyclePrev<cr>',    desc = 'Prev buffer' },
      { '<leader>bp', '<cmd>BufferLineTogglePin<cr>',    desc = '[B]uffer [P]in' },
      { '<leader>bc', '<cmd>BufferLinePickClose<cr>',    desc = '[B]uffer [C]lose (pick)' },
      { '<leader>bb', '<cmd>BufferLinePick<cr>',         desc = '[B]uffer [P]ick' },
      { '<leader>1',  '<cmd>BufferLineGoToBuffer 1<cr>', desc = 'Buffer 1' },
      { '<leader>2',  '<cmd>BufferLineGoToBuffer 2<cr>', desc = 'Buffer 2' },
      { '<leader>3',  '<cmd>BufferLineGoToBuffer 3<cr>', desc = 'Buffer 3' },
      { '<leader>4',  '<cmd>BufferLineGoToBuffer 4<cr>', desc = 'Buffer 4' },
      { '<leader>5',  '<cmd>BufferLineGoToBuffer 5<cr>', desc = 'Buffer 5' },
      { '<leader>6',  '<cmd>BufferLineGoToBuffer 6<cr>', desc = 'Buffer 6' },
      { '<leader>7',  '<cmd>BufferLineGoToBuffer 7<cr>', desc = 'Buffer 7' },
      { '<leader>8',  '<cmd>BufferLineGoToBuffer 8<cr>', desc = 'Buffer 8' },
      { '<leader>9',  '<cmd>BufferLineGoToBuffer 9<cr>', desc = 'Buffer 9' },
    },
  },

  -- ---------------------------------------------------------------------------
  -- Smear Cursor: animate cursor movement between lines and buffers
  -- ---------------------------------------------------------------------------
  {
    'sphamba/smear-cursor.nvim',
    opts = {
      smear_between_buffers        = true,
      smear_between_neighbor_lines = true,
      scroll_buffer_space          = true,
      legacy_computing_symbols_support = false,
      smear_insert_mode            = true,
    },
  },

  -- ---------------------------------------------------------------------------
  -- Mini.nvim: lightweight collection of small utility modules
  --   mini.ai       — extended text objects (va), yinq, ci', …)
  --   mini.surround — add/delete/replace surroundings (saiw), sd', sr)')
  --   mini.pairs    — auto-close brackets, quotes, parens (replaces nvim-autopairs)
  --   mini.statusline — simple, icon-aware statusline
  -- ---------------------------------------------------------------------------
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      require('mini.pairs').setup()

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- Show LINE:COL instead of the default percentage-based location
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  -- ---------------------------------------------------------------------------
  -- Todo Comments: highlight TODO, FIXME, NOTE, HACK, etc. in comments
  -- ---------------------------------------------------------------------------
  {
    'folke/todo-comments.nvim',
    event        = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts         = { signs = false },
  },

}

