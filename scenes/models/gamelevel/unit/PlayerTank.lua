local Unit = require "scenes.models.gamelevel.unit.Unit"
---@class PlayerTank
PlayerTank = {}

PlayerTank.new = function()
    local playerTank = Unit.new("playerTank", "assets/gamelevel/tank.png", 0, 0)

    setmetatable(playerTank, PlayerTank)
    PlayerTank.__index = PlayerTank

    function playerTank.setPosition(newX, newY, newRotation)
        playerTank.bounds.x = newX
        playerTank.bounds.y = newY
        playerTank.rotation = newRotation
        playerTank.scale = 0.5
    end

    return playerTank
end

return PlayerTank
