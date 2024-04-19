---@class Order
Order     = {}

Order.new = function(enemy, target, gameManager)
    local order = {}

    setmetatable(order, Order)
    Order.__index   = Order

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local currentPath
    local pathIndex = 1
    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    ---@public
    function order.update(_)

    end

    function order.clearCurrentPath()
        currentPath = nil
        pathIndex   = 1
    end

    function order.setCurrentPath(path)
        currentPath = path
        pathIndex   = 1
    end

    function order.getPathNode()
        if pathIndex > #currentPath then
            return nil
        end
        return currentPath[pathIndex]
    end

    function order.nextNode()
        pathIndex = pathIndex + 1
    end

    function order.getCurrentPath()
        return currentPath
    end

    function order.moveCloseToTarget(dt)
        if order.getCurrentPath() == nil then
            local path = gameManager.getPathFinding().findPath(enemy.getCollider().getPoint(), target.getCollider().getPoint())
            order.setCurrentPath(path)
        else
            local nextTile = order.getPathNode()
            if nextTile ~= nil then
                local nextTilePosition = gameManager.getGameLevelData().getRealPositionFromTileIndex(nextTile).offsetPosition(gameManager.getGameLevelData().getLevel().TileSize / 2, gameManager.getGameLevelData().getLevel().TileSize / 2)
                order.lookAtPosition({ x = nextTilePosition.x, y = nextTilePosition.y })
                if nextTilePosition.distance(enemy.getEnemyPosition().x, enemy.getEnemyPosition().y) < gameManager.getGameLevelData().getLevel().TileSize / 4 then
                    enemy.setEnemyPosition({ x = nextTilePosition.x, y = nextTilePosition.y })
                    order.nextNode()
                else
                    enemy.moveToPoint({ x = nextTilePosition.x, y = nextTilePosition.y }, dt)
                end
            else
                order.clearCurrentPath()
            end
        end
    end

    function order.lookAtPosition(targetPosition)
        if targetPosition ~= nil then
            enemy.lookAtPosition(targetPosition)
        end
    end

    return order
end

return Order
