local Component       = require "models.scenes.Component"

---@class GameMapTilesDebug
GameMapTilesDebug     = {}

--- @param gameManager GameManager
GameMapTilesDebug.new = function(gameManager)
    local gameMapTilesDebug = Component.new("GameMapTilesDebug")

    setmetatable(gameMapTilesDebug, GameMapTilesDebug)
    GameMapTilesDebug.__index = GameMapTilesDebug

    local tilesToRender       = {}
    local debugFont           = love.graphics.newFont("assets/ui/ui-18.fnt")
    local debugText           = love.graphics.newText(debugFont, "")

    function gameMapTilesDebug.update(_)
        tilesToRender      = {}
        local renderBounds = gameManager.getViewport().getRenderBounds()

        local x            = renderBounds.x
        local y            = renderBounds.y
        local vx           = 0
        local vy           = 0

        while x <= renderBounds.width do
            while y <= renderBounds.height do

                local tilePosition = gameManager.getGameLevelData().getGridPosition(vx, vy)
                if (tilePosition.x < 1 or tilePosition.y < 1 or tilePosition.x > gameManager.getGameLevelData().data.level.Width or tilePosition.y > gameManager.getGameLevelData().data.level.Height) then
                    break
                end
                local index   = gameManager.getGameLevelData().getTileIndex(tilePosition.x, tilePosition.y)
                local blocked = gameManager.getGameLevelData().isTileBlocked(index)
                if y >= -gameManager.getGameLevelData().data.level.TileSize and x >= -gameManager.getGameLevelData().data.level.TileSize then
                    table.insert(tilesToRender, { x = x, y = y, tileIndex = index, tilePosition = tilePosition, blocked = blocked })
                end

                y  = y + gameManager.getGameLevelData().data.level.TileSize
                vy = vy + gameManager.getGameLevelData().data.level.TileSize
            end
            y  = renderBounds.y
            vy = 0
            x  = x + gameManager.getGameLevelData().data.level.TileSize
            vx = vx + gameManager.getGameLevelData().data.level.TileSize
        end

        table.sort(tilesToRender, function(a, b)
            if a.blocked and not b.blocked then return false end
            if b.blocked and not a.blocked then return true end
            return false
        end)
    end

    ---@public
    function gameMapTilesDebug.draw()
        for _, cell in ipairs(tilesToRender) do
            if cell.blocked then
                gameMapTilesDebug.drawRectangle("fill", cell, { r = 1, g = 0, b = 0, a = 0.25 })
                gameMapTilesDebug.drawRectangle("line", cell, { r = 1, g = 0, b = 0, a = 1 })
            else
                gameMapTilesDebug.drawRectangle("line", cell, { r = 0.5, g = 0.5, b = 0.5, a = 1 })
            end

            gameMapTilesDebug.drawText(cell, tostring(cell.tileIndex), screenManager:ScaleValueY(-15))
            gameMapTilesDebug.drawText(cell, tostring(math.floor(cell.tilePosition.x)) .. " - " .. tostring(math.floor(cell.tilePosition.y)), screenManager:ScaleValueY(15))
        end
        love.graphics.setColor(1, 1, 1, 1)
    end

    function gameMapTilesDebug.drawRectangle(mode, cell, color)
        love.graphics.setColor(color.r, color.g, color.b, color.a)
        love.graphics.rectangle(mode, screenManager:ScaleValueX(cell.x), screenManager:ScaleValueY(cell.y), screenManager:ScaleValueX(gameManager.getGameLevelData().data.level.TileSize), screenManager:ScaleValueY(gameManager.getGameLevelData().data.level.TileSize))
    end

    function gameMapTilesDebug.drawText(cell, text, offsetY)
        love.graphics.setColor(1, 1, 1, 1)
        debugText:set(text)
        local originX   = debugText:getWidth() / 2
        local originY   = debugText:getHeight() / 2
        local textScale = 0.7
        love.graphics.draw(debugText, screenManager:ScaleValueX(cell.x + gameManager.getGameLevelData().data.level.TileSize / 2), screenManager:ScaleValueY(cell.y + (gameManager.getGameLevelData().data.level.TileSize / 2) + offsetY), 0, textScale * screenManager:getScaleX(), textScale * screenManager:getScaleY(), originX, originY)
    end

    return gameMapTilesDebug
end

return GameMapTilesDebug
