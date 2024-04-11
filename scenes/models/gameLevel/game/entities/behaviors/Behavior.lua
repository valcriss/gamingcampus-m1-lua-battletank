---@class Behavior
Behavior     = {}

---@param gameManager GameManager
---@param enemy Enemy
Behavior.new = function(gameManager, enemy)
    local behavior = {}

    setmetatable(behavior, Behavior)
    Behavior.__index = Behavior

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local currentPath
    local currentOrder
    local seenTiles  = {}
    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    ---@public
    function behavior.update(_)

    end

    function behavior.updateTilesSeen(sight)
        if enemy.getCollider() == nil then return end
        local position    = enemy.getCollider().getPoint()
        local distInSight = ((sight) * gameManager.getGameLevelData().data.level.TileSize)
        local xMin        = position.x - distInSight
        local yMin        = position.y - distInSight
        local xMax        = position.x + distInSight
        local yMax        = position.y + distInSight

        while xMin <= xMax do
            while yMin <= yMax do
                -- ---------------------------------
                local tile     = gameManager.getGameLevelData().getTileIndexFromRealPosition(xMin, yMin)
                local distance = position.distance(xMin, yMin)
                if (distance <= distInSight) then
                    seenTiles["inSight_" .. tostring(tile)] = true
                end
                -- ---------------------------------
                yMin = yMin + gameManager.getGameLevelData().data.level.TileSize
            end
            xMin = xMin + gameManager.getGameLevelData().data.level.TileSize
            yMin = position.y - distInSight
        end
    end

    -- ---------------------------------------------
    -- Protected Functions
    -- ---------------------------------------------
    ---@protected
    ---@param position Vector2
    function behavior.getClosestEmptyTileFromPoint(destination, position)
        local tileIndex = gameManager.getGameLevelData().getTileIndexFromRealPosition(destination.x, destination.y)
        local neighbors = gameManager.getGameLevelData().getNeighbors(tileIndex)
        table.sort(neighbors, function(a, b) return gameManager.getGameLevelData().getRealPositionFromTileIndex(a).distance(position.x, position.y) < gameManager.getGameLevelData().getRealPositionFromTileIndex(b).distance(position.x, position.y) end)
        if #neighbors == 0 then return nil end
        return neighbors[1]
    end

    function behavior.searchPlayerInRange(range)
        local player   = gameManager.getPlayer()
        local distance = range * gameManager.getGameLevelData().data.level.TileSize
        if player == nil or player.getCollider() == nil or enemy.getCollider() == nil then
            return nil
        end
        if player.getCollider().getPoint().distance(enemy.getCollider().getPoint().x, enemy.getCollider().getPoint().y) < distance then return player end
        return nil
    end

    function behavior.searchFlagInRange(range)
        local flags    = gameManager.getPlayerOrNeutralFlags()
        local distance = range * gameManager.getGameLevelData().data.level.TileSize
        for index = 1, #flags do
            local flag = flags[index]
            if flag.getCollider() == nil or enemy.getCollider() == nil then
                return nil
            end
            if flag.getCollider().getPoint().distance(enemy.getCollider().getPoint().x, enemy.getCollider().getPoint().y) < distance then return flag end
        end
        return nil
    end

    function behavior.setCurrentPath(path)
        currentPath = path
    end

    function behavior.setCurrentOrder(order)
        currentOrder = order
    end

    function behavior.resetCurrentOrder()
        currentOrder = nil
    end

    function behavior.getCurrentPath()
        return currentPath
    end

    function behavior.getCurrentOrder()
        return currentOrder
    end

    function behavior.getSeenTiles()
        return seenTiles
    end

    return behavior
end

return Behavior
