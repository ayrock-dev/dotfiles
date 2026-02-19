return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local bufnr = event.buf
        local bufname = vim.api.nvim_buf_get_name(bufnr)

        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('grn', vim.lsp.buf.rename, 'goto rename')
        map('gra', vim.lsp.buf.code_action, 'goto code action')
        map('grr', vim.lsp.buf.references, 'goto references')
        map('gri', vim.lsp.buf.implementation, 'goto implementation')
        map('grd', vim.lsp.buf.declaration, 'goto declaration')
        map('grD', vim.lsp.buf.definition, 'goto definition')
        map('gO', vim.lsp.buf.document_symbol, 'goto document symbols')
        map('gW', vim.lsp.buf.workspace_symbol, 'goto workspace symbols')
        map('grt', vim.lsp.buf.type_definition, 'goto type definition')

        --  See `:help K` for why this keymap.
        map('K', function()
          vim.lsp.buf.hover({ border = 'rounded' })
        end, 'show documentation')
        map('<C-k>', function()
          vim.lsp.buf.signature_help({ border = 'rounded' })
        end, 'show documentation')

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- This block highlights the symbol under cursor using highlight groups
        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = 'kickstart-lsp-highlight', buffer = event2.buf })
            end,
          })
        end

        -- Detach from non-file buffers
        if bufname == '' or bufname:match('^diffview://') or bufname:match('^fugitive://') then
          vim.schedule(function()
            vim.lsp.buf_detach_client(bufnr, event.data.client_id)
          end)
          return
        end
      end,
    })

    local icons = require('ayrock/icons')

    -- Diagnostic Config
    -- See :help vim.diagnostic.Opts
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
          [vim.diagnostic.severity.WARN] = icons.diagnostics.warn,
          [vim.diagnostic.severity.INFO] = icons.diagnostics.info,
          [vim.diagnostic.severity.HINT] = icons.diagnostics.info,
        },
      },
    })

    local servers = require('ayrock/langs').servers
    require('mason-tool-installer').setup({ ensure_installed = servers })
    require('mason-lspconfig').setup({ ensure_installed = servers })
  end,
}
