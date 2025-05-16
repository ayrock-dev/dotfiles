return {
  'folke/todo-comments.nvim',
  event = { 'BufReadPost' },
  opts = {
    -- i prefer to only match my own todos
    --
    -- the following todos are tests:
    --
    -- TODO: should not match
    -- TODO(ayrock-dev): should match
    -- TODO (ayrock-dev): should match
    -- TODO (ayrock-dev) should match
    -- TODO(ayrock-dev) should match
    -- FIX: should not match
    -- FIXME: should not match
    -- FIX(ericlee): should match
    -- FIX(eric.lee): should match
    -- FIXME (ericlee): should match
    -- FIXME (eric.lee): should match
    search = { pattern = [[\b(KEYWORDS)\s?\((ayrock-dev|ayrock|ericlee|eric\.lee)\)]] },
    highlight = { pattern = [[.*<((KEYWORDS)\s?\((ayrock-dev|ayrock|ericlee|eric\.lee)\))]] },
  },
  keys = {
    {
      '<leader>sT',
      function()
        Snacks.picker.todo_comments()
      end,
      desc = '[s]earch [t]odo comments',
    },
    {
      ']T',
      function()
        require('todo-comments').jump_next()
      end,
      desc = 'next [t]odo comment',
    },
    {
      '[T',
      function()
        require('todo-comments').jump_prev()
      end,
      desc = 'previous [t]odo comment',
    },
  },
}

--[[
  {
    -- "gc" to comment visual regions/lines
    'numToStr/Comment.nvim',
    opts = {},
  },
-=]]
