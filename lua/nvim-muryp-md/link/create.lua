local checkLink = require('nvim-muryp-md.link.check')
local function createLink()
  local getLink = checkLink()
  if not getLink then
    return
  end
  if not getLink.isLInkMd then
    local WORD = getLink.text
    local LINK = '[' .. WORD .. '](' .. WORD .. ')'
    vim.cmd('normal! ciW' .. LINK)
  end
end
return createLink
