local Entity           = require "models.gameLevel.game.entities.Entity"
local Image            = require "framework.images.Image"
local SpriteSheetImage = require "framework.images.SpriteSheetImage"
local UnitMissile      = require "models.gameLevel.game.entities.UnitMissile"
local HealthBar        = require "models.gameLevel.game.entities.HealthBar"
local SoundEffect      = require "framework.audio.SoundEffect"

---@class Unit
Unit                   = {}

Unit.new               = function(name, gameManager, body, turret, fireAnimation, x, y, group)
    local unit = Entity.new(name, gameManager, "Tank", group, x, y, 64, 64, 0, 1)

    setmetatable(unit, Unit)
    Unit.__index       = Unit

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------

    local tankBody     = Image.new(unit.name .. "_body", body, unit.bounds.x + (unit.bounds.width / 2), unit.bounds.y + (unit.bounds.height / 2), unit.rotation, unit.scale)
    local tankTurret   = Image.new(unit.name .. "_turret", turret, unit.bounds.x + (unit.bounds.width / 2), unit.bounds.y + (unit.bounds.height / 2), unit.rotation, unit.scale)
    local tankFire     = SpriteSheetImage.new(unit.name .. "_tankFire", fireAnimation, 18, 1, 10, false, unit.bounds.x + (unit.bounds.width / 2), unit.bounds.y + (unit.bounds.height / 2), nil, nil, unit.rotation, unit.scale, unit.color, function() unit.fireEnds() end).hide()
    local missile1     = UnitMissile.new("missile1", gameManager, group).hide()
    local missile2     = UnitMissile.new("missile2", gameManager, group).hide()
    local healthBar    = HealthBar.new(unit.name .. "_healthBar", unit)
    local emoteWait    = SpriteSheetImage.new(unit.name .. "_emoteWait", "assets/gameLevel/emote-wait.png", 15, 1, 50, true, 0, 0, nil, nil, unit.rotation, unit.scale, unit.color)
    local missileSound = SoundEffect.new("background", "assets/sound/tank-fire.mp3", "static", false, false, configuration:getSoundVolume())

    unit.addComponent(tankBody)
    unit.addComponent(tankTurret)
    unit.addComponent(tankFire)
    unit.addComponent(missile1)
    unit.addComponent(missile2)
    unit.addComponent(healthBar)
    unit.addComponent(emoteWait)
    unit.addComponent(missileSound)

    local turretRotation = 0
    local startRealPosition
    local destinationRealPosition

    -- ---------------------------------------------
    -- Public Functions
    -- ---------------------------------------------

    function unit.entityUpdate(dt)
        unit.updateUnit(dt)
        unit.updateUnitVisibility(dt)
        unit.updateTankPosition()
    end

    function unit.updateTankPosition()
        tankBody.color      = unit.color
        tankTurret.color    = unit.color
        tankBody.scale      = unit.scale
        tankBody.bounds.x   = unit.bounds.x
        tankBody.bounds.y   = unit.bounds.y
        tankTurret.scale    = unit.scale
        tankTurret.bounds.x = unit.bounds.x
        tankTurret.bounds.y = unit.bounds.y
        tankFire.scale      = unit.scale
        tankFire.bounds.x   = unit.bounds.x
        tankFire.bounds.y   = unit.bounds.y
        healthBar.bounds.x  = unit.bounds.x
        healthBar.bounds.y  = unit.bounds.y
        emoteWait.bounds.x  = unit.bounds.x
        emoteWait.bounds.y  = unit.bounds.y - 28
        if unit.isFrozen() then return end
        tankBody.rotation   = unit.rotation
        tankTurret.rotation = turretRotation
        tankFire.rotation   = turretRotation
    end

    ---@public
    function unit.targetPosition(targetX, targetY)
        if unit.isFrozen() then return end
        local tankPositionX = unit.bounds.x
        local tankPositionY = unit.bounds.y
        local angle         = math.deg(math.atan2(tankPositionY - targetY, targetX - tankPositionX))
        local turretAngle   = -angle - 90
        turretRotation      = turretAngle
    end

    ---@public
    function unit.targetRealPosition(realTargetX, realTargetY)
        if unit.isFrozen() then return end
        local tankPositionX = unit.getCollider().x
        local tankPositionY = unit.getCollider().y
        local angle         = math.deg(math.atan2(tankPositionY - realTargetY, realTargetX - tankPositionX))
        local turretAngle   = -angle - 90
        turretRotation      = turretAngle
    end

    function unit.fireStarts()
        if missile1.isRunning() or missile2.isRunning() or unit.isFrozen() then return end
        missileSound.play()
        missile1.show()
        missile1.fire(
                startRealPosition.x - math.cos(math.rad(turretRotation)) * 10,
                startRealPosition.y - math.sin(math.rad(turretRotation)) * 10,
                destinationRealPosition.x,
                destinationRealPosition.y,
                turretRotation
        )
        missile2.show()
        missile2.fire(
                startRealPosition.x + math.cos(math.rad(turretRotation)) * 10,
                startRealPosition.y + math.sin(math.rad(turretRotation)) * 10,
                destinationRealPosition.x,
                destinationRealPosition.y,
                turretRotation
        )

        tankFire.show()
        tankTurret.hide()
    end

    function unit.fireEnds()
        tankFire.hide()
        tankTurret.show()
    end

    function unit.updateUnitVisibility(_)
        if unit.isFrozen() and not emoteWait.isVisible() then
            emoteWait.show()
        elseif not unit.isFrozen() and emoteWait.isVisible() then
            emoteWait.hide()
        end
    end

    function unit.setStartRealPosition(newStartRealPosition)
        startRealPosition = newStartRealPosition
    end

    function unit.setDestinationRealPosition(newDestinationRealPosition)
        destinationRealPosition = newDestinationRealPosition
    end

    return unit
end

return Unit
