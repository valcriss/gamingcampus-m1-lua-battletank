local Vector2 = require "models.drawing.Vector2"

---@class Rectangle
Rectangle     = {}

Rectangle.new = function(x, y, width, height)
    x               = x or 0
    y               = y or 0
    width           = width or 0
    height          = height or 0

    local rectangle = {
        x      = x,
        y      = y,
        width  = width,
        height = height
    }

    setmetatable(rectangle, Rectangle)
    Rectangle.__index = Rectangle

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------

    ---@public
    ---@param pointX number
    ---@param pointY number
    ---@return boolean
    function rectangle.containsPoint(pointX, pointY)
        return pointX >= rectangle.x and pointX <= rectangle.x + rectangle.width and pointY >= rectangle.y and pointY <= rectangle.y + rectangle.height
    end

    ---@public
    ---@param vector Vector2
    ---@return boolean
    function rectangle.containsVector2(vector)
        return vector.x >= rectangle.x and vector.x <= rectangle.x + rectangle.width and vector.y >= rectangle.y and vector.y <= rectangle.y + rectangle.height
    end

    ---@public
    ---@return Vector2
    function rectangle.getPoint()
        return Vector2.new(rectangle.x, rectangle.y)
    end

    ---@public
    ---@return Vector2
    function rectangle.getCenter()
        return Vector2.new(rectangle.x + (rectangle.width / 2), rectangle.y + (rectangle.height / 2))
    end

    ---@public
    ---@param positionX number
    ---@param positionY number
    ---@return Rectangle
    function rectangle.setPoint(positionX, positionY)
        rectangle.x = positionX
        rectangle.y = positionY
        return rectangle
    end

    ---@public
    ---@type number
    ---@return Rectangle
    function rectangle.scale(value)
        rectangle.width  = rectangle.width * value
        rectangle.height = rectangle.height * value
        return rectangle
    end

    ---@public
    ---@param offsetX number
    ---@param offsetY number
    ---@return Rectangle
    function rectangle.offsetPosition(offsetX, offsetY)
        rectangle.x = rectangle.x + offsetX
        rectangle.y = rectangle.y + offsetY
        return rectangle
    end

    ---@public
    ---@param offsetWidth number
    ---@param offsetHeight number
    ---@return Rectangle
    function rectangle.offsetSize(offsetWidth, offsetHeight)
        rectangle.width  = rectangle.width + offsetWidth
        rectangle.height = rectangle.height + offsetHeight
        return rectangle
    end

    ---@public
    ---@return string
    function rectangle.toString()
        return math.floor(rectangle.x) .. " " .. math.floor(rectangle.y) .. " " .. math.floor(rectangle.width) .. " " .. math.floor(rectangle.height)
    end

    return rectangle
end

return Rectangle
