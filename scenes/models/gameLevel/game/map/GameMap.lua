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
        local realPosition   = gameManager.getViewport().getRealPosition()
        local renderBounds   = gameManager.getViewport().getRenderBounds()

        local x              = renderBounds.x
        local y              = renderBounds.y
        local vx             = realPosition.x
        local vy             = realPosition.y
        print("x: " .. x .. " y: " .. y .. " vx: " .. vx .. " vy: " .. vy)
        while x <= renderBounds.width do
            while y <= renderBounds.height do
                if x < -gameManager.getGameLevelData().data.level.TileSize or y < -gameManager.getGameLevelData().data.level.TileSize then break end
                local tilePosition = gameManager.getGameLevelData().getGridPosition(vx, vy)
                if (tilePosition.x < 1 or tilePosition.y < 1 or tilePosition.x > gameManager.getGameLevelData().data.level.Width or tilePosition.y > gameManager.getGameLevelData().data.level.Height) then
                    break
                end
                local index      = gameManager.getGameLevelData().getTileIndex(tilePosition.x, tilePosition.y)
                local tileIndex0 = gameManager.getGameLevelData().getImageIndexFromTileIndex(index, 0) or "tile_56"
                local tileIndex1 = gameManager.getGameLevelData().getImageIndexFromTileIndex(index, 1)
                if tileIndex0 ~= nil then
                    table.insert(tilesToRenderLayout0, { x = x, y = y, tileIndex = tileIndex0 })
                end
                if tileIndex1 ~= nil then
                    table.insert(tilesToRenderLayout1, { x = x, y = y, tileIndex = tileIndex1 })
                end
                y  = y + gameManager.getGameLevelData().data.level.TileSize
                vy = vy + gameManager.getGameLevelData().data.level.TileSize
            end
            y  = renderBounds.y
            vy = realPosition.y
            x  = x + gameManager.getGameLevelData().data.level.TileSize
            vx = vx + gameManager.getGameLevelData().data.level.TileSize
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
