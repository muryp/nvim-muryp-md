local DEFAULT_CONFIGS = {
  rootFolder = { '/home' },
  openCmd = 'xdg-open',
  ---@param TEXT string
  replaceTexttoLink = function(TEXT)
    return '[' .. TEXT .. '](' .. TEXT .. ')'
  end,
  maps = {
    enter = {
      ['<CR>'] = { 'cmd', 'create link or open link' },
      ['<leader><CR>'] = { 'cmd', 'undo link' },
    }
  }
}

return DEFAULT_CONFIGS