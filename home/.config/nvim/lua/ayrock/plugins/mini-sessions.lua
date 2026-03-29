return {
  {
    'echasnovski/mini.sessions',
    version = false,
    lazy = false,
    keys = {
      ['<leader>ss'] = { ':mksession!', mode = { 'n', 'x' }, desc = 'Save Session' },
    },
  },
}
