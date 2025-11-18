return {
  'rachartier/tiny-inline-diagnostic.nvim',
  event = 'VeryLazy',
  priority = 1000,
  opts = {
    {
      preset = 'powerline',
      options = {
        use_icons_from_diagnostic = true,
        add_messages = {
          display_count = true,
          messages = true,
        },
        multilines = {
          always_show = true,
          enabled = true,
        },
      },
    },
  },
  init = function()
    vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
  end,
}
