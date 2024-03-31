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

    -- ---------------------------------------------
    -- Functions
    -- ---------------------------------------------
    ---@return LevelGrid
    function levelGrid.load()
        viewPort   = GridViewPort.new(levelGrid.data.gameLevelData).load()
        layer0Grid = GameGrid.new(levelGrid.data.gameLevelData, viewPort, levelGrid.data.gameLevelData.layer0).load()
        return levelGrid
    end

    function levelGrid.update(dt)
        viewPort.update(dt)
        layer0Grid.setViewPort(viewPort)
    end

    function levelGrid.draw()
        layer0Grid.draw()
        viewPort.draw()
    end

    function levelGrid.getViewPortPosition()
        return { x = viewPort.x, y = viewPort.y }
    end

    function levelGrid.getViewPortDrawPosition()
        return { x = viewPort.drawPosition.x, y = viewPort.drawPosition.y }
    end

    function levelGrid.setViewPortPosition(x, y)
        viewPort.x = x
        viewPort.y = y
    end

    return levelGrid
end

return LevelGrid
