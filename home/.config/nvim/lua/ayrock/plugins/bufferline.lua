return {
  'akinsho/bufferline.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  after = 'catppuccin',
  config = function()
    local bufferline = require('bufferline')
    local icons = require('ayrock/icons')
    bufferline.setup({
      highlights = require('catppuccin.groups.integrations.bufferline').get(),

      options = {
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match('error') and icons.diagnostics.error or icons.diagnostics.warn
          return vim.trim(' ' .. icon .. count)
        end,
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = true,
        styles_preset = bufferline.style_preset.no_italic,
      },
    })
  end,
}
