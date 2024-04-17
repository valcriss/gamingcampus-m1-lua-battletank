local Component        = require "models.scenes.Component"
local SpriteSheetImage = require "models.images.SpriteSheetImage"
local SoundEffect      = require "models.audio.SoundEffect"
---@class MapTank
MapTank                = {}

MapTank.new            = function(name, x, y, rotation, scale)
    local mapTank = Component.new(name, x, y, nil, nil, rotation, scale)

    setmetatable(mapTank, MapTank)
    MapTank.__index       = MapTank
    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local moving          = false
    local animationSpeed  = 80

    -- ---------------------------------------------
    -- Components
    -- ---------------------------------------------
    local tankWaiting     = SpriteSheetImage.new(mapTank.name .. "_tankWaiting", "assets/levelselect/map-tank-waiting.png", 10, nil, animationSpeed, true, mapTank.bounds.x, mapTank.bounds.y, nil, nil, mapTank.rotation, mapTank.scale)
    local tankRunning     = SpriteSheetImage.new(mapTank.name .. "_tankRunning", "assets/levelselect/map-tank-running.png", 10, nil, animationSpeed, true, mapTank.bounds.x, mapTank.bounds.y, nil, nil, mapTank.rotation, mapTank.scale).hide()
    local tankMovingSound = SoundEffect.new(mapTank.name .. "_tankMovingSound", "assets/sound/tank-moving.mp3", "static", true, false, configuration:getSoundVolume())

    mapTank.addComponent(tankWaiting)
    mapTank.addComponent(tankRunning)
    mapTank.addComponent(tankMovingSound)

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    ---@public
    function mapTank.update(_)
        tankRunning.setPosition(mapTank.bounds.x, mapTank.bounds.y)
        tankWaiting.setPosition(mapTank.bounds.x, mapTank.bounds.y)
        tankRunning.setRotation(mapTank.rotation)
        tankWaiting.setRotation(mapTank.rotation)
    end

    ---@public
    function mapTank.run()
        if not moving then
            moving = true
            tankMovingSound.play()
            tankWaiting.hide()
            tankRunning.show()
        end
    end

    ---@public
    function mapTank.stop()
        if moving then
            moving = false
            tankMovingSound.stop()
            tankRunning.hide()
            tankWaiting.show()
        end
    end

    return mapTank
end

return MapTank
