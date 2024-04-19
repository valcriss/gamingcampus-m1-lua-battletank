local Component        = require "framework.scenes.Component"
local Image            = require "framework.images.Image"
local SpriteSheetImage = require "framework.images.SpriteSheetImage"
---@class UnitMissile
UnitMissile            = {}

UnitMissile.new        = function(name, gameManager, group, asset, speed)
    asset             = asset or "assets/gameLevel/bullet.png"
    speed             = speed or 2000
    local unitMissile = Component.new(name)

    setmetatable(unitMissile, UnitMissile)
    UnitMissile.__index   = UnitMissile

    local startX          = 0
    local startY          = 0
    local currentX        = 0
    local currentY        = 0
    local currentRotation = 0
    local destinationX    = 0
    local destinationY    = 0
    local rotation        = 0
    local running         = false
    local moving          = false
    local drawViewPort
    local unitGroup       = group

    local missile         = Image.new(unitMissile.name .. "_missile", asset, 0, 0)
    local explosion       = SpriteSheetImage.new(unitMissile.name .. "_explosion", "assets/gameLevel/explosion2.png", 5, 4, 3, false, 0, 0, nil, nil, 0, 1, nil, function()
        unitMissile.explosionEnds()
    end)                                    .hide()

    unitMissile.addComponent(missile)
    unitMissile.addComponent(explosion)

    function unitMissile.load()
        unitMissile.setBounds(startX, startY, 8, 28)
    end

    function unitMissile.update(dt)
        if (running == false) then
            return
        end
        unitMissile.updateMissileMovement(dt)
        local translated   = gameManager.getViewport().transformPointWorldToViewport({ x = currentX, y = currentY })
        missile.bounds.x   = translated.x
        missile.bounds.y   = translated.y
        explosion.bounds.x = translated.x
        explosion.bounds.y = translated.y
        missile.scale      = 0.75
        explosion.scale    = 0.4
        missile.rotation   = currentRotation
    end

    function unitMissile.updateMissileMovement(dt)
        if not moving then
            return
        end
        local vector               = unitMissile.getNormalizedMovementVector()

        currentX                   = currentX + (speed * vector.x * dt)
        currentY                   = currentY + (speed * vector.y * dt)

        local tileIndex            = gameManager.getGameLevelData().getTileIndexFromRealPosition(currentX, currentY)
        local blockedByEnvironment = gameManager.getGameLevelData().isTileEnvironmentBlocked(tileIndex)
        local blockedByUnit        = unitMissile.isBlockedByUnit(currentX, currentY)

        if blockedByEnvironment then
            unitMissile.blockMissile()
        elseif blockedByUnit ~= nil then
            if blockedByUnit.getGroup() ~= group then
                unitMissile.blockMissile()
                gameManager.onUnitTakeDamage(blockedByUnit, group == 1 and configuration:getPlayerDamage() or configuration:getEnemyDamage(), group)
            end
        end

        local distance = unitMissile.distanceToDestination()

        if distance < 5 then
            currentX = destinationX
            currentY = destinationY
            moving   = false
            missile.hide()
            explosion.show()
        end
    end

    function unitMissile.blockMissile()
        destinationX = currentX
        destinationY = currentY
    end

    function unitMissile.isBlockedByUnit(x, y)
        for _, unit in ipairs(gameManager.getUnits()) do
            if unit.getCollider() ~= nil and not (unit.getType() == "Tank" and unit.getGroup() == unitGroup) then
                local realUnitBounds = unit.getCollider()
                if realUnitBounds.containsPoint(x, y) then
                    return unit
                end
            end
        end
        return nil
    end

    function unitMissile.explosionEnds()
        running = false
        explosion.hide()
    end

    function unitMissile.isRunning()
        return running
    end

    function unitMissile.distanceToDestination()
        local vector    = { x = destinationX - currentX, y = destinationY - currentY }
        local magnitude = math.sqrt(vector.x ^ 2 + vector.y ^ 2)
        return magnitude
    end

    function unitMissile.getNormalizedMovementVector()
        local vector    = { x = destinationX - currentX, y = destinationY - currentY }
        local magnitude = math.sqrt(vector.x ^ 2 + vector.y ^ 2)
        return { x = vector.x / magnitude, y = vector.y / magnitude }
    end

    function unitMissile.fire(newStartX, newStartY, newDestinationX, newDestinationY, newRotation)
        startX          = newStartX
        startY          = newStartY
        destinationX    = newDestinationX
        destinationY    = newDestinationY
        rotation        = newRotation
        currentX        = newStartX
        currentY        = newStartY
        currentRotation = newRotation
        missile.show()
        running = true
        moving  = true
    end

    function unitMissile.translateRealPositionToScreenPosition(realX, realY)
        if (drawViewPort) then
            return { x = realX + drawViewPort.x + gameManager.getGameLevelData().getLevel().TileSize / 2, y = realY + drawViewPort.y + gameManager.getGameLevelData().getLevel().TileSize / 2 }
        end
        return { x = -100, y = -100 }
    end

    function unitMissile.setDrawViewPort(drawViewPortObj)
        drawViewPort = drawViewPortObj
    end
    return unitMissile
end

return UnitMissile
