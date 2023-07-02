local checkLink = require('nvim-muryp-md.link.check')
local function createLink()
  local isLink = checkLink()
  if type(isLink) == 'string' then
    local LINK = '['..isLink..']('..isLink..')'
    vim.cmd('normal! ciW'..LINK)
  end
end
return createLink
