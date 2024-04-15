local Component = require "models.scenes.Component"
---@class Entity
Entity          = {}

Entity.new      = function(name, gameManager, unitType, unitGroup, x, y, width, height, rotation, scale)
    x            = x or 0
    y            = y or 0
    width        = width or 0
    height       = height or 0
    rotation     = rotation or 0
    scale        = scale or 1
    local entity = Component.new(name, x, y, width, height, rotation, scale)

    setmetatable(entity, Entity)
    Entity.__index          = Entity

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local type              = unitType
    local group             = unitGroup
    local maxHealth         = 1000
    local canBeDamaged      = true
    local isFrozen          = false
    local canRegenHealth    = true
    local isDead            = false
    local regenHealthAmount = configuration:getEnemyRegenHealthAmount()
    local regenTimer        = 0
    local frozenDuration    = 0
    local currentHealth     = maxHealth
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

    function entity.setGroup(newGroup)
        group = newGroup
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

    function entity.setCanRegenHealth(newCanRegenHealth)
        canRegenHealth = newCanRegenHealth
        regenTimer     = 0
    end

    function entity.setRegenHealthAmount(newRegenHealthAmount)
        regenHealthAmount = newRegenHealthAmount
    end

    function entity.getHealth()
        return currentHealth
    end

    function entity.setHealth(newHealth)
        currentHealth = math.min(math.max(newHealth, 0), maxHealth)
    end

    function entity.getHealthPercentage()
        return currentHealth / maxHealth
    end

    function entity.getMaxHealth()
        return maxHealth
    end

    function entity.canBeDamaged()
        return canBeDamaged
    end

    function entity.isFrozen()
        return isFrozen
    end

    function entity.setFrozen(duration)
        frozenDuration = duration
        isFrozen       = true
    end

    function entity.setCanBeDamaged(newCanBeDamaged)
        canBeDamaged = newCanBeDamaged
    end

    function entity.setMaxHealth(newMaxHealth)
        maxHealth     = newMaxHealth
        currentHealth = newMaxHealth
    end

    function entity.update(dt)
        entity.entityUpdate(dt)
        if canRegenHealth and not isDead and entity.getHealth() < entity.getMaxHealth() then
            regenTimer = regenTimer + dt
            if regenTimer >= 1 then
                entity.setHealth(entity.getHealth() + regenHealthAmount)
                regenTimer = 0
            end
        end
        if isFrozen then
            frozenDuration = math.max(frozenDuration - dt, 0)
            if frozenDuration <= 0 then
                isFrozen = false
            end
        end
        if isFrozen then
            entity.color = { r = 1, g = 1, b = 1, a = 0.75 }
        else
            entity.color = { r = 1, g = 1, b = 1, a = 1 }
        end
    end

    function entity.entityUpdate(_)

    end

    function entity.takeDamage(damage, fromGroup)
        if not canBeDamaged or isFrozen then return end
        currentHealth = math.max(currentHealth - damage, 0)
        if currentHealth <= 0 then
            isDead = true
            gameManager.onUnitDead(entity, fromGroup)
        end
    end

    function entity.fullHealth()
        currentHealth = maxHealth
        isDead        = false
    end

    return entity
end

return Entity
