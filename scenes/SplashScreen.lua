local Scene = require "models.scenes.Scene"
local SpriteSheetImage = require "models.images.SpriteSheetImage"
local BitmapText = require "models.texts.BitmapText"
local SoundEffect = require "models.audio.SoundEffect"

---@class SplashScreen
SplashScreen = {}

SplashScreen.new = function(splashScreenDuration)
    splashScreenDuration = splashScreenDuration or 7
    local splashScreen = Scene:new("SplashScreen", 0)

    setmetatable(splashScreen, SplashScreen)
    SplashScreen.__index = SplashScreen

    -- Classe Properties
    local logo = SpriteSheetImage.new("assets/splashscreen/logo.png", 33)
    local title = BitmapText.new("assets/splashscreen/title-font.fnt")
    local subTitle = BitmapText.new("assets/splashscreen/subtitle-font.fnt")
    local SoundEffect = SoundEffect.new("assets/splashscreen/logo.mp3", nil, true, true, 0.05)
    local elapsedTime = 0

    -- Classe functions

    function splashScreen:load()
        logo:load()
        title:load()
        subTitle:load()
        SoundEffect:load()
    end

    function splashScreen:update(dt)
        logo:update(dt)
        SoundEffect:update(dt)
        elapsedTime = elapsedTime + dt
        if (elapsedTime > splashScreenDuration) then
            scenesManager:addScene(MainMenu.new())
            scenesManager:removeScene(splashScreen)
        end
    end

    function splashScreen:draw()
        screenManager:clear(128, 180, 255)
        logo:draw(screenManager.calculateCenterPointX(), 300, 0, 0.5)
        title:draw(screenManager.calculateCenterPointX(), 600, "Daniel SILVESTRE", 0, "center", "center")
        subTitle:draw(screenManager.calculateCenterPointX(), 700, "Programmation fondamentale LUA et Love2", 0, "center", "center")
    end

    function splashScreen:unload()
        logo:unload()
        title:unload()
        subTitle:unload()
        SoundEffect:unload()
    end

    return splashScreen
end

return SplashScreen
