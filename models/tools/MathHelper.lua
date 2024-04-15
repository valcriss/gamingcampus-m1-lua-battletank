---@class MathHelper
MathHelper = {}

---@public
--- Interpoler entre deux nombres par un pourcentage t.
---@param a number
---@param b number
---@param t number
---@return number
function MathHelper:lerp(a, b, t)
    return a + (b - a) * t
end

return MathHelper
