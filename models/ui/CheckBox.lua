local Component   = require "models.scenes.Component"
local Image       = require "models.images.Image"
local SoundEffect = require "models.audio.SoundEffect"
---@class CheckBox
CheckBox          = {}

---@param name string
---@param assetPath string
---@param assetCheckedPath string
---@param x number
---@param y number
---@param checked boolean
---@param stateChangedCallback function
CheckBox.new      = function(name, assetPath, assetCheckedPath, x, y, checked, stateChangedCallback)
    checked        = checked or false
    local checkBox = Component.new(name, x, y, 38, 36)

    setmetatable(checkBox, CheckBox)
    CheckBox.__index           = CheckBox

    -- ---------------------------------------------
    -- Properties
    -- ---------------------------------------------
    local mouseIsOver          = false
    local mouseIsPressed       = false

    -- ---------------------------------------------
    -- Components
    -- ---------------------------------------------
    local checkboxImage        = Image.new(checkBox.name .. "_checkboxImage", assetPath, checkBox.bounds.x + (checkBox.bounds.width / 2), checkBox.bounds.y + (checkBox.bounds.height / 2))
    local checkBoxCheckedImage = Image.new(checkBox.name .. "_checkBoxCheckedImage", assetCheckedPath, checkBox.bounds.x + (checkBox.bounds.width / 2), checkBox.bounds.y + (checkBox.bounds.height / 2))
    local soundEffect          = SoundEffect.new(checkBox.name .. "_soundEffect", "assets/ui/switch2.ogg", "static", false, false, configuration:getSoundVolume())

    checkBox.addComponent(checkboxImage)
    checkBox.addComponent(checkBoxCheckedImage)
    checkBox.addComponent(soundEffect)

    -- ---------------------------------------------
    -- Public functions
    -- ---------------------------------------------

    ---@public
    function checkBox.update(_)
        soundEffect.setVolume(configuration:getSoundVolume())
        checkboxImage.setPosition(checkBox.bounds.x + (checkBox.bounds.width / 2), checkBox.bounds.y + (checkBox.bounds.height / 2))
        checkBoxCheckedImage.setPosition(checkBox.bounds.x + (checkBox.bounds.width / 2), checkBox.bounds.y + (checkBox.bounds.height / 2))

        local mouseX, mouseY = love.mouse.getPosition()
        if (mouseX == nil or mouseY == nil) then return end
        local isDown     = love.mouse.isDown(1)
        local wasPressed = not isDown and mouseIsPressed
        mouseIsPressed   = isDown
        mouseIsOver      = checkBox.bounds.containsPoint(screenManager:ScaleUIValueX(mouseX), screenManager:ScaleUIValueY(mouseY))
        if not mouseIsOver then mouseIsPressed = false end

        if mouseIsOver and wasPressed then
            soundEffect.play()
            checked = not checked
            if stateChangedCallback ~= nil then
                stateChangedCallback(checked)
            end
        end

        if checked then
            checkBoxCheckedImage.show()
            checkboxImage.hide()
        else
            checkBoxCheckedImage.hide()
            checkboxImage.show()
        end
    end

    function checkBox.isChecked()
        return checked
    end

    return checkBox
end

return CheckBox
