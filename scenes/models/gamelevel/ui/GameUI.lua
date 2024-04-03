local Component        = require "models.scenes.Component"
local Image            = require "models.images.Image"

---@class GameUI
GameUI                   = {}

GameUI.new               = function(name)
    local gameUI       = Component.new(
            name,
            {

            }
    )

    local mainUi   = Image.new(gameUI.name .. "_mainUi", "assets/gamelevel/mainUI.png", screenManager:calculateCenterPointX(), 32)

    setmetatable(gameUI, GameUI)
    GameUI.__index = GameUI

    gameUI.addComponent(mainUi)

    function gameUI.update(_)

    end

    return gameUI
end

return GameUI
