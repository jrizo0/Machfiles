M = {}
M.on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  -- Create a command `:Format` local to the LSP buffer
  -- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
  --   vim.lsp.buf.format()
  -- end, { desc = 'Format current buffer with LSP' })

  -- Create a command `:LspOrganizeImports` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'LspOrganizeImports', function(_)
    local params = {
      command = '_typescript.organizeImports',
      arguments = { vim.api.nvim_buf_get_name(0) },
      title = '',
    }
    vim.lsp.buf.execute_command(params)
  end, { desc = 'Organize imports for current buffer TS' })

  nmap('gd', require('telescope.builtin').lsp_definitions, 'Goto Definition')
  nmap('gr', require('telescope.builtin').lsp_references, 'Goto References')
  nmap('gi', require('telescope.builtin').lsp_implementations, 'Goto Implementation')
  nmap('go', require('telescope.builtin').lsp_type_definitions, 'Type Definition')
  -- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  nmap('gl', vim.diagnostic.open_float, 'Open Diagnostic Float')

  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('gs', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Workspace Add Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Workspace Remove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, 'Workspace List Folders')

  nmap('<leader>v', '<cmd>vsplit | lua vim.lsp.buf.definition()<cr>', 'Goto Definition in Vertical Split')

  -- JR
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
end

return M
