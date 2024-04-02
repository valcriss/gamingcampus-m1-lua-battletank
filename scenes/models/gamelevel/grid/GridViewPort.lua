local Rectangle  = require "models.drawing.Rectangle"
---@class GridViewPort
GridViewPort     = {}

---@param gameLevelData GameLevelData
GridViewPort.new = function(gameLevelData)
    local gridViewPort = {
        gameLevelData = gameLevelData,
        bounds        = Rectangle.new(0, 0, gameLevelData.level.Width * gameLevelData.tileSize, gameLevelData.level.Height * gameLevelData.tileSize),
        padding       = gameLevelData.tileSize / 2,
        x             = gameLevelData.getRealPosition(gameLevelData.startX, gameLevelData.startY).x,
        y             = gameLevelData.getRealPosition(gameLevelData.startX, gameLevelData.startY).y,
        viewport      = nil,
        drawViewport  = nil,
        drawPosition  = nil
    }

    setmetatable(gridViewPort, GridViewPort)
    GridViewPort.__index = GridViewPort

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local font           = love.graphics.getFont()
    local debug          = love.graphics.newText(font, "")
    -- ---------------------------------------------
    -- Functions
    -- ---------------------------------------------
    ---@return GridViewPort
    function gridViewPort.load()
        gridViewPort.viewport = gridViewPort.calculateViewport()
        return gridViewPort
    end

    function gridViewPort.update(_)
        gridViewPort.viewport = gridViewPort.calculateViewport()
    end

    function gridViewPort.draw()
        gridViewPort.drawDebug()
    end

    function gridViewPort.drawDebug()
        if DEBUG == nil or DEBUG == false then return end
        love.graphics.setColor(1, 1, 1, 0.75)
        local boxX      = 5
        local boxY      = 5
        local boxWidth  = 450
        local boxHeight = 100
        love.graphics.polygon("fill",
                              screenManager:ScaleValueX(boxX), screenManager:ScaleValueY(boxY),
                              screenManager:ScaleValueX(boxX + boxWidth), screenManager:ScaleValueY(boxY),
                              screenManager:ScaleValueX(boxX + boxWidth), screenManager:ScaleValueY(boxY + boxHeight),
                              screenManager:ScaleValueX(boxX), screenManager:ScaleValueY(boxY + boxHeight)
        )

        love.graphics.setColor(1, 0, 0, 1)
        debug:set("gridViewPort.bounds : " .. gridViewPort.bounds.toString())
        love.graphics.draw(debug, screenManager:ScaleValueX(10), screenManager:ScaleValueY(25), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        debug:set("gridViewPort.viewport : " .. gridViewPort.viewport.toString())
        love.graphics.draw(debug, screenManager:ScaleValueX(10), screenManager:ScaleValueY(40), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        debug:set("gridViewPort.x and gridViewPort.y : " .. gridViewPort.x .. " " .. gridViewPort.y)
        love.graphics.draw(debug, screenManager:ScaleValueX(10), screenManager:ScaleValueY(55), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        debug:set("gridViewPort.drawViewport : " .. gridViewPort.drawViewport.toString())
        love.graphics.draw(debug, screenManager:ScaleValueX(10), screenManager:ScaleValueY(70), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)
        local gridPosition = gridViewPort.gameLevelData.getGridPosition(gridViewPort.x, gridViewPort.y)
        debug:set("gridViewPort.TileX and gridViewPort.TileY : " .. gridPosition.x .. " " .. gridPosition.y)
        love.graphics.draw(debug, screenManager:ScaleValueX(10), screenManager:ScaleValueY(85), 0, screenManager:getScaleX(), screenManager:getScaleY(), 0, 0)

        love.graphics.setColor(1, 1, 1, 1)
    end

    function gridViewPort.calculateViewport()
        local v      = Rectangle.new(0, 0, screenManager:getWindowWidth(), screenManager:getWindowHeight())

        local drawX  = (screenManager:getWindowWidth() / 2) - gridViewPort.x - (gridViewPort.gameLevelData.tileSize / 2)
        local drawY  = (screenManager:getWindowHeight() / 2) - gridViewPort.y - (gridViewPort.gameLevelData.tileSize / 2)

        gridViewPort.drawViewport   = Rectangle.new(drawX, drawY, screenManager:getWindowWidth(), screenManager:getWindowHeight())
        gridViewPort.drawPosition   = { x = (gridViewPort.x / (v.x + v.width + v.x)) * screenManager:getWindowWidth(), y = (gridViewPort.y / (v.y + v.height + v.y)) * screenManager:getWindowHeight() }
        gridViewPort.drawPosition.x = math.min(screenManager:getWindowWidth() - gridViewPort.padding, math.max(gridViewPort.padding, gridViewPort.drawPosition.x))
        gridViewPort.drawPosition.y = math.min(screenManager:getWindowHeight() - gridViewPort.padding, math.max(gridViewPort.padding, gridViewPort.drawPosition.y))

        return v
    end

    return gridViewPort
end

return GridViewPort
