local LeftMenuFrame = require "models.ui.LeftMenuFrame"
local Image         = require "models.images.Image"
local Button        = require "models.ui.Button"

---@class HelpFrame
HelpFrame           = {}

HelpFrame.new       = function(onClose)
    local helpFrame = LeftMenuFrame.new("HelpFrame", "Comment jouer", 190, 200, 600, 400, 3000, "assets/ui/yellow_panel.png", { content = "" }, true)

    setmetatable(helpFrame, HelpFrame)
    HelpFrame.__index  = HelpFrame

    local helpImage    = Image.new("helpImage", "assets/gameLevel/help.png", 0, 0, 0, 0.7)
    local resumeButton = Button.new(helpFrame.name .. "_resumeButton", "assets/ui/green_button00.png", "assets/ui/green_button04.png", "assets/ui/green_button03.png", 0, 0, "Reprendre", function() onClose() end)

    helpFrame.addComponent(helpImage)
    helpFrame.addComponent(resumeButton)

    function helpFrame.update(dt)
        helpFrame.updateAnimation(dt)
        helpImage.setPosition(helpFrame.bounds.x + 300 + helpFrame.data.offsetX + 20, helpFrame.bounds.y + 160)
        resumeButton.setPosition(helpFrame.bounds.x + 200 + helpFrame.data.offsetX + 20, helpFrame.bounds.y + 340)
    end

    return helpFrame
end

return HelpFrame
