local Rectangle = require "models.drawing.Rectangle"
local Component = require "models.scenes.Component"
local Image     = require "models.images.Image"
---@class UnitMissile
UnitMissile     = {}

UnitMissile.new = function(name, gameLevelData, missileEnded)
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
        gameLevelData   = gameLevelData,
        speed           = 2000,
        drawViewPort    = nil,
        missileEnded    = missileEnded
    })

    setmetatable(unitMissile, UnitMissile)
    UnitMissile.__index = UnitMissile

    local missile       = Image.new(unitMissile.name .. "_missile", "assets/gamelevel/bullet.png", 0, 0)

    unitMissile.addComponent(missile)

    function unitMissile.load()
        unitMissile.data.bounds = Rectangle.new(unitMissile.data.startX, unitMissile.data.startY, 8, 28)
    end

    function unitMissile.update(dt)
        if (unitMissile.data.running == false) then return end
        unitMissile.updateMissileMovement(dt)
        local translated = unitMissile.translateRealPositionToScreenPosition(unitMissile.data.currentX, unitMissile.data.currentY)
        missile.bounds.x = translated.x
        missile.bounds.y = translated.y
        missile.scale    = 0.75
        missile.rotation = unitMissile.data.currentRotation
    end

    function unitMissile.updateMissileMovement(dt)
        local vector              = unitMissile.getNormalizedMovementVector()
        local distance            = unitMissile.distanceToDestination()

        unitMissile.data.currentX = unitMissile.data.currentX + (unitMissile.data.speed * vector.x * dt)
        unitMissile.data.currentY = unitMissile.data.currentY + (unitMissile.data.speed * vector.y * dt)

        if distance < 5 then
            unitMissile.data.currentX = unitMissile.data.destinationX
            unitMissile.data.currentY = unitMissile.data.destinationY
            missile.hide()
        end
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
