---@class Vector2
Vector2     = {}

Vector2.new = function(x, y)
    x             = x or 0
    y             = y or 0

    local vector2 = {
        x = x,
        y = y
    }

    setmetatable(vector2, Vector2)
    Vector2.__index = Vector2

    function vector2.toString()
        return math.floor(vector2.x) .. " " .. math.floor(vector2.y)
    end

    function vector2.distance(x2, y2)
        return math.sqrt((x2 - vector2.x) * (x2 - vector2.x) + (y2 - vector2.y) * (y2 - vector2.y))
    end

    return vector2
end

return Vector2
