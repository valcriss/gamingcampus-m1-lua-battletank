local Component          = require "models.scenes.Component"
local ViewPortDebug      = require "scenes.models.gameLevel.debug.ViewPortDebug"
local GameMapDebug       = require "scenes.models.gameLevel.debug.GameMapDebug"
local FpsDebug           = require "scenes.models.gameLevel.debug.FpsDebug"
local GameMapTilesDebug  = require "scenes.models.gameLevel.debug.GameMapTilesDebug"
local UnitsColliderDebug = require "scenes.models.gameLevel.debug.UnitsColliderDebug"
local PathFindingDebug   = require "scenes.models.gameLevel.debug.PathFindingDebug"

---@class DebugManager
DebugManager             = {}

--- @param gameManager GameManager
DebugManager.new         = function(gameManager)
    local debugManager = Component.new("DebugManager")

    setmetatable(debugManager, DebugManager)
    DebugManager.__index     = DebugManager

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local viewPortDebug      = ViewPortDebug.new(gameManager)
    local gameMapDebug       = GameMapDebug.new(gameManager)
    local fpsDebug           = FpsDebug.new()
    local gameMapTilesDebug  = GameMapTilesDebug.new(gameManager)
    local unitsColliderDebug = UnitsColliderDebug.new(gameManager)
    local pathFindingDebug   = PathFindingDebug.new(gameManager)

    debugManager.addComponent(gameMapTilesDebug)
    debugManager.addComponent(viewPortDebug)
    debugManager.addComponent(gameMapDebug)
    debugManager.addComponent(unitsColliderDebug)
    debugManager.addComponent(fpsDebug)
    debugManager.addComponent(pathFindingDebug)

    function debugManager.update(dt)
        local x       = 10
        local y       = 60
        local padding = 10

        viewPortDebug.updateBounds(dt)
        gameMapDebug.updateBounds(dt)
        fpsDebug.updateBounds(dt)
        viewPortDebug.setPosition(x, y)
        gameMapDebug.setPosition(x, y + viewPortDebug.bounds.height + padding)
        fpsDebug.setPosition(x, y + viewPortDebug.bounds.height + padding + gameMapDebug.bounds.height + padding)
    end

    return debugManager
end

return DebugManager
