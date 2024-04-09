local Entity           = require "scenes.models.gameLevel.game.entities.Entity"
local Image            = require "models.images.Image"
local SpriteSheetImage = require "models.images.SpriteSheetImage"
local Rectangle        = require "models.drawing.Rectangle"

---@class MainTower
MainTower              = {}

MainTower.new          = function(name, gameManager, group)
    local mainTower = Entity.new(name, "MainTower", group, 0, 0, 128, 128, 0, 0.5)

    setmetatable(mainTower, MainTower)
    MainTower.__index = MainTower

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------

    local tower       = Image.new(mainTower.name .. "_tower", "assets/gameLevel/tower.png", 0, 0, 0, 0.5)
    local gun         = Image.new(mainTower.name .. "_tower", "assets/gameLevel/tower-gun-" .. tostring(group) .. ".png", 0, 0, 0, 0.5)
    local shield      = SpriteSheetImage.new(mainTower.name .. "_shield", "assets/gameLevel/shield.png", 12, 1, 50, true, 0, 0, nil, nil, 0, 0.25)

    local realPosition

    mainTower.addComponent(tower)
    mainTower.addComponent(gun)
    mainTower.addComponent(shield)

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    function mainTower.load()
        realPosition = gameManager.getGameLevelData().getMainTowerWorldPosition(group)
        mainTower.setCollider(Rectangle.new(realPosition.x, realPosition.y, mainTower.bounds.width, mainTower.bounds.height).scale(mainTower.scale))
    end

    function mainTower.update(dt)
        mainTower.updateMainTower(dt)
        local screenPosition = gameManager.getViewport().transformPointWorldToViewport(realPosition)
        mainTower.bounds.setPoint(screenPosition.x + gameManager.getGameLevelData().data.level.TileSize / 2, screenPosition.y + gameManager.getGameLevelData().data.level.TileSize / 2)
        tower.bounds.setPoint(screenPosition.x + gameManager.getGameLevelData().data.level.TileSize / 2, screenPosition.y + gameManager.getGameLevelData().data.level.TileSize / 2)
        gun.bounds.setPoint(screenPosition.x + gameManager.getGameLevelData().data.level.TileSize / 2, screenPosition.y + gameManager.getGameLevelData().data.level.TileSize / 2)
    end

    function mainTower.updateMainTower(_)

    end

    return mainTower
end

return MainTower
