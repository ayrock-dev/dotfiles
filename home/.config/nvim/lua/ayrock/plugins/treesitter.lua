-- nvim-treesitter `main` branch (rewrite for Neovim 0.12+)
-- See: https://github.com/nvim-treesitter/nvim-treesitter (main branch)
--
-- The new plugin no longer provides `nvim-treesitter.configs`.
-- Highlighting/indent/folding are now opt-in per-filetype using
-- Neovim core APIs (`vim.treesitter.start`, `indentexpr`, `foldexpr`).
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false, -- new plugin does not support lazy-loading
  build = ':TSUpdate',
  config = function()
    local langs = require('ayrock.langs').treesitter_langs

    require('nvim-treesitter').setup({
      install_dir = vim.fn.stdpath('data') .. '/site',
    })

    -- Install parsers (no-op if already installed; runs async)
    require('nvim-treesitter').install(langs)

    -- Register filetype <-> parser mappings where they differ.
    -- The `tsx` parser handles `typescriptreact`; the `markdown` parser
    -- handles `markdown` natively but `markdown_inline` is auto-injected.
    vim.treesitter.language.register('tsx', { 'typescriptreact' })
    vim.treesitter.language.register('bash', { 'sh', 'zsh' })

    local max_filesize = 1000 * 1024 -- 1MB

    -- Enable highlighting + treesitter indent for a buffer/language.
    -- Mirrors the old `highlight.disable` bigfile guard.
    local function ts_attach(buf, lang)
      -- Bigfile guard: skip treesitter on files >1MB
      local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return
      end

      pcall(vim.treesitter.start, buf, lang)

      -- Treesitter-based indentation, but only when the parser ships an
      -- `indents` query; otherwise fall back to Vim's built-in indentexpr.
      if vim.treesitter.query.get(lang, 'indents') ~= nil then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('ayrock.treesitter', { clear = true }),
      callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype
        local lang = vim.treesitter.language.get_lang(ft) or ft

        local ts = require('nvim-treesitter')

        if vim.tbl_contains(ts.get_installed('parsers'), lang) then
          -- Parser already installed: attach immediately.
          ts_attach(buf, lang)
        elseif vim.tbl_contains(ts.get_available(), lang) then
          -- Parser available but not installed: auto-install on first open,
          -- then attach once the install finishes.
          ts.install(lang):await(function()
            ts_attach(buf, lang)
          end)
        else
          -- Parser not managed by nvim-treesitter (may exist externally):
          -- try to attach anyway; guarded by pcall above.
          ts_attach(buf, lang)
        end
      end,
    })
  end,
}
