local MenuFrame = require "scenes.models.mainmenu.MenuFrame"
local BitmapText = require "models.texts.BitmapText"
local CheckBox = require "models.ui.CheckBox"
---@class ParametersFrame
ParametersFrame = {}

---@param name string
---@param title string
---@param x number
---@param y number
---@param width number
---@param height number
---@param moveSpeed number
ParametersFrame.new = function(name, title, x, y, width, height, moveSpeed)
    local parametersFrame = MenuFrame.new(name, title, x, y, width, height, moveSpeed, "assets/ui/red_panel.png",nil,true)

    setmetatable(parametersFrame, ParametersFrame)
    ParametersFrame.__index = ParametersFrame

    local fullScreenLabel = BitmapText.new(parametersFrame.name .. "_graphicAssetsFont", "assets/ui/roboto-bold-black.fnt", "Plein Ecran","left")
    local vSyncLabel = BitmapText.new(parametersFrame.name .. "_fontsAssetsFont", "assets/ui/roboto-bold-black.fnt", "Vsync","left")

    local fullScreenCheckbox = CheckBox.new(parametersFrame.name .. "_fullScreenCheckbox", "assets/ui/checkbox_unchecked.png", "assets/ui/checkbox_checked.png", 0, 0)
    local vsyncCheckbox = CheckBox.new(parametersFrame.name .. "_vsyncCheckbox", "assets/ui/checkbox_unchecked.png", "assets/ui/checkbox_checked.png", 0, 0)

    parametersFrame.addComponent(fullScreenCheckbox)
    parametersFrame.addComponent(vsyncCheckbox)
    parametersFrame.addComponent(fullScreenLabel)
    parametersFrame.addComponent(vSyncLabel)

    function parametersFrame.update(dt)
        parametersFrame.updateAnimation(dt)
        local paddingY = 20
        local paddingX = 150
        local textOffset = 7
        local fullScreenTop = paddingY
        local vSyncTop = fullScreenTop + fullScreenLabel.getHeight() + paddingY
        fullScreenLabel.setPosition(parametersFrame.bounds.x + parametersFrame.data.offsetX + 20, parametersFrame.bounds.y + textOffset+ fullScreenTop)
        fullScreenCheckbox.setPosition(parametersFrame.bounds.x + parametersFrame.data.offsetX + paddingX , parametersFrame.bounds.y + fullScreenTop)
        vSyncLabel.setPosition(parametersFrame.bounds.x + parametersFrame.data.offsetX + 20, parametersFrame.bounds.y + textOffset + vSyncTop + paddingY)
        vsyncCheckbox.setPosition(parametersFrame.bounds.x + parametersFrame.data.offsetX + paddingX, parametersFrame.bounds.y + vSyncTop + paddingY)
    end

    return parametersFrame
end

return ParametersFrame
