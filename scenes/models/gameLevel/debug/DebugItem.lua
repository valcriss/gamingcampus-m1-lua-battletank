local Component  = require "models.scenes.Component"
local BitmapText = require "models.texts.BitmapText"

---@class DebugItem
DebugItem        = {}

--- @param name string
--- @param color Tables
--- @param data Tables
DebugItem.new    = function(name, color, data)
    data            = data or {}
    color           = color or { r = 0, g = 0, b = 0, a = 0.75 }
    local debugItem = Component.new(name, 0, 0)

    setmetatable(debugItem, DebugItem)
    DebugItem.__index = DebugItem

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local padding     = 10

    -- ---------------------------------------------
    -- Components
    -- ---------------------------------------------
    local debug       = BitmapText.new(debugItem.name .. "_debugText", "assets/debug/courier-12.fnt", "Not enough data", "left", "top", 0, 0, nil, nil, 0, 1)
    debugItem.addComponent(debug)

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    ---@public
    function debugItem.updateBounds(dt)
        debugItem.innerUpdate(dt)
        debug.setPosition(debugItem.bounds.x + padding, debugItem.bounds.y + padding)
        debugItem.setSize(math.max(300, debug.getWidth() + (padding * 2)), debug.getHeight() + (padding * 2))
    end

    ---@protected
    function debugItem.innerUpdate(_)

    end

    ---@public
    function debugItem.setText(text)
        debug.setContent(text)
    end

    ---@public
    function debugItem.draw()
        love.graphics.setColor(color.r, color.g, color.b, color.a)
        love.graphics.rectangle("fill", screenManager:ScaleValueX(debugItem.bounds.x), screenManager:ScaleValueY(debugItem.bounds.y), screenManager:ScaleValueX(debugItem.bounds.width), screenManager:ScaleValueY(debugItem.bounds.height))
        love.graphics.setColor(1, 1, 1, 1)
    end

    return debugItem
end

return DebugItem
