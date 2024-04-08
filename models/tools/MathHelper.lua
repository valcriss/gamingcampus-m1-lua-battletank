---@class MathHelper
MathHelper  = {}

function MathHelper:lerp(a, b, t)
    return a + (b - a) * t
end

return MathHelper
