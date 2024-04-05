local Component        = require "models.scenes.Component"
local Image            = require "models.images.Image"
local SpriteSheetImage = require "models.images.SpriteSheetImage"
local UnitMissile      = require "scenes.models.gamelevel.unit.UnitMissile"

---@class Unit
Unit                   = {}

Unit.new               = function(name, body, turret, fireAnimation, x, y, gameLevelData)
    local unit       = Component.new(
            name,
            {
                name                    = name,
                body                    = body,
                turret                  = turret,
                fireAnimation           = fireAnimation,
                turretRotation          = 0,
                turretSpeed             = 10,
                mouseWasDown            = false,
                mouseClicked            = false,
                limitUnitAngle          = false,
                gameLevelData           = gameLevelData,
                startRealPosition       = { x = 0, y = 0 },
                destinationRealPosition = { x = 0, y = 0 },
                viewPort                = nil,
                drawViewPort            = nil
            },
            x,
            y,
            104,
            104,
            0,
            1,
            { r = 1, g = 1, b = 1, a = 1 }
    )

    local tankBody   = Image.new(unit.name .. "_body", body, unit.bounds.x + (unit.bounds.width / 2), unit.bounds.y + (unit.bounds.height / 2), unit.rotation, unit.scale, unit.color)
    local tankTurret = Image.new(unit.name .. "_turret", turret, unit.bounds.x + (unit.bounds.width / 2), unit.bounds.y + (unit.bounds.height / 2), unit.rotation, unit.scale, unit.color)
    local tankFire   = SpriteSheetImage.new(unit.name .. "_tankFire", fireAnimation, 18, 1, 10, false, unit.bounds.x + (unit.bounds.width / 2), unit.bounds.y + (unit.bounds.height / 2), nil, nil, unit.rotation, unit.scale, unit.color, function() unit.fireEnds() end).hide()
    local missile1   = UnitMissile.new("missile1", gameLevelData)
    local missile2   = UnitMissile.new("missile2", gameLevelData)

    unit.addComponent(tankBody)
    unit.addComponent(tankTurret)
    unit.addComponent(tankFire)
    unit.addComponent(missile1)
    unit.addComponent(missile2)

    setmetatable(unit, Unit)
    Unit.__index = Unit

    function unit.update(dt)
        unit.updateUnit(dt)

        if unit.data.mouseClicked then
            unit.fireStarts()
            unit.data.mouseClicked = false
        end

        unit.updateTankPosition()
    end

    function unit.setViewPort(viewPort)
        unit.data.viewPort = viewPort
    end

    function unit.setDrawViewPort(drawViewPort)
        unit.data.drawViewPort = drawViewPort
        missile1.setDrawViewPort(drawViewPort)
        missile2.setDrawViewPort(drawViewPort)
    end

    function unit.updateTankPosition()
        tankBody.rotation   = unit.rotation
        tankBody.scale      = unit.scale
        tankBody.bounds.x   = unit.bounds.x
        tankBody.bounds.y   = unit.bounds.y
        tankTurret.rotation = unit.data.turretRotation
        tankTurret.scale    = unit.scale
        tankTurret.bounds.x = unit.bounds.x
        tankTurret.bounds.y = unit.bounds.y
        tankFire.rotation   = unit.data.turretRotation
        tankFire.scale      = unit.scale
        tankFire.bounds.x   = unit.bounds.x
        tankFire.bounds.y   = unit.bounds.y
    end

    function unit.targetPosition(targetX, targetY)
        targetX             = screenManager:ScaleUIValueX(targetX)
        targetY             = screenManager:ScaleUIValueY(targetY)
        local tankPositionX = unit.bounds.x
        local tankPositionY = unit.bounds.y
        local angle         = math.deg(math.atan2(tankPositionY - targetY, targetX - tankPositionX))
        local turretAngle   = -angle - 90

        if unit.data.limitUnitAngle then
            if (unit.rotation == 0) then
                turretAngle = math.max(-60, math.min(60, turretAngle))
            elseif (unit.rotation == 180) then
                turretAngle = math.max(-240, math.min(-120, turretAngle))
            elseif (unit.rotation == -90) then
                turretAngle = math.max(-150, math.min(-30, turretAngle))
            elseif (unit.rotation == 90) then
                if turretAngle >= 0 then
                    turretAngle = math.max(30, math.min(90, turretAngle))
                else
                    turretAngle = math.max(-270, math.min(-210, turretAngle))
                end
            end
        end
        unit.data.turretRotation = turretAngle
    end

    function unit.fireStarts()
        if missile1.isRunning() or missile2.isRunning() then return end
        missile1.fire(
                unit.data.startRealPosition.x - math.cos(math.rad(unit.data.turretRotation)) * 10,
                unit.data.startRealPosition.y - math.sin(math.rad(unit.data.turretRotation)) * 10,
                unit.data.destinationRealPosition.x,
                unit.data.destinationRealPosition.y,
                unit.data.turretRotation
        )
        missile2.fire(
                unit.data.startRealPosition.x + math.cos(math.rad(unit.data.turretRotation)) * 10,
                unit.data.startRealPosition.y + math.sin(math.rad(unit.data.turretRotation)) * 10,
                unit.data.destinationRealPosition.x,
                unit.data.destinationRealPosition.y,
                unit.data.turretRotation
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

    function unit.lerp(a, b, t)
        return a + (b - a) * t
    end

    function unit.setPosition(posX, posY, rotation)
        unit.bounds.x = posX
        unit.bounds.y = posY
        unit.rotation = rotation
    end

    return unit
end

return Unit
