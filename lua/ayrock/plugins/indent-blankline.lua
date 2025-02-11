return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  opts = {
    exclude = {
      filetypes = {
        'help',
        'alpha',
        'dashboard',
        'Trouble',
        'trouble',
        'lazy',
        'mason',
        'notify',
      },
    },
  },
}
