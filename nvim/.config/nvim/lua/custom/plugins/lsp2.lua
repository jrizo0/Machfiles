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
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup {}
          end,
          ['vtsls'] = function()
            require('lspconfig').vtsls.setup {
              root_dir = require('lspconfig').util.root_pattern('.git', 'pnpm-workspace.yaml', 'pnpm-lock.yaml', 'yarn.lock', 'package-lock.json', 'bun.lockb'),
              typescript = {
                tsserver = {
                  maxTsServerMemory = 1024,
                },
              },
              experimental = {
                completion = {
                  entriesLimit = 3,
                },
              },
            }
          end,
        },
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
