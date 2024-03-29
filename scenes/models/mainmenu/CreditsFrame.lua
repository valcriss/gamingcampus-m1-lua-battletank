local BitmapText = require "models.texts.BitmapText"
local MenuFrame = require "scenes.models.mainmenu.MenuFrame"
---@class CreditsFrame
CreditsFrame = {}

---@param name string
---@param title string
---@param x number
---@param y number
---@param width number
---@param height number
---@param moveSpeed number
CreditsFrame.new = function(name, title, x, y, width, height, moveSpeed)
    local creditsFrame = MenuFrame.new(
            name,
            title,
            x,
            y,
            width,
            height,
            moveSpeed,
            "assets/ui/yellow_panel.png",
            {
                graphicAssetsList = "- Tanks by kenney (https://kenney.nl/)\n- UI Pack by kenney (https://kenney.nl/)\n- Top-down Tanks Redux by kenney (https://kenney.nl/)\n- Map Pack by kenney (https://kenney.nl/)",
                fontAssetsList = "- Bouncy by Mans Greback (https://www.mansgreback.com/)\n- Hey Comic by Khurasan (https://www.dafont.com/fr/hey-comic.font)\n- Komika Axis by Vigilante Typeface Corporation (https://www.dafont.com/fr/komika-axis.font)\n- Roboto by Google Android Design (https://m3.material.io/styles/typography/overview)",
                soundAssetsList = "- Game music – retro, arcade melody with electro drums and synth elements by zapsplat (https://www.zapsplat.com/)\n- Boing effect by pixabay (https://pixabay.com/users/pixabay-1/)\n- Button pressed effect in ui-pack by kenney (https://kenney.nl/)"
            }
    )

    setmetatable(creditsFrame, CreditsFrame)
    CreditsFrame.__index = CreditsFrame

    local graphicAssetsFont = BitmapText.new(creditsFrame.name .. "_graphicAssetsFont", "assets/ui/roboto-bold-black.fnt", "Graphics Assets")
    local fontsAssetsFont = BitmapText.new(creditsFrame.name .. "_fontsAssetsFont", "assets/ui/roboto-bold-black.fnt", "Fonts Assets")
    local soundAssetsFont = BitmapText.new(creditsFrame.name .. "_soundAssetsFont", "assets/ui/roboto-bold-black.fnt", "Sound Assets")
    local graphicAssetsList = BitmapText.new(creditsFrame.name .. "_graphicAssetsList", "assets/ui/roboto-regular-black.fnt", creditsFrame.data.graphicAssetsList)
    local fontAssetsList = BitmapText.new(creditsFrame.name .. "_fontAssetsList", "assets/ui/roboto-regular-black.fnt", creditsFrame.data.fontAssetsList)
    local soundAssetsList = BitmapText.new(creditsFrame.name .. "_soundAssetsList", "assets/ui/roboto-regular-black.fnt", creditsFrame.data.soundAssetsList)

    creditsFrame.addComponent(graphicAssetsFont)
    creditsFrame.addComponent(fontsAssetsFont)
    creditsFrame.addComponent(soundAssetsFont)
    creditsFrame.addComponent(graphicAssetsList)
    creditsFrame.addComponent(fontAssetsList)
    creditsFrame.addComponent(soundAssetsList)

    function creditsFrame.update(dt)
        creditsFrame.updateAnimation(dt)

        local graphicsTop = 20
        local fontsTop = graphicsTop + 150
        local soundTop = fontsTop + 150

        graphicAssetsFont.setPosition(creditsFrame.bounds.x + creditsFrame.data.offsetX + 20, creditsFrame.bounds.y + graphicsTop)
        graphicAssetsList.setPosition(creditsFrame.bounds.x + creditsFrame.data.offsetX + 35, creditsFrame.bounds.y + graphicsTop + 20)

        fontsAssetsFont.setPosition(creditsFrame.bounds.x + creditsFrame.data.offsetX + 20, creditsFrame.bounds.y + fontsTop)
        fontAssetsList.setPosition(creditsFrame.bounds.x + creditsFrame.data.offsetX + 35, creditsFrame.bounds.y + fontsTop + 20)

        soundAssetsFont.setPosition(creditsFrame.bounds.x + creditsFrame.data.offsetX + 20, creditsFrame.bounds.y + soundTop)
        soundAssetsList.setPosition(creditsFrame.bounds.x + creditsFrame.data.offsetX + 35, creditsFrame.bounds.y + soundTop + 20)
    end

    return creditsFrame
end

return CreditsFrame
