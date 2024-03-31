local Component = require "models.scenes.Component"
local Image     = require "models.images.Image"
---@class Unit
Unit            = {}

Unit.new        = function(name, idleAnimation, x, y)
    local unit = Component.new(
            name,
            {
                name          = name,
                idleAnimation = idleAnimation
            },
            x,
            y,
            104,
            104
    )

    local idle = Image.new(unit.name .. "_idle", idleAnimation, unit.bounds.x + (unit.bounds.width / 2), unit.bounds.y + (unit.bounds.height / 2), unit.rotation, unit.scale)

    unit.addComponent(idle)

    setmetatable(unit, Unit)
    Unit.__index = Unit

    function unit.update(_)
        idle.rotation = unit.rotation
        idle.scale    = unit.scale
        idle.bounds.x = unit.bounds.x
        idle.bounds.y = unit.bounds.y
    end

    function unit.setPosition(posX, posY, rotation)
        unit.bounds.x = posX
        unit.bounds.y = posY
        unit.rotation = rotation
    end

    return unit
end

return Unit
