local Order     = require "scenes.models.gameLevel.game.entities.behaviors.orders.Order"
---@class AttackOrder
AttackOrder     = {}

---@param gameManager GameManager
---@param enemy Enemy
AttackOrder.new = function(target, gameManager, enemy, behavior)
    local attackOrder = Order.new()

    setmetatable(attackOrder, AttackOrder)
    AttackOrder.__index = AttackOrder

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local attackRange   = 5 * gameManager.getGameLevelData().data.level.TileSize
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

    function attackOrder.moveCloseToTarget(dt)
        if attackOrder.getCurrentPath() == nil then
            local path = gameManager.getPathFinding().findPath(enemy.getCollider().getPoint(), target.getCollider().getPoint())
            attackOrder.setCurrentPath(path)
        else
            local nextTile = attackOrder.getPathNode()
            if nextTile ~= nil then
                local nextTilePosition = gameManager.getGameLevelData().getRealPositionFromTileIndex(nextTile).offsetPosition(gameManager.getGameLevelData().data.level.TileSize / 2, gameManager.getGameLevelData().data.level.TileSize / 2)
                attackOrder.lookAtPosition({ x = nextTilePosition.x, y = nextTilePosition.y })
                if nextTilePosition.distance(enemy.getEnemyPosition().x, enemy.getEnemyPosition().y) < gameManager.getGameLevelData().data.level.TileSize / 4 then
                    enemy.setEnemyPosition({ x = nextTilePosition.x, y = nextTilePosition.y })
                    attackOrder.nextNode()
                else
                    enemy.moveToPoint({ x = nextTilePosition.x, y = nextTilePosition.y }, dt)
                end
            else
                attackOrder.clearCurrentPath()
            end
        end
    end

    function attackOrder.lookAtPosition(targetPosition)
        if targetPosition ~= nil then
            enemy.lookAtPosition(targetPosition)
        end
    end

    return attackOrder
end

return AttackOrder
