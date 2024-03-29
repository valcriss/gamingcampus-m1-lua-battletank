local Component = require "models.scenes.Component"
local Frame = require "models.ui.Frame"
local BitmapText = require "models.texts.BitmapText"
local Tables = require "models.tools.Tables"
local SoundEffect = require "models.audio.SoundEffect"
---@class MenuFrame
MenuFrame = {}

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
MenuFrame.new = function(name, title, x, y, width, height, moveSpeed, headerAssetPath, data, stillUpdate)
    moveSpeed = moveSpeed or 2600
    data = data or {}
    if stillUpdate == nil then
        stillUpdate = false
    end
    local extraData = Tables.merge(
            {
                title = title,
                offsetX = 0,
                moveSpeed = moveSpeed,
                headerAssetPath = headerAssetPath,
                animation = "none",
                stillUpdate = stillUpdate,
            },
            data
    )
    local menuFrame = Component.new(name, extraData, x, y, width, height)

    setmetatable(menuFrame, MenuFrame)
    MenuFrame.__index = MenuFrame

    local frame = Frame.new(menuFrame.name .. "_frame", "assets/ui/grey_panel.png", 10, 0, 0, menuFrame.bounds.width, menuFrame.bounds.height)
    local titleFrame = Frame.new(menuFrame.name .. "_titleFrame", menuFrame.data.headerAssetPath, 10, 0, 0, menuFrame.bounds.width, 50)
    local frameTitle = BitmapText.new(menuFrame.name .. "_frameTitle", "assets/ui/ui-18.fnt", menuFrame.data.title, "center", "center")
    menuFrame.data.soundEffect = SoundEffect.new("soundEffect", "assets/ui/swipe.mp3", "static", false, false, configuration:getSoundVolume())

    menuFrame.addComponent(titleFrame)
    menuFrame.addComponent(frame)
    menuFrame.addComponent(frameTitle)
    menuFrame.addComponent(menuFrame.data.soundEffect)

    function menuFrame.updateAnimation(dt)
        menuFrame.animationShow(dt)
        menuFrame.animationHide(dt)
        frame.setBounds(menuFrame.bounds.x + menuFrame.data.offsetX, menuFrame.bounds.y, menuFrame.bounds.width, menuFrame.bounds.height)
        titleFrame.setPosition(menuFrame.bounds.x + menuFrame.data.offsetX, menuFrame.bounds.y - 30)
        frameTitle.setPosition(menuFrame.bounds.x + menuFrame.data.offsetX + (menuFrame.bounds.width / 2) + 7, menuFrame.bounds.y - 13)
    end

    function menuFrame.animationShow(dt)
        if menuFrame.data.animation == "show" then
            menuFrame.data.offsetX = menuFrame.data.offsetX - (menuFrame.data.moveSpeed * dt)
            if menuFrame.data.offsetX <= 0 then
                menuFrame.data.offsetX = 0
                menuFrame.data.animation = "none"
                if not menuFrame.data.stillUpdate then menuFrame.disable() end
            end
        end
    end

    function menuFrame.animationHide(dt)
        if menuFrame.data.animation == "hide" then
            menuFrame.data.offsetX = menuFrame.data.offsetX + (menuFrame.data.moveSpeed * dt)
            if menuFrame.data.offsetX > screenManager.getWindowWidth() then
                menuFrame.data.offsetX = screenManager.getWindowWidth()
                menuFrame.data.animation = "none"
                menuFrame.hide()
                menuFrame.disable()
            end
        end
    end

    function menuFrame.disappear()
        menuFrame.data.animation = "hide"
        menuFrame.data.offsetX = 0
        menuFrame.show()
        menuFrame.enable()
        menuFrame.data.soundEffect.play()
    end

    function menuFrame.appear()
        menuFrame.show()
        menuFrame.enable()
        menuFrame.data.offsetX = screenManager.getWindowWidth()
        menuFrame.data.animation = "show"
        menuFrame.data.soundEffect.play()
    end

    return menuFrame
end

return MenuFrame
