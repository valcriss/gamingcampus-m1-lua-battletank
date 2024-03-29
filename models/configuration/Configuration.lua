-- Configuration sauvegardé dans le fichier : %appdata%\LOVE\gamingcampus-m1-lua-battletank\configuration.json
local json = require "libs.json"
---@class Configuration
Configuration = {}

Configuration.new = function()
    local configuration = {
        data = {},
        defaultConfiguration = {
            fullScreen = false,
            vsync = false,
            musicVolume = 1,
            soundVolume = 1,
            difficulty = 0.5,
            maximized = false,
            windowX = nil,
            windowY = nil,
            windowWidth = nil,
            windowHeight = nil
        }
    }

    setmetatable(configuration, Configuration)
    Configuration.__index = Configuration
    --[[
        Getter et Setters
    --]]
    function configuration:isFullScreen()
        return configuration.data.fullscreen
    end

    function configuration:setFullScreen(value)
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

    function configuration:getDifficulty()
        return configuration.data.difficulty
    end

    function configuration:setDifficulty(value)
        configuration.data.difficulty = value
        configuration:save()
    end

    function configuration:isMaximized()
        return configuration.data.maximized
    end

    function configuration:setMaximized(value)
        configuration.data.maximized = value
        configuration:save()
    end

    function configuration:getWindowX()
        return configuration.data.windowX
    end

    function configuration:getWindowY()
        return configuration.data.windowY
    end

    function configuration:setWindowPosition(x, y)
        configuration.data.windowX = x
        configuration.data.windowY = y
        configuration:save()
    end

    function configuration:getWindowWidth()
        return configuration.data.windowWidth
    end

    function configuration:getWindowHeight()
        return configuration.data.windowHeight
    end

    function configuration:setWindowDimensions(width, height)
        configuration.data.windowWidth = width
        configuration.data.windowHeight = height
        configuration:save()
    end

    function configuration:setConfiguration(data)
        local needReload = configuration.data.fullscreen ~= data.fullscreen or configuration.data.vsync ~= data.vsync
        configuration.data = data
        configuration:save()
        return needReload
    end

    function configuration:storeWindowConfiguration()
        windowX, windowY, displayIndex = love.window.getPosition()
        configuration.data.maximized = love.window.isMaximized()
        configuration.data.windowX = windowX
        configuration.data.windowY = windowY
        configuration.data.windowWidth = love.graphics.getWidth()
        configuration.data.windowHeight = love.graphics.getHeight()
        configuration:save()
    end

    --[[
        Fonctions de sauvegarde et chargement
    --]]
    function configuration:load()
        local filename = configuration:getFileName()
        local file = io.open(filename, "r")
        if file == nil then
            print("Creating new configuration file : " .. filename)
            configuration.data = configuration.defaultConfiguration
            configuration:save()
        else
            print("Loading configuration file : " .. filename)
            local contents = file:read("*a")
            file:close()
            configuration.data = json.decode(contents)
        end
    end

    function configuration:save()
        local filename = configuration:getFileName()
        print("Saving configuration file : " .. filename)
        local file = io.open(filename, "w")
        file:write(json.encode(configuration.data))
        file:close()
    end

    function configuration:getFileName()
        local saveDirectory = love.filesystem.getSaveDirectory()
        if love.filesystem.getInfo(saveDirectory) == nil then
            love.filesystem.createDirectory(saveDirectory)
        end
        local path = love.filesystem.getSaveDirectory() .. "/configuration.json"
        if love.system.getOS() == "Windows" then
            path = path:gsub("/", "\\")
        end
        return path
    end

    return configuration
end

return Configuration
