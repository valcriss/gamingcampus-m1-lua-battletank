local Entity           = require "models.gameLevel.game.entities.Entity"
local Image            = require "framework.images.Image"
local SpriteSheetImage = require "framework.images.SpriteSheetImage"
local Rectangle        = require "framework.drawing.Rectangle"
local HealthBar        = require "models.gameLevel.game.entities.HealthBar"
local UnitMissile      = require "models.gameLevel.game.entities.UnitMissile"
local SoundEffect      = require "framework.audio.SoundEffect"

---@class MainTower
MainTower              = {}

MainTower.new          = function(name, gameManager, group)
    local mainTower = Entity.new(name, gameManager, "MainTower", group, 0, 0, 64, 64, 0, 1)

    setmetatable(mainTower, MainTower)
    MainTower.__index = MainTower

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    mainTower.setMaxHealth(configuration:getMainTowerMaxHealth())
    local tower             = Image.new(mainTower.name .. "_tower", "assets/gameLevel/tower.png", 0, 0, 0, 1)
    local gun               = Image.new(mainTower.name .. "_tower", "assets/gameLevel/tower-gun-" .. tostring(group) .. ".png", 0, 0, 0, 1)
    local shield            = SpriteSheetImage.new(mainTower.name .. "_shield", "assets/gameLevel/shield.png", 12, 1, 50, true, 0, 0, nil, nil, 0, 1)
    local healthBar         = HealthBar.new(mainTower.name .. "_healthBar", mainTower)
    local missile1          = UnitMissile.new("missile1", gameManager, group, "assets/gameLevel/main-missile.png", 1500).hide()
    local missile2          = UnitMissile.new("missile2", gameManager, group, "assets/gameLevel/main-missile.png", 1500).hide()
    local missileSound      = SoundEffect.new("background", "assets/sound/tower-fire.mp3", "static", false, false, configuration:getSoundVolume())

    local realPosition
    local gunRotation       = 0
    local shieldActive      = true
    local idleRotationSpeed = 10
    local fastRotationSpeed = 200
    local distanceThreshold = 450
    local fireThreshold     = 400

    mainTower.addComponent(tower)
    mainTower.addComponent(gun)
    mainTower.addComponent(healthBar)
    mainTower.addComponent(shield)
    mainTower.addComponent(missile1)
    mainTower.addComponent(missile2)
    mainTower.addComponent(missileSound)


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
        mainTower.bounds.setPoint(screenPosition.x + gameManager.getGameLevelData().getLevel().TileSize / 2, screenPosition.y + gameManager.getGameLevelData().getLevel().TileSize / 2)
        tower.bounds.setPoint(screenPosition.x + gameManager.getGameLevelData().getLevel().TileSize / 2, screenPosition.y + gameManager.getGameLevelData().getLevel().TileSize / 2)
        gun.bounds.setPoint(screenPosition.x + gameManager.getGameLevelData().getLevel().TileSize / 2, screenPosition.y + gameManager.getGameLevelData().getLevel().TileSize / 2)
        healthBar.bounds.setPoint(screenPosition.x + gameManager.getGameLevelData().getLevel().TileSize / 2, screenPosition.y + gameManager.getGameLevelData().getLevel().TileSize / 2)
        gun.rotation = gunRotation
        shield.bounds.setPoint(screenPosition.x + gameManager.getGameLevelData().getLevel().TileSize / 2, screenPosition.y + gameManager.getGameLevelData().getLevel().TileSize / 2)
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

    function mainTower.isShieldActive()
        return shieldActive
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
                        targetUnit  = unit
                    end
                end
            end
        end

        if targetUnit ~= nil then
            local targetAngle = -math.deg(math.atan2(realPosition.y - targetUnit.getCollider().y, targetUnit.getCollider().x - realPosition.x)) + 90
            if targetAngle < 0 then targetAngle = targetAngle + 360 end
            if targetAngle > 360 then targetAngle = targetAngle - 360 end
            local angleMove = math.min(fastRotationSpeed * dt, math.abs(targetAngle - gunRotation))
            if gunRotation < targetAngle then
                gunRotation = gunRotation + angleMove
            else
                gunRotation = gunRotation - angleMove
            end

            if math.abs(targetAngle - gunRotation) < 2 and minDistance <= fireThreshold then
                mainTower.fireToTarget(targetUnit)
            end

        else
            gunRotation = gunRotation + (idleRotationSpeed * dt)
        end
        if gunRotation > 360 then gunRotation = gunRotation - 360 end
        if gunRotation < 0 then gunRotation = gunRotation + 360 end
    end

    function mainTower.fireToTarget(targetUnit)
        if mainTower.getCollider() == nil or targetUnit.getCollider() == nil then return end

        local startRealPosition       = mainTower.getCollider().getCenter()
        local destinationRealPosition = targetUnit.getCollider().getCenter()
        if missile1.isRunning() or missile2.isRunning() or targetUnit.isFrozen() then return end
        missileSound.play()
        missile1.show()
        missile1.fire(
                startRealPosition.x - math.cos(math.rad(gunRotation)) * 10,
                startRealPosition.y - math.sin(math.rad(gunRotation)) * 10,
                destinationRealPosition.x,
                destinationRealPosition.y,
                gunRotation
        )
        missile2.show()
        missile2.fire(
                startRealPosition.x + math.cos(math.rad(gunRotation)) * 10,
                startRealPosition.y + math.sin(math.rad(gunRotation)) * 10,
                destinationRealPosition.x,
                destinationRealPosition.y,
                gunRotation
        )

    end

    return mainTower
end

return MainTower
