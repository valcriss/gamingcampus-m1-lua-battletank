local json = require "libs/json"
---@class JsonAsset
JsonAsset  = {}

function JsonAsset:load(path)
    contents, size = love.filesystem.read(path)
    return json.decode(contents)
end

return JsonAsset
