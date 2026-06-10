-- Plugin to highlight all instances of the word under the cursor
return {
  "RRethy/vim-illuminate",
  event = { 'BufReadPost', 'BufNewFile' },
  -- enabled = false,
}
