---@class Behavior
Behavior     = {}

---@param gameManager GameManager
---@param enemy Enemy
Behavior.new = function(gameManager, enemy)
    local behavior = {}

    setmetatable(behavior, Behavior)
    Behavior.__index   = Behavior

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local currentOrder
    local seenTiles    = {}
    local ignoredTiles = {}
    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    ---@public
    function behavior.update(_)

    end

    function behavior.getFirstUnSeenTilePosition()
        if enemy.getCollider() == nil then return end
        local position = enemy.getCollider().getPoint()
        local diffX    = 0
        local diffY    = 0

        while diffX * diffY <= gameManager.getGameLevelData().getLevel().Width * gameManager.getGameLevelData().getLevel().Height do
            local xMin = position.x - (gameManager.getGameLevelData().getLevel().TileSize * diffX)
            local yMin = position.y - (gameManager.getGameLevelData().getLevel().TileSize * diffY)
            local xMax = position.x + (gameManager.getGameLevelData().getLevel().TileSize * diffX)
            local yMax = position.y + (gameManager.getGameLevelData().getLevel().TileSize * diffY)

            while xMin <= xMax do
                while yMin <= yMax do
                    -- ---------------------------------
                    local tile = gameManager.getGameLevelData().getTileIndexFromRealPosition(xMin, yMin)
                    if (tile ~= nil and gameManager.getGameLevelData().isTileBlocked(tile)) then
                        ignoredTiles["ignored_" .. tostring(tile)] = true
                    elseif (tile ~= nil and seenTiles["inSight_" .. tostring(tile)] == nil and ignoredTiles["ignored_" .. tostring(tile)] == nil) then
                        local path = gameManager.getPathFinding().findPath(position, { x = xMin, y = yMin })
                        if path == nil then
                            ignoredTiles["ignored_" .. tostring(tile)] = true
                        else
                            return { x = xMin, y = yMin }
                        end
                    end
                    -- ---------------------------------
                    yMin = yMin + gameManager.getGameLevelData().getLevel().TileSize
                end
                xMin = xMin + gameManager.getGameLevelData().getLevel().TileSize
                yMin = position.y - diffY
            end

            diffX = diffX + 1
            diffY = diffY + 1
        end
        return nil
    end

    function behavior.updateTilesSeen(sight)
        if enemy.getCollider() == nil then return end
        local position    = enemy.getCollider().getPoint()
        local distInSight = ((sight) * gameManager.getGameLevelData().getLevel().TileSize)
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
                yMin = yMin + gameManager.getGameLevelData().getLevel().TileSize
            end
            xMin = xMin + gameManager.getGameLevelData().getLevel().TileSize
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
        local distance = range * gameManager.getGameLevelData().getLevel().TileSize
        if player == nil or player.getCollider() == nil or enemy.getCollider() == nil then
            return nil
        end
        if player.getCollider().getPoint().distance(enemy.getCollider().getPoint().x, enemy.getCollider().getPoint().y) < distance then return player end
        return nil
    end

    function behavior.searchFlagInRange(range)
        local flags    = gameManager.getPlayerOrNeutralFlags()
        local distance = range * gameManager.getGameLevelData().getLevel().TileSize
        for index = 1, #flags do
            local flag = flags[index]
            if flag.getCollider() == nil or enemy.getCollider() == nil then
                return nil
            end
            if flag.getCollider().getPoint().distance(enemy.getCollider().getPoint().x, enemy.getCollider().getPoint().y) < distance then return flag end
        end
        for index = 1, #flags do
            local flag      = flags[index]
            local flagIndex = gameManager.getGameLevelData().getTileIndexFromRealPosition(flag.getCollider().getPoint().x, flag.getCollider().getPoint().y)
            if seenTiles["inSight_" .. tostring(flagIndex)] ~= nil then
                return flag
            end
        end

        return nil
    end

    function behavior.setCurrentOrder(order)
        currentOrder = order
    end

    function behavior.resetCurrentOrder()
        currentOrder = nil
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
