local isRawLink = function()
  local current_word = vim.fn.expand('<cWORD>') ---@type string
  local REGEX_RAW_LINK = "^https?://[%w-_%.%?%.:/%+=&]+"
  local isLinkRaw = string.match(current_word, REGEX_RAW_LINK) ---@type string | nil strin will return raw link select
  if isLinkRaw then
    return { url = isLinkRaw }
  end
  return false
end

---@param CONTENT_LINE string
---@param CURRENT_COL number
---@param REGEX string
local cekLinkMdWiki = function(CONTENT_LINE, CURRENT_COL, REGEX)
  local startCol, endCol = CONTENT_LINE:find(REGEX)
  local LIST_LINK_NUM = {} ---@type {startCol:integer, endCol:integer}[]
  while startCol do
    local tabel = { startCol = startCol, endCol = endCol }
    if tabel ~= nil then
      table.insert(LIST_LINK_NUM, tabel)
    end
    startCol, endCol = CONTENT_LINE:find(REGEX, endCol + 1)
  end
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
  local REGEX_MD = "%[(.-)%]%((.-)%)"
  local LINK_MD = cekLinkMdWiki(LINE_CONTENT, CURRENT_COL, REGEX_MD)
  if LINK_MD then
    local text, url = LINK_MD.CONTENT:match(REGEX_MD)
    return { text = text, url = url, isMdWiki = true, COL = LINK_MD.COL }
  end
  local REGEX_WIKI = "%[%[(.-)%]%]"
  local LINK_WIKI = cekLinkMdWiki(LINE_CONTENT, CURRENT_COL, REGEX_WIKI)
  if LINK_WIKI then
    local LINK_TEXT_WIKI = LINK_WIKI:match("%[%[(.-)%]%]")
    return { text = LINK_TEXT_WIKI, url = LINK_TEXT_WIKI, isMdWiki = true, COL = LINK_MD.COL }
  end
  return false
end

local isLink = function()
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

return isLink
