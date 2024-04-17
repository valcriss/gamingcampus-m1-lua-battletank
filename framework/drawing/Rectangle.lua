local Vector2 = require "framework.drawing.Vector2"

---@class Rectangle
Rectangle     = {}

---@param x number
---@param y number
---@param width number
---@param height number
Rectangle.new = function(x, y, width, height)
    x               = x or 0
    y               = y or 0
    width           = width or 0
    height          = height or 0

    ---@type table
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
    --- Indique si le point est dans le rectangle
    ---@param pointX number
    ---@param pointY number
    ---@return boolean
    function rectangle.containsPoint(pointX, pointY)
        return pointX >= rectangle.x and pointX <= rectangle.x + rectangle.width and pointY >= rectangle.y and pointY <= rectangle.y + rectangle.height
    end

    ---@public
    --- Indique si le vecteur est dans le rectangle
    ---@param vector Vector2
    ---@return boolean
    function rectangle.containsVector2(vector)
        return vector.x >= rectangle.x and vector.x <= rectangle.x + rectangle.width and vector.y >= rectangle.y and vector.y <= rectangle.y + rectangle.height
    end

    ---@public
    --- Retourne la position du rectangle
    ---@return Vector2
    function rectangle.getPoint()
        return Vector2.new(rectangle.x, rectangle.y)
    end

    ---@public
    --- Retourne le centre du rectangle
    ---@return Vector2
    function rectangle.getCenter()
        return Vector2.new(rectangle.x + (rectangle.width / 2), rectangle.y + (rectangle.height / 2))
    end

    ---@public
    --- Change la position du rectangle
    ---@param positionX number
    ---@param positionY number
    ---@return Rectangle
    function rectangle.setPoint(positionX, positionY)
        rectangle.x = positionX
        rectangle.y = positionY
        return rectangle
    end

    ---@public
    --- Change la taille du rectangle d'un facteur value
    ---@type number
    ---@return Rectangle
    function rectangle.scale(value)
        rectangle.width  = rectangle.width * value
        rectangle.height = rectangle.height * value
        return rectangle
    end

    ---@public
    --- Change la position du rectangle
    ---@param offsetX number
    ---@param offsetY number
    ---@return Rectangle
    function rectangle.offsetPosition(offsetX, offsetY)
        rectangle.x = rectangle.x + offsetX
        rectangle.y = rectangle.y + offsetY
        return rectangle
    end

    ---@public
    --- Change la taille du rectangle
    ---@param offsetWidth number
    ---@param offsetHeight number
    ---@return Rectangle
    function rectangle.offsetSize(offsetWidth, offsetHeight)
        rectangle.width  = rectangle.width + offsetWidth
        rectangle.height = rectangle.height + offsetHeight
        return rectangle
    end

    ---@public
    --- Retourne une représentation sous forme de string du rectangle
    ---@return string
    function rectangle.toString()
        return math.floor(rectangle.x) .. " " .. math.floor(rectangle.y) .. " " .. math.floor(rectangle.width) .. " " .. math.floor(rectangle.height)
    end

    return rectangle
end

return Rectangle
