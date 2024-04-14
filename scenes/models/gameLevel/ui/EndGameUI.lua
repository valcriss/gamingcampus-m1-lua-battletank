local Component = require "models.scenes.Component"
local Image     = require "models.images.Image"

---@class EndGameUI
EndGameUI       = {}

EndGameUI.new   = function(onShowCompleted)
    local endGameUI = Component.new("endGameUI")

    setmetatable(endGameUI, EndGameUI)
    EndGameUI.__index = EndGameUI

    local victory     = Image.new(endGameUI.name .. "_victory", "assets/gameLevel/victoire.png", screenManager:calculateCenterPointX(), screenManager:calculateCenterPointY(), 0, 1).disable().hide()
    local defeat      = Image.new(endGameUI.name .. "_victory", "assets/gameLevel/defaite.png", screenManager:calculateCenterPointX(), screenManager:calculateCenterPointY(), 0, 1).disable().hide()

    endGameUI.addComponent(victory)
    endGameUI.addComponent(defeat)

    local color        = { r = 1, g = 1, b = 1, a = 0 }
    local colorSpeed   = 0.5
    local showDuration = 5
    local isVictory    = false
    local animation    = "hide"

    function endGameUI.victory()
        color.a       = 0
        animation     = "show"
        victory.color = color
        isVictory     = true
        showDuration  = 5
        victory.enable().show()
    end

    function endGameUI.defeat()
        color.a      = 0
        animation    = "show"
        defeat.color = color
        isVictory    = false
        showDuration = 5
        defeat.enable().show()
    end

    function endGameUI.update(dt)
        if animation == "show" then
            color.a = math.min(color.a + (colorSpeed * dt), 1)
            if color.a >= 1 then
                animation = "none"
            end
        end
        if animation == "none" then
            showDuration = showDuration - dt
            if showDuration <= 0 then
                if onShowCompleted ~= nil then
                    onShowCompleted(isVictory)
                end
            end
        end
        victory.color = color
        defeat.color  = color
    end

    return endGameUI
end

return EndGameUI
