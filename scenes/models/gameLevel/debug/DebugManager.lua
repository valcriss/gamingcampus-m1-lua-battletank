local Component     = require "models.scenes.Component"
local ViewPortDebug = require "scenes.models.gameLevel.debug.ViewPortDebug"
local GameMapDebug  = require "scenes.models.gameLevel.debug.GameMapDebug"
local FpsDebug      = require "scenes.models.gameLevel.debug.FpsDebug"

---@class DebugManager
DebugManager        = {}

--- @param gameManager GameManager
DebugManager.new    = function(gameManager)
    local debugManager = Component.new("DebugManager")

    setmetatable(debugManager, DebugManager)
    DebugManager.__index = DebugManager

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local viewPortDebug  = ViewPortDebug.new(gameManager)
    local gameMapDebug   = GameMapDebug.new(gameManager)
    local fpsDebug       = FpsDebug.new()

    debugManager.addComponent(viewPortDebug)
    debugManager.addComponent(gameMapDebug)
    debugManager.addComponent(fpsDebug)

    function debugManager.update(dt)
        viewPortDebug.updateBounds(dt)
        gameMapDebug.updateBounds(dt)
        fpsDebug.updateBounds(dt)
        local x       = 10
        local y       = 10
        local padding = 10
        viewPortDebug.setPosition(x, y)
        y = y + padding + viewPortDebug.bounds.height
        gameMapDebug.setPosition(x, y)
        y = y + padding + gameMapDebug.bounds.height
        fpsDebug.setPosition(x, y)
    end

    return debugManager
end

return DebugManager
