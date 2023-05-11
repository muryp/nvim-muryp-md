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
local function isListEmpty(line)
  local delete_point = string.gsub(line, "^%s*[-*+]%s+", '', 1)
  local delete_checkbox = string.gsub(delete_point, "^%[.%] ", '', 1)
  local delete_number = string.gsub(delete_checkbox, "^%s*%d+%.%s+", '', 2)
  if delete_number == '' then
    return true
  end
  return false
end

local function cekLevel()
  -- mengambil pengaturan shiftwidth dan tabstop pada buffer saat ini
  local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
  -- local tabstop = vim.api.nvim_buf_get_option(0, "tabstop")
  -- menghitung jumlah spasi pada indentasi
  local indent_spaces = vim.fn.indent(".")
  -- memeriksa apakah expandtab diaktifkan
  local expandtab = vim.bo.expandtab
  -- mengatur jumlah spasi yang digunakan
  local spaces = expandtab and shiftwidth or 1
  -- menghitung level indentasi
  local level = math.floor(indent_spaces / spaces)
  return level
end

M.next_bullet = function()
  local line = vim.api.nvim_get_current_line()
  local ceckbox = ''
  if is_list_item(line) then
    local bullet = string.match(line, "^%s*([%-%*%+]?%s*[0-9]*%.?)%s+.*$")
    if isCeklist(line) then
      ceckbox = ' [ ]'
    end
    if isListEmpty(line) then
      if cekLevel() == 0 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>A<C-u>", true, false, true), "n", true)
        return
      end
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc><<a", true, false, true), "n", true)
      return
    end
    --- cek is have colon
    if string.match(line, '^.*:') then
      local backTofirstBullet = bullet:gsub("%d*", function(num)
        return tonumber(num) and tostring(1) or ""
      end)
      vim.api.nvim_feedkeys('\n' .. backTofirstBullet .. ceckbox .. " ", "n", true)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>>>A", true, false, true), "n", true)
      return
    end
    local next_bullet = bullet:gsub("%d*", function(num)
      return tonumber(num) and tostring(tonumber(num) + 1) or ""
    end)
    --- create emty list/point
    return vim.api.nvim_feedkeys('\n' .. next_bullet .. ceckbox .. " ", "n", true)
  end
  return vim.api.nvim_feedkeys("\n", "n", true)
end


return M
