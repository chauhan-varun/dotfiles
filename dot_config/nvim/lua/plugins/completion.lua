-- =============================================================================
-- Autocompletion
-- lua/plugins/completion.lua
-- =============================================================================

return {
  {
    'saghen/blink.cmp',
    event        = 'VimEnter',
    version      = '1.*',
    dependencies = {
      -- Snippet engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        -- Regex support in snippets requires building a C extension
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- Pre-built snippet collections (VS Code format)
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      enabled = function()
        -- Disable blink.cmp during visual-multi mode to prevent key conflicts
        return not (vim.g.VM_active == 1 or (vim.g.VM and vim.g.VM.is_active == 1))
      end,

      keymap = {
        -- <CR> only accepts if you explicitly navigated to a suggestion with
        -- <C-n>/<C-p>. Auto-shown/pre-selected items are NOT confirmed on Enter
        -- — it just inserts a newline as expected (e.g. inside a TSX fragment).
        -- <C-y> still force-accepts whatever is highlighted at any time.
        -- <C-space> opens menu, <C-e> closes, <C-k> toggles signature help
        -- <Tab>/<S-Tab> moves through snippet expansion points
        preset = 'none',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>']     = { 'hide', 'fallback' },
        ['<C-y>']     = { 'select_and_accept' },
        ['<C-k>']     = { 'show_signature', 'hide_signature', 'fallback' },
        ['<C-n>']     = { 'select_next', 'fallback' },
        ['<C-p>']     = { 'select_prev', 'fallback' },
        ['<CR>']      = {
          -- 1. If user explicitly navigated to an item → accept it.
          function(cmp)
            if cmp.is_visible() and cmp.get_selected_item() ~= nil then
              return cmp.accept()
            end
          end,
          -- 2. If cursor is between matching inline tags in JSX/TSX/HTML →
          --    split into three lines and place cursor on the indented middle.
          --
          --    Before:  <div>|</div>
          --    After:   <div>
          --               |          ← cursor here
          --             </div>
          --
          --    Uses nvim_buf_set_lines (not feedkeys) so treesitter auto-indent
          --    does NOT fire and double-indent nested tags.
          function(_cmp)
            local jsx_fts = { html = true, javascriptreact = true, typescriptreact = true }
            if not jsx_fts[vim.bo.filetype] then return end

            local line   = vim.api.nvim_get_current_line()
            local col    = vim.api.nvim_win_get_cursor(0)[2]
            local before = line:sub(1, col)
            local after  = line:sub(col + 1)

            -- Check for JSX fragment:  <>|</>
            local is_fragment = before:match('<>%s*$') and after:match('^%s*</>')
            -- Check for named tag:  <div>|</div>
            local tag = not is_fragment and before:match('<(%w[%w%-]*)%s*[^/]*>%s*$')
            if not (is_fragment or (tag and after:match('^%s*</' .. tag .. '>'))) then return end

            local row     = vim.api.nvim_win_get_cursor(0)[1]  -- 1-indexed
            local buf     = vim.api.nvim_get_current_buf()
            local indent  = before:match('^(%s*)') or ''
            local inner   = indent .. string.rep(' ', vim.bo.shiftwidth)
            -- Strip leading whitespace from the closing tag text
            local closing = after:match('^%s*(.+)') or after

            -- Directly write 3 lines — no feedkeys, no treesitter auto-indent conflict.
            -- vim.schedule defers past blink's callback context (direct edits not allowed there).
            vim.schedule(function()
              vim.api.nvim_buf_set_lines(buf, row - 1, row, false, {
                before,              -- e.g. "    <div>"
                inner,               -- e.g. "      "  ← cursor lands here
                indent .. closing,   -- e.g. "    </div>"
              })
              -- Place cursor at the end of the indentation on the middle line
              vim.api.nvim_win_set_cursor(0, { row + 1, #inner })
            end)

            return true
          end,
          -- 3. Normal newline for everything else.
          'fallback',
        },
        ['<Tab>']   = { 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      },

      appearance = {
        -- 'mono' = Nerd Font Mono spacing; 'normal' = standard Nerd Font
        nerd_font_variant = 'mono',
      },

      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },

      sources = {
        default   = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          -- Give lazydev completions a very high score so they rank first
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Use the Rust-based fuzzy matcher (downloads a prebuilt binary on first install)
      fuzzy = { implementation = 'prefer_rust_with_warning' },

      -- Show function signature help while typing arguments
      signature = { enabled = true },
    },
  },
}
