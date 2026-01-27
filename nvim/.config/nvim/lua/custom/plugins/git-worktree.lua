return {
  'ThePrimeagen/git-worktree.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  keys = { -- in whichkey
    { "<leader>gw", function() require("telescope").extensions.git_worktree.git_worktrees() end,       desc = "[G]it [W]orktree switch" },
    { "<leader>gW", function() require("telescope").extensions.git_worktree.create_git_worktree() end, desc = "[G]it [W]orktree create" },
  },
  config = function(_, opts)
    require('git-worktree').setup()
    pcall(require('telescope').load_extension, 'git_worktree')
  end,
}
