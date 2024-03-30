local Component = require "models.scenes.Component"
---@class SoundEffect
SoundEffect     = {}

---@param name string
---@param assetPath string
---@param loadType string
---@param loop boolean
---@param playOnStart boolean
---@param volume number
---@param pitch number
SoundEffect.new = function(name, assetPath, loadType --[[optional]], loop --[[optional]], playOnStart --[[optional]], volume --[[optional]], pitch --[[optional]])
    loadType = loadType or "static"
    if loop == nil then
        loop = false
    end
    if playOnStart == nil then
        playOnStart = true
    end
    volume            = volume or 1
    pitch             = pitch or 1
    local soundEffect = Component.new(
            name,
            {
                assetPath   = assetPath,
                loadType    = loadType,
                loop        = loop,
                playOnStart = playOnStart,
                volume      = volume,
                pitch       = pitch,
                sound       = nil
            }
    )

    setmetatable(soundEffect, SoundEffect)
    SoundEffect.__index = SoundEffect

    ---@public
    function soundEffect.load()
        soundEffect.data.sound = love.audio.newSource(soundEffect.data.assetPath, soundEffect.data.loadType)
        if (soundEffect.data.playOnStart) then
            soundEffect.play()
        else
            soundEffect.stop()
        end
    end

    ---@public
    function soundEffect.update(_)
        if soundEffect.data.sound then
            if not soundEffect.data.sound:isPlaying() and soundEffect.data.loop == true then
                soundEffect.play()
            end
        end
    end

    ---@public
    function soundEffect.play()
        if soundEffect.data.sound then
            if soundEffect.data.sound:isPlaying() then
                soundEffect.stop()
            end
            soundEffect.data.sound:setVolume(soundEffect.data.volume)
            soundEffect.data.sound:setPitch(soundEffect.data.pitch)
            soundEffect.data.sound:play()
        end
    end

    ---@public
    function soundEffect.stop()
        if soundEffect.data.sound then
            soundEffect.data.sound:stop()
        end
    end

    ---@public
    function soundEffect.pause()
        if soundEffect.data.sound then
            soundEffect.data.sound:pause()
        end
    end

    ---@public
    function soundEffect.unload()
        soundEffect.stop()
        soundEffect.data.sound:release()
        soundEffect.data.sound = nil
    end

    function soundEffect.setVolume(value)
        soundEffect.data.volume = value
        if soundEffect.data.sound then
            soundEffect.data.sound:setVolume(soundEffect.data.volume)
        end
    end

    return soundEffect
end

return SoundEffect
