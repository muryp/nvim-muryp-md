---merge table into one
---@param table table[] - exam = {table1,table2,table3}
return function(table)
  local mergedTable = {}
  for i = 1, #table do
    if table[i] == nil then
      return false
    end
    for j = 1, #table[i] do
      mergedTable[#mergedTable + 1] = table[i][j]
    end
  end
  return mergedTable
end
