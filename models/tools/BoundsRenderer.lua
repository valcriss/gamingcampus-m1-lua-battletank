local Component    = require "models.scenes.Component"
---@class BoundsRenderer
BoundsRenderer     = {}

BoundsRenderer.new = function(levelGrid, gameLevelData)

    local boundsRenderer = Component.new(
            "boundsRenderer",
            {
                levelGrid     = levelGrid,
                gameLevelData = gameLevelData
            }
    )

    setmetatable(boundsRenderer, BoundsRenderer)
    BoundsRenderer.__index = BoundsRenderer

    ---@public
    function boundsRenderer.draw()
        if DEBUG == false then return end
        local drawViewPort = boundsRenderer.data.levelGrid.getGridViewDrawViewPort()
        for _, unit in ipairs(gameUnits) do
            if unit.data.realBounds ~= nil then
                local x = (unit.data.realBounds.x + drawViewPort.x)
                local y = (unit.data.realBounds.y + drawViewPort.y)
                love.graphics.setColor(0, 0, 1, 1)
                love.graphics.rectangle("line", x, y, unit.data.realBounds.width, unit.data.realBounds.height)
                love.graphics.setColor(1, 1, 1, 1)
            end
        end
    end

    return boundsRenderer
end

return BoundsRenderer
