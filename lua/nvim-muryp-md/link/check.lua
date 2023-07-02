local function get_column_of_first_opening_bracket()
  local line_content = vim.api.nvim_get_current_line()
  local current_cursor = vim.fn.col('.') ---@type number
  while current_cursor > 0 do
    local char = line_content:sub(current_cursor, current_cursor)
    if char == '[' then
      return current_cursor
    end
    current_cursor = current_cursor - 1
  end
  return false
end
local function get_column_of_last_closing_parenthesis()
  local line_content = vim.api.nvim_get_current_line()
  local current_cursor = vim.fn.col('.')
  local line_length = #line_content
  while current_cursor <= line_length do
    local char = line_content:sub(current_cursor, current_cursor)
    if char == ')' then
      return current_cursor
    end
    current_cursor = current_cursor + 1
  end
  return false
end

local function cek()
  local current_line = vim.api.nvim_get_current_line()
  local current_col = vim.fn.col('.')
  local TEXT_UNDER_CURSOR = current_line:sub(current_col, current_col)
  -- Ambil teks saat ini dari posisi awal kata hingga kursor
  local current_word = vim.fn.expand('<cWORD>')
  -- Cek apakah teks di bawah kursor adalah tautan
  local REGEX_RAW_LINK = "^https?://[%w-_%.%?%.:/%+=&]+"
  if string.match(current_word, REGEX_RAW_LINK) and not string.match(TEXT_UNDER_CURSOR, "^[%s\t]") then
    return true
  end
  local isHaveBraket = get_column_of_first_opening_bracket()
  local isHaveparenthesis = get_column_of_last_closing_parenthesis()
  local GET_LINK = ''
  if isHaveBraket and isHaveparenthesis then
    GET_LINK = current_line:sub(isHaveBraket, isHaveparenthesis)
  end
  local REGEX_LINK_MD = "%[[^%]]+%]%([^%)]+%)"
  local isMatch = string.match(GET_LINK, REGEX_LINK_MD)
  if isMatch then
    return true
  end
  return false
end

return cek
