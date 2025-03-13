return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    bufdelete = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
          { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = ' ', key = 'f', desc = 'Find File', action = ':lua Snacks.picker.files()' },
          { icon = ' ', key = 'g', desc = 'Find Text', action = ':lua Snacks.picker.grep()' },
          { icon = ' ', key = 'r', desc = 'Recent', action = ':lua Snacks.picker.recent()' },
          { icon = ' ', key = 'c', desc = 'Neovim Config', action = ":lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})" },
          { icon = ' ', key = 'M', desc = 'Mason', action = ':Mason' },
          { icon = '󰒲 ', key = 'L', desc = 'Lazy Plugins', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        { section = 'startup' },
      },
    },
    explorer = {
      enabled = true,
      replace_netrw = true,
    },
    git = { enabled = true },
    gitbrowse = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    picker = {
      enabled = true,
      hidden = true,
      matcher = {
        cwd_bonus = true,
        frecency = true,
      },
      sources = {
        explorer = {
          layout = { layout = { position = 'right' } },
          auto_close = true,
        },
      },
    },
    scroll = { enabled = true },
  },
  keys = {
    {
      '<leader>n',
      function()
        Snacks.notifier.show_history()
      end,
      desc = '[n]otification history',
    },
    {
      '<leader>bd',
      function()
        Snacks.bufdelete()
      end,
      desc = 'delete buffer',
    },
    {
      '<leader>cR',
      function()
        Snacks.rename.rename_file()
      end,
      desc = 'rename file',
    },
    {
      '<leader>un',
      function()
        Snacks.notifier.hide()
      end,
      desc = 'dismiss all [n]otifications',
    },
    {
      '<leader>gB',
      function()
        Snacks.gitbrowse()
      end,
      desc = '[g]it [B]rowse',
      mode = { 'n', 'v' },
    },
    {
      '<leader>gb',
      function()
        Snacks.git.blame_line()
      end,
      desc = '[g]it [b]lame line',
    },
    {
      '<leader>gl',
      function()
        Snacks.git.blame_line()
      end,
      desc = '[g]it [l]og',
    },
    {
      '<leader>gL',
      function()
        Snacks.git.blame_line()
      end,
      desc = '[g]it [L]og line',
    },
    {
      '<leader><leader>',
      function()
        Snacks.picker.buffers()
      end,
      desc = '[s]earch [b]uffers',
    },
    {
      '<leader>sb',
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = '[s]earch [b]uffers',
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = '[s]earch [g]rep',
    },
    {
      '<leader>sf',
      function()
        Snacks.picker.files()
      end,
      desc = '[s]earch [f]iles',
    },
    {
      '<leader>:',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'command history',
    },
    {
      '<leader>s.',
      function()
        Snacks.picker.recent()
      end,
      desc = '[s]earch recent [.]',
    },
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = '[s]earch [w]ord',
      mode = { 'n', 'x' },
    },
    {
      '<leader>sd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = '[s]earch [d]iagnostics',
    },
    {
      '<leader>sm',
      function()
        Snacks.picker.marks()
      end,
      desc = '[s]earch [b]arks',
    },
    {
      '<leader>sq',
      function()
        Snacks.picker.qflist()
      end,
      desc = '[s]earch [q]uickfixes',
    },
    {
      '<leader>ss',
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = '[s]earch LSP [s]ymbols',
    },
    {
      '<leader>gc',
      function()
        Snacks.picker.git_log()
      end,
      desc = '[g]it log [c]',
    },
    {
      '<leader>gs',
      function()
        Snacks.picker.git_status()
      end,
      desc = '[g]it [s]tatus',
    },
    {
      '<leader>gd',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = '[g]oto [d]efinition',
    },
    {
      '<leader>gr',
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = '[g]oto [r]eferences',
    },
    {
      '<leader>gI',
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = '[g]oto [I]mplementation',
    },
    {
      '<leader>gy',
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = '[g]oto t[y]pe definition',
    },
    {
      '<leader>e',
      function()
        Snacks.explorer()
      end,
      desc = 'File explorer (cwd)',
    },
    {
      '<leader>-',
      function()
        Snacks.explorer()
      end,
      desc = 'File explorer (cwd)',
    },
    {
      '<leader>E',
      function()
        Snacks.explorer({
          follow_file = false,
        })
      end,
      desc = 'File explorer (root)',
    },
    {
      '<leader>_',
      function()
        Snacks.explorer({
          follow_file = false,
        })
      end,
      desc = 'File explorer (root)',
    },
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command
      end,
    })
  end,
}
