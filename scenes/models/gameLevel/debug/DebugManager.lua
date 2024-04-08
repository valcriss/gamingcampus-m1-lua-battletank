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

    return debugManager
end

return DebugManager
