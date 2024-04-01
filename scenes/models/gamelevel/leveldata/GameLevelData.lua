---@class GameLevelData
GameLevelData     = {}

GameLevelData.new = function(name, layer0, layer1, startX, startY, mapWidth, mapHeight, baseTile)
    baseTile            = baseTile or 1
    local gameLevelData = {
        name        = name,
        layer0      = layer0,
        layer1      = layer1,
        startX      = startX,
        startY      = startY,
        mapWidth    = mapWidth,
        mapHeight   = mapHeight,
        baseTile    = baseTile,
        tileSize    = 64,
        tileScale   = 0.5,
        tilesAssets = {
            "assets/gamelevel/tiles/tile_23.png", -- 1
            "assets/gamelevel/tiles/tile_06.png", -- 2
            "assets/gamelevel/tiles/tile_06.png", -- 3
            "assets/gamelevel/tiles/tile_07.png", -- 4
            "assets/gamelevel/tiles/tile_09.png", -- 5
            "assets/gamelevel/tiles/tile_22.png", -- 6
            "assets/gamelevel/tiles/tile_54.png", -- 7
            "assets/gamelevel/tiles/tile_56.png", -- 8
            "assets/gamelevel/tiles/tile_57.png", -- 9
            "assets/gamelevel/tiles/tile_41.png", -- 10
        },
        tiles       = {}
    }
    setmetatable(gameLevelData, GameLevelData)
    GameLevelData.__index = GameLevelData

    ---@return GameLevelData
    function gameLevelData.load()
        for _, tileAsset in ipairs(gameLevelData.tilesAssets) do
            print("Loading tile: " .. tileAsset)
            table.insert(gameLevelData.tiles, love.graphics.newImage(tileAsset))
        end
        return gameLevelData
    end

    function gameLevelData.draw(x, y, realX, realY, layer)
        local tilePosition = gameLevelData.getGridPosition(realX, realY)
        local index        = tostring(gameLevelData.getTileIndex(tilePosition))
        local tileIndex    = gameLevelData.baseTile
        if layer["cell_" .. index] then
            tileIndex = layer["cell_" .. index]
        end
        local image = gameLevelData.tiles[tileIndex]
        love.graphics.draw(image, screenManager:ScaleValueX(x), screenManager:ScaleValueY(y), 0, gameLevelData.tileScale * screenManager:getScaleX(), gameLevelData.tileScale * screenManager:getScaleY())
    end

    function gameLevelData.getTileIndex(tilePosition)
        return ((tilePosition.y - 1) * gameLevelData.mapWidth) + tilePosition.x
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
