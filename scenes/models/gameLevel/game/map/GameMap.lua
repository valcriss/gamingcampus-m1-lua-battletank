local Component = require "models.scenes.Component"

---@class GameMap
GameMap         = {}

--- @param gameManager GameManager
GameMap.new     = function(gameManager)
    local gameMap = Component.new("GameMap")

    setmetatable(gameMap, GameMap)
    GameMap.__index            = GameMap

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local tilesToRenderLayout0 = {}
    local tilesToRenderLayout1 = {}
    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    ---@public
    function gameMap.update(_)
        tilesToRenderLayout0 = {}
        tilesToRenderLayout1 = {}
        local renderBounds   = gameManager.getViewport().getMapRenderBounds()
        local mapBounds      = gameManager.getViewport().getMapBounds()
        local renderX        = mapBounds.x
        local renderY        = mapBounds.y
        local tileSize       = gameManager.getGameLevelData().data.level.TileSize

        for realX = renderBounds.x, renderBounds.width, tileSize do
            for realY = renderBounds.y, renderBounds.height, tileSize do
                local index      = gameManager.getGameLevelData().getTileIndexFromRealPosition(realX, realY)
                local tileIndex0 = gameManager.getGameLevelData().getImageIndexFromTileIndex(index, 0)
                local tileIndex1 = gameManager.getGameLevelData().getImageIndexFromTileIndex(index, 1)

                if tileIndex0 == nil then tileIndex0 = "tile_56" end

                if tileIndex0 ~= nil then
                    table.insert(tilesToRenderLayout0, { x = renderX, y = renderY, tileIndex = tileIndex0 })
                end
                if tileIndex1 ~= nil then
                    table.insert(tilesToRenderLayout1, { x = renderX, y = renderY, tileIndex = tileIndex1 })
                end
                renderY = renderY + tileSize
            end
            renderY = mapBounds.y
            renderX = renderX + tileSize
        end
    end

    ---@public
    function gameMap.draw()
        local tileScale = gameManager.getGameLevelData().data.level.TileScale
        for _, cell in ipairs(tilesToRenderLayout0) do
            local image = gameManager.getGameLevelData().data.tiles[cell.tileIndex]
            love.graphics.draw(image, screenManager:ScaleValueX(cell.x), screenManager:ScaleValueY(cell.y), 0, tileScale * screenManager:getScaleX(), tileScale * screenManager:getScaleY())
        end
        for _, cell in ipairs(tilesToRenderLayout1) do
            local image = gameManager.getGameLevelData().data.tiles[cell.tileIndex]
            love.graphics.draw(image, screenManager:ScaleValueX(cell.x), screenManager:ScaleValueY(cell.y), 0, tileScale * screenManager:getScaleX(), tileScale * screenManager:getScaleY())
        end
    end

    ---@public
    ---@return number
    function gameMap.getTilesToRenderLayout0()
        return #tilesToRenderLayout0
    end

    ---@public
    ---@return number
    function gameMap.getTilesToRenderLayout1()
        return #tilesToRenderLayout1
    end

    return gameMap
end

return GameMap
