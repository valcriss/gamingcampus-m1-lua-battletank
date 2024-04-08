local Entity           = require "scenes.models.gameLevel.game.entities.Entity"
local Image            = require "models.images.Image"
local SpriteSheetImage = require "models.images.SpriteSheetImage"
local UnitMissile      = require "scenes.models.gameLevel.game.entities.UnitMissile"

---@class Unit
Unit                   = {}

Unit.new               = function(name, gameManager, body, turret, fireAnimation, x, y, group)
    local unit       = Entity.new(name, "Tank", group, x, y, 128, 128, 0, 0.5)

    local tankBody   = Image.new(unit.name .. "_body", body, unit.bounds.x + (unit.bounds.width / 2), unit.bounds.y + (unit.bounds.height / 2), unit.rotation, unit.scale)
    local tankTurret = Image.new(unit.name .. "_turret", turret, unit.bounds.x + (unit.bounds.width / 2), unit.bounds.y + (unit.bounds.height / 2), unit.rotation, unit.scale)
    local tankFire   = SpriteSheetImage.new(unit.name .. "_tankFire", fireAnimation, 18, 1, 10, false, unit.bounds.x + (unit.bounds.width / 2), unit.bounds.y + (unit.bounds.height / 2), nil, nil, unit.rotation, unit.scale, unit.color, function() unit.fireEnds() end).hide()
    local missile1   = UnitMissile.new("missile1", gameManager, group)
    local missile2   = UnitMissile.new("missile2", gameManager, group)
    --
    unit.addComponent(tankBody)
    unit.addComponent(tankTurret)
    unit.addComponent(tankFire)
    unit.addComponent(missile1)
    unit.addComponent(missile2)

    local turretRotation = 0
    local startRealPosition
    local destinationRealPosition

    setmetatable(unit, Unit)
    Unit.__index = Unit

    function unit.update(dt)
        unit.updateUnit(dt)
        unit.updateTankPosition()
    end

    function unit.updateTankPosition()
        tankBody.rotation   = unit.rotation
        tankBody.scale      = unit.scale
        tankBody.bounds.x   = unit.bounds.x
        tankBody.bounds.y   = unit.bounds.y
        tankTurret.rotation = turretRotation
        tankTurret.scale    = unit.scale
        tankTurret.bounds.x = unit.bounds.x
        tankTurret.bounds.y = unit.bounds.y
        tankFire.rotation   = turretRotation
        tankFire.scale      = unit.scale
        tankFire.bounds.x   = unit.bounds.x
        tankFire.bounds.y   = unit.bounds.y
    end

    ---@public
    function unit.targetPosition(targetX, targetY)
        local tankPositionX = unit.bounds.x
        local tankPositionY = unit.bounds.y
        local angle         = math.deg(math.atan2(tankPositionY - targetY, targetX - tankPositionX))
        local turretAngle   = -angle - 90
        turretRotation      = turretAngle
    end

    function unit.fireStarts()
        if missile1.isRunning() or missile2.isRunning() then return end
        missile1.fire(
                startRealPosition.x - math.cos(math.rad(turretRotation)) * 10,
                startRealPosition.y - math.sin(math.rad(turretRotation)) * 10,
                destinationRealPosition.x,
                destinationRealPosition.y,
                turretRotation
        )
        missile2.fire(
                startRealPosition.x + math.cos(math.rad(turretRotation)) * 10,
                startRealPosition.y + math.sin(math.rad(turretRotation)) * 10,
                destinationRealPosition.x,
                destinationRealPosition.y,
                turretRotation
        )

        tankFire.show()
        tankTurret.hide()
    end

    function unit.fireEnds()
        tankFire.hide()
        tankTurret.show()
    end

    function unit.updateUnit(_)

    end

    function unit.setStartRealPosition(newStartRealPosition)
        startRealPosition = newStartRealPosition
    end

    function unit.setDestinationRealPosition(newDestinationRealPosition)
        destinationRealPosition = newDestinationRealPosition
    end

    return unit
end

return Unit
