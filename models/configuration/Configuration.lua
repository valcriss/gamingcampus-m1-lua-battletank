-- Configuration sauvegardé dans le fichier : %appdata%\LOVE\gamingcampus-m1-lua-battletank\configuration.json
local json           = require "libs.json"
local EasyBehavior   = require "scenes.models.gameLevel.game.entities.behaviors.EasyBehavior"
local MediumBehavior = require "scenes.models.gameLevel.game.entities.behaviors.MediumBehavior"
local HardBehavior   = require "scenes.models.gameLevel.game.entities.behaviors.HardBehavior"
---@class Configuration
Configuration        = {}

Configuration.new    = function()
    local configuration = {
        data                 = {},
        defaultConfiguration = {
            fullScreen  = false,
            vsync       = false,
            musicVolume = 1,
            soundVolume = 1,
            difficulty  = 0.5,
            maximized   = false,
            level       = 1
        }
    }

    setmetatable(configuration, Configuration)
    Configuration.__index = Configuration
    --[[
        Getter et Setters
    --]]
    function configuration:isFullScreen()
        return configuration.data.fullScreen
    end

    function configuration:setFullScreen(value)
        configuration.data.fullScreen = value
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

    function configuration:getLevel()
        return configuration.data.level
    end

    function configuration:setLevel(value)
        configuration.data.level = value
        configuration:save()
    end

    function configuration:getEnemyRegenHealthAmount()
        return (9 * configuration:getDifficulty()) + 1
    end

    function configuration:getPlayerRegenHealthAmount()
        return 10 - (9 * configuration:getDifficulty())
    end

    function configuration:getFlagMaxHealth()
        return (configuration:getDifficulty() * 200) + 300
    end

    function configuration:getMainTowerMaxHealth()
        return (configuration:getDifficulty() * 500) + 500
    end

    function configuration:getEnemyMaxHealth()
        return (configuration:getDifficulty() * 200) + 150
    end

    function configuration:getPlayerMaxHealth()
        return ((1 - (configuration:getDifficulty())) * 200) + 150
    end

    function configuration:getPlayerDamage()
        return ((1 - (configuration:getDifficulty())) * 20) + 10
    end

    function configuration:getEnemyDamage()
        return 20 - (configuration:getDifficulty() * 10)
    end

    function configuration:getEnemySpeed()
        return 400 + (configuration:getDifficulty() * 200)
    end

    function configuration:getEnemyBehavior(gameManager, enemy)
        if configuration:getDifficulty() < 0.4 then
            return EasyBehavior.new(gameManager, enemy)
        elseif configuration:getDifficulty() < 0.7 then
            return MediumBehavior.new(gameManager, enemy)
        else
            return HardBehavior.new(gameManager, enemy)
        end
    end
    function configuration:setConfiguration(data)
        local needReload   = configuration.data.fullScreen ~= data.fullScreen or configuration.data.vsync ~= data.vsync
        configuration.data = data
        configuration:save()
        return needReload
    end

    --[[
        Fonctions de sauvegarde et chargement
    --]]
    function configuration:load()
        local filename = configuration:getFileName()
        local file     = io.open(filename, "r")
        if file == nil then
            configuration.data = configuration.defaultConfiguration
            configuration:save()
        else
            local contents = file:read("*a")
            file:close()
            configuration.data = json.decode(contents)
        end
    end

    function configuration:save()
        local filename = configuration:getFileName()
        local file     = io.open(filename, "w")
        file:write(json.encode(configuration.data))
        file:close()
    end

    function configuration:getFileName()
        local saveDirectory = love.filesystem.getSaveDirectory()
        if love.filesystem.getInfo(saveDirectory) == nil then love.filesystem.createDirectory(saveDirectory) end
        local path = love.filesystem.getSaveDirectory() .. "/configuration.json"
        if love.system.getOS() == "Windows" then path = path:gsub("/", "\\") end
        return path
    end

    return configuration
end

return Configuration
