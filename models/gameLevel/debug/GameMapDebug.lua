local DebugItem  = require "models.gameLevel.debug.DebugItem"

---@class GameMapDebug
GameMapDebug     = {}

--- @param gameManager GameManager
GameMapDebug.new = function(gameManager)
    local gameMapDebug = DebugItem.new("GameMapDebug")

    setmetatable(gameMapDebug, GameMapDebug)
    GameMapDebug.__index = GameMapDebug

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    ---@protected
    function gameMapDebug.innerUpdate(_)
        gameMapDebug.setText(
                "GameMap.Layer0 cells to draw : " .. gameManager.getGameMap().getTilesToRenderLayout0() .. "\n" ..
                        "GameMap.Layer1 cells to draw : " .. gameManager.getGameMap().getTilesToRenderLayout1()
        )
    end

    return gameMapDebug
end

return GameMapDebug
