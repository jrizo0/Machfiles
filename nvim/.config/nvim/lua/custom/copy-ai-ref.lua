local M = {}

function M.copy_ai_ref()
  -- Get the project root (git root or cwd)
  local git_root = vim.fn.finddir('.git', '.;')
  local project_root
  if git_root == '' then
    project_root = vim.fn.getcwd()
  else
    project_root = vim.fn.fnamemodify(git_root, ':h')
  end

  -- Get the full file path
  local file_path = vim.fn.expand('%:p')

  -- Get relative path from project root
  local rel_path = vim.fn.fnamemodify(file_path, ':s?' .. project_root .. '/??')

  -- Get line numbers based on mode
  local mode = vim.fn.mode()
  local ref
  if mode == 'n' then
    local line = vim.fn.line('.')
    ref = rel_path .. ':L' .. line
  elseif mode == 'v' or mode == 'V' or mode == '\22' then -- visual modes
    local start_line = vim.fn.line('v')
    local end_line = vim.fn.line('.')
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    ref = rel_path .. ':L' .. start_line .. '-' .. end_line
  else
    vim.notify('Unsupported mode for copy AI ref', vim.log.levels.WARN)
    return
  end

  -- Copy to system clipboard
  vim.fn.setreg('+', ref)
  vim.notify('Copied: ' .. ref, vim.log.levels.INFO)
end

return M