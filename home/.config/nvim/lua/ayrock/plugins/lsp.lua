-- LSP setup using Neovim 0.11+ native APIs (`vim.lsp.config` / `vim.lsp.enable`).
--
-- `nvim-lspconfig` is intentionally NOT used. Per-server config lives in
-- `after/lsp/<name>.lua`, which Neovim auto-discovers and merges via
-- `vim.lsp.config['<name>']`. Each file must be self-contained
-- (`cmd`, `filetypes`, `root_markers`, ...).
return {
  'mason-org/mason.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  cmd = { 'Mason', 'MasonInstall', 'MasonUpdate', 'MasonLog', 'MasonUninstall', 'MasonUninstallAll' },
  dependencies = {
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    require('mason').setup({})

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('ayrock.lsp-attach', { clear = true }),
      callback = function(event)
        local bufnr = event.buf
        local bufname = vim.api.nvim_buf_get_name(bufnr)

        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Customizations / non-default mappings only.
        -- Built-in 0.11+ defaults retained as-is:
        --   grn  -> vim.lsp.buf.rename
        --   gra  -> vim.lsp.buf.code_action (n + x)
        --   grr  -> vim.lsp.buf.references
        --   gri  -> vim.lsp.buf.implementation
        --   grt  -> vim.lsp.buf.type_definition  (added in 0.12)
        --   gO   -> vim.lsp.buf.document_symbol
        --   K    -> vim.lsp.buf.hover (when LSP attached)
        --   <C-S> (insert/select) -> vim.lsp.buf.signature_help
        --
        -- Descriptions for these are surfaced via which-key spec.

        -- Convention: grd = definition, grD = declaration
        map('grd', vim.lsp.buf.definition, 'goto definition')
        map('grD', vim.lsp.buf.declaration, 'goto declaration')
        map('gW', vim.lsp.buf.workspace_symbol, 'goto workspace symbols')

        -- Keep <C-k> in normal mode for signature help (insert-mode binding
        -- is the built-in <C-S>).
        map('<C-k>', vim.lsp.buf.signature_help, 'show signature')

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Highlight symbol under cursor
        if client and client:supports_method('textDocument/documentHighlight') then
          local highlight_augroup = vim.api.nvim_create_augroup('ayrock.lsp-highlight', { clear = false })
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
            group = vim.api.nvim_create_augroup('ayrock.lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = 'ayrock.lsp-highlight', buffer = event2.buf })
            end,
          })
        end

        -- Detach from non-file buffers
        if bufname == '' or bufname:match('^diffview://') or bufname:match('^fugitive://') then
          vim.schedule(function()
            if client then
              client:detach(bufnr)
            end
          end)
          return
        end
      end,
    })

    local icons = require('ayrock.icons')

    -- Diagnostic config
    -- See :help vim.diagnostic.Opts
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
          [vim.diagnostic.severity.WARN] = icons.diagnostics.warn,
          [vim.diagnostic.severity.INFO] = icons.diagnostics.info,
          [vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
        },
      },
      virtual_text = false,
      virtual_lines = { current_line = true }, -- 0.11+: only render on the cursor line
      severity_sort = true,
    })

    -- Discover LSP servers by globbing `after/lsp/*.lua` filenames in this
    -- config (only). Drop a file in `after/lsp/` and it's automatically
    -- installed (Mason) + enabled.
    --
    -- Scoped to `stdpath('config')` to avoid pulling in `after/lsp/*.lua`
    -- shipped by other plugins (e.g., mason-lspconfig).
    local servers = {}
    local config_lsp = vim.fn.stdpath('config') .. '/after/lsp'
    for _, path in ipairs(vim.fn.glob(config_lsp .. '/*.lua', true, true)) do
      table.insert(servers, vim.fn.fnamemodify(path, ':t:r'))
    end

    require('mason-tool-installer').setup({ ensure_installed = servers })
    require('mason-lspconfig').setup({
      ensure_installed = servers,
      automatic_enable = false, -- we enable explicitly via vim.lsp.enable below
    })

    -- Enable each LSP server. Configuration for each is loaded from
    -- `after/lsp/<name>.lua` via Neovim's runtime path.
    vim.lsp.enable(servers)
  end,
}
