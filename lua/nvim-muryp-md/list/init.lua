local api = vim.api
local M = {}
local isCeklist = function(line)
  return string.find(line, "^%s*%-[ ]%[[%s|x]%]")
end
M.cheklist = function()
  local GET_CURRENT_LINE = api.nvim_get_current_line()
  local new_line
  if isCeklist(GET_CURRENT_LINE) then
    new_line = string.gsub(GET_CURRENT_LINE, "%[([%s|x])%]", function(match)
      return match == " " and "[x]" or "[ ]"
    end)
  end
  if new_line then
    api.nvim_set_current_line(new_line)
  end
end

local function is_list_item(line)
  return string.match(line, "^%s*[%-%*%+]?%s*[0-9]*%.?%s+.*$")
end

M.next_bullet = function()
  local line = vim.api.nvim_get_current_line()
  local ceckbox = ''
  if is_list_item(line) then
    -- local indent = string.match(line, "^%s*")
    local bullet = string.match(line, "^%s*([%-%*%+]?%s*[0-9]*%.?)%s+.*$")
    local next_bullet = bullet:gsub("%d*", function(num)
      return tonumber(num) and tostring(tonumber(num) + 1) or ""
    end)
    if isCeklist(line) then
      ceckbox = ' [ ]'
    end
    vim.api.nvim_feedkeys('\n' .. next_bullet .. ceckbox .. " ", "n", true)
  else
    vim.api.nvim_feedkeys("\n", "n", true)
  end
end


return M
