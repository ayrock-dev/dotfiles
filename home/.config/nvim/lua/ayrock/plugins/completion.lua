return {
  {
    'saghen/blink.cmp',
    lazy = false,
    version = '1.*',
    dependencies = {
      {
        'saghen/blink.compat',
        version = '*',
        lazy = true,
        opts = {
          impersonate_nvim_cmp = true,
        },
      },
      {
        'supermaven-inc/supermaven-nvim',
        opts = {
          disable_inline_completion = true,
          disable_keymaps = true,
        },
      },
    },
    event = 'InsertEnter',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'super-tab',
        ['<C-y>'] = { 'select_and_accept' },
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
        trigger = {
          show_on_keyword = true,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
      sources = {
        default = { 'supermaven', 'lsp', 'path' },
        providers = {
          supermaven = {
            name = 'supermaven',
            module = 'blink.compat.source',
            async = true,
            transform_items = function(_, items)
              for _, item in ipairs(items) do
                item.kind_icon = '󰘧'
                item.kind_name = 'Supermaven'
              end
              return items
            end,
            score_offset = 10,
          },
        },
      },

      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
  },
}
