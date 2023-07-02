local checkLink = require('nvim-muryp-md.link.check')
local function replace_text_in_columns(FROM, INTO, NEW_TEXT)
  local buffer = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buffer, 4, 9, false)

  for i, line in ipairs(lines) do
    local text_before = line:sub(1, FROM - 1)
    local text_after = line:sub(INTO + 1)


    local replaced_line = text_before .. NEW_TEXT .. text_after
    lines[i] = replaced_line
  end

  vim.api.nvim_buf_set_lines(buffer, 4, 9, false, lines)
end

local function unLink()
  local getLink = checkLink()
  if not getLink then
    return
  end
  if getLink.isLInkMd then
    local LINK_MD = getLink.text ---@type string
    local FROM = getLink.from
    local INTO = getLink.into
    local markdown_text_pattern = "%[(.-)%]%([^%)]+%)"
    local TEXT = string.match(LINK_MD, markdown_text_pattern)
    replace_text_in_columns(FROM, INTO, TEXT)
  end
end

return unLink
