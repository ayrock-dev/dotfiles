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

    -- Enable highlighting + treesitter indent for any filetype whose
    -- resolved parser is in our installed set. Mirrors the old
    -- `highlight.disable` bigfile guard.
    local installed = {}
    for _, l in ipairs(langs) do
      installed[l] = true
    end

    local max_filesize = 1000 * 1024 -- 1MB

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('ayrock.treesitter', { clear = true }),
      callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype
        local lang = vim.treesitter.language.get_lang(ft) or ft
        if not installed[lang] then
          return
        end

        -- Bigfile guard: skip treesitter on files >1MB
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return
        end

        pcall(vim.treesitter.start, buf, lang)

        -- Treesitter-based indentation (experimental in main branch)
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
