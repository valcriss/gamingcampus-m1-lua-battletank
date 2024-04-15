local Component   = require "models.scenes.Component"
local Frame       = require "models.ui.Frame"
local BitmapText  = require "models.texts.BitmapText"
local SoundEffect = require "models.audio.SoundEffect"
---@class MenuFrame
MenuFrame         = {}

---@param name string
---@param title string
---@param x number
---@param y number
---@param width number
---@param height number
---@param moveSpeed number
---@param headerAssetPath string
---@param stillUpdate boolean
MenuFrame.new     = function(name, title, x, y, width, height, moveSpeed, headerAssetPath, stillUpdate)
    moveSpeed = moveSpeed or 3000
    if stillUpdate == nil then
        stillUpdate = false
    end

    local menuFrame = Component.new(name, x, y, width, height)

    setmetatable(menuFrame, MenuFrame)
    MenuFrame.__index = MenuFrame

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local offsetX     = 0
    local animation   = "none"

    -- ---------------------------------------------
    -- Components
    -- ---------------------------------------------
    local frame       = Frame.new(menuFrame.name .. "_frame", "assets/ui/grey_panel.png", 10, 0, 0, menuFrame.bounds.width, menuFrame.bounds.height)
    local titleFrame  = Frame.new(menuFrame.name .. "_titleFrame", headerAssetPath, 10, 0, 0, menuFrame.bounds.width, 50)
    local frameTitle  = BitmapText.new(menuFrame.name .. "_frameTitle", "assets/ui/ui-18.fnt", title, "center", "center")
    local soundEffect = SoundEffect.new("soundEffect", "assets/ui/swipe.mp3", "static", false, false, configuration:getSoundVolume())

    menuFrame.addComponent(titleFrame)
    menuFrame.addComponent(frame)
    menuFrame.addComponent(frameTitle)
    menuFrame.addComponent(soundEffect)

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------
    ---@public
    --- Fonction qui met a jour l'animation de la frame
    --- @param dt number
    function menuFrame.updateAnimation(dt)
        menuFrame.animationShow(dt)
        menuFrame.animationHide(dt)
        frame.setBounds(menuFrame.bounds.x + offsetX, menuFrame.bounds.y, menuFrame.bounds.width, menuFrame.bounds.height)
        titleFrame.setPosition(menuFrame.bounds.x + offsetX, menuFrame.bounds.y - 30)
        frameTitle.setPosition(menuFrame.bounds.x + offsetX + (menuFrame.bounds.width / 2) + 7, menuFrame.bounds.y - 13)
    end

    ---@public
    --- Fonction qui gère l'animation d'apparition de la frame
    ----@param dt number
    function menuFrame.animationShow(dt)
        if animation == "show" then
            offsetX = offsetX - (moveSpeed * dt)
            if offsetX <= 0 then
                offsetX   = 0
                animation = "none"
                if not stillUpdate then menuFrame.disable() end
            end
        end
    end

    ---@public
    --- Fonction qui gère l'animation de disparition de la frame
    ---@param dt number
    function menuFrame.animationHide(dt)
        if animation == "hide" then
            offsetX = offsetX + (moveSpeed * dt)
            if offsetX > screenManager.getWindowWidth() then
                offsetX   = screenManager.getWindowWidth()
                animation = "none"
                menuFrame.hide()
                menuFrame.disable()
            end
        end
    end

    ---@public
    --- Fonction permettant de faire apparaitre la frame
    function menuFrame.disappear()
        animation = "hide"
        offsetX   = 0
        menuFrame.show()
        menuFrame.enable()
        soundEffect.play()
    end

    ---@public
    --- Fonction permettant de faire disparaitre la frame
    function menuFrame.appear()
        menuFrame.show()
        menuFrame.enable()
        offsetX   = screenManager.getWindowWidth()
        animation = "show"
        soundEffect.play()
    end

    return menuFrame
end

return MenuFrame
