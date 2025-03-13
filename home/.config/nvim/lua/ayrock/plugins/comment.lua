return {
  {
    'folke/todo-comments.nvim',
    optional = true,
    keys = {
      {
        '<leader>st',
        function()
          Snacks.picker.todo_comments({ keywords = { 'todo', 'Todo', 'TODO', 'FIX', 'FIXME' } })
        end,
        desc = '[s]earch [t]odo comments',
      },
    },
  },
  {
    -- "gc" to comment visual regions/lines
    'numToStr/Comment.nvim',
    opts = {},
  },
}
