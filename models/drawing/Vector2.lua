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

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------

    ---@public
    ---@param x2 number
    ---@param y2 number
    ---@return number
    function vector2.distance(x2, y2)
        return math.sqrt((x2 - vector2.x) * (x2 - vector2.x) + (y2 - vector2.y) * (y2 - vector2.y))
    end

    ---@public
    ---@param offsetX number
    ---@param offsetY number
    ---@return Vector2
    function vector2.offsetPosition(offsetX, offsetY)
        vector2.x = vector2.x + offsetX
        vector2.y = vector2.y + offsetY
        return vector2
    end

    ---@public
    ---@return Vector2
    function vector2.normalize()
        local magnitude = math.sqrt(vector2.x ^ 2 + vector2.y ^ 2)
        return Vector2.new(vector2.x / magnitude, vector2.y / magnitude)
    end

    ---@public
    ---@return string
    function vector2.toString()
        return math.floor(vector2.x) .. " " .. math.floor(vector2.y)
    end
    return vector2
end

return Vector2
