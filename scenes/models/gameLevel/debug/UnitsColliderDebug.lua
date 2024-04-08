local DebugItem        = require "scenes.models.gameLevel.debug.DebugItem"
---@class UnitsColliderDebug
UnitsColliderDebug     = {}

--- @param gameManager GameManager
UnitsColliderDebug.new = function(gameManager)
    local unitsColliderDebug = DebugItem.new("UnitsColliderDebug")

    setmetatable(unitsColliderDebug, UnitsColliderDebug)
    UnitsColliderDebug.__index = UnitsColliderDebug

    local colliderBounds       = {}

    ---@public
    function unitsColliderDebug.innerUpdate(_)
        colliderBounds = {}
        local units    = gameManager.getUnits()
        for _, unit in ipairs(units) do
            local collider = unit.getCollider()
            if collider ~= nil then
                local translated = gameManager.getViewport().transformRectangleWorldToViewport(collider)
                table.insert(colliderBounds, { unitName = unit.name, colliderBounds = translated })
            end
        end
    end

    function unitsColliderDebug.draw()
        for _, collider in ipairs(colliderBounds) do
            unitsColliderDebug.drawRectangle("line", collider.colliderBounds.x, collider.colliderBounds.y, collider.colliderBounds.width, collider.colliderBounds.height, { r = 0, g = 0, b = 1, a = 1 })
        end
    end

    function unitsColliderDebug.drawRectangle(mode, x, y, w, h, color)
        love.graphics.setColor(color.r, color.g, color.b, color.a)
        love.graphics.rectangle(mode, screenManager:ScaleValueX(x), screenManager:ScaleValueY(y), screenManager:ScaleValueX(w), screenManager:ScaleValueY(h))
    end

    return unitsColliderDebug
end

return UnitsColliderDebug
