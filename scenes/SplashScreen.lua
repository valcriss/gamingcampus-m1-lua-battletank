local Scene            = require "models.scenes.Scene"
local SpriteSheetImage = require "models.images.SpriteSheetImage"
local BitmapText       = require "models.texts.BitmapText"
local SoundEffect      = require "models.audio.SoundEffect"
local MainMenu         = require "scenes.MainMenu"

---@class SplashScreen
SplashScreen           = {}

SplashScreen.new       = function(splashScreenDuration)
    splashScreenDuration = splashScreenDuration or 7

    local splashScreen   = Scene.new("SplashScreen", 0, { r = 0.5, g = 0.7, b = 1 })

    setmetatable(splashScreen, SplashScreen)
    SplashScreen.__index = SplashScreen

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local elapsedTime    = 0

    -- ---------------------------------------------
    -- Components
    -- ---------------------------------------------

    local logo           = SpriteSheetImage.new("logo", "assets/splashscreen/logo.png", 6, 5, nil, true, screenManager.calculateCenterPointX(), 300, nil, nil, 0, 1)
    local title          = BitmapText.new("title", "assets/splashscreen/title-font.fnt", "Daniel SILVESTRE", "center", "center", screenManager.calculateCenterPointX(), 500)
    local subTitle       = BitmapText.new("subTitle", "assets/splashscreen/subtitle-font.fnt", "Programmation fondamentale LUA et Love2", "center", "center", screenManager.calculateCenterPointX(), 600)
    local soundEffect    = SoundEffect.new("logo-sound", "assets/splashscreen/logo.mp3", nil, true, true, configuration:getSoundVolume())

    splashScreen.addComponent(logo)
    splashScreen.addComponent(title)
    splashScreen.addComponent(subTitle)
    splashScreen.addComponent(soundEffect)

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    ---@public
    function splashScreen.update(dt)
        elapsedTime = elapsedTime + dt
        if (elapsedTime > splashScreenDuration) then
            scenesManager:removeScene(splashScreen)
            scenesManager:addScene(MainMenu.new())
        end
    end

    return splashScreen
end

return SplashScreen
