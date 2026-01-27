return {
  -- nvim-treesitter (plugin principal)
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false, -- No soporta lazy loading
    build = ':TSUpdate',
    config = function()
      local ts = require('nvim-treesitter')
      ts.setup({
        install_dir = vim.fn.stdpath('data') .. '/site',
      })

      -- Instalar parsers
      local parsers = {
        'html', 'javascript', 'json', 'lua', 'luadoc',
        'query', 'regex', 'tsx', 'typescript', 'vue', 'php',
      }
      ts.install(parsers)

      -- Habilitar highlighting e indentacion por FileType
      vim.api.nvim_create_autocmd('FileType', {
        pattern = parsers,
        callback = function()
          vim.treesitter.start()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- nvim-treesitter-textobjects
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter-textobjects').setup({
        select = {
          lookahead = true,
          selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@parameter.inner'] = 'v',
            ['@function.outer'] = 'v',
            ['@conditional.outer'] = 'V',
            ['@loop.outer'] = 'V',
            ['@class.outer'] = '<c-v>',
          },
          include_surrounding_whitespace = false,
        },
        move = {
          set_jumps = true,
        },
      })

      local select = require('nvim-treesitter-textobjects.select')
      local move = require('nvim-treesitter-textobjects.move')
      local swap = require('nvim-treesitter-textobjects.swap')

      -- Selection keymaps (visual + operator-pending)
      local select_maps = {
        ['af'] = { '@function.outer', 'around a function' },
        ['if'] = { '@function.inner', 'inner part of a function' },
        ['ac'] = { '@class.outer', 'around a class' },
        ['ic'] = { '@class.inner', 'inner part of a class' },
        ['ai'] = { '@conditional.outer', 'around an if statement' },
        ['ii'] = { '@conditional.inner', 'inner part of an if statement' },
        ['al'] = { '@loop.outer', 'around a loop' },
        ['il'] = { '@loop.inner', 'inner part of a loop' },
        ['ap'] = { '@parameter.outer', 'around parameter' },
        ['ip'] = { '@parameter.inner', 'inside a parameter' },
      }

      for key, data in pairs(select_maps) do
        vim.keymap.set({ 'x', 'o' }, key, function()
          select.select_textobject(data[1], 'textobjects')
        end, { desc = data[2] })
      end

      -- Movement keymaps
      vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
        move.goto_previous_start('@function.outer', 'textobjects')
      end, { desc = 'Previous function' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
        move.goto_next_start('@function.outer', 'textobjects')
      end, { desc = 'Next function' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[c', function()
        move.goto_previous_start('@class.outer', 'textobjects')
      end, { desc = 'Previous class' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']c', function()
        move.goto_next_start('@class.outer', 'textobjects')
      end, { desc = 'Next class' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[p', function()
        move.goto_previous_start('@parameter.inner', 'textobjects')
      end, { desc = 'Previous parameter' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']p', function()
        move.goto_next_start('@parameter.inner', 'textobjects')
      end, { desc = 'Next parameter' })

      -- Swap keymaps
      vim.keymap.set('n', '<leader>a', function()
        swap.swap_next('@parameter.inner')
      end, { desc = 'Swap with next parameter' })

      vim.keymap.set('n', '<leader>A', function()
        swap.swap_previous('@parameter.inner')
      end, { desc = 'Swap with previous parameter' })

      -- Incremental selection
      vim.keymap.set('n', '<leader>vv', function()
        require('nvim-treesitter.incremental_selection').init_selection()
      end, { desc = 'Init selection' })

      vim.keymap.set('x', '+', function()
        require('nvim-treesitter.incremental_selection').node_incremental()
      end, { desc = 'Increment selection' })

      vim.keymap.set('x', '_', function()
        require('nvim-treesitter.incremental_selection').node_decremental()
      end, { desc = 'Decrement selection' })
    end,
  },
}
