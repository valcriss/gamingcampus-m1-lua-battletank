local Order     = require "models.gameLevel.game.entities.behaviors.orders.Order"
---@class DefendOrder
DefendOrder     = {}

---@param gameManager GameManager
---@param enemy Enemy
DefendOrder.new = function(target, gameManager, enemy, behavior)
    local defendOrder = Order.new(enemy, target, gameManager)

    setmetatable(defendOrder, DefendOrder)
    DefendOrder.__index = DefendOrder

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local defendRange   = 5 * gameManager.getGameLevelData().getLevel().TileSize

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------
    ---@public
    function defendOrder.update(dt)
        if target.getCollider() == nil then return end
        local targetPosition   = target.getCollider().getPoint()
        local distanceToTarget = enemy.getEnemyPosition().distance(targetPosition.x, targetPosition.y)

        enemy.targetRealPosition(targetPosition.x, targetPosition.y)

        if distanceToTarget < defendRange then
            behavior.resetCurrentOrder()
        else
            defendOrder.moveCloseToTarget(dt)
        end
    end

    return defendOrder
end

return DefendOrder
