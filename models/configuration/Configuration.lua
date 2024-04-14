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

    function configuration:changeLevel()
        local level = configuration:getLevel()
        level       = level + 1
        if level == 4 then level = 1 end
        configuration.data.level = level
        configuration:save()
    end


    -- ------------------------------------------------
    -- Enemy Regen Health
    -- ------------------------------------------------

    function configuration:getEnemyRegenHealthAmount()
        return configuration:calculateEnemyRegenHealthAmount(configuration:getDifficulty())
    end

    function configuration:calculateEnemyRegenHealthAmount(value)
        return (9 * value) + 1
    end

    -- ------------------------------------------------
    -- Player Regen Health
    -- ------------------------------------------------

    function configuration:getPlayerRegenHealthAmount()
        return configuration:calculatePlayerRegenHealthAmount(configuration:getDifficulty())
    end

    function configuration:calculatePlayerRegenHealthAmount(value)
        return 10 - (9 * value)
    end

    -- ------------------------------------------------
    -- Player Frozen Duration
    -- ------------------------------------------------

    function configuration:getPlayerFrozenDuration()
        return configuration:calculatePlayerFrozenDuration(configuration:getDifficulty())
    end

    function configuration:calculatePlayerFrozenDuration(value)
        return 3 + (7 * value)
    end

    -- ------------------------------------------------
    -- Enemy Frozen Duration
    -- ------------------------------------------------

    function configuration:getEnemyFrozenDuration()
        return configuration:calculateEnemyFrozenDuration(configuration:getDifficulty())
    end

    function configuration:calculateEnemyFrozenDuration(value)
        return 10 - (7 * value)
    end

    -- ------------------------------------------------
    -- Flag Max Health
    -- ------------------------------------------------

    function configuration:getFlagMaxHealth()
        return configuration:calculateFlagMaxHealth(configuration:getDifficulty())
    end

    function configuration:calculateFlagMaxHealth(value)
        return (value * 200) + 1500
    end

    -- ------------------------------------------------
    -- Main Tower Max Health
    -- ------------------------------------------------

    function configuration:getMainTowerMaxHealth()
        return configuration:calculateMainTowerMaxHealth(configuration:getDifficulty())
    end

    function configuration:calculateMainTowerMaxHealth(value)
        return (value * 500) + 2000
    end

    -- ------------------------------------------------
    -- Enemy Max Health
    -- ------------------------------------------------

    function configuration:getEnemyMaxHealth()
        return configuration:calculateEnemyMaxHealth(configuration:getDifficulty())
    end

    function configuration:calculateEnemyMaxHealth(value)
        return (value * 200) + 150
    end

    -- ------------------------------------------------
    -- Player Max Health
    -- ------------------------------------------------

    function configuration:getPlayerMaxHealth()
        return configuration:calculatePlayerMaxHealth(configuration:getDifficulty())
    end

    function configuration:calculatePlayerMaxHealth(value)
        return ((1 - (value)) * 200) + 150
    end

    -- ------------------------------------------------
    -- Player Damage
    -- ------------------------------------------------

    function configuration:getPlayerDamage()
        return configuration:calculatePlayerDamage(configuration:getDifficulty())
    end

    function configuration:calculatePlayerDamage(value)
        return 30 - (value * 10)
    end

    -- ------------------------------------------------
    -- Enemy Damage
    -- ------------------------------------------------

    function configuration:getEnemyDamage()
        return configuration:calculateEnemyDamage(configuration:getDifficulty())
    end

    function configuration:calculateEnemyDamage(value)
        return 20 + (value * 10)
    end

    -- ------------------------------------------------
    -- Enemy Speed
    -- ------------------------------------------------

    function configuration:getEnemySpeed()
        return configuration:calculateEnemySpeed(configuration:getDifficulty())
    end

    function configuration:calculateEnemySpeed(value)
        return 475 + (value * 25)
    end

    -- ------------------------------------------------
    -- Player Speed
    -- ------------------------------------------------

    function configuration:getPlayerSpeed()
        return configuration:calculatePlayerSpeed(configuration:getDifficulty())
    end

    function configuration:calculatePlayerSpeed(value)
        return 500 - (value * 25)
    end

    -- ------------------------------------------------
    -- Enemy Behavior
    -- ------------------------------------------------

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
