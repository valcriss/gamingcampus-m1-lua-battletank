local MenuFrame   = require "models.ui.MenuFrame"

---@class LeftMenuFrame
LeftMenuFrame     = {}

---@param name string
---@param title string
---@param x number
---@param y number
---@param width number
---@param height number
---@param moveSpeed number
---@param headerAssetPath string
---@param stillUpdate boolean
LeftMenuFrame.new = function(name, title, x, y, width, height, moveSpeed, headerAssetPath, stillUpdate)
    local leftMenuFrame = MenuFrame.new(name, title, x, y, width, height, moveSpeed, headerAssetPath, stillUpdate)

    setmetatable(leftMenuFrame, LeftMenuFrame)
    LeftMenuFrame.__index = LeftMenuFrame

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    ---@public
    --- Fonction qui met a jour l'animation de la frame
    --- @param dt number
    function leftMenuFrame.animationShow(dt)

        if leftMenuFrame.data.animation == "show" then
            leftMenuFrame.data.offsetX = leftMenuFrame.data.offsetX + (leftMenuFrame.data.moveSpeed * dt)
            if leftMenuFrame.data.offsetX >= leftMenuFrame.bounds.x then
                leftMenuFrame.data.offsetX   = leftMenuFrame.bounds.x
                leftMenuFrame.data.animation = "none"
                if not leftMenuFrame.data.stillUpdate then leftMenuFrame.disable() end
            end
        end
    end

    ---@public
    --- Fonction qui gère l'animation de disparition de la frame
    ---@param dt number
    function leftMenuFrame.animationHide(dt)

        if leftMenuFrame.data.animation == "hide" then
            leftMenuFrame.data.offsetX = leftMenuFrame.data.offsetX - (leftMenuFrame.data.moveSpeed * dt)
            if leftMenuFrame.data.offsetX < -leftMenuFrame.bounds.width then
                leftMenuFrame.data.offsetX   = -leftMenuFrame.bounds.width
                leftMenuFrame.data.animation = "none"
                leftMenuFrame.hide()
                leftMenuFrame.disable()
            end
        end
    end

    ---@public
    --- Fonction permettant de faire apparaitre la frame
    function leftMenuFrame.disappear()
        leftMenuFrame.data.animation = "hide"
        leftMenuFrame.data.offsetX   = leftMenuFrame.bounds.x
        leftMenuFrame.show()
        leftMenuFrame.enable()
        leftMenuFrame.data.soundEffect.play()
    end

    ---@public
    --- Fonction permettant de faire disparaitre la frame
    function leftMenuFrame.appear()
        leftMenuFrame.data.offsetX   = -leftMenuFrame.bounds.width
        leftMenuFrame.data.animation = "show"
        leftMenuFrame.data.soundEffect.play()
        leftMenuFrame.show()
        leftMenuFrame.enable()
    end

    return leftMenuFrame
end

return LeftMenuFrame
