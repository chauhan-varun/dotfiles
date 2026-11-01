-- =============================================================================
-- AI / Autocomplete Plugins
-- lua/plugins/ai.lua
-- =============================================================================

return {

  -- ---------------------------------------------------------------------------
  -- NeoCodeium: free AI code completion (inline virtual text)
  --   <C-l>        — accept full suggestion
  --   <C-j>        — accept next word
  --   <C-e>        — clear/dismiss suggestion
  --   <M-]>        — cycle to next suggestion
  --   <M-[>        — cycle to previous suggestion
  --   <leader>tc   — toggle NeoCodeium on/off
  --
  --   First run:  :NeoCodeium auth  to sign in
  -- ---------------------------------------------------------------------------
  {
    'monkoose/neocodeium',
    event = 'VeryLazy',
    config = function()
      local neocodeium = require 'neocodeium'

      neocodeium.setup {
        silent = true,
        debounce = false, -- request suggestions immediately as you type
        max_lines = 2000, -- parse fewer surrounding lines for faster payload generation
        filetypes = {
          help = false,
          gitcommit = false,
          gitrebase = false,
          ['.'] = false,
        },
      }

      -- Keymaps (NeoCodeium doesn't set any by default)
      vim.keymap.set('i', '<C-l>', neocodeium.accept, { desc = 'Accept suggestion' })
      vim.keymap.set('i', '<C-j>', neocodeium.accept_word, { desc = 'Accept word' })
      vim.keymap.set('i', '<C-e>', neocodeium.clear, { desc = 'Clear suggestion' })
      vim.keymap.set('i', '<M-]>', function() neocodeium.cycle_or_complete(1) end, { desc = 'Next suggestion' })
      vim.keymap.set('i', '<M-[>', function() neocodeium.cycle_or_complete(-1) end, { desc = 'Prev suggestion' })

      -- Toggle NeoCodeium on or off
      vim.keymap.set('n', '<leader>tc', function()
        vim.cmd 'NeoCodeium toggle'
      end, { desc = '[T]oggle Neo[C]odeium' })
    end,
  },
}
