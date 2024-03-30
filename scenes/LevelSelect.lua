local Scene            = require "models.scenes.Scene"
local Image            = require "models.images.Image"
local LevelButton      = require "scenes.models.levelselect.LevelButton"
local Button           = require "models.ui.Button"
local SpriteSheetImage = require "models.images.SpriteSheetImage"
local InformationFrame = require "scenes.models.levelselect.InformationFrame"
local SoundEffect      = require "models.audio.SoundEffect"

---@class LevelSelect
LevelSelect            = {}

LevelSelect.new        = function()
    order             = order or 0
    local levelSelect = Scene.new("LevelSelect", 0)

    setmetatable(levelSelect, LevelSelect)
    LevelSelect.__index    = LevelSelect

    local map              = Image.new("LevelSelect_map", "assets/levelselect/map.png", screenManager:calculateCenterPointX(), screenManager:calculateCenterPointY())
    local level1           = LevelButton.new("LevelSelect_level1", "assets/levelselect/map-1.png", "assets/levelselect/map-1-disabled.png", "assets/levelselect/map-1-hover.png", "assets/levelselect/map-1-locked.png", 223 - 32, 543 - 32, 1, function(data) levelSelect.onLevelClick(data) end, function(data) levelSelect.onLevelEnter(data) end, function(data) levelSelect.onLevelLeave(data) end)
    local level2           = LevelButton.new("LevelSelect_level2", "assets/levelselect/map-2.png", "assets/levelselect/map-2-disabled.png", "assets/levelselect/map-2-hover.png", "assets/levelselect/map-2-locked.png", 671 - 32, 351 - 32, 2, function(data) levelSelect.onLevelClick(data) end, function(data) levelSelect.onLevelEnter(data) end, function(data) levelSelect.onLevelLeave(data) end)
    local level3           = LevelButton.new("LevelSelect_level3", "assets/levelselect/map-3.png", "assets/levelselect/map-3-disabled.png", "assets/levelselect/map-3-hover.png", "assets/levelselect/map-3-locked.png", 1120 - 32, 159 - 32, 3, function(data) levelSelect.onLevelClick(data) end, function(data) levelSelect.onLevelEnter(data) end, function(data) levelSelect.onLevelLeave(data) end)
    local transition       = SpriteSheetImage.new("transition", "assets/mainmenu/transition-100.png", 3, 8, 30, false, screenManager:calculateCenterPointX(), screenManager:calculateCenterPointY(), nil, nil, nil, 1.01, nil, function() levelSelect.backToMainMenu() end)                                                       .hide().disable()
    local transitionEffect = SoundEffect.new("transitionEffect", "assets/ui/ascending.mp3", "static", false, false, configuration:getSoundVolume())
    local backgroundMusic  = SoundEffect.new("backgroundMusic", "assets/levelselect/levelselect.mp3", "stream", true, true, configuration:getMusicVolume())
    local returnButton     = Button.new("LevelSelect_returnButton", "assets/ui/yellow_button00.png", "assets/ui/yellow_button04.png", "assets/ui/yellow_button03.png", screenManager:getWindowWidth() - 220, screenManager:getWindowHeight() - 72, "Menu Principal", function()
        transition.enable().show()
        transitionEffect.play()
    end)
    local information      = InformationFrame.new("LevelSelect_information", "Information", 30, 80, 500, 50, 3000).hide()
    local informationText  = ""

    levelSelect.addComponent(map)
    levelSelect.addComponent(level1)
    levelSelect.addComponent(level2)
    levelSelect.addComponent(level3)
    levelSelect.addComponent(returnButton)
    levelSelect.addComponent(transition)
    levelSelect.addComponent(information)
    levelSelect.addComponent(transitionEffect)
    levelSelect.addComponent(backgroundMusic)

    function levelSelect.update(_)
        information.setContent(informationText)
    end

    function levelSelect.backToMainMenu()
        scenesManager:removeScene(levelSelect)
        scenesManager:addScene(MainMenu.new())
    end

    function levelSelect.onLevelClick(_)
    end

    function levelSelect.onLevelEnter(data)
        if data.active then
            informationText = "Cliquez poour commencer le niveau " .. data.level
        else
            informationText = "Vous n'avez pas encore atteind le niveau " .. data.level
        end
        information.appear()
    end

    function levelSelect.onLevelLeave(_)
        information.disappear()
    end

    return levelSelect
end

return LevelSelect
