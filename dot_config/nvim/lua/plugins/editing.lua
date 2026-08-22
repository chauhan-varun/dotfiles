-- =============================================================================
-- Editing Plugins
-- lua/plugins/editing.lua
-- =============================================================================

return {

  -- ---------------------------------------------------------------------------
  -- vim-sleuth: automatically detect indentation (tabstop / shiftwidth)
  -- ---------------------------------------------------------------------------
  'tpope/vim-sleuth',

  -- ---------------------------------------------------------------------------
  -- vim-visual-multi: multi-cursor editing (like VS Code Ctrl+D)
  --   <C-n>   — select word under cursor / next match
  --   \\A      — select all matches
  -- ---------------------------------------------------------------------------
  {
    'mg979/vim-visual-multi',
    branch = 'master',
  },

  -- ---------------------------------------------------------------------------
  -- auto-save: silently save on InsertLeave and TextChanged
  -- Using okuuva/auto-save (the original Pocco81 repo is abandoned)
  -- ---------------------------------------------------------------------------
  {
    'okuuva/auto-save.nvim',
    config = function()
      require('auto-save').setup {
        enabled = true,
        trigger_events = { 'InsertLeave', 'TextChanged' },
      }

      -- Prevent conform from formatting on auto-save writes.
      -- auto-save fires on InsertLeave, so we set the flag there — guaranteed
      -- to be true before BufWritePre fires.
      -- BufWritePost clears it so the next manual :w formats normally.
      -- Safety net: if the buffer had no changes, auto-save skips the write
      -- entirely so BufWritePost never fires — defer_fn clears the flag anyway.
      local ag = vim.api.nvim_create_augroup('auto-save-no-format', { clear = true })
      vim.api.nvim_create_autocmd('InsertLeave', {
        group    = ag,
        callback = function()
          vim.g.auto_save_abort = true
          -- If auto-save decides not to write (buffer unchanged), BufWritePost
          -- won't fire and the flag would stay true forever. Clear it after
          -- 500 ms as a safety net (auto-save writes complete well under that).
          vim.defer_fn(function()
            vim.g.auto_save_abort = false
          end, 500)
        end,
      })
      vim.api.nvim_create_autocmd('BufWritePost', {
        group    = ag,
        -- Clear immediately on any write so the next :w formats normally.
        callback = function() vim.g.auto_save_abort = false end,
      })
    end,
  },

  -- ---------------------------------------------------------------------------
  -- vim-prisma: filetype detection for *.prisma files
  -- Required so that treesitter and prismals LSP activate correctly.
  -- ---------------------------------------------------------------------------
  'prisma/vim-prisma',

  -- ---------------------------------------------------------------------------
  -- nvim-ts-autotag: auto-close and auto-rename HTML / JSX tags
  -- ---------------------------------------------------------------------------
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    opts  = {},
  },

}
