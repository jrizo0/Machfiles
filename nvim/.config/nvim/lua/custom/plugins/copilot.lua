-- return {}
return {
  {
    'zbirenbaum/copilot.lua',
    enabled = false,
    config = function()
      local ok, copilot = pcall(require, "copilot")
      if not ok then
        return
      end

      copilot.setup {
        panel = {
          keymap = {
            jump_next = "<c-j>",
            jump_prev = "<c-k>",
            accept = "<c-l>",
            refresh = "r",
            open = "<S-CR>",
          },
          layout = {
            position = "bottom", -- | top | left | right
            ratio = 0.4
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<c-l>",
            next = "<c-j>",
            prev = "<c-k>",
            dismiss = "<c-h>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = true,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
      }
      local opts = { noremap = true, silent = false }
      vim.api.nvim_set_keymap("n", "<c-s>", "<cmd>lua require('copilot.suggestion').toggle_auto_trigger()<CR>", opts)
      -- vim.api.nvim_set_keymap("n", "<c-i>", "<cmd>Copilot panel<CR>", opts)
    end
  },
}
