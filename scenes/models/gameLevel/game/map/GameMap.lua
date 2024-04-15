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
        local renderBounds   = gameManager.getViewport().getRenderBounds()

        local x              = renderBounds.x
        local y              = renderBounds.y
        local vx             = 0
        local vy             = 0

        while x <= renderBounds.width do
            while y <= renderBounds.height do

                local tilePosition = gameManager.getGameLevelData().getGridPosition(vx, vy)
                if (tilePosition.x < 1 or tilePosition.y < 1 or tilePosition.x > gameManager.getGameLevelData().getLevel().Width or tilePosition.y > gameManager.getGameLevelData().getLevel().Height) then
                    break
                end
                local index            = gameManager.getGameLevelData().getTileIndex(tilePosition.x, tilePosition.y)
                local tileIndexLayout0 = gameManager.getGameLevelData().getImageIndexFromTileIndex(index, 0)
                local tileIndexLayout1 = gameManager.getGameLevelData().getImageIndexFromTileIndex(index, 1)
                if tileIndexLayout0 ~= nil and y >= -gameManager.getGameLevelData().getLevel().TileSize and x >= -gameManager.getGameLevelData().getLevel().TileSize then
                    table.insert(tilesToRenderLayout0, { x = x, y = y, tileIndex = tileIndexLayout0 })
                end
                if tileIndexLayout1 ~= nil and y >= -gameManager.getGameLevelData().getLevel().TileSize and x >= -gameManager.getGameLevelData().getLevel().TileSize then
                    table.insert(tilesToRenderLayout1, { x = x, y = y, tileIndex = tileIndexLayout1 })
                end

                y  = y + gameManager.getGameLevelData().getLevel().TileSize
                vy = vy + gameManager.getGameLevelData().getLevel().TileSize
            end
            y  = renderBounds.y
            vy = 0
            x  = x + gameManager.getGameLevelData().getLevel().TileSize
            vx = vx + gameManager.getGameLevelData().getLevel().TileSize
        end
    end

    ---@public
    function gameMap.draw()
        local tileScale = gameManager.getGameLevelData().getLevel().TileScale
        for _, cell in ipairs(tilesToRenderLayout0) do
            local image = gameManager.getGameLevelData().getTiles()[cell.tileIndex]
            love.graphics.draw(image, screenManager:ScaleValueX(cell.x), screenManager:ScaleValueY(cell.y), 0, tileScale * screenManager:getScaleX(), tileScale * screenManager:getScaleY())
        end
        for _, cell in ipairs(tilesToRenderLayout1) do
            local image = gameManager.getGameLevelData().getTiles()[cell.tileIndex]
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
