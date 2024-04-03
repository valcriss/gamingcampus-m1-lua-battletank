local Unit     = require "scenes.models.gamelevel.unit.Unit"
---@class PlayerTank
PlayerTank     = {}

PlayerTank.new = function()
    local playerTank = Unit.new("playerTank", "assets/gamelevel/tank-body.png", "assets/gamelevel/tank-turret.png", "assets/gamelevel/tank-turret-fire.png", 0, 0)

    setmetatable(playerTank, PlayerTank)
    PlayerTank.__index = PlayerTank

    function playerTank.setPosition(newX, newY, newRotation)
        playerTank.bounds.x = newX
        playerTank.bounds.y = newY
        playerTank.rotation = newRotation
        playerTank.scale    = 0.5
    end

    function playerTank.updateUnit(_)
        if love.mouse.isDown(1) then
            playerTank.data.mouseWasDown = true
        elseif not love.mouse.isDown(1) and playerTank.data.mouseWasDown then
            playerTank.data.mouseClicked = true
            playerTank.data.mouseWasDown = false
        end
        local mouseX, mouseY = love.mouse.getPosition()
        playerTank.targetPosition(mouseX,mouseY)
    end

    return playerTank
end

return PlayerTank
