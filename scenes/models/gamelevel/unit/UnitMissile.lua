local Rectangle        = require "models.drawing.Rectangle"
local Component        = require "models.scenes.Component"
local Image            = require "models.images.Image"
local SpriteSheetImage = require "models.images.SpriteSheetImage"
---@class UnitMissile
UnitMissile            = {}

UnitMissile.new        = function(name, gameLevelData, missileEnded)
    local unitMissile = Component.new(name, {
        startX          = 0,
        startY          = 0,
        currentX        = 0,
        currentY        = 0,
        currentRotation = 0,
        destinationX    = 0,
        destinationY    = 0,
        rotation        = 0,
        running         = false,
        moving          = false,
        gameLevelData   = gameLevelData,
        speed           = 2000,
        drawViewPort    = nil,
        missileEnded    = missileEnded
    })

    setmetatable(unitMissile, UnitMissile)
    UnitMissile.__index = UnitMissile

    local missile       = Image.new(unitMissile.name .. "_missile", "assets/gamelevel/bullet.png", 0, 0)
    local explosion     = SpriteSheetImage.new(unitMissile.name .. "_explosion", "assets/gamelevel/explosion2.png", 5, 4, 3, false, 0, 0, nil, nil, 0, 1, nil, function() unitMissile.explosionEnds() end).hide()

    unitMissile.addComponent(missile)
    unitMissile.addComponent(explosion)

    function unitMissile.load()
        unitMissile.data.bounds = Rectangle.new(unitMissile.data.startX, unitMissile.data.startY, 8, 28)
    end

    function unitMissile.update(dt)
        if (unitMissile.data.running == false) then return end
        unitMissile.updateMissileMovement(dt)
        local translated = unitMissile.translateRealPositionToScreenPosition(unitMissile.data.currentX, unitMissile.data.currentY)
        missile.bounds.x = translated.x
        missile.bounds.y = translated.y
        explosion.bounds.x = translated.x
        explosion.bounds.y = translated.y
        missile.scale    = 0.75
        explosion.scale = 0.4
        missile.rotation = unitMissile.data.currentRotation
    end

    function unitMissile.updateMissileMovement(dt)
        if not unitMissile.data.moving then return end
        local vector              = unitMissile.getNormalizedMovementVector()


        unitMissile.data.currentX = unitMissile.data.currentX + (unitMissile.data.speed * vector.x * dt)
        unitMissile.data.currentY = unitMissile.data.currentY + (unitMissile.data.speed * vector.y * dt)

        local tileIndex = unitMissile.data.gameLevelData.getTileIndexFromRealPosition(unitMissile.data.currentX + (unitMissile.data.gameLevelData.tileSize / 2), unitMissile.data.currentY + (unitMissile.data.gameLevelData.tileSize / 2))
        local blocked = unitMissile.data.gameLevelData.isTileDecorationBlocked(tileIndex)

        if blocked then
            unitMissile.data.destinationX = unitMissile.data.currentX
            unitMissile.data.destinationY = unitMissile.data.currentY
        end

        local distance            = unitMissile.distanceToDestination()

        if distance < 5 or blocked then
            unitMissile.data.currentX = unitMissile.data.destinationX
            unitMissile.data.currentY = unitMissile.data.destinationY
            unitMissile.data.moving = false
            missile.hide()
            explosion.show()
        end
    end

    function unitMissile.explosionEnds()
        unitMissile.data.running = false
        explosion.hide()
    end

    function unitMissile.isRunning()
        return unitMissile.data.running
    end

    function unitMissile.distanceToDestination()
        local vector    = { x = unitMissile.data.destinationX - unitMissile.data.currentX, y = unitMissile.data.destinationY - unitMissile.data.currentY }
        local magnitude = math.sqrt(vector.x ^ 2 + vector.y ^ 2)
        return magnitude
    end

    function unitMissile.getNormalizedMovementVector()
        local vector    = { x = unitMissile.data.destinationX - unitMissile.data.currentX, y = unitMissile.data.destinationY - unitMissile.data.currentY }
        local magnitude = math.sqrt(vector.x ^ 2 + vector.y ^ 2)
        return { x = vector.x / magnitude, y = vector.y / magnitude }
    end

    function unitMissile.fire(startX, startY, destinationX, destinationY, rotation)
        unitMissile.data.startX          = startX
        unitMissile.data.startY          = startY
        unitMissile.data.destinationX    = destinationX
        unitMissile.data.destinationY    = destinationY
        unitMissile.data.rotation        = rotation
        unitMissile.data.currentX        = startX
        unitMissile.data.currentY        = startY
        unitMissile.data.currentRotation = rotation
        missile.show()
        unitMissile.data.running = true
        unitMissile.data.moving = true
    end

    function unitMissile.translateRealPositionToScreenPosition(realX, realY)
        if (unitMissile.data.drawViewPort) then
            return { x = realX + unitMissile.data.drawViewPort.x + unitMissile.data.gameLevelData.tileSize / 2, y = realY + unitMissile.data.drawViewPort.y + unitMissile.data.gameLevelData.tileSize / 2 }
        end
        return { x = -100, y = -100 }
    end

    function unitMissile.setDrawViewPort(drawViewPort)
        unitMissile.data.drawViewPort = drawViewPort
    end
    return unitMissile
end

return UnitMissile
