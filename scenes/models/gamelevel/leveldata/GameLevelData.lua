local JsonAsset   = require "models.tools.JsonAsset"
---@class GameLevelData
GameLevelData     = {}

GameLevelData.new = function(name, levelAsset, startX, startY, baseTile)
    baseTile            = baseTile or 1
    local gameLevelData = {
        name      = name,
        level     = JsonAsset:load(levelAsset),
        startX    = startX,
        startY    = startY,
        baseTile  = baseTile,
        tileSize  = 64,
        tileScale = 0.5,
        tiles     = {}
    }
    setmetatable(gameLevelData, GameLevelData)
    GameLevelData.__index = GameLevelData

    ---@return GameLevelData
    function gameLevelData.load()
        for key, value in pairs(gameLevelData.level.TilesAssets) do
            print("Loading tile: [" .. key .. "]=" .. value)
            gameLevelData.tiles[key] = love.graphics.newImage(value)
        end
        return gameLevelData
    end

    function gameLevelData.draw(x, y, realX, realY, layer)
        local tilePosition = gameLevelData.getGridPosition(realX, realY)
        local image = gameLevelData.getTileImage(tilePosition, layer)
        if image == nil then return end
        love.graphics.draw(image, screenManager:ScaleValueX(x), screenManager:ScaleValueY(y), 0, gameLevelData.tileScale * screenManager:getScaleX(), gameLevelData.tileScale * screenManager:getScaleY())
    end

    function gameLevelData.getTileImage(tilePosition, layer)
        local index        = gameLevelData.getTileIndex(tilePosition)
        local tileIndex
        if layer["cell_" .. index] then
            tileIndex = layer["cell_" .. index]
        end
        if tileIndex == nil then return nil end
        local image = gameLevelData.tiles[tileIndex]
        return image
    end

    function gameLevelData.isTileBlocked(tilePosition)
        if(tilePosition.x <=0 or tilePosition.y <= 0) then return true end
        local index        = gameLevelData.getTileIndex(tilePosition)
        local v = gameLevelData.level.Block["block_" .. tostring(index)]
        if v == nil then return false end
        if v == true then return true end
        return false
    end

    function gameLevelData.getTileIndex(tilePosition)
        return ((tilePosition.y - 1) * gameLevelData.level.Width) + tilePosition.x
    end

    function gameLevelData.getRealPosition(x, y)
        return {
            x = (x - 1) * gameLevelData.tileSize,
            y = (y - 1) * gameLevelData.tileSize
        }
    end

    function gameLevelData.getGridPosition(x, y)
        return {
            x = math.floor(x / gameLevelData.tileSize) + 1,
            y = math.floor(y / gameLevelData.tileSize) + 1
        }
    end

    return gameLevelData
end

return GameLevelData
