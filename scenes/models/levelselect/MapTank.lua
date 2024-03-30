local Component        = require "models.scenes.Component"
local SpriteSheetImage = require "models.images.SpriteSheetImage"
local SoundEffect      = require "models.audio.SoundEffect"
---@class MapTank
MapTank                = {}

MapTank.new            = function(name, x, y, rotation, scale)
    local mapTank = Component.new(
            name,
            {
                moving = false
            },
            x,
            y,
            nil,
            nil,
            rotation,
            scale
    )

    setmetatable(mapTank, MapTank)
    MapTank.__index       = MapTank

    local animationSpeed  = 80
    local tankWaiting     = SpriteSheetImage.new(mapTank.name .. "_tankWaiting", "assets/levelselect/map-tank-waiting.png", 10, nil, animationSpeed, true, mapTank.bounds.x, mapTank.bounds.y, nil, nil, mapTank.rotation, mapTank.scale)
    local tankRunning     = SpriteSheetImage.new(mapTank.name .. "_tankRunning", "assets/levelselect/map-tank-running.png", 10, nil, animationSpeed, true, mapTank.bounds.x, mapTank.bounds.y, nil, nil, mapTank.rotation, mapTank.scale).hide()
    local tankMovingSound = SoundEffect.new(mapTank.name .. "_tankMovingSound", "assets/shared/tank-moving.mp3", "static", true, false, configuration:getSoundVolume())

    mapTank.addComponent(tankWaiting)
    mapTank.addComponent(tankRunning)
    mapTank.addComponent(tankMovingSound)

    function mapTank.update(_)
        tankRunning.setPosition(mapTank.bounds.x, mapTank.bounds.y)
        tankWaiting.setPosition(mapTank.bounds.x, mapTank.bounds.y)
        tankRunning.setRotation(mapTank.rotation)
        tankWaiting.setRotation(mapTank.rotation)
    end

    function mapTank.run()
        if not mapTank.data.moving then
            mapTank.data.moving = true
            tankMovingSound.play()
            tankWaiting.hide()
            tankRunning.show()
        end
    end

    function mapTank.stop()
        if mapTank.data.moving then
            mapTank.data.moving = false
            tankMovingSound.stop()
            tankRunning.hide()
            tankWaiting.show()
        end
    end

    return mapTank
end

return MapTank
