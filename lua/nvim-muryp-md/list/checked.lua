local isCeklist = function(line)
  return string.find(line, "^%s*%-[ ]%[[%s|x]%]")
end
return function(GET_CURRENT_LINE)
  if isCeklist(GET_CURRENT_LINE) then
    return string.gsub(GET_CURRENT_LINE, "%[([%s|x])%]", function(match)
      return match == " " and "[x]" or "[ ]"
    end)
  end
end
