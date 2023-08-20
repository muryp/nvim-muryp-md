local M = {}
local isRawLink = function()
  local current_word = vim.fn.expand('<cWORD>') ---@type string
  local REGEX_RAW_LINK = "^https?://[%w-_%.%?%.:/%+=&]+"
  local isLinkRaw = string.match(current_word, REGEX_RAW_LINK) ---@type string | nil strin will return raw link select
  if isLinkRaw then
    return { url = isLinkRaw }
  end
  return false
end

local REGEX_MD = "%[(.-)%]%((.-)%)"
local REGEX_WIKI = "%[%[(.-)%]%]"
---get list link md/wiki
---@param CONTENT_LINE string
---@param TYPE 'md'|'wiki'
M.listLinkNum = function(CONTENT_LINE, TYPE)
  local REGEX ---@type string - regex
  if TYPE == 'md' then
    REGEX = REGEX_MD
  else
    REGEX = REGEX_WIKI
  end
  local startCol, endCol = CONTENT_LINE:find(REGEX)
  local LIST_LINK_NUM = {} ---@type {startCol:integer, endCol:integer}[]
  while startCol do
    local tabel = { startCol = startCol, endCol = endCol }
    if tabel ~= nil then
      table.insert(LIST_LINK_NUM, tabel)
    end
    startCol, endCol = CONTENT_LINE:find(REGEX, endCol + 1)
  end
  return LIST_LINK_NUM
end

---@param CONTENT_LINE string
---@param CURRENT_COL number
---@param TYPE 'md'|'wiki
local cekLinkMdWiki = function(CONTENT_LINE, CURRENT_COL, TYPE)
  local LIST_LINK_NUM = M.listLinkNum(CONTENT_LINE, TYPE)
  if next(LIST_LINK_NUM) ~= nil then
    for _, VAL in pairs(LIST_LINK_NUM) do
      if VAL.startCol <= CURRENT_COL and VAL.endCol >= CURRENT_COL then
        local CONTENT_RESULT = CONTENT_LINE:sub(VAL.startCol, VAL.endCol)
        return { CONTENT = CONTENT_RESULT, COL = VAL }
      end
    end
  end
end
local isLinkMdWiki = function()
  local CURRENT_COL = vim.fn.col('.') ---@type number
  local LINE_CONTENT = vim.api.nvim_get_current_line() ---@type string - get text on current line
  local LINK_MD = cekLinkMdWiki(LINE_CONTENT, CURRENT_COL, 'md')
  if LINK_MD then
    local text, url = LINK_MD.CONTENT:match(REGEX_MD)
    return { text = text, url = url, isMdWiki = true, COL = LINK_MD.COL }
  end
  local LINK_WIKI = cekLinkMdWiki(LINE_CONTENT, CURRENT_COL, 'wiki')
  if LINK_WIKI then
    local LINK_TEXT_WIKI = LINK_WIKI.CONTENT:match(REGEX_WIKI)
    return { text = LINK_TEXT_WIKI, url = LINK_TEXT_WIKI, isMdWiki = true, COL = LINK_MD.COL }
  end
  return false
end

M.isLink = function()
  local MD_LINK = isLinkMdWiki()
  if MD_LINK then
    return MD_LINK
  end
  local RAW_LINK = isRawLink()
  if RAW_LINK then
    return RAW_LINK
  end
  return false
end

return M
