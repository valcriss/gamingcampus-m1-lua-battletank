local JsonAsset   = require "models.tools.JsonAsset"
local Component   = require "models.scenes.Component"
local Vector2     = require "models.drawing.Vector2"

---@class GameLevelData
GameLevelData     = {}

GameLevelData.new = function()
    local gameLevelData = Component.new("GameLevelData", {
        level = nil,
        tiles = {}
    })

    setmetatable(gameLevelData, GameLevelData)
    GameLevelData.__index = GameLevelData

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    ---@public
    ---@param sourceEnemy Enemy
    ---@param gameManager GameManager
    ---@param index number
    function gameLevelData.getNeighbors(index)
        local neighbors = {}
        --- Normals
        local topIndex  = index - gameLevelData.data.level.Width
        if topIndex >= 1 and not gameLevelData.isTileBlocked(topIndex) and not gameLevelData.isTileBlocked(topIndex) then
            neighbors["top"] = topIndex
        end
        local bottomIndex = index + gameLevelData.data.level.Width
        if bottomIndex <= gameLevelData.data.level.Width * gameLevelData.data.level.Height and not gameLevelData.isTileBlocked(bottomIndex) then
            neighbors["bottom"] = bottomIndex
        end
        local leftIndex = index - 1
        if leftIndex % gameLevelData.data.level.Width ~= 0 and not gameLevelData.isTileBlocked(leftIndex) then
            neighbors["left"] = leftIndex
        end
        local rightIndex = index + 1
        if rightIndex % gameLevelData.data.level.Width ~= 0 and not gameLevelData.isTileBlocked(rightIndex) then
            neighbors["right"] = rightIndex
        end
        --- Diagonals
        local topRightIndex = (index - gameLevelData.data.level.Width) + 1
        if topRightIndex >= 1 and topRightIndex % gameLevelData.data.level.Width ~= 0 and not gameLevelData.isTileBlocked(topRightIndex) and not gameLevelData.isTileBlocked(topIndex) and not gameLevelData.isTileBlocked(rightIndex) then
            neighbors["topRight"] = topRightIndex
        end
        local topLeftIndex = (index - gameLevelData.data.level.Width) - 1
        if topLeftIndex >= 1 and topLeftIndex % gameLevelData.data.level.Width ~= 0 and not gameLevelData.isTileBlocked(topLeftIndex) and not gameLevelData.isTileBlocked(topIndex) and not gameLevelData.isTileBlocked(leftIndex) then
            neighbors["topLeft"] = topLeftIndex
        end
        local bottomRightIndex = (index + gameLevelData.data.level.Width) + 1
        if bottomRightIndex <= gameLevelData.data.level.Width * gameLevelData.data.level.Height and bottomRightIndex % gameLevelData.data.level.Width ~= 0 and not gameLevelData.isTileBlocked(bottomIndex) and not gameLevelData.isTileBlocked(bottomRightIndex) and not gameLevelData.isTileBlocked(rightIndex) then
            neighbors["bottomRight"] = bottomRightIndex
        end
        local bottomLeftIndex = (index + gameLevelData.data.level.Width) - 1
        if bottomLeftIndex <= gameLevelData.data.level.Width * gameLevelData.data.level.Height and bottomLeftIndex % gameLevelData.data.level.Width ~= 0 and not gameLevelData.isTileBlocked(bottomIndex) and not gameLevelData.isTileBlocked(bottomLeftIndex) and not gameLevelData.isTileBlocked(leftIndex) then
            neighbors["bottomLeft"] = bottomLeftIndex
        end

        return neighbors
    end

    ---@public
    function gameLevelData.load()
        local levelAsset         = gameLevelData.getLevelAsset()
        gameLevelData.data.level = JsonAsset:load(levelAsset)
        for key, value in pairs(gameLevelData.data.level.TilesAssets) do
            gameLevelData.data.tiles[key] = love.graphics.newImage(value)
        end
    end

    ---@public
    ---@param realX number
    ---@param realY number
    ---@return number
    function gameLevelData.getTileIndexFromRealPosition(realX, realY)
        local position = gameLevelData.getGridPosition(realX, realY)
        return gameLevelData.getTileIndex(position.x, position.y)
    end

    ---@public
    ---@param gridX number
    ---@param gridY number
    ---@return number
    function gameLevelData.getTileIndex(gridX, gridY)
        local index = ((gridY - 1) * gameLevelData.data.level.Width) + gridX
        if index < 1 or index > gameLevelData.data.level.Width * gameLevelData.data.level.Height then return nil end
        return index
    end

    ---@public
    ---@param realX number
    ---@param realY number
    ---@return { x: number, y: number }
    function gameLevelData.getGridPosition(realX, realY)
        return {
            x = math.floor(realX / gameLevelData.data.level.TileSize) + 1,
            y = math.floor(realY / gameLevelData.data.level.TileSize) + 1
        }
    end

    ---@public
    ---@param tileIndex number
    ---@param layer number
    ---@return number
    function gameLevelData.getImageIndexFromTileIndex(tileIndex, layer)
        return gameLevelData.data.level["Layer" .. tostring(layer)]["cell_" .. tostring(tileIndex)]
    end

    function gameLevelData.isTileBlocked(tileIndex)
        return gameLevelData.data.level["Block"]["block_" .. tostring(tileIndex)] == true
    end

    function gameLevelData.isTileEnvironmentBlocked(tileIndex)
        return gameLevelData.data.level["Layer1"]["cell_" .. tostring(tileIndex)] ~= nil and gameLevelData.isTileBlocked(tileIndex)
    end

    function gameLevelData.isTileBlockedFromGridPosition(gridPosition)
        local tileIndex = gameLevelData.getTileIndex(gridPosition.x, gridPosition.y)
        return gameLevelData.isTileBlocked(tileIndex)
    end

    function gameLevelData.getMainTowerWorldPosition(group)
        if group == 1 then
            return gameLevelData.getPlayerMainTowerWorldPosition()
        else
            return gameLevelData.getEnemyMainTowerWorldPosition()
        end
    end

    function gameLevelData.getPlayerMainTowerWorldPosition()
        return gameLevelData.translateGridPositionToWorldPosition(gameLevelData.data.level.PlayerBase.x, gameLevelData.data.level.PlayerBase.y)
    end

    function gameLevelData.getEnemyMainTowerWorldPosition()
        return gameLevelData.translateGridPositionToWorldPosition(gameLevelData.data.level.EnemyBase.x, gameLevelData.data.level.EnemyBase.y)
    end

    function gameLevelData.translateGridPositionToWorldPosition(x, y)
        return Vector2.new((x - 1) * gameLevelData.data.level.TileSize, (y - 1) * gameLevelData.data.level.TileSize)
    end

    function gameLevelData.getRealPositionFromTileIndex(tileIndex)
        local gridPosition = gameLevelData.getGridPositionFromTileIndex(tileIndex)
        return gameLevelData.translateGridPositionToWorldPosition(gridPosition.x, gridPosition.y)
    end

    function gameLevelData.getGridPositionFromTileIndex(tileIndex)
        local x = (tileIndex - 1) % gameLevelData.data.level.Width + 1
        local y = math.floor((tileIndex - 1) / gameLevelData.data.level.Width) + 1
        return { x = x, y = y }
    end

    -- ---------------------------------------------
    -- Private Functions
    -- ---------------------------------------------

    ---@private
    ---@return string
    function gameLevelData.getLevelAsset()
        if configuration.getLevel() == 1 then return "assets/levels/level1.json" end
        if configuration.getLevel() == 2 then return "assets/levels/level2.json" end
        if configuration.getLevel() == 3 then return "assets/levels/level3.json" end
        return nil
    end

    return gameLevelData
end

return GameLevelData
