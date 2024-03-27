local Frame = require "models.ui.Frame"
local BitmapText = require "models.texts.BitmapText"

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

    function mainMenuFrame:load()
        frameTitle:load()
        blueFrame:load()
        frame:load()
    end

    function mainMenuFrame:draw()
        blueFrame:draw()
        frame:draw()
        frameTitle:draw(mainMenuFrame.x + frameTitle:getWidth(), mainMenuFrame.y - 13, mainMenuFrame.title, 0, "center", "center")
    end

    function mainMenuFrame:unload()
        frameTitle:unload()
        blueFrame:unload()
        frame:unload()
    end

    return mainMenuFrame
end

return MainMenuFrame
