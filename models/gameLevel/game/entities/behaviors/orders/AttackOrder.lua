local Order     = require "models.gameLevel.game.entities.behaviors.orders.Order"
---@class AttackOrder
AttackOrder     = {}

---@param gameManager GameManager
---@param enemy Enemy
AttackOrder.new = function(target, gameManager, enemy, behavior)
    local attackOrder = Order.new(enemy, target, gameManager)

    setmetatable(attackOrder, AttackOrder)
    AttackOrder.__index = AttackOrder

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local attackRange   = 5 * gameManager.getGameLevelData().getLevel().TileSize
    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    ---@public
    function attackOrder.update(dt)
        if target.getCollider() == nil then return end
        local targetPosition   = target.getCollider().getCenter()
        local distanceToTarget = enemy.getEnemyPosition().distance(targetPosition.x, targetPosition.y)

        enemy.targetRealPosition(targetPosition.x, targetPosition.y)

        if distanceToTarget < attackRange then
            attackOrder.clearCurrentPath()
            enemy.setDestinationRealPosition(targetPosition)
            enemy.fireStarts()
            if target.isFrozen() or target.getGroup() == enemy.getGroup() then
                behavior.resetCurrentOrder()
            end
        else
            attackOrder.moveCloseToTarget(dt)
            if target.isFrozen() or target.getGroup() == enemy.getGroup() then
                behavior.resetCurrentOrder()
            end
        end
    end

    return attackOrder
end

return AttackOrder
