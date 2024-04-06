local Unit      = require "scenes.models.gamelevel.unit.Unit"
local Rectangle = require "models.drawing.Rectangle"
---@class PlayerTank
PlayerTank      = {}

--- @param gameLevelData GameLevelData
PlayerTank.new  = function(gameLevelData)
    local playerTank = Unit.new("playerTank", "assets/gamelevel/tank-body.png", "assets/gamelevel/tank-turret.png", "assets/gamelevel/tank-turret-fire.png", 0, 0, gameLevelData, 1)

    setmetatable(playerTank, PlayerTank)
    PlayerTank.__index = PlayerTank

    function playerTank.setPosition(newX, newY, newRotation)
        playerTank.bounds.x = newX
        playerTank.bounds.y = newY
        playerTank.rotation = newRotation
        playerTank.scale    = 0.5
    end

    function playerTank.updateUnit(_)
        local mouseX, mouseY       = love.mouse.getPosition()
        local mouseOffset          = { x = screenManager:ScaleUIValueX(mouseX) - screenManager:calculateCenterPointX(), y = screenManager:ScaleUIValueY(mouseY) - screenManager:calculateCenterPointY() }
        local realUnitPosition     = { x = (playerTank.data.viewPort.x), y = (playerTank.data.viewPort.y) }
        playerTank.data.realBounds = Rectangle.new(realUnitPosition.x, realUnitPosition.y, playerTank.bounds.width * playerTank.scale, playerTank.bounds.height * playerTank.scale)
        if love.mouse.isDown(1) then
            playerTank.data.mouseMapCoords = nil
            playerTank.data.mouseWasDown   = true
        elseif not love.mouse.isDown(1) and playerTank.data.mouseWasDown then
            playerTank.data.startRealPosition       = realUnitPosition
            playerTank.data.destinationRealPosition = { x = realUnitPosition.x + mouseOffset.x, y = realUnitPosition.y + mouseOffset.y }
            playerTank.data.mouseClicked            = true
            playerTank.data.mouseWasDown            = false
        else
            playerTank.data.mouseMapCoords = nil
            playerTank.data.mouseWasDown   = false
        end

        playerTank.targetPosition(screenManager:ScaleUIValueX(mouseX), screenManager:ScaleUIValueY(mouseY))
    end

    return playerTank
end

return PlayerTank
