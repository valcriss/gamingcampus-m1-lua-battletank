local Component   = require "models.scenes.Component"
local Frame       = require "models.ui.Frame"
local BitmapText  = require "models.texts.BitmapText"
local Button      = require "models.ui.Button"

---@class MainMenuFrame
MainMenuFrame     = {}

MainMenuFrame.new = function(name, title, x, y, width, height, action)
    local mainMenuFrame = Component.new(name, x, y, width, height)

    setmetatable(mainMenuFrame, MainMenuFrame)
    MainMenuFrame.__index      = MainMenuFrame

    -- ---------------------------------------------
    -- Components
    -- ---------------------------------------------
    
    local frame                = Frame.new(mainMenuFrame.name .. "_frame", "assets/ui/grey_panel.png", 10, mainMenuFrame.bounds.x, mainMenuFrame.bounds.y, mainMenuFrame.bounds.width, mainMenuFrame.bounds.height)
    local blueFrame            = Frame.new(mainMenuFrame.name .. "_blueFrame", "assets/ui/blue_panel.png", 10, mainMenuFrame.bounds.x, mainMenuFrame.bounds.y - 30, mainMenuFrame.bounds.width, 50)
    local frameTitle           = BitmapText.new(mainMenuFrame.name .. "_frameTitle", "assets/ui/ui-18.fnt", title, "center", "center", mainMenuFrame.bounds.x + (mainMenuFrame.bounds.width / 2) + 7, mainMenuFrame.bounds.y - 13)
    local startGameButton      = Button.new(mainMenuFrame.name .. "_startGameButton", "assets/ui/green_button00.png", "assets/ui/green_button04.png", "assets/ui/green_button03.png", mainMenuFrame.bounds.x + 20, mainMenuFrame.bounds.y + 20, "Lancer le jeu", function() action("start") end)
    local creditGameButton     = Button.new(mainMenuFrame.name .. "_creditGameButton", "assets/ui/yellow_button00.png", "assets/ui/yellow_button04.png", "assets/ui/yellow_button03.png", mainMenuFrame.bounds.x + 20, mainMenuFrame.bounds.y + 80, "Credits", function() action("credits") end)
    local parametersGameButton = Button.new(mainMenuFrame.name .. "_parametersGameButton", "assets/ui/red_button11.png", "assets/ui/red_button01.png", "assets/ui/red_button02.png", mainMenuFrame.bounds.x + 20, mainMenuFrame.bounds.y + 140, "Parametres", function() action("parameters") end)
    local quitGameButton       = Button.new(mainMenuFrame.name .. "_quitGameButton", "assets/ui/blue_button13.png", "assets/ui/red_button10.png", "assets/ui/red_button02.png", mainMenuFrame.bounds.x + 20, mainMenuFrame.bounds.y + 200, "Quitter le jeu", function() action("quit") end)

    mainMenuFrame.addComponent(blueFrame)
    mainMenuFrame.addComponent(frame)
    mainMenuFrame.addComponent(frameTitle)
    mainMenuFrame.addComponent(startGameButton)
    mainMenuFrame.addComponent(creditGameButton)
    mainMenuFrame.addComponent(parametersGameButton)
    mainMenuFrame.addComponent(quitGameButton)

    return mainMenuFrame
end

return MainMenuFrame
