---@class SoundEffect
SoundEffect = {}

SoundEffect.new = function(assetPath, loadType --[[optional]], loop --[[optional]], playOnStart --[[optional]], volume --[[optional]], pitch --[[optional]])
    loadType = loadType or "static"
    loop = loop or false
    playOnStart = playOnStart or true
    volume = volume or 1
    pitch = pitch or 1
    local soundEffect = {
        assetPath = assetPath,
        loadType = loadType,
        loop = loop,
        playOnStart = playOnStart,
        volume = volume,
        pitch = pitch,
        sound = nil
    }

    setmetatable(soundEffect, SoundEffect)
    SoundEffect.__index = SoundEffect

    ---@public
    function soundEffect:load()
        soundEffect.sound = love.audio.newSource(soundEffect.assetPath, soundEffect.loadType)
        if (soundEffect.playOnStart) then
            soundEffect:play()
        end
    end

    ---@public
    function soundEffect:update(dt)
        if soundEffect.sound then
            if not soundEffect.sound:isPlaying() and soundEffect.loop then
                soundEffect:play()
            end
        end
    end

    ---@public
    function soundEffect:play()
        if soundEffect.sound then
            soundEffect.sound:setVolume(soundEffect.volume)
            soundEffect.sound:setPitch(soundEffect.pitch)
            soundEffect.sound:play()
        end
    end

    ---@public
    function soundEffect:stop()
        if soundEffect.sound then
            soundEffect.sound:stop()
        end
    end

    ---@public
    function soundEffect:pause()
        if soundEffect.sound then
            soundEffect.sound:pause()
        end
    end

    ---@public
    function soundEffect:unload()
        soundEffect:stop()
        soundEffect.sound:release()
        soundEffect.sound = nil
    end

    return soundEffect
end

return SoundEffect
