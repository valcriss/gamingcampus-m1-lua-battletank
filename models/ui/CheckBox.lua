local Component = require "models.scenes.Component"
local Image = require "models.images.Image"
local SoundEffect = require "models.audio.SoundEffect"
---@class CheckBox
CheckBox = {}

CheckBox.new = function(name, assetPath, assetCheckedPath, x, y)
    local checkBox =
        Component.new(
        name,
        {
            assetPath = assetPath,
            assetCheckedPath = assetCheckedPath,
            mouseIsOver = false,
            mouseIsPressed = false
        },
        x,
        y,
        38,
        36
    )

    setmetatable(checkBox, CheckBox)
    CheckBox.__index = CheckBox

    local checkboxImage = Image.new(checkBox.name .. "_checkboxImage", checkBox.data.assetPath, checkBox.bounds.x + (checkBox.bounds.width / 2), checkBox.bounds.y + (checkBox.bounds.height / 2))
    local checkBoxCheckedImage = Image.new(checkBox.name .. "_checkBoxCheckedImage", checkBox.data.assetCheckedPath, checkBox.bounds.x + (checkBox.bounds.width / 2), checkBox.bounds.y + (checkBox.bounds.height / 2))
    local soundEffect = SoundEffect.new(checkBox.name .. "_soundEffect", "assets/ui/switch2.ogg", "static", false, false, configuration:getSoundVolume())

    checkBox.addComponent(checkboxImage)
    checkBox.addComponent(checkBoxCheckedImage)
    checkBox.addComponent(soundEffect)

    function checkBox.update(_)
        soundEffect.setVolume(configuration:getSoundVolume())
        checkboxImage.setPosition(checkBox.bounds.x + (checkBox.bounds.width / 2), checkBox.bounds.y + (checkBox.bounds.height / 2))
        checkBoxCheckedImage.setPosition(checkBox.bounds.x + (checkBox.bounds.width / 2), checkBox.bounds.y + (checkBox.bounds.height / 2))

        local mouseX, mouseY = love.mouse.getPosition()
        if (mouseX == nil or mouseY == nil) then
            return
        end
        local isDown = love.mouse.isDown(1)
        local wasPressed = not isDown and checkBox.data.mouseIsPressed
        checkBox.data.mouseIsPressed = isDown
        checkBox.data.mouseIsOver = checkBox.bounds.containsPoint(mouseX, mouseY)
        if not checkBox.data.mouseIsOver then
            checkBox.data.mouseIsPressed = false
        end

        if checkBox.data.mouseIsOver and wasPressed then
            soundEffect.play()
            checkBox.data.checked = not checkBox.data.checked
        end

        if checkBox.data.checked then
            checkBoxCheckedImage.show()
            checkboxImage.hide()
        else
            checkBoxCheckedImage.hide()
            checkboxImage.show()
        end
    end

    function checkBox.isChecked()
        return checkBox.data.checked
    end

    return checkBox
end

return CheckBox
