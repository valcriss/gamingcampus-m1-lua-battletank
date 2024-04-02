local Component = require "models.scenes.Component"
local Image = require "models.images.Image"
---@class Unit
Unit = {}

Unit.new = function(name, idleAnimation, x, y)
    local unit = Component.new(
            name,
            {
                name = name,
                idleAnimation = idleAnimation,
                collisionBox = { x = 0, y = 0, width = 104 * 0.6, height = 104 * 0.6 },
            },
            x,
            y,
            104,
            104,
            0,
            1,
            { r = 1, g = 1, b = 1, a = 0.5 }
    )

    local idle = Image.new(unit.name .. "_idle", idleAnimation, unit.bounds.x + (unit.bounds.width / 2), unit.bounds.y + (unit.bounds.height / 2), unit.rotation, unit.scale, unit.color)

    unit.addComponent(idle)

    setmetatable(unit, Unit)
    Unit.__index = Unit

    function unit.update(_)
        idle.rotation = unit.rotation
        idle.scale = unit.scale
        idle.bounds.x = unit.bounds.x
        idle.bounds.y = unit.bounds.y
        unit.data.collisionBox.x = unit.bounds.x
        unit.data.collisionBox.y = unit.bounds.y
    end

    function unit.setPosition(posX, posY, rotation)
        unit.bounds.x = posX
        unit.bounds.y = posY
        unit.data.collisionBox.x = unit.bounds.x
        unit.data.collisionBox.y = unit.bounds.y
        unit.rotation = rotation
    end

    return unit
end

return Unit
