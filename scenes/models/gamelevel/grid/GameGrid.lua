local Grid = require "scenes.models.gamelevel.grid.Grid"
local BitmapText = require "models.texts.BitmapText"
---@class GameGrid
GameGrid = {}

---@param gameLevelData GameLevelData
---@param gridViewPort GridViewPort
---@param layer Tables
GameGrid.new = function(gameLevelData, gridViewPort, layer)
    local gameGrid = Grid.new(gameLevelData.mapWidth, gameLevelData.mapHeight, gameLevelData.tileSize, {
        ---@type GridViewPort
        gridViewPort = gridViewPort,
        ---@type GameLevelData
        gameLevelData = gameLevelData,
        ---@type Tables
        layer = layer
    })

    setmetatable(gameGrid, GameGrid)
    GameGrid.__index = GameGrid

    local debugFont = love.graphics.newFont("assets/ui/ui-18.fnt")
    local debugText = love.graphics.newText(debugFont, "")

    function gameGrid.load()
        gameGrid.data.debugLog = BitmapText.new("debuglog", "assets/ui/ui-18.fnt", "", "center", "center", 0, 0)
        gameGrid.data.debugLog.load()
        return gameGrid
    end

    function gameGrid.draw()
        local x = gameGrid.data.gridViewPort.drawViewport.x
        local y = gameGrid.data.gridViewPort.drawViewport.y
        local vx = gameGrid.data.gridViewPort.viewport.x
        local vy = gameGrid.data.gridViewPort.viewport.y

        while x <= gameGrid.data.gridViewPort.drawViewport.width do
            while y <= gameGrid.data.gridViewPort.drawViewport.height do
                local tilePosition = gameGrid.data.gameLevelData.getGridPosition(vx, vy)
                if (tilePosition.x < 1 or tilePosition.y < 1 or tilePosition.x > gameGrid.data.gameLevelData.level.Width or tilePosition.y > gameGrid.data.gameLevelData.level.Height) then
                    break
                end
                gameGrid.data.gameLevelData.draw(x, y, vx, vy, gameGrid.data.layer)
                gameGrid.printDebug(x, y, vx, vy)
                y = y + gameGrid.data.gameLevelData.tileSize
                vy = vy + gameGrid.data.gameLevelData.tileSize
            end
            y = gameGrid.data.gridViewPort.drawViewport.y
            vy = gameGrid.data.gridViewPort.viewport.y
            x = x + gameGrid.data.gameLevelData.tileSize
            vx = vx + gameGrid.data.gameLevelData.tileSize
        end
    end

    function gameGrid.printDebug(realX, realY, vx, vy)
        if DEBUG == nil or DEBUG == false then return end
        local tilePosition = gameGrid.data.gameLevelData.getGridPosition(vx, vy)
        local content = gameGrid.data.gameLevelData.getTileIndex(tilePosition)
        local tileBlocked = gameGrid.data.gameLevelData.isTileBlocked(tilePosition)
        debugText:set(content)
        local originX = debugText:getWidth() / 2
        local originY = debugText:getHeight() / 2
        local textScale = 0.75
        love.graphics.draw(debugText, screenManager:ScaleValueX(realX + gameGrid.data.gameLevelData.tileSize / 2), screenManager:ScaleValueY(realY + gameGrid.data.gameLevelData.tileSize / 2), 0, textScale * screenManager:getScaleX(), textScale * screenManager:getScaleY(), originX, originY)

        if tileBlocked then
            love.graphics.setColor(1, 0, 0, 0.5)
        else
            love.graphics.setColor(1, 1, 1, 0.5)
        end

        love.graphics.polygon("line",
                screenManager:ScaleValueX(realX), screenManager:ScaleValueY(realY),
                screenManager:ScaleValueX(realX + gameGrid.data.gameLevelData.tileSize), screenManager:ScaleValueY(realY),
                screenManager:ScaleValueX(realX + gameGrid.data.gameLevelData.tileSize), screenManager:ScaleValueY(realY + gameGrid.data.gameLevelData.tileSize),
                screenManager:ScaleValueX(realX), screenManager:ScaleValueY(realY + gameGrid.data.gameLevelData.tileSize)
        )

        love.graphics.setColor(1, 1, 1, 1)
    end

    ---@param newViewPort GridViewPort
    ---@return GameGrid
    function gameGrid.setViewPort(newViewPort)
        gameGrid.data.gridViewPort = newViewPort
        return gameGrid
    end

    return gameGrid
end

return GameGrid
