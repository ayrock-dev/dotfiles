return {
  {
    'pmizio/typescript-tools.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
      'marilari88/twoslash-queries.nvim',
    },
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    opts = {

      config = {
        on_attach = function(client, bufnr)
          require('twoslash-queries').attach(client, bufnr)
        end,
      },
      settings = {
        -- tsserver_path = "",

        -- Performance: separate diagnostic server for large projects
        separate_diagnostic_server = true,

        -- When to publish diagnostics
        publish_diagnostic_on = 'insert_leave',

        -- JSX auto-closing tags
        jsx_close_tag = {
          enable = true,
          filetypes = { 'javascriptreact', 'typescriptreact' },
        },

        tsserver_file_preferences = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
        },

        complete_function_calls = true,
        include_completions_with_insert_text = true,
        code_lens = 'off',
        disable_member_code_lens = true,
        tsserver_max_memory = 12288,
      },
    },
  },
}
