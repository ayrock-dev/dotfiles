return {
  'nvim-lualine/lualine.nvim',
  opts = {
    options = {
      icons_enabled = false,
      theme = 'catppuccin',
      component_separators = '|',
      section_separators = '',
    },
    sections = {
      lualine_b = {'branch','diff','diagnostics'},
      lualine_c = {'filename',path=1},
      lualine_x = {'filetype'},
    },
  },
}
