return {
  {
    'saghen/blink.cmp',
    lazy = false,
    version = '1.*',
    event = 'InsertEnter',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        -- https://cmp.saghen.dev/configuration/keymap.html#presets
        preset = 'default',
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { 'lsp' },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
      sources = {
        -- intentionally omit snippets, I don't use them
        default = {
          'lsp',
          'path',
          'buffer',
        },
      },

      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
  },
}
