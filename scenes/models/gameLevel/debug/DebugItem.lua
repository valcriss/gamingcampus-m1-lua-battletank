local Component = require "models.scenes.Component"
local BitmapText = require "models.texts.BitmapText"

---@class DebugItem
DebugItem = {}

--- @param gameManager GameManager
DebugItem.new = function(name, data)
    local debugItem = Component.new(name, data)

    setmetatable(debugItem, DebugItem)
    DebugItem.__index = DebugItem

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local debug = BitmapText.new(debugItem.name .. "_debugText", "assets/debug/courier-14.fnt", "", "left", "top", 0, 0, nil, nil, 0, 1)
    debugItem.addComponent(debug)

    return debugItem
end

return DebugItem
