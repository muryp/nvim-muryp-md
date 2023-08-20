local checkLink = require('nvim-muryp-md.link.check')
local mergeTable = require('nvim-muryp-md.helper.mergeTable')
local configs = require('nvim-muryp-md').configs

local function replace_line(TEXT)
  local line_num = vim.fn.line('.')
  local toLink = configs.link.replaceTexttoLink(TEXT)
  vim.api.nvim_buf_set_text(0, line_num - 1, TEXT.startCol - 1, line_num - 1, TEXT.endCol, { toLink })
end

---@param LINE_CONTENT string
---@param startCol number
---@param endCol number
---@return boolean
local cekNotConflictWithMdWiki = function(startCol, endCol, LINE_CONTENT)
  local LIST_MD_LINK = checkLink.listLinkNum(LINE_CONTENT, 'md')
  local LIST_WIKI_LINK = checkLink.listLinkNum(LINE_CONTENT, 'wiki')
  local TABLE_MD_WIKI = mergeTable({ LIST_MD_LINK, LIST_WIKI_LINK }) ---@type {startCol:integer, endCol:integer}[]|false
  if TABLE_MD_WIKI == false then
    return false
  end
  for _, value in pairs(TABLE_MD_WIKI) do
    if value.endCol >= startCol then
      return true
    end
    if value.startCol <= endCol then
      return true
    end
  end
  return false
end

local getText = function()
  local LINE_CONTENT = vim.api.nvim_get_current_line() ---@type string
  local CURRENT_COL = vim.fn.col('.') ---@type number
  if #LINE_CONTENT == 0 then
    return
  end
  local startCol ---@type number
  while CURRENT_COL > 0 do
    local PREV_COL = CURRENT_COL - 1
    local char = LINE_CONTENT:sub(PREV_COL, PREV_COL)
    startCol = CURRENT_COL
    if char == ' ' then
      break
    end
    CURRENT_COL = PREV_COL
  end
  CURRENT_COL = vim.fn.col('.')
  local endCol ---@type number
  while CURRENT_COL <= #LINE_CONTENT do
    local NEXT_COL = CURRENT_COL + 1
    local char = LINE_CONTENT:sub(NEXT_COL, NEXT_COL)
    endCol = CURRENT_COL
    if char == ' ' then
      break
    end
    CURRENT_COL = NEXT_COL
  end
  local isConflict = cekNotConflictWithMdWiki(startCol, endCol, LINE_CONTENT)
  if isConflict == true then
    return
  end
  local val = LINE_CONTENT:sub(startCol, endCol)
  return { startCol = startCol, endCol = endCol, val = val }
end

local function createLink()
  local CHEK_LINK = checkLink.isLink()
  if CHEK_LINK then
    return
  end
  local TEXT = getText()
  if TEXT then
    replace_line(TEXT)
  end
end
return createLink
