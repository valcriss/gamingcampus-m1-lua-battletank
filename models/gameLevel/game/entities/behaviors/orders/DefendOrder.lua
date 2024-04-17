local Order     = require "models.gameLevel.game.entities.behaviors.orders.Order"
---@class DefendOrder
DefendOrder     = {}

---@param gameManager GameManager
---@param enemy Enemy
DefendOrder.new = function(target, gameManager, enemy, behavior)
    local defendOrder = Order.new()

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

    function defendOrder.moveCloseToTarget(dt)
        if defendOrder.getCurrentPath() == nil then
            local path = gameManager.getPathFinding().findPath(enemy.getCollider().getPoint(), target.getCollider().getPoint())
            defendOrder.setCurrentPath(path)
        else
            local nextTile = defendOrder.getPathNode()
            if nextTile ~= nil then
                local nextTilePosition = gameManager.getGameLevelData().getRealPositionFromTileIndex(nextTile).offsetPosition(gameManager.getGameLevelData().getLevel().TileSize / 2, gameManager.getGameLevelData().getLevel().TileSize / 2)
                defendOrder.lookAtPosition({ x = nextTilePosition.x, y = nextTilePosition.y })
                if nextTilePosition.distance(enemy.getEnemyPosition().x, enemy.getEnemyPosition().y) < gameManager.getGameLevelData().getLevel().TileSize / 4 then
                    enemy.setEnemyPosition({ x = nextTilePosition.x, y = nextTilePosition.y })
                    defendOrder.nextNode()
                else
                    enemy.moveToPoint({ x = nextTilePosition.x, y = nextTilePosition.y }, dt)
                end
            else
                defendOrder.clearCurrentPath()
            end
        end
    end

    function defendOrder.lookAtPosition(targetPosition)
        if targetPosition ~= nil then
            enemy.lookAtPosition(targetPosition)
        end
    end

    return defendOrder
end

return DefendOrder
