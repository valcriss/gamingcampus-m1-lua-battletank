-- Configuration sauvegardé dans le fichier : %appdata%\LOVE\gamingcampus-m1-lua-battletank\configuration.json
local json           = require "libs.json"
local EasyBehavior   = require "models.gameLevel.game.entities.behaviors.EasyBehavior"
local MediumBehavior = require "models.gameLevel.game.entities.behaviors.MediumBehavior"
local HardBehavior   = require "models.gameLevel.game.entities.behaviors.HardBehavior"

---@class Configuration
Configuration        = {}

Configuration.new    = function()
    local configuration = {
        data                 = {},
        defaultConfiguration = {
            fullScreen  = false,
            vsync       = false,
            musicVolume = 0.1,
            soundVolume = 0.5,
            difficulty  = 0,
            maximized   = false,
            level       = 1
        }
    }

    setmetatable(configuration, Configuration)
    Configuration.__index = Configuration

    -- ------------------------------------------------
    -- Game Fullscreen (get,set)
    -- ------------------------------------------------
    ---@public
    --- Retourne un boolean indiquant si la fenetre est en plein ecran
    ---@return boolean
    function configuration:isFullScreen()
        return configuration.data.fullScreen
    end

    ---@public
    --- Defini si la fenetre est en plein ecran
    ---@param value boolean
    function configuration:setFullScreen(value)
        configuration.data.fullScreen = value
        configuration:save()
    end

    -- ------------------------------------------------
    -- Graphics Vsync (get,set)
    -- ------------------------------------------------

    ---@public
    --- Retourne un boolean indiquant si le vsync est active
    ---@return boolean
    function configuration:getVsync()
        return configuration.data.vsync
    end

    ---@public
    --- Retourne un entier indiquant si le vsync est active
    ---@return number
    function configuration:getVsyncAsInteger()
        if configuration.data.vsync then
            return 1
        else
            return 0
        end
    end

    ---@public
    --- Defini si le vsync est active
    ---@param value boolean
    function configuration:setVsync(value)
        configuration.data.vsync = value
        configuration:save()
    end

    -- ------------------------------------------------
    -- Music Volume (get,set)
    -- ------------------------------------------------

    ---@public
    --- Retourne un réel entre 0 et 1 indiquant le volume de la musique
    ---@return number
    function configuration:getMusicVolume()
        return configuration.data.musicVolume
    end

    ---@public
    --- Defini le volume de la musique
    ---@param value number
    function configuration:setMusicVolume(value)
        configuration.data.musicVolume = value
        configuration:save()
    end

    -- ------------------------------------------------
    -- Sound Volume (get,set)
    -- ------------------------------------------------

    ---@public
    --- Retourne un réel entre 0 et 1 indiquant le volume des sons
    ---@return number
    function configuration:getSoundVolume()
        return configuration.data.soundVolume
    end

    ---@public
    --- Defini le volume des sons
    ---@param value number
    function configuration:setSoundVolume(value)
        configuration.data.soundVolume = value
        configuration:save()
    end

    -- ------------------------------------------------
    -- Game difficulty (get,set)
    -- ------------------------------------------------

    ---@public
    --- Retourne un réel (0,0.5,1) indiquant la difficulte
    ---@return number
    function configuration:getDifficulty()
        return configuration.data.difficulty
    end

    ---@public
    --- Defini la difficulte
    ---@param value number
    function configuration:setDifficulty(value)
        configuration.data.difficulty = value
        configuration:save()
    end

    -- ------------------------------------------------
    -- Screen Maximized (get,set)
    -- ------------------------------------------------

    ---@public
    --- Retourne un boolean indiquant si la fenetre est maximise
    ---@return boolean
    function configuration:isMaximized()
        return configuration.data.maximized
    end

    ---@public
    --- Defini si la fenetre est maximise
    ---@param value boolean
    function configuration:setMaximized(value)
        configuration.data.maximized = value
        configuration:save()
    end

    -- ------------------------------------------------
    -- Player level (get, set, increment)
    -- ------------------------------------------------

    ---@public
    --- Retourne le niveau du joueur
    ---@return number
    function configuration:getLevel()
        return configuration.data.level
    end

    ---@public
    --- Defini le niveau du joueur
    ---@param value number
    function configuration:setLevel(value)
        configuration.data.level = value
        configuration:save()
    end

    ---@public
    --- Incremente le niveau du joueur
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
    ---@public
    --- Retourne le nombre de points de vie regen par ennemi
    ---@return number
    function configuration:getEnemyRegenHealthAmount()
        return configuration:calculateEnemyRegenHealthAmount(configuration:getDifficulty())
    end

    ---@public
    --- Retourne le nombre de points de vie regen par ennemi en passant en param une valeur entre 0 et 1
    ---@param value number
    ---@return number
    function configuration:calculateEnemyRegenHealthAmount(value)
        return (9 * value) + 1
    end

    -- ------------------------------------------------
    -- Player Regen Health
    -- ------------------------------------------------
    ---@public
    --- Retourne le nombre de points de vie regen par joueur
    ---@return number
    function configuration:getPlayerRegenHealthAmount()
        return configuration:calculatePlayerRegenHealthAmount(configuration:getDifficulty())
    end

    ---@public
    --- Retourne le nombre de points de vie regen par joueur en passant en param une valeur entre 0 et 1
    ---@param value number
    ---@return number
    function configuration:calculatePlayerRegenHealthAmount(value)
        return 20 - (9 * value)
    end

    -- ------------------------------------------------
    -- Player Frozen Duration
    -- ------------------------------------------------
    ---@public
    --- Retourne le temps de freeze du joueur
    ---@return number
    function configuration:getPlayerFrozenDuration()
        return configuration:calculatePlayerFrozenDuration(configuration:getDifficulty())
    end

    ---@public
    --- Retourne le temps de freeze du joueur en passant en param une valeur entre 0 et 1
    ---@param value number
    ---@return number
    function configuration:calculatePlayerFrozenDuration(value)
        return 3 + (7 * value)
    end

    -- ------------------------------------------------
    -- Enemy Frozen Duration
    -- ------------------------------------------------
    ---@public
    --- Retourne le temps de freeze de l'ennemi
    ---@return number
    function configuration:getEnemyFrozenDuration()
        return configuration:calculateEnemyFrozenDuration(configuration:getDifficulty())
    end

    ---@public
    --- Retourne le temps de freeze de l'ennemi en passant en param une valeur entre 0 et 1
    ---@param value number
    ---@return number
    function configuration:calculateEnemyFrozenDuration(value)
        return 15 - (7 * value)
    end

    -- ------------------------------------------------
    -- Flag Max Health
    -- ------------------------------------------------
    ---@public
    --- Retourne le nombre de points de vie max du drapeau
    ---@return number
    function configuration:getFlagMaxHealth()
        return configuration:calculateFlagMaxHealth(configuration:getDifficulty())
    end

    ---@public
    --- Retourne le nombre de points de vie max du drapeau en passant en param une valeur entre 0 et 1
    ---@param value number
    ---@return number
    function configuration:calculateFlagMaxHealth(value)
        return (value * 200) + 1500
    end

    -- ------------------------------------------------
    -- Main Tower Max Health
    -- ------------------------------------------------
    ---@public
    --- Retourne le nombre de points de vie max de la tour
    ---@return number
    function configuration:getMainTowerMaxHealth()
        return configuration:calculateMainTowerMaxHealth(configuration:getDifficulty())
    end

    ---@public
    --- Retourne le nombre de points de vie max de la tour en passant en param une valeur entre 0 et 1
    ---@param value number
    ---@return number
    function configuration:calculateMainTowerMaxHealth(value)
        return (value * 500) + 2000
    end

    -- ------------------------------------------------
    -- Enemy Max Health
    -- ------------------------------------------------
    ---@public
    --- Retourne le nombre de points de vie max de l'ennemi
    ---@return number
    function configuration:getEnemyMaxHealth()
        return configuration:calculateEnemyMaxHealth(configuration:getDifficulty())
    end

    ---@public
    --- Retourne le nombre de points de vie max de l'ennemi en passant en param une valeur entre 0 et 1
    ---@param value number
    ---@return number
    function configuration:calculateEnemyMaxHealth(value)
        return (value * 200) + 150
    end

    -- ------------------------------------------------
    -- Player Max Health
    -- ------------------------------------------------
    ---@public
    --- Retourne le nombre de points de vie max du joueur
    ---@return number
    function configuration:getPlayerMaxHealth()
        return configuration:calculatePlayerMaxHealth(configuration:getDifficulty())
    end

    ---@public
    --- Retourne le nombre de points de vie max du joueur en passant en param une valeur entre 0 et 1
    ---@param value number
    ---@return number
    function configuration:calculatePlayerMaxHealth(value)
        return ((1 - (value)) * 200) + 150
    end

    -- ------------------------------------------------
    -- Player Damage
    -- ------------------------------------------------
    ---@public
    --- Retourne le nombre de points de degats du joueur
    ---@return number
    function configuration:getPlayerDamage()
        return configuration:calculatePlayerDamage(configuration:getDifficulty())
    end

    ---@public
    --- Retourne le nombre de points de degats du joueur en passant en param une valeur entre 0 et 1
    ---@param value number
    ---@return number
    function configuration:calculatePlayerDamage(value)
        return 40 - (value * 10)
    end

    -- ------------------------------------------------
    -- Enemy Damage
    -- ------------------------------------------------
    ---@public
    --- Retourne le nombre de points de degats de l'ennemi
    ---@return number
    function configuration:getEnemyDamage()
        return configuration:calculateEnemyDamage(configuration:getDifficulty())
    end

    ---@public
    --- Retourne le nombre de points de degats de l'ennemi en passant en param une valeur entre 0 et 1
    ---@param value number
    ---@return number
    function configuration:calculateEnemyDamage(value)
        return 10 + (value * 10)
    end

    -- ------------------------------------------------
    -- Enemy Speed
    -- ------------------------------------------------
    ---@public
    --- Retourne la vitesse de l'ennemi
    ---@return number
    function configuration:getEnemySpeed()
        return configuration:calculateEnemySpeed(configuration:getDifficulty())
    end

    ---@public
    --- Retourne la vitesse de l'ennemi en passant en param une valeur entre 0 et 1
    ---@param value number
    ---@return number
    function configuration:calculateEnemySpeed(value)
        return 400 + (value * 25)
    end

    -- ------------------------------------------------
    -- Player Speed
    -- ------------------------------------------------
    ---@public
    --- Retourne la vitesse du joueur
    ---@return number
    function configuration:getPlayerSpeed()
        return configuration:calculatePlayerSpeed(configuration:getDifficulty())
    end

    ---@public
    --- Retourne la vitesse du joueur en passant en param une valeur entre 0 et 1
    ---@param value number
    ---@return number
    function configuration:calculatePlayerSpeed(value)
        return 500 - (value * 25)
    end

    -- ------------------------------------------------
    -- Enemy Behavior
    -- ------------------------------------------------
    ---@public
    --- Retourne le comportement de l'ennemi
    ---@param gameManager GameManager
    ---@param enemy Enemy
    ---@return Behavior
    function configuration:getEnemyBehavior(gameManager, enemy)
        if configuration:getDifficulty() < 0.4 then
            return EasyBehavior.new(gameManager, enemy)
        elseif configuration:getDifficulty() < 0.7 then
            return MediumBehavior.new(gameManager, enemy)
        else
            return HardBehavior.new(gameManager, enemy)
        end
    end

    -- ------------------------------------------------
    -- Remplace la configuration actuelle et la sauvegarde
    -- ------------------------------------------------
    ---@public
    --- Defini la configuration
    ---@param data Configuration
    ---@return boolean
    function configuration:setConfiguration(data)
        local needReload   = configuration.data.fullScreen ~= data.fullScreen or configuration.data.vsync ~= data.vsync
        configuration.data = data
        configuration:save()
        return needReload
    end

    -- ------------------------------------------------
    -- Charge la configuration depuis un fichier ou la configuration par défaut
    -- ------------------------------------------------
    ---@public
    --- Charge la configuration
    ---@return Configuration
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

    -- ------------------------------------------------
    -- Sauvegarde la configuration dans un fichier
    -- ------------------------------------------------
    ---@private
    --- Sauvegarde la configuration
    function configuration:save()
        local filename = configuration:getFileName()
        local file     = io.open(filename, "w")
        file:write(json.encode(configuration.data))
        file:close()
    end

    -- ------------------------------------------------
    -- Retourne le chemin complet vers le fichier de configuration
    -- ------------------------------------------------
    ---@private
    --- Retourne le chemin complet vers le fichier de configuration
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
