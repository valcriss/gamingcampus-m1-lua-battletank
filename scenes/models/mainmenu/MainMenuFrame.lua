local Frame = require "models.ui.Frame"
local BitmapText = require "models.texts.BitmapText"
local Button = require "models.ui.Button"

---@class MainMenuFrame
MainMenuFrame = {}

MainMenuFrame.new = function(title, x, y, width, height)
    local mainMenuFrame = {
        title = title,
        x = x,
        y = y,
        width = width,
        height = height
    }

    setmetatable(mainMenuFrame, MainMenuFrame)
    MainMenuFrame.__index = MainMenuFrame

    local frame = Frame.new("assets/ui/grey_panel.png", 10, mainMenuFrame.x, mainMenuFrame.y, mainMenuFrame.width, mainMenuFrame.height)
    local blueFrame = Frame.new("assets/ui/blue_panel.png", 10, mainMenuFrame.x, mainMenuFrame.y - 30, mainMenuFrame.width, 50)
    local frameTitle = BitmapText.new("assets/ui/ui-18.fnt")
    local startGameButton = Button.new("assets/ui/green_button00.png", "assets/ui/green_button04.png", mainMenuFrame.x + 20, mainMenuFrame.y + 20, "Lancer le jeu")
    local creditGameButton = Button.new("assets/ui/yellow_button00.png", "assets/ui/yellow_button04.png", mainMenuFrame.x + 20, mainMenuFrame.y + 80, "Credits")
    local parametersGameButton = Button.new("assets/ui/red_button11.png", "assets/ui/red_button01.png", mainMenuFrame.x + 20, mainMenuFrame.y + 140, "Parametres")
    local quitGameButton =
        Button.new(
        "assets/ui/blue_button13.png",
        "assets/ui/red_button10.png",
        mainMenuFrame.x + 20,
        mainMenuFrame.y + 200,
        "Quitter le jeu",
        function()
            mainMenuFrame:quitGame()
        end
    )

    function mainMenuFrame:load()
        frameTitle:load()
        blueFrame:load()
        frame:load()
        startGameButton:load()
        creditGameButton:load()
        parametersGameButton:load()
        quitGameButton:load()
    end

    function mainMenuFrame:update(dt)
        startGameButton:update(dt)
        creditGameButton:update(dt)
        parametersGameButton:update(dt)
        quitGameButton:update(dt)
    end

    function mainMenuFrame:draw()
        blueFrame:draw()
        frame:draw()
        frameTitle:draw(mainMenuFrame.x + (mainMenuFrame.width / 2) + 7, mainMenuFrame.y - 13, mainMenuFrame.title, 0, "center", "center")
        startGameButton:draw()
        creditGameButton:draw()
        parametersGameButton:draw()
        quitGameButton:draw()
    end

    function mainMenuFrame:unload()
        frameTitle:unload()
        blueFrame:unload()
        frame:unload()
        startGameButton:unload()
        creditGameButton:unload()
        parametersGameButton:unload()
        quitGameButton:unload()
    end

    function mainMenuFrame:quitGame()
        love.event.quit()
    end

    return mainMenuFrame
end

return MainMenuFrame
