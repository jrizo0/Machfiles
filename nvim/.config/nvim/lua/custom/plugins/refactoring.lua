return {
  'ThePrimeagen/refactoring.nvim',
  cmd = 'Refactor',
  keys = {
    { '<leader>re', mode = { 'n', 'x' }, function() require('refactoring').select_refactor() end, desc = 'Refactor' },
  },
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-treesitter/nvim-treesitter' },
  },
  config = function()
    require('refactoring').setup {}
  end,
}
