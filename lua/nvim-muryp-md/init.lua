local LINK_DEFAULT_CONFIGS = require('nvim-muryp-md.link.configs')
local M = {}

M.configs = {
  link = LINK_DEFAULT_CONFIGS
}
M.setup = function(arg)
  -- if arg.mapping ~= nil then
  --   if arg.mapping.git ~= nil then
  --     Setup.mapping.git = arg.mapping.git
  --   end
  --   if arg.mapping.issue ~= nil then
  --     Setup.mapping.issue = arg.mapping.issue
  --   end
  -- end
  -- if arg.SSH_PATH ~= nil then
  --   Setup.SSH_PATH = arg.SSH_PATH
  -- end
  -- if arg.CACHE_DIR ~= nil then
  --   Setup.CACHE_DIR = arg.CACHE_DIR
  -- end
  -- if arg.DEFAULT_REMOTE ~= nil then
  --   Setup.DEFAULT_REMOTE = arg.DEFAULT_REMOTE
  -- end
  -- Setup.mapping()
end

return M
