--- Utility functions.
-- @module utility

local M = {}

--- Split a string by delimiter.
-- @tparam string str The string to be split
-- @tparam string delim The delimeter to split on
-- @tparam number maxNb Maximum parts to return
-- @treturn {string,...} Table of parts
function M.split(str, delim, maxNb)
   -- Eliminate bad cases...
   if string.find(str, delim) == nil then
      return { str }
   end
   if maxNb == nil or maxNb < 1 then
      maxNb = 0    -- No limit
   end
   local result = {}
   local pat = "(.-)" .. delim .. "()"
   local nb = 0
   local lastPos
   for part, pos in string.gmatch(str, pat) do
      nb = nb + 1
      result[nb] = part
      lastPos = pos
      if nb == maxNb then
         break
      end
   end
   -- Handle the last field
   if nb ~= maxNb then
      result[nb + 1] = string.sub(str, lastPos)
   end
   return result
end

--- Convert a 0-255 colour value to 0-1
-- @tparam number rgbValue A number value in the range 0-255
-- @treturn number The converted value between 0 and 1
function M.convertColour(rgbValue)
    return rgbValue / 255
end

--- Convert a list of 0-255 colours to 0-1
-- @tparam table rgbValues A list of numbers in the range 0-255
-- @treturn table List of converted values
function M.convertColours(rgbValues)
    local convertedValues = {}
    for i, k in ipairs(rgbValues) do
        table.insert(convertedValues, M.convertColour(k))
    end
    
    return convertedValues
end

return M
