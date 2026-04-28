return {
  -- Detect tabstop and shiftwidth automatically
  'NMAC427/guess-indent.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {},
}
