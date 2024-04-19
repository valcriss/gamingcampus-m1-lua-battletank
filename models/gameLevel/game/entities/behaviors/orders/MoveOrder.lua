local Order   = require "models.gameLevel.game.entities.behaviors.orders.Order"
---@class MoveOrder
MoveOrder     = {}

---@param gameManager GameManager
---@param enemy Enemy
MoveOrder.new = function(target, gameManager, enemy, behavior)
    local moveOrder = Order.new(enemy, target, gameManager)

    setmetatable(moveOrder, MoveOrder)
    MoveOrder.__index = MoveOrder

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    ---@public
    function moveOrder.update(dt)
        if moveOrder.getCurrentPath() == nil then
            moveOrder.setCurrentPath(gameManager.getPathFinding().findPath(enemy.getCollider().getPoint(), target))
        else
            local nextTile = moveOrder.getPathNode()
            if nextTile ~= nil then
                local nextTilePosition = gameManager.getGameLevelData().getRealPositionFromTileIndex(nextTile).offsetPosition(gameManager.getGameLevelData().getLevel().TileSize / 2, gameManager.getGameLevelData().getLevel().TileSize / 2)
                moveOrder.lookAtPosition({ x = nextTilePosition.x, y = nextTilePosition.y })
                if nextTilePosition.distance(enemy.getEnemyPosition().x, enemy.getEnemyPosition().y) < gameManager.getGameLevelData().getLevel().TileSize / 4 then
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

    return moveOrder
end

return MoveOrder
