local Order   = require "scenes.models.gameLevel.game.entities.behaviors.orders.Order"
---@class MoveOrder
MoveOrder     = {}

---@param gameManager GameManager
---@param enemy Enemy
MoveOrder.new = function(type, target, gameManager, enemy, behavior)
    local moveOrder = Order.new(type, target, gameManager, enemy, behavior)

    setmetatable(moveOrder, MoveOrder)
    MoveOrder.__index = MoveOrder

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    ---@public
    function moveOrder.update(dt)
        if moveOrder.getCurrentPath() == nil then
            moveOrder.setCurrentPath(gameManager.getPathFinding().findPath(enemy.getCollider().getPoint(), target))
        else
            local path     = moveOrder.getCurrentPath()
            local nextTile = moveOrder.getPathNode()
            if nextTile ~= nil then
                local nextTilePosition = gameManager.getGameLevelData().getRealPositionFromTileIndex(nextTile)
                moveOrder.lookAtPosition({ x = nextTilePosition.x, y = nextTilePosition.y })
                if nextTilePosition.distance(enemy.getEnemyPosition().x, enemy.getEnemyPosition().y) < gameManager.getGameLevelData().data.level.TileSize / 4 then
                    enemy.setEnemyPosition({ x = nextTilePosition.x, y = nextTilePosition.y })
                    moveOrder.nextNode()
                else
                    enemy.moveToPoint({ x = nextTilePosition.x, y = nextTilePosition.y }, dt)
                end
            else
                behavior.resetCurrentOrder()
            end
        end
    end

    function moveOrder.lookAtPosition(targetPosition)
        if targetPosition ~= nil then
            enemy.lookAtPosition(targetPosition)
        end
    end

    return moveOrder
end

return MoveOrder
