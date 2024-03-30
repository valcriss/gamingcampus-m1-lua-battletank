local MenuFrame       = require "scenes.models.mainmenu.MenuFrame"
local BitmapText      = require "models.texts.BitmapText"
local Button          = require "models.ui.Button"

---@class ConfirmationFrame
ConfirmationFrame     = {}

---@param name string
---@param title string
---@param x number
---@param y number
---@param width number
---@param height number
---@param moveSpeed number
ConfirmationFrame.new = function(name, title, x, y, width, height, moveSpeed, confirmAction)
    local confirmationFrame = MenuFrame.new(name, title, x, y, width, height, moveSpeed, "assets/ui/green_panel.png", { confirmAction = confirmAction }, true)

    setmetatable(confirmationFrame, ConfirmationFrame)
    ConfirmationFrame.__index = ConfirmationFrame

    local confirmationText    = BitmapText.new(confirmationFrame.name .. "_confirmationText", "assets/ui/ui-18.fnt", "Etes-vous sur de vouloir quitter ?", "center", "center", confirmationFrame.bounds.x + confirmationFrame.bounds.width / 2, confirmationFrame.bounds.y + 50)
    local confirmButton       = Button.new("confirmButton", "assets/ui/green_button00.png", "assets/ui/green_button04.png", "assets/ui/green_button03.png", confirmationFrame.bounds.x + 40, confirmationFrame.bounds.y + confirmationFrame.bounds.height - 60, "Oui", function() confirmationFrame.data.confirmAction(true) end)
    local cancelButton        = Button.new("confirmButton", "assets/ui/red_button11.png", "assets/ui/red_button01.png", "assets/ui/red_button02.png", confirmationFrame.bounds.x + confirmationFrame.bounds.width - 180, confirmationFrame.bounds.y + confirmationFrame.bounds.height - 60, "Non", function() confirmationFrame.data.confirmAction(false) end)

    confirmationFrame.addComponent(confirmationText)
    confirmationFrame.addComponent(confirmButton)
    confirmationFrame.addComponent(cancelButton)

    function confirmationFrame.update(dt)
        confirmationFrame.updateAnimation(dt)
        confirmationText.setPosition(confirmationFrame.bounds.x + confirmationFrame.data.offsetX + (confirmationFrame.bounds.width / 2), confirmationFrame.bounds.y + 50)
        confirmButton.setPosition(confirmationFrame.bounds.x + confirmationFrame.data.offsetX + 40, confirmationFrame.bounds.y + confirmationFrame.bounds.height - 60)
        cancelButton.setPosition(confirmationFrame.bounds.x + confirmationFrame.data.offsetX + confirmationFrame.bounds.width - 220, confirmationFrame.bounds.y + confirmationFrame.bounds.height - 60)
    end

    return confirmationFrame
end

return ConfirmationFrame
