local Component        = require "models.scenes.Component"
local Image            = require "models.images.Image"
local SpriteSheetImage = require "models.images.SpriteSheetImage"

---@class Unit
Unit                   = {}

Unit.new               = function(name, body, turret, fireAnimation, x, y)
    local unit       = Component.new(
            name,
            {
                name           = name,
                body           = body,
                turret         = turret,
                fireAnimation  = fireAnimation,
                turretRotation = 0,
                turretSpeed    = 10,
                mouseWasDown   = false,
                mouseClicked   = false
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
    local tankBullet1 = Image.new(unit.name .. "_tankBullet", "assets/gamelevel/bullet.png", unit.bounds.x + (unit.bounds.width / 2), unit.bounds.y + (unit.bounds.height / 2), unit.rotation, unit.scale, unit.color)
    local tankBullet2 = Image.new(unit.name .. "_tankBullet", "assets/gamelevel/bullet.png", unit.bounds.x + (unit.bounds.width / 2), unit.bounds.y + (unit.bounds.height / 2), unit.rotation, unit.scale, unit.color)
    local tankFire   = SpriteSheetImage.new(unit.name .. "_tankFire", fireAnimation, 18, 1, 10, false, unit.bounds.x + (unit.bounds.width / 2), unit.bounds.y + (unit.bounds.height / 2), nil, nil, unit.rotation, unit.scale, unit.color, function() unit.fireEnds() end).hide()

    unit.addComponent(tankBody)
    unit.addComponent(tankTurret)
    unit.addComponent(tankFire)

    unit.addComponent(tankBullet1)
    unit.addComponent(tankBullet2)

    setmetatable(unit, Unit)
    Unit.__index = Unit

    function unit.update(dt)
        unit.updateUnit(dt)

        if unit.data.mouseClicked then
            unit.fireStarts()
            unit.data.mouseClicked = false
        end

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

        tankBullet1.bounds.x = unit.bounds.x - math.cos(math.rad(unit.data.turretRotation)) * 10
        tankBullet1.bounds.y = unit.bounds.y - math.sin(math.rad(unit.data.turretRotation)) * 10
        tankBullet1.scale    = unit.scale
        tankBullet1.rotation = unit.data.turretRotation

        tankBullet2.bounds.x = unit.bounds.x + math.cos(math.rad(unit.data.turretRotation)) * 10
        tankBullet2.bounds.y = unit.bounds.y + math.sin(math.rad(unit.data.turretRotation)) * 10
        tankBullet2.scale    = unit.scale
        tankBullet2.rotation = unit.data.turretRotation
    end

    function unit.targetPosition(targetX, targetY)
        local tankPositionX = unit.bounds.x
        local tankPositionY = unit.bounds.y
        local angle         = math.deg(math.atan2(tankPositionY - targetY, targetX - tankPositionX))
        local turretAngle   = -angle - 90

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
        unit.data.turretRotation = turretAngle
    end

    function unit.fireStarts()
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
