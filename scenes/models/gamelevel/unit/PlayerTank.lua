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
        local tankPositionX  = playerTank.bounds.x
        local tankPositionY  = playerTank.bounds.y
        local angle          = math.deg(math.atan2(tankPositionY - mouseY, mouseX - tankPositionX))
        local turretAngle    = -angle - 90

        if (playerTank.rotation == 0) then
            turretAngle = math.max(-60, math.min(60, turretAngle))
        elseif (playerTank.rotation == 180) then
            turretAngle = math.max(-240, math.min(-120, turretAngle))
        elseif (playerTank.rotation == -90) then
            turretAngle = math.max(-150, math.min(-30, turretAngle))
        elseif (playerTank.rotation == 90) then
            if turretAngle >= 0 then
                turretAngle = math.max(30, math.min(90, turretAngle))
            else
                turretAngle = math.max(-270, math.min(-210, turretAngle))
            end
        end
        playerTank.data.turretRotation = turretAngle
    end

    return playerTank
end

return PlayerTank
