local Entity           = require "scenes.models.gameLevel.game.entities.Entity"
local Image            = require "models.images.Image"
local SpriteSheetImage = require "models.images.SpriteSheetImage"
local Rectangle        = require "models.drawing.Rectangle"
local HealthBar        = require "scenes.models.gameLevel.game.entities.HealthBar"

---@class MainTower
MainTower              = {}

MainTower.new          = function(name, gameManager, group)
    local mainTower = Entity.new(name, gameManager, "MainTower", group, 0, 0, 128, 128, 0, 0.5)

    setmetatable(mainTower, MainTower)
    MainTower.__index = MainTower

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    mainTower.setMaxHealth((configuration:getDifficulty() * 500) + 500)
    mainTower.setHealth((configuration:getDifficulty() * 500) + 500)
    local tower             = Image.new(mainTower.name .. "_tower", "assets/gameLevel/tower.png", 0, 0, 0, 0.5)
    local gun               = Image.new(mainTower.name .. "_tower", "assets/gameLevel/tower-gun-" .. tostring(group) .. ".png", 0, 0, 0, 0.5)
    local shield            = SpriteSheetImage.new(mainTower.name .. "_shield", "assets/gameLevel/shield.png", 12, 1, 50, true, 0, 0, nil, nil, 0, 0.25)
    local healthBar         = HealthBar.new(mainTower.name .. "_healthBar", mainTower)

    local realPosition
    local gunRotation       = 0
    local shieldActive      = true
    local idleRotationSpeed = 10
    local fastRotationSpeed = 200
    local distanceThreshold = 450

    mainTower.addComponent(tower)
    mainTower.addComponent(gun)
    mainTower.addComponent(healthBar)
    mainTower.addComponent(shield)


    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    function mainTower.load()
        realPosition = gameManager.getGameLevelData().getMainTowerWorldPosition(group)
        mainTower.setCollider(Rectangle.new(realPosition.x, realPosition.y, mainTower.bounds.width, mainTower.bounds.height).scale(mainTower.scale))
        mainTower.setCanBeDamaged(false)
    end

    function mainTower.entityUpdate(dt)
        mainTower.updateMainTower(dt)
        mainTower.updateGunRotation(dt)
        local screenPosition = gameManager.getViewport().transformPointWorldToViewport(realPosition)
        mainTower.bounds.setPoint(screenPosition.x + gameManager.getGameLevelData().data.level.TileSize / 2, screenPosition.y + gameManager.getGameLevelData().data.level.TileSize / 2)
        tower.bounds.setPoint(screenPosition.x + gameManager.getGameLevelData().data.level.TileSize / 2, screenPosition.y + gameManager.getGameLevelData().data.level.TileSize / 2)
        gun.bounds.setPoint(screenPosition.x + gameManager.getGameLevelData().data.level.TileSize / 2, screenPosition.y + gameManager.getGameLevelData().data.level.TileSize / 2)
        healthBar.bounds.setPoint(screenPosition.x + gameManager.getGameLevelData().data.level.TileSize / 2, screenPosition.y + gameManager.getGameLevelData().data.level.TileSize / 2)
        gun.rotation = gunRotation
        shield.bounds.setPoint(screenPosition.x + gameManager.getGameLevelData().data.level.TileSize / 2, screenPosition.y + gameManager.getGameLevelData().data.level.TileSize / 2)
    end

    function mainTower.updateMainTower(_)

    end

    function mainTower.setShieldOff()
        shieldActive = false
        shield.hide()
        mainTower.setCanBeDamaged(true)
    end

    function mainTower.setShieldOn()
        shieldActive = true
        shield.show()
        mainTower.setCanBeDamaged(false)
    end

    function mainTower.updateGunRotation(dt)
        realPosition      = gameManager.getGameLevelData().getMainTowerWorldPosition(group)
        local minDistance = math.huge
        local targetUnit
        for _, unit in ipairs(gameManager.getUnits()) do
            local collider = unit.getCollider()
            if collider ~= nil and unit.getGroup() ~= group then
                local distance = realPosition.distance(collider.x, collider.y)
                if distance < distanceThreshold then
                    if distance < minDistance then
                        minDistance = distance
                        targetUnit  = collider
                    end
                end
            end
        end

        if targetUnit ~= nil then
            local targetAngle = -math.deg(math.atan2(realPosition.y - targetUnit.y, targetUnit.x - realPosition.x)) + 90
            if targetAngle < 0 then targetAngle = targetAngle + 360 end
            if targetAngle > 360 then targetAngle = targetAngle - 360 end
            local angleMove = math.min(fastRotationSpeed * dt, math.abs(targetAngle - gunRotation))
            if gunRotation < targetAngle then
                gunRotation = gunRotation + angleMove
            else
                gunRotation = gunRotation - angleMove
            end
        else
            gunRotation = gunRotation + (idleRotationSpeed * dt)
        end
        if gunRotation > 360 then gunRotation = gunRotation - 360 end
        if gunRotation < 0 then gunRotation = gunRotation + 360 end
    end

    return mainTower
end

return MainTower
