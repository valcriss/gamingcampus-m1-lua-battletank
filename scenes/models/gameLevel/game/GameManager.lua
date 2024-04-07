local Component = require "models.scenes.Component"
---@class GameManager
GameManager     = {}

GameManager.new = function()

    local gameManager = Component.new(
            "GameManager",
            {

            }
    )

    setmetatable(gameManager, GameManager)
    GameManager.__index = GameManager

    return gameManager
end

return GameManager
