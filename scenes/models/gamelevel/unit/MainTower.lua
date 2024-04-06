local Component        = require "models.scenes.Component"
local SpriteSheetImage = require "models.images.SpriteSheetImage"

---@class MainTower
MainTower              = {}

---@param name string
---@param x number
---@param y number
---@param gameLevelData GameLevelData
---@param levelGrid LevelGrid
MainTower.new          = function(name, cellX, cellY, gameLevelData, levelGrid)
    local mainTower = Component.new(
            name,
            {
                gameLevelData = gameLevelData,
                levelGrid     = levelGrid,
                tilePosition  = { x = cellX, y = cellY },
                wasVisible    = true,
                shieldActive  = true,
                realBounds    = nil
            }
    )

    local bouclier  = SpriteSheetImage.new(mainTower.name .. "_bouclier", "assets/gamelevel/bouclier.png", 12, 1, 50, true, mainTower.bounds.x, mainTower.bounds.y, nil, nil, 0, 0.25)

    setmetatable(mainTower, MainTower)
    MainTower.__index = MainTower

    mainTower.addComponent(bouclier)

    function mainTower.update(_)
        local realPosition      = mainTower.data.gameLevelData.getRealPosition(mainTower.data.tilePosition.x, mainTower.data.tilePosition.y)
        local drawViewPort      = mainTower.data.levelGrid.getGridViewDrawViewPort()
        mainTower.bounds.x      = (realPosition.x + drawViewPort.x) + mainTower.data.gameLevelData.tileSize / 2
        mainTower.bounds.y      = (realPosition.y + drawViewPort.y) + mainTower.data.gameLevelData.tileSize / 2
        mainTower.bounds.width  = bouclier.bounds.width
        mainTower.bounds.height = bouclier.bounds.height
        bouclier.setPosition(mainTower.bounds.x, mainTower.bounds.y)
        mainTower.data.realBounds = Rectangle.new(realPosition.x - mainTower.data.gameLevelData.tileSize / 2, realPosition.y - mainTower.data.gameLevelData.tileSize / 2, mainTower.bounds.width, mainTower.bounds.height)
        local inSight             = mainTower.data.levelGrid.data.fog.isTileInSight(mainTower.data.tilePosition)
        if inSight == true and mainTower.data.wasVisible == false then
            bouclier.show()
            mainTower.data.wasVisible = true
        elseif inSight == false and mainTower.data.wasVisible == true then
            bouclier.hide()
            mainTower.data.wasVisible = false
        end
    end

    return mainTower
end

return MainTower
