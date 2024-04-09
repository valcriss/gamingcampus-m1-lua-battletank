local Component = require "models.scenes.Component"
local Rectangle = require "models.drawing.Rectangle"
local Vector2 = require "models.drawing.Vector2"

---@class ViewPort
ViewPort = {}

---@param gameManager GameManager
ViewPort.new = function(gameManager)

    local viewPort = Component.new("ViewPort")

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
        viewPort.bounds.setPoint((gameManager.getGameLevelData().data.level.StartX - 1) * gameManager.getGameLevelData().data.level.TileSize, (gameManager.getGameLevelData().data.level.StartY - 1) * gameManager.getGameLevelData().data.level.TileSize)
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

    function viewPort.playerInputs(dt, top, left, bottom, right)
        local previousBounds = Rectangle.new(viewPort.bounds.x, viewPort.bounds.y, viewPort.bounds.width, viewPort.bounds.height)
        local speed = 500

        if top then
            viewPort.verticalMove(-speed * dt)
        end
        if left then
            viewPort.horizontalMove(-speed * dt)
        end
        if bottom then
            viewPort.verticalMove(speed * dt)
        end
        if right then
            viewPort.horizontalMove(speed * dt)
        end

        if viewPort.newPositionIsInvalid() then
            viewPort.bounds = previousBounds
        end
    end

    function viewPort.newPositionIsInvalid()
        local ref = viewPort.bounds.getPoint()
        local border = (gameManager.getGameLevelData().data.level.TileSize)
        local tilePosition1 = gameManager.getGameLevelData().getGridPosition(ref.x, ref.y)
        local tilePosition2 = gameManager.getGameLevelData().getGridPosition(ref.x + border, ref.y)
        local tilePosition3 = gameManager.getGameLevelData().getGridPosition(ref.x + border, ref.y + border)
        local tilePosition4 = gameManager.getGameLevelData().getGridPosition(ref.x, ref.y + border)
        return gameManager.getGameLevelData().isTileBlockedFromGridPosition(tilePosition1) or
                gameManager.getGameLevelData().isTileBlockedFromGridPosition(tilePosition2) or
                gameManager.getGameLevelData().isTileBlockedFromGridPosition(tilePosition3) or
                gameManager.getGameLevelData().isTileBlockedFromGridPosition(tilePosition4)
    end

    ---@public
    ---@param position Rectangle
    ---@return Rectangle
    function viewPort.transformRectangleWorldToViewport(position)
        return Rectangle.new(position.x + renderBounds.x, position.y + renderBounds.y, position.width, position.height)
    end

    ---@public
    ---@param position Vector2
    ---@return Vector2
    function viewPort.transformPointWorldToViewport(position)
        return Vector2.new(position.x + renderBounds.x, position.y + renderBounds.y)
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
        local drawX = (screenManager:getWindowWidth() / 2) - viewPort.bounds.x - (gameManager.getGameLevelData().data.level.TileSize / 2)
        local drawY = (screenManager:getWindowHeight() / 2) - viewPort.bounds.y - (gameManager.getGameLevelData().data.level.TileSize / 2)
        renderBounds = Rectangle.new(drawX, drawY, screenManager:getWindowWidth(), screenManager:getWindowHeight())
    end

    return viewPort
end

return ViewPort
