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
    local tankFire   = SpriteSheetImage.new(unit.name .. "_tankFire", fireAnimation, 18, 1, 10, false, unit.bounds.x + (unit.bounds.width / 2), unit.bounds.y + (unit.bounds.height / 2), nil, nil, unit.rotation, unit.scale, unit.color, function() unit.fireEnds() end).hide()

    unit.addComponent(tankBody)
    unit.addComponent(tankTurret)
    unit.addComponent(tankFire)

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
