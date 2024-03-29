-- Configuration sauvegardé dans le fichier : %appdata%\Roaming\LOVE\gamingcampus-m1-lua-battletank\configuration.json
local json = require "libs.json"
---@class Configuration
Configuration = {}

Configuration.new = function()
    local configuration = {
        data = {},
        defaultConfiguration = {
            fullscreen = false,
            vsync = false,
            musicVolume = 0.5,
            soundVolume = 1,
            difficulty = 2
        }
    }

    setmetatable(configuration, Configuration)
    Configuration.__index = Configuration
    --[[
        Getter et Setters
    --]]
    function configuration:isFullscreen()
        return configuration.data.fullscreen
    end

    function configuration:setFullscreen(value)
        configuration.data.fullscreen = value
        configuration:save()
    end

    function configuration:getVsync()
        return configuration.data.vsync
    end

    function configuration:getVsyncAsInteger()
        if configuration.data.vsync then
            return 1
        else
            return 0
        end
    end

    function configuration:setVsync(value)
        configuration.data.vsync = value
        configuration:save()
    end

    function configuration:getMusicVolume()
        return configuration.data.musicVolume
    end

    function configuration:setMusicVolume(value)
        configuration.data.musicVolume = value
        configuration:save()
    end

    function configuration:getSoundVolume()
        return configuration.data.soundVolume
    end

    function configuration:setSoundVolume(value)
        configuration.data.soundVolume = value
        configuration:save()
    end

    --[[
        Fonctions de sauvegarde et chargement
    --]]
    function configuration:load()
        local filename = configuration:getFileName()
        print(filename)
        if love.filesystem.getInfo(filename) == nil then
            configuration.data = configuration.defaultConfiguration
            configuration:save()
        else
            local file = io.open(filename, "r")
            local contents = file:read("*a")
            file:close()
            configuration.data = json.decode(contents)
        end
    end

    function configuration:save()
        local filename = configuration:getFileName()
        local file = io.open(filename, "w")
        file:write(json.encode(configuration.data))
        file:close()
    end

    function configuration:getFileName()
        local saveDirectory = love.filesystem.getSaveDirectory()
        if love.filesystem.getInfo(saveDirectory) == nil then
            love.filesystem.createDirectory(saveDirectory)
        end
        return love.filesystem.getSaveDirectory() .. "/configuration.json"
    end

    return configuration
end

return Configuration
