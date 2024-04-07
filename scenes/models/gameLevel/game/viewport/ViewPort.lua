local Component = require "models.scenes.Component"
local Rectangle = require "models.drawing.Rectangle"

---@class ViewPort
ViewPort        = {}

---@param gameManager GameManager
ViewPort.new    = function(gameManager)

    local viewPort = Component.new("ViewPort", {
        gameManager = gameManager
    }, 0, 0)

    setmetatable(viewPort, ViewPort)
    ViewPort.__index      = ViewPort

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local maxBounds       = Rectangle.new()
    local realBounds      = Rectangle.new()
    local mapBounds       = Rectangle.new()
    local mapRenderBounds = Rectangle.new()

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
        viewPort.updateMapBounds()
        viewPort.restrictViewPortPosition()
    end

    ---@public
    ---@return Rectangle
    function viewPort.getRealBounds()
        return realBounds
    end

    ---@public
    ---@return Rectangle
    function viewPort.getMapBounds()
        return mapBounds
    end

    ---@public
    ---@return Rectangle
    function viewPort.getMapRenderBounds()
        return mapRenderBounds
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
    function viewPort.updateMapBounds()
        -- Calcul de la largeur et hauteur maximum
        local maxWidth  = gameManager.getGameLevelData().data.level.Width * gameManager.getGameLevelData().data.level.TileSize
        local maxHeight = gameManager.getGameLevelData().data.level.Height * gameManager.getGameLevelData().data.level.TileSize
        -- Calcul de la position du viewport
        local x         = screenManager:calculateCenterPointX() - viewPort.bounds.x
        local y         = screenManager:calculateCenterPointY() - viewPort.bounds.y
        local width     = screenManager:getWindowWidth()
        local height    = screenManager:getWindowHeight()

        -- Calcul du viewport limité par la fenêtre
        if realBounds.x < 0 then
            width = screenManager:getWindowWidth() + realBounds.x
        end
        if realBounds.x + width > maxWidth then
            width = maxWidth - realBounds.x
        end
        if realBounds.y < 0 then
            height = screenManager:getWindowHeight() + realBounds.y
        end
        if realBounds.y + height > maxHeight then
            height = maxHeight - realBounds.y
        end
        local offset    = gameManager.getGameLevelData().data.level.TileSize / 2
        mapBounds       = Rectangle.new(x, y, width, height).offsetPosition(-offset, -offset).offsetSize(offset * 2, offset * 2)
        mapRenderBounds = Rectangle.new(math.max(0, realBounds.x), math.max(0, realBounds.y), width, height)
    end

    return viewPort
end

return ViewPort
