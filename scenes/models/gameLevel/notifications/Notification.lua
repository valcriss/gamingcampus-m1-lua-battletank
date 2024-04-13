local Component  = require "models.scenes.Component"
local Image      = require "models.images.Image"
local BitmapText = require "models.texts.BitmapText"

---@class Notification
Notification     = {}

Notification.new = function(x, y)
    local notification = Component.new("Notification", x, y)

    setmetatable(notification, Notification)
    Notification.__index = Notification

    local warningImage   = Image.new("warning", "assets/gameLevel/warning.png", 0, 0, 0, 0.75)
    local warningText    = BitmapText.new(notification.name .. "_frameTitle", "assets/ui/ui-18.fnt", "L'enemie attaque la tour 2", "center", "center", x + 130, y + 20)

    notification.addComponent(warningImage)
    notification.addComponent(warningText)

    local minX        = -500
    local offsetX     = -500
    local animation   = "none"
    local speed       = 3000
    local visibleTime = 1

    function notification.appear(content)
        warningText.setContent(content)
        animation = "show"
        offsetX   = -500
    end

    function notification.disappear()
        animation = "hide"
    end

    function notification.update(dt)
        warningImage.setPosition(x + 220 + offsetX, y)
        warningText.setPosition(x + 220 + offsetX, y)
        if animation == "show" then
            offsetX = offsetX + speed * dt
            if (offsetX >= 0) then
                animation   = "visible"
                visibleTime = 1
            end
        elseif animation == "hide" then
            offsetX = offsetX - speed * dt
            if (offsetX <= minX) then
                animation = "none"
            end
        elseif animation == "visible" then
            visibleTime = visibleTime - dt
            if (visibleTime <= 0) then
                notification.disappear()
            end
        end
    end
    return notification
end

return Notification