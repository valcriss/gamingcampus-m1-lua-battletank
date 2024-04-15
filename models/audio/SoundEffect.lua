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
    if loop == nil then loop = false end
    if playOnStart == nil then playOnStart = true end
    loadType          = loadType or "static"
    volume            = volume or 1
    pitch             = pitch or 1

    local soundEffect = Component.new(name)

    setmetatable(soundEffect, SoundEffect)
    SoundEffect.__index = SoundEffect

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------

    ---@type table
    local sound
    ---@type boolean
    local started       = false
    ---@type boolean
    local paused        = false

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------

    ---@public
    --- Fonction appelée automatiquement qui charge le son
    function soundEffect.load()
        sound = love.audio.newSource(assetPath, loadType)
        if (playOnStart) then
            soundEffect.play()
            started = true
        else
            soundEffect.stop()
        end
    end

    ---@public
    --- Fonction appelée automatiquement qui relance le son si la proprétie loop est vraie
    function soundEffect.update(_)
        if sound then
            if not sound:isPlaying() and started and loop == true and paused == false then
                soundEffect.play()
            end
        end
    end

    ---@public
    --- Function qui permet de déclencher le son
    function soundEffect.play()
        if sound then
            if sound:isPlaying() then
                soundEffect.stop()
            end
            sound:setVolume(volume)
            sound:setPitch(pitch)
            sound:play()
            started = true
            paused  = false
        end
    end

    ---@public
    --- Fonction qui permet de reprendre la lecture du son qui à été en pause
    function soundEffect.resume()
        if sound then
            sound:setVolume(volume)
            sound:setPitch(pitch)
            sound:play()
            started = true
            paused  = false
        end
    end

    ---@public
    --- Fonction qui permet de savoir si le son est en cours de lecture
    ---@return boolean
    function soundEffect.isPlaying()
        if sound then
            return sound:isPlaying()
        end
        return false
    end

    ---@public
    --- Fonction qui permet de stopper la lecture du son
    function soundEffect.stop()
        if sound then
            sound:stop()
            started = false
        end
    end

    ---@public
    ----Fonction qui permet de mettre en pause la lecture du son
    function soundEffect.pause()
        if sound then
            sound:pause()
            started = false
            paused  = true
        end
    end

    ---@public
    --- fonction appelée automatiquement qui supprime le son
    function soundEffect.unload()
        soundEffect.stop()
        sound:release()
        sound = nil
    end

    ---@public
    --- Fonction qui permet de modifier le volume
    ---@param value number
    function soundEffect.setVolume(value)
        if sound then
            sound:setVolume(value)
        end
    end

    return soundEffect
end

return SoundEffect
