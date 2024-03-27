local Frame = require "models.ui.Frame"
local BitmapText = require "models.texts.BitmapText"
---@class ParametersFrame
ParametersFrame = {}

ParametersFrame.new = function(title, x, y, width, height, moveSpeed)
    moveSpeed = moveSpeed or 1300
    local parametersFrame = {
        title = title,
        x = x,
        y = y,
        width = width,
        height = height,
        visible = false,
        offsetX = 0,
        moveSpeed = moveSpeed,
        animation = "none"
    }

    setmetatable(parametersFrame, ParametersFrame)
    ParametersFrame.__index = ParametersFrame

    local frame = Frame.new("assets/ui/grey_panel.png", 10, parametersFrame.x, parametersFrame.y, parametersFrame.width, parametersFrame.height)
    local blueFrame = Frame.new("assets/ui/red_panel.png", 10, parametersFrame.x, parametersFrame.y - 30, parametersFrame.width, 50)
    local frameTitle = BitmapText.new("assets/ui/ui-18.fnt")

    function parametersFrame:load()
        frame:load()
        blueFrame:load()
        frameTitle:load()
    end

    function parametersFrame:update(dt)
        if not parametersFrame.visible then
            return
        end

        if parametersFrame.animation == "show" then
            parametersFrame.offsetX = parametersFrame.offsetX - (parametersFrame.moveSpeed * dt)
            if parametersFrame.offsetX <= 0 then
                parametersFrame.offsetX = 0
                parametersFrame.animation = "none"
            end
        end

        if parametersFrame.animation == "hide" then
            parametersFrame.offsetX = parametersFrame.offsetX + (moveSpeed * dt)
            if parametersFrame.offsetX > screenManager.getWindowWidth() then
                parametersFrame.offsetX = screenManager.getWindowWidth()
                parametersFrame.animation = "none"
                parametersFrame.visible = false
            end
        end
        frame:setPosition(parametersFrame.x + parametersFrame.offsetX, parametersFrame.y)
        blueFrame:setPosition(parametersFrame.x + parametersFrame.offsetX, parametersFrame.y - 30)
    end

    function parametersFrame:draw()
        if not parametersFrame.visible then
            return
        end
        blueFrame:draw()
        frame:draw()
        frameTitle:draw(parametersFrame.x + parametersFrame.offsetX + (parametersFrame.width / 2) + 7, parametersFrame.y - 13, parametersFrame.title, 0, "center", "center")
    end

    function parametersFrame:unload()
        frame:unload()
        blueFrame:unload()
        frameTitle:unload()
    end

    function parametersFrame:hide()
        parametersFrame.animation = "hide"
    end

    function parametersFrame:show()
        parametersFrame.visible = true
        parametersFrame.offsetX = screenManager.getWindowWidth()
        parametersFrame.animation = "show"
    end

    function parametersFrame:isVisible()
        return parametersFrame.visible
    end

    return parametersFrame
end

return ParametersFrame
