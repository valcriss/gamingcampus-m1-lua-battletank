local Component    = require "models.scenes.Component"
local GridViewPort = require "scenes.models.gamelevel.grid.GridViewPort"
local GameGrid     = require "scenes.models.gamelevel.grid.GameGrid"
---@class LevelGrid
LevelGrid          = {}

---@param gameLevelData GameLevelData
LevelGrid.new      = function(name, gameLevelData)
    local levelGrid = Component.new(name, {
        gameLevelData = gameLevelData
    })

    setmetatable(levelGrid, LevelGrid)
    LevelGrid.__index = LevelGrid

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    ---@type GridViewPort
    local viewPort
    local layer0Grid
    local layer1Grid

    -- ---------------------------------------------
    -- Functions
    -- ---------------------------------------------
    ---@return LevelGrid
    function levelGrid.load()
        viewPort   = GridViewPort.new(levelGrid.data.gameLevelData).load()
        layer0Grid = GameGrid.new(levelGrid.data.gameLevelData, viewPort, levelGrid.data.gameLevelData.level.Layer0).load()
        layer1Grid = GameGrid.new(levelGrid.data.gameLevelData, viewPort, levelGrid.data.gameLevelData.level.Layer1).load()
        return levelGrid
    end

    function levelGrid.update(dt)
        viewPort.update(dt)
        layer0Grid.setViewPort(viewPort)
        layer1Grid.setViewPort(viewPort)
    end

    function levelGrid.draw()
        layer0Grid.draw()
        layer1Grid.draw()
        viewPort.draw()
    end

    function levelGrid.isTileBlocked(viewPortPosition)
        local ref           = { x = viewPortPosition.x + levelGrid.data.gameLevelData.tileSize / 2, y = viewPortPosition.y + levelGrid.data.gameLevelData.tileSize / 2 }
        local border        = (levelGrid.data.gameLevelData.tileSize / 2) * 0.6
        local tilePosition1 = levelGrid.data.gameLevelData.getGridPosition(ref.x - border, ref.y + border)
        local tilePosition2 = levelGrid.data.gameLevelData.getGridPosition(ref.x - border, ref.y - border)
        local tilePosition3 = levelGrid.data.gameLevelData.getGridPosition(ref.x + border, ref.y - border)
        local tilePosition4 = levelGrid.data.gameLevelData.getGridPosition(ref.x + border, ref.y + border)

        return levelGrid.data.gameLevelData.isTileBlocked(tilePosition1) or levelGrid.data.gameLevelData.isTileBlocked(tilePosition2) or levelGrid.data.gameLevelData.isTileBlocked(tilePosition3) or levelGrid.data.gameLevelData.isTileBlocked(tilePosition4)
    end

    function levelGrid.getViewPortPosition()
        return { x = viewPort.x, y = viewPort.y }
    end

    function levelGrid.setViewPortPosition(x, y)
        viewPort.x = math.max(0, math.min(x, viewPort.bounds.width - levelGrid.data.gameLevelData.tileSize))
        viewPort.y = math.max(0, math.min(y, viewPort.bounds.height - levelGrid.data.gameLevelData.tileSize))
    end

    return levelGrid
end

return LevelGrid
