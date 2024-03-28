local Scene = require "models.scenes.Scene"
local MainMenuParallax = require "scenes.models.mainmenu.MainMenuParallax"
local MainMenuFrame = require "scenes.models.mainmenu.MainMenuFrame"
local SpriteSheetImage = require "models.images.SpriteSheetImage"
local BitmapText = require "models.texts.BitmapText"
local SoundEffect = require "models.audio.SoundEffect"
local CreditsFrame = require "scenes.models.mainmenu.CreditsFrame"
local ParametersFrame = require "scenes.models.mainmenu.ParametersFrame"
local Fps = require "models.tools.Fps"

---@class MainMenu
MainMenu = {}

MainMenu.new = function()
    local mainMenu = Scene.new("MainMenu", 0)

    setmetatable(mainMenu, MainMenu)
    MainMenu.__index = MainMenu

    local fps = Fps.new("fps").disable().hide()
    local tank = SpriteSheetImage.new("tank", "assets/mainmenu/tank.png", 34, 65, true, 750, 600, nil, nil, nil, 0.5)
    local backgroundMusic = SoundEffect.new("backgroundMusic", "assets/mainmenu/mainmenu.mp3", "stream", true, true, 0.02)
    local mainMenuTitle = BitmapText.new("mainMenuTitle", "assets/mainmenu/mainmenu-title.fnt", "Battle Tank", "center", "center", screenManager:calculateCenterPointX(), 100, nil, nil, nil)

    mainMenu.addComponent(fps)
            .addComponent(tank)
            .addComponent(backgroundMusic)
            .addComponent(mainMenuTitle)
    -- local mainMenuParallax = MainMenuParallax.new()
    --
    --
    -- local mainMenuFrame =
    --     MainMenuFrame.new(
    --     "Menu Principal",
    --     75,
    --     270,
    --     220,
    --     260,
    --     function(button)
    --         mainMenu:OnButtonClicked(button)
    --     end
    -- )
    -- local creditsFrame = CreditsFrame.new("Credits", 350, 200, 950, 500)
    -- local parametersFrame = ParametersFrame.new("Parametres", 350, 200, 950, 500)

    function mainMenu.OnButtonClicked(button)
        if button == "quit" then
            love.event.quit()
        elseif button == "credits" or button == "parameters" then
            mainMenu.showFrame(button)
        end
    end

    function mainMenu.showFrame(name)
        if name == "credits" then
            if parametersFrame:isVisible() then
                parametersFrame:hide()
            end
            if creditsFrame:isVisible() then
                creditsFrame:hide()
            else
                creditsFrame:show()
            end
        elseif name == "parameters" then
            if creditsFrame:isVisible() then
                creditsFrame:hide()
            end
            if parametersFrame:isVisible() then
                parametersFrame:hide()
            else
                parametersFrame:show()
            end
        end
    end

    function love.keypressed(key)
        if key == "f1" then
            fps.toggleVisibility()
            fps.toggleEnabled()
        end
    end

    return mainMenu
end

return MainMenu
