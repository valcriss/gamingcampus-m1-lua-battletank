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

    ---@public
    ---@param pointX number
    ---@param pointY number
    function rectangle.containsPoint(pointX, pointY)
        return pointX >= screenManager:ScaleValueX(rectangle.x) and pointX <= screenManager:ScaleValueX(rectangle.x + rectangle.width) and pointY >= screenManager:ScaleValueY(rectangle.y) and pointY <= screenManager:ScaleValueY(rectangle.y + rectangle.height)
    end

    function rectangle.toString()
        return rectangle.x .. " " .. rectangle.y .. " " .. rectangle.width .. " " .. rectangle.height
    end

    return rectangle
end

return Rectangle
