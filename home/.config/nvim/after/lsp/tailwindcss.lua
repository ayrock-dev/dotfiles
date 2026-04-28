---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'tailwindcss-language-server'
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)
  end,
  filetypes = {
    -- html
    'aspnetcorerazor', 'astro', 'astro-markdown', 'blade', 'clojure',
    'django-html', 'htmldjango', 'edge', 'eelixir', 'elixir', 'ejs',
    'erb', 'eruby', 'gohtml', 'gohtmltmpl', 'haml', 'handlebars', 'hbs',
    'html', 'htmlangular', 'html-eex', 'heex', 'jade', 'leaf', 'liquid',
    'markdown', 'mdx', 'mustache', 'njk', 'nunjucks', 'php', 'razor',
    'slim', 'twig',
    -- css
    'css', 'less', 'postcss', 'sass', 'scss', 'stylus', 'sugarss',
    -- js
    'javascript', 'javascriptreact', 'reason', 'rescript',
    'typescript', 'typescriptreact',
    -- mixed
    'vue', 'svelte', 'templ',
  },
  workspace_required = true,
  root_markers = {
    'tailwind.config.js',
    'tailwind.config.cjs',
    'tailwind.config.mjs',
    'tailwind.config.ts',
    'postcss.config.js',
    'postcss.config.cjs',
    'postcss.config.mjs',
    'postcss.config.ts',
    -- Tailwind v4 doesn't require a config file; fall back to .git
    '.git',
  },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
  settings = {
    tailwindCSS = {
      validate = true,
      lint = {
        cssConflict = 'warning',
        invalidApply = 'error',
        invalidScreen = 'error',
        invalidVariant = 'error',
        invalidConfigPath = 'error',
        invalidTailwindDirective = 'error',
        recommendedVariantOrder = 'warning',
      },
      classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass' },
      includeLanguages = {
        eelixir = 'html-eex',
        elixir = 'phoenix-heex',
        eruby = 'erb',
        heex = 'phoenix-heex',
        htmlangular = 'html',
        templ = 'html',
      },
    },
  },
  before_init = function(_, config)
    config.settings = vim.tbl_deep_extend('keep', config.settings or {}, {
      editor = { tabSize = vim.lsp.util.get_effective_tabstop() },
    })
  end,
}
