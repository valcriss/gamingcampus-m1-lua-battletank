local JsonAsset   = require "models.tools.JsonAsset"
local Component   = require "models.scenes.Component"
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

    -- ---------------------------------------------
    -- Private Functions
    -- ---------------------------------------------

    ---@private
    ---@return string
    function gameLevelData.getLevelAsset()
        if configuration.getLevel() == 1 then return "assets/levels/level1.json" end
        return nil
    end

    return gameLevelData
end

return GameLevelData
