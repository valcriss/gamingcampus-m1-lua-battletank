local Component     = require "models.scenes.Component"
local BitmapText  = require "models.texts.BitmapText"

---@class GameMapDebug
GameMapDebug        = {}

--- @param gameManager GameManager
GameMapDebug.new    = function(gameManager)
    local gameMapDebug = Component.new("GameMapDebug")

    setmetatable(gameMapDebug, GameMapDebug)
    GameMapDebug.__index = GameMapDebug

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local debug           = BitmapText.new("GameMapDebug_Debug", "assets/debug/courier-14.fnt", "", "left", "top", 20, 110, nil, nil, 0, 1)
    gameMapDebug.addComponent(debug)

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------
    ---@public
    function gameMapDebug.update(_)
        debug.setContent(
                "GameMap.Layer0 cells to draw : " .. gameManager.getGameMap().getTilesToRenderLayout0() .. "\n" ..
                "GameMap.Layer1 cells to draw : " .. gameManager.getGameMap().getTilesToRenderLayout1()
        )
    end

    ---@public
    function gameMapDebug.draw()
        love.graphics.setColor(1, 1, 0, 0.5)
        love.graphics.rectangle("fill", screenManager:ScaleValueX(10), screenManager:ScaleValueY(100), screenManager:ScaleValueX(420), screenManager:ScaleValueY(50))
        love.graphics.setColor(1, 1, 0, 1)
        love.graphics.circle("fill", screenManager:ScaleValueX(screenManager:calculateCenterPointX()), screenManager:ScaleValueY(screenManager:calculateCenterPointY()), 5)
        love.graphics.setColor(1, 1, 1, 1)
    end

    return gameMapDebug
end

return GameMapDebug
