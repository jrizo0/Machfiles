return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      local lspconfig_defaults = require('lspconfig').util.default_config
      lspconfig_defaults.capabilities = vim.tbl_deep_extend('force', lspconfig_defaults.capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- mason-lspconfig v2 habilita servidores vía vim.lsp.enable(), que NO lee
      -- lspconfig_defaults: los overrides por servidor van con vim.lsp.config().
      vim.lsp.config('*', {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })

      -- FIX congelamiento: nvim-lspconfig fuerza dynamicRegistration=true para
      -- tailwindcss, que registra file-watchers sobre todo el workspace. Sin
      -- inotifywait instalado, Neovim los implementa crawleando el árbol completo
      -- (node_modules, .git, .repos...) en Lua en el hilo principal -> el editor
      -- queda congelado ~1-2 min al abrir cualquier buffer al que tailwind se
      -- adjunta (incluye markdown). Apagarlo: tailwind pierde solo la
      -- auto-detección de cambios en tailwind.config (reiniciable con :LspRestart).
      vim.lsp.config('tailwindcss', {
        capabilities = {
          workspace = { didChangeWatchedFiles = { dynamicRegistration = false } },
        },
      })

      -- Config de vtsls migrada aquí: el bloque `handlers` de mason-lspconfig v2
      -- ya no existe, así que lo que había ahí se ignoraba silenciosamente.
      vim.lsp.config('vtsls', {
        root_markers = { 'pnpm-workspace.yaml', 'pnpm-lock.yaml', 'yarn.lock', 'package-lock.json', 'bun.lockb', '.git' },
        settings = {
          typescript = {
            tsserver = { maxTsServerMemory = 1024 },
          },
          vtsls = {
            experimental = {
              completion = { entriesLimit = 3 },
            },
          },
        },
      })
      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
          local opts = { buffer = event.buf }

          vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
          vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
          vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
          vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
          vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
          vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
          vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
          vim.keymap.set('n', '<leader>vd', '<cmd>lua vim.diagnostic.open_float()<cr>', { desc = 'View Diagnostics' })
          vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
          vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
          vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        end,
      })

      require('mason').setup()
      require('mason-lspconfig').setup {
        ensure_installed = {
          'astro',
          'cssls',
          'vtsls',
          'cssmodules_ls',
          -- 'gopls',
          'lua_ls',
        },
        -- NOTE: `handlers` fue eliminado en mason-lspconfig v2; los servidores se
        -- habilitan solos (automatic_enable) y se configuran con vim.lsp.config()
        -- arriba.
      }

      vim.api.nvim_create_user_command('LspToggle', function()
        local clients = vim.lsp.get_active_clients { bufnr = 0 }
        if #clients > 0 then
          vim.cmd 'LspStop'
          print 'LSP desactivado'
        else
          vim.cmd 'LspStart'
          print 'LSP activado'
        end
      end, { desc = 'Toggle LSP on/off' })
    end,
  },
  -- NOTE: nvim-cmp is configured in cmp.lua (lazy on InsertEnter). The duplicate
  -- spec that used to live here was overriding cmp.lua's full config and forcing an
  -- eager load — removed. Edit cmp.lua for completion settings.
}
