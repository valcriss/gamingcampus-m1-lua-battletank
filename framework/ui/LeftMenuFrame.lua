local MenuFrame   = require "framework.ui.MenuFrame"

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
        if leftMenuFrame.getAnimation() == "show" then
            leftMenuFrame.setOffsetX(leftMenuFrame.getOffsetX() + (moveSpeed * dt))
            if leftMenuFrame.getOffsetX() >= leftMenuFrame.bounds.x then
                leftMenuFrame.setOffsetX(leftMenuFrame.bounds.x)
                leftMenuFrame.setAnimation("none")
                if not stillUpdate then leftMenuFrame.disable() end
            end
        end
    end

    ---@public
    --- Fonction qui gère l'animation de disparition de la frame
    ---@param dt number
    function leftMenuFrame.animationHide(dt)
        if leftMenuFrame.getAnimation() == "hide" then
            leftMenuFrame.setOffsetX(leftMenuFrame.getOffsetX() - (moveSpeed * dt))
            if leftMenuFrame.getOffsetX() < -leftMenuFrame.bounds.width then
                leftMenuFrame.setOffsetX(-leftMenuFrame.bounds.width)
                leftMenuFrame.setAnimation("none")
                leftMenuFrame.hide()
                leftMenuFrame.disable()
            end
        end
    end

    ---@public
    --- Fonction permettant de faire apparaitre la frame
    function leftMenuFrame.disappear()
        leftMenuFrame.setAnimation("hide")
        leftMenuFrame.setOffsetX(leftMenuFrame.bounds.x)
        leftMenuFrame.show()
        leftMenuFrame.enable()
        leftMenuFrame.PlaySoundEffect()
    end

    ---@public
    --- Fonction permettant de faire disparaitre la frame
    function leftMenuFrame.appear()
        leftMenuFrame.setOffsetX(-leftMenuFrame.bounds.width)
        leftMenuFrame.setAnimation("show")
        leftMenuFrame.PlaySoundEffect()
        leftMenuFrame.show()
        leftMenuFrame.enable()
    end

    return leftMenuFrame
end

return LeftMenuFrame
