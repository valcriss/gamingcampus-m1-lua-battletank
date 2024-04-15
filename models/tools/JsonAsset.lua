local json = require "libs/json"
---@class JsonAsset
JsonAsset  = {}

---@public
---@param path string
---@return table
function JsonAsset:load(path)
    contents, size = love.filesystem.read(path)
    return json.decode(contents)
end

return JsonAsset
