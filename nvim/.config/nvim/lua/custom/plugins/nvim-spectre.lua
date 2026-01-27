-- search/replace in multiple files
return {
  "nvim-pack/nvim-spectre",
  -- stylua: ignore
  keys = { -- in whichkey
    { "<leader>sar", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
  },
}
