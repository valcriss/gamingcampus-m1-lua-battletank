local MenuFrame = require "scenes.models.mainmenu.MenuFrame"

---@class LeftMenuFrame
LeftMenuFrame = {}

---@param name string
---@param title string
---@param x number
---@param y number
---@param width number
---@param height number
---@param moveSpeed number
---@param headerAssetPath string
---@param data table
---@param stillUpdate boolean
LeftMenuFrame.new = function(name, title, x, y, width, height, moveSpeed, headerAssetPath, data, stillUpdate)
    local leftMenuFrame = MenuFrame.new(name, title, x, y, width, height, moveSpeed, headerAssetPath, data, stillUpdate)

    setmetatable(leftMenuFrame, LeftMenuFrame)
    LeftMenuFrame.__index = LeftMenuFrame

    function leftMenuFrame.animationShow(dt)
        if leftMenuFrame.data.animation == "show" then
            leftMenuFrame.data.offsetX = leftMenuFrame.data.offsetX + (leftMenuFrame.data.moveSpeed * dt)
            if leftMenuFrame.data.offsetX >= leftMenuFrame.bounds.x then
                leftMenuFrame.data.offsetX = leftMenuFrame.bounds.x
                leftMenuFrame.data.animation = "none"
                if not leftMenuFrame.data.stillUpdate then leftMenuFrame.disable() end
            end
        end
    end

    function leftMenuFrame.animationHide(dt)
        if leftMenuFrame.data.animation == "hide" then
            leftMenuFrame.data.offsetX = leftMenuFrame.data.offsetX - (leftMenuFrame.data.moveSpeed * dt)
            if leftMenuFrame.data.offsetX < -leftMenuFrame.bounds.width then
                leftMenuFrame.data.offsetX = -leftMenuFrame.bounds.width
                leftMenuFrame.data.animation = "none"
                leftMenuFrame.hide()
                leftMenuFrame.disable()
            end
        end
    end

    function leftMenuFrame.disappear()
        leftMenuFrame.data.animation = "hide"
        leftMenuFrame.data.offsetX = leftMenuFrame.bounds.x
        leftMenuFrame.show()
        leftMenuFrame.enable()
        leftMenuFrame.data.soundEffect.play()
    end

    function leftMenuFrame.appear()
        leftMenuFrame.show()
        leftMenuFrame.enable()
        leftMenuFrame.data.offsetX = -leftMenuFrame.bounds.width
        leftMenuFrame.data.animation = "show"
        leftMenuFrame.data.soundEffect.play()
    end

    return leftMenuFrame
end

return LeftMenuFrame
