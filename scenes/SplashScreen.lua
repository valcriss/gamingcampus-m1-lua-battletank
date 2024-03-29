local Scene = require "models.scenes.Scene"
local SpriteSheetImage = require "models.images.SpriteSheetImage"
local BitmapText = require "models.texts.BitmapText"
local SoundEffect = require "models.audio.SoundEffect"

---@class SplashScreen
SplashScreen = {}

SplashScreen.new = function(splashScreenDuration)
    splashScreenDuration = splashScreenDuration or 7

    local splashScreen = Scene.new("SplashScreen", 0, {r = 128, g = 180, b = 255})

    setmetatable(splashScreen, SplashScreen)
    SplashScreen.__index = SplashScreen

    local logo = SpriteSheetImage.new("logo", "assets/splashscreen/logo.png", 33, nil, nil, true, screenManager.calculateCenterPointX(), 300, nil, nil, 0, 0.5)
    local title = BitmapText.new("title", "assets/splashscreen/title-font.fnt", "Daniel SILVESTRE", "center", "center", screenManager.calculateCenterPointX(), 600)
    local subTitle = BitmapText.new("subTitle", "assets/splashscreen/subtitle-font.fnt", "Programmation fondamentale LUA et Love2", "center", "center", screenManager.calculateCenterPointX(), 700)
    local soundEffect = SoundEffect.new("logo-sound", "assets/splashscreen/logo.mp3", nil, true, true, configuration:getSoundVolume())

    splashScreen.addComponent(logo).addComponent(title).addComponent(subTitle).addComponent(soundEffect)

    local elapsedTime = 0

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
