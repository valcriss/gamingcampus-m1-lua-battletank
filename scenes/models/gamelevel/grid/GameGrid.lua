local Grid   = require "scenes.models.gamelevel.grid.Grid"
---@class GameGrid
GameGrid     = {}

---@param width number
---@param height number
---@param x number
---@param y number
---@param gameLevelData GameLevelData
GameGrid.new = function(gameLevelData, gridViewPort, layer)
    local gameGrid = Grid.new(gameLevelData.mapWidth, gameLevelData.mapHeight, gameLevelData.tileSize, {
        ---@type GridViewPort
        gridViewPort  = gridViewPort,
        ---@type GameLevelData
        gameLevelData = gameLevelData,
        ---@type Tables
        layer         = layer
    })

    setmetatable(gameGrid, GameGrid)
    GameGrid.__index = GameGrid

    local debugFont  = love.graphics.newFont("assets/ui/ui-18.fnt")
    local debugText  = love.graphics.newText(debugFont, "")

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
                gameGrid.data.gameLevelData.draw(x, y, vx,vy, gameGrid.data.layer)
                gameGrid.printDebug(x, y, tostring(tilePosition.x) .. "\n" .. tostring(tilePosition.y))
                y = y + gameGrid.data.gameLevelData.tileSize
                vy = vy + gameGrid.data.gameLevelData.tileSize
            end
            y = 0
            vy = gameGrid.data.gridViewPort.viewport.y
            x = x + gameGrid.data.gameLevelData.tileSize
            vx = vx + gameGrid.data.gameLevelData.tileSize
        end
    end

    function gameGrid.printDebug(realX, realY, content)
        debugText:set(content)
        local originX = debugText:getWidth() / 2
        local originY = debugText:getHeight() / 2
        local textScale = 0.75
        love.graphics.draw(debugText, screenManager:ScaleValueX(realX + gameGrid.data.gameLevelData.tileSize / 2), screenManager:ScaleValueY(realY + gameGrid.data.gameLevelData.tileSize / 2), 0, textScale * screenManager:getScaleX(), textScale * screenManager:getScaleY(), originX, originY)
        love.graphics.setColor(1, 1, 1, 0.5)
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
