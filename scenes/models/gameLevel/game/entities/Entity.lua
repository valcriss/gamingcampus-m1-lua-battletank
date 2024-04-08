local Component = require "models.scenes.Component"
---@class Entity
Entity          = {}

Entity.new      = function(name, unitType, unitGroup, x, y, width, height, rotation, scale)
    x            = x or 0
    y            = y or 0
    width        = width or 0
    height       = height or 0
    rotation     = rotation or 0
    scale        = scale or 1
    local entity = Component.new(name, {}, x, y, width, height, rotation, scale)

    setmetatable(entity, Entity)
    Entity.__index = Entity

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local type     = unitType
    local group    = unitGroup
    local collider

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------
    ---@public
    function entity.getType()
        return type
    end
    ---@public
    function entity.getGroup()
        return group
    end
    ---@public
    function entity.getCollider()
        return collider
    end
    ---@public
    ---@param newRotation number
    function entity.setRotation(newRotation)
        entity.rotation = newRotation
    end
    ---@public
    ---@param newCollider Rectangle
    function entity.setCollider(newCollider)
        collider = newCollider
    end

    return entity
end

return Entity
