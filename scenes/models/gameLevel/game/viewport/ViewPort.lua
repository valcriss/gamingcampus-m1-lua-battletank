local Component = require "models.scenes.Component"
local Rectangle = require "models.drawing.Rectangle"

---@class ViewPort
ViewPort = {}

---@param gameManager GameManager
ViewPort.new = function(gameManager)

    local viewPort = Component.new("ViewPort", {
        gameManager = gameManager
    }, 0, 0)

    setmetatable(viewPort, ViewPort)
    ViewPort.__index = ViewPort

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local maxBounds = Rectangle.new()
    local realBounds = Rectangle.new()
    local renderBounds = Rectangle.new()

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------
    ---@public
    function viewPort.load()
        maxBounds = Rectangle.new(0, 0, gameManager.getGameLevelData().data.level.Width * gameManager.getGameLevelData().data.level.TileSize, gameManager.getGameLevelData().data.level.Height * gameManager.getGameLevelData().data.level.TileSize)
        viewPort.bounds.setPoint(gameManager.getGameLevelData().data.level.StartX, gameManager.getGameLevelData().data.level.StartY)
    end

    ---@public
    function viewPort.update(_)
        viewPort.updateRealBounds()
        viewPort.updateRenderBounds()
        viewPort.restrictViewPortPosition()
    end

    ---@public
    ---@return Rectangle
    function viewPort.getRealBounds()
        return realBounds
    end

    ---@public
    ---@return Rectangle
    function viewPort.getRenderBounds()
        return renderBounds
    end

    ---@public
    ---@return Rectangle
    function viewPort.getMaxBounds()
        return maxBounds
    end

    ---@public
    ---@return Vector2
    function viewPort.getRealPosition()
        return viewPort.bounds.getPoint()
    end

    function viewPort.verticalMove(value)
        viewPort.bounds.y = viewPort.bounds.y + value
    end

    function viewPort.horizontalMove(value)
        viewPort.bounds.x = viewPort.bounds.x + value
    end

    -- ---------------------------------------------
    -- Private Functions
    -- ---------------------------------------------

    ---@private
    function viewPort.restrictViewPortPosition()
        viewPort.bounds.x = math.min(maxBounds.width, math.max(0, viewPort.bounds.x))
        viewPort.bounds.y = math.min(maxBounds.height, math.max(0, viewPort.bounds.y))
    end

    ---@private
    function viewPort.updateRealBounds()
        realBounds = Rectangle.new(viewPort.bounds.x - screenManager:calculateCenterPointX(), viewPort.bounds.y - screenManager:calculateCenterPointY(), screenManager:getWindowWidth(), screenManager:getWindowHeight())
    end

    ---@private
    function viewPort.updateRenderBounds()
        local drawX  = (screenManager:getWindowWidth() / 2) - viewPort.bounds.x - (gameManager.getGameLevelData().data.level.TileSize / 2)
        local drawY  = (screenManager:getWindowHeight() / 2) - viewPort.bounds.y - (gameManager.getGameLevelData().data.level.TileSize / 2)
        renderBounds = Rectangle.new(drawX, drawY, screenManager:getWindowWidth(), screenManager:getWindowHeight())
    end

    return viewPort
end

return ViewPort
