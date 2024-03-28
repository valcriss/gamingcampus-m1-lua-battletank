---@class Rectangle
Rectangle = {}

Rectangle.new = function(x, y, width, height)
    x = x or 0
    y = y or 0
    width = width or 0
    height = height or 0

    local rectangle = {
        x = x,
        y = y,
        width = width,
        height = height
    }

    setmetatable(rectangle, Rectangle)
    Rectangle.__index = Rectangle

    return rectangle
end

return Rectangle
