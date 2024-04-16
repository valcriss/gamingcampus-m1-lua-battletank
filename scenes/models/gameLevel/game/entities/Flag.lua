local Entity    = require "scenes.models.gameLevel.game.entities.Entity"
local Image     = require "models.images.Image"
local Rectangle = require "models.drawing.Rectangle"
local HealthBar = require "scenes.models.gameLevel.game.entities.HealthBar"

---@class Flag
Flag            = {}

Flag.new        = function(gameManager, flagPosition, index)
    local flag = Entity.new("Flag-" .. tostring(index), gameManager, "Flag", 0, 0, 0, 64, 64, 0, 1)

    setmetatable(flag, Flag)
    Flag.__index = Flag

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    flag.setMaxHealth(configuration:getFlagMaxHealth())
    local realPosition
    local tower     = Image.new(flag.name .. "_flag", "assets/gameLevel/flag.png", 0, 0, 0, 1)
    local number    = Image.new(flag.name .. "_number", "assets/gameLevel/flag-" .. tostring(index) .. ".png", 0, 0, 0, 1)
    local healthBar = HealthBar.new(flag.name .. "_healthBar", flag)

    flag.addComponent(tower)
    flag.addComponent(number)
    flag.addComponent(healthBar)

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    function flag.load()
        realPosition = gameManager.getGameLevelData().translateGridPositionToWorldPosition(flagPosition.x, flagPosition.y).offsetPosition(gameManager.getGameLevelData().getLevel().TileSize / 2, gameManager.getGameLevelData().getLevel().TileSize / 2)
        flag.setCollider(Rectangle.new(realPosition.x, realPosition.y, flag.bounds.width, flag.bounds.height).scale(flag.scale).offsetPosition(-gameManager.getGameLevelData().getLevel().TileSize / 2, -gameManager.getGameLevelData().getLevel().TileSize / 2))
    end

    function flag.entityUpdate(_)
        local position = gameManager.getViewport().transformPointWorldToViewport(realPosition)
        flag.bounds.setPoint(position.x, position.y)
        flag.updateAssetsPosition()
    end

    function flag.updateAssetsPosition()
        tower.bounds.setPoint(flag.bounds.x, flag.bounds.y)
        number.bounds.setPoint(flag.bounds.x, flag.bounds.y)
        healthBar.bounds.setPoint(flag.bounds.x, flag.bounds.y)
        number.color = flag.getNumberColor()
    end

    function flag.getNumberColor()
        if flag.getGroup() == 0 then
            return { r = 1, g = 1, b = 1, a = 1 }
        elseif flag.getGroup() == 1 then
            return { r = 1, g = 0.5, b = 0.5, a = 1 }
        elseif flag.getGroup() == 2 then
            return { r = 0.5, g = 0.5, b = 1, a = 1 }
        end
    end

    function flag.getIndex()
        return index
    end

    return flag
end

return Flag
