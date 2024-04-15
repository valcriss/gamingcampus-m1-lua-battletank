local DebugItem      = require "scenes.models.gameLevel.debug.DebugItem"
---@class PathFindingDebug
PathFindingDebug     = {}

--- @param gameManager GameManager
PathFindingDebug.new = function(gameManager)
    local pathFindingDebug = DebugItem.new("PathFindingDebug")

    setmetatable(pathFindingDebug, PathFindingDebug)
    PathFindingDebug.__index = PathFindingDebug

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local pathFindingInfo    = {}

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    ---@public
    function pathFindingDebug.innerUpdate(_)
        pathFindingInfo = {}
        local enemies   = gameManager.getEnemyUnits()
        for _, unit in ipairs(enemies) do
            local behavior = unit.getEnemyBehavior()
            if behavior ~= nil then
                local order = behavior.getCurrentOrder()
                if order ~= nil then
                    local path = order.getCurrentPath()
                    if path ~= nil then
                        local positions = {}
                        for i = 1, #path do
                            local realPosition = gameManager.getGameLevelData().getRealPositionFromTileIndex(path[i])
                            local translated   = gameManager.getViewport().transformPointWorldToViewport(realPosition).offsetPosition(gameManager.getGameLevelData().getLevel().TileSize / 2, gameManager.getGameLevelData().getLevel().TileSize / 2)
                            table.insert(positions, translated)
                            table.insert(pathFindingInfo, { unit = unit, positions = positions })
                        end
                    end
                end
            end
        end
    end

    ---@public
    function pathFindingDebug.draw()
        for _, pathInfo in ipairs(pathFindingInfo) do
            pathFindingDebug.drawLines(pathInfo.positions)
        end
    end

    ---@public
    function pathFindingDebug.drawLines(positions)
        love.graphics.setColor(1, 0, 0, 1)
        for i = 1, #positions - 1 do
            love.graphics.line(screenManager:ScaleValueX(positions[i].x), screenManager:ScaleValueY(positions[i].y), screenManager:ScaleValueX(positions[i + 1].x), screenManager:ScaleValueY(positions[i + 1].y))
        end
    end

    return pathFindingDebug
end

return PathFindingDebug
