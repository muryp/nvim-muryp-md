local api = vim.api
local M = {}

M.cheklist = function()
  local GET_CURRENT_LINE = api.nvim_get_current_line()
  local new_line
  if string.find(GET_CURRENT_LINE, "^%s*%-[ ]%[[%s|x]%]") then
    new_line = string.gsub(GET_CURRENT_LINE, "%[([%s|x])%]", function(match)
      return match == " " and "[x]" or "[ ]"
    end)
  end
  if new_line then
    api.nvim_set_current_line(new_line)
  end
end

return M
