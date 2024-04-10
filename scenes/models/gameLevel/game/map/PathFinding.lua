---@class PathFinding
PathFinding     = {}

---@param gameManager GameManager
---@param enemy Enemy
PathFinding.new = function(gameManager)
    local pathFinding = {}

    setmetatable(pathFinding, PathFinding)
    PathFinding.__index  = PathFinding

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    ---@type GameLevelData
    local gameLevelData
    local neighborsCache = {}
    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    function pathFinding.load()
        gameLevelData = gameManager.getGameLevelData()
    end

    ---@public
    ---@param source Vector2
    ---@param destination Vector2
    function pathFinding.findPath(sourceEnemy, source, destination)
        local done             = {}
        local queue            = {}
        local sourceIndex      = gameLevelData.getTileIndexFromRealPosition(source.x + gameLevelData.data.level.TileSize / 2, source.y + gameLevelData.data.level.TileSize / 2)
        local destinationIndex = gameLevelData.getTileIndexFromRealPosition(destination.x + gameLevelData.data.level.TileSize / 2, destination.y + gameLevelData.data.level.TileSize / 2)
        local startingItem     = { sourceIndex }
        table.insert(queue, startingItem)
        while #queue > 0 do
            local currentPath = table.remove(queue, 1)
            local lastIndex   = currentPath[#currentPath]
            local neighbors   = pathFinding.getNeighbors(sourceEnemy, destination, lastIndex, done)
            for _, neighborIndex in ipairs(neighbors) do
                done["n" .. neighborIndex] = true
                if neighborIndex == destinationIndex then
                    table.insert(currentPath, neighborIndex)
                    return currentPath
                end
                local newPath = pathFinding.shallowCopy(currentPath)
                table.insert(newPath, neighborIndex)
                table.insert(queue, newPath)
            end
        end
        return nil
    end

    function pathFinding.shallowCopy(orig)
        local orig_type = type(orig)
        local copy
        if orig_type == 'table' then
            copy = {}
            for orig_key, orig_value in pairs(orig) do
                copy[orig_key] = orig_value
            end
        else
            -- number, string, boolean, etc
            copy = orig
        end
        return copy
    end

    function pathFinding.getNeighbors(sourceEnemy, destination, tileIndex, done)
        return gameLevelData.getNeighbors(sourceEnemy, gameManager, tileIndex, destination, done)
    end

    function pathFinding.clearCache()
        neighborsCache = {}
    end

    return pathFinding
end

return PathFinding