local Frame = require "models.ui.Frame"
local BitmapText = require "models.texts.BitmapText"
---@class CreditsFrame
CreditsFrame = {}

CreditsFrame.new = function(title, x, y, width, height, moveSpeed)
    moveSpeed = moveSpeed or 1300
    local creditsFrame = {
        title = title,
        x = x,
        y = y,
        width = width,
        height = height,
        visible = false,
        offsetX = 0,
        moveSpeed = moveSpeed,
        animation = "none",
        graphicAssetsList = "- tanks by kenney (https://kenney.nl/)\n- ui-pack by kenney (https://kenney.nl/)",
        fontAssetsList = "- Bouncy by Mans Greback (https://www.mansgreback.com/)\n- Hey Comic by Khurasan (https://www.dafont.com/fr/hey-comic.font)\n- Komika Axis by Vigilante Typeface Corporation (https://www.dafont.com/fr/komika-axis.font)\n- Roboto by Google Android Design (https://m3.material.io/styles/typography/overview)",
        soundAssetsList = "- Game music – retro, arcade melody with electro drums and synth elements by zapsplat (https://www.zapsplat.com/)\n- boing effect by pixabay (https://pixabay.com/users/pixabay-1/)"
    }

    setmetatable(creditsFrame, CreditsFrame)
    CreditsFrame.__index = CreditsFrame

    local frame = Frame.new("assets/ui/grey_panel.png", 10, creditsFrame.x, creditsFrame.y, creditsFrame.width, creditsFrame.height)
    local blueFrame = Frame.new("assets/ui/yellow_panel.png", 10, creditsFrame.x, creditsFrame.y - 30, creditsFrame.width, 50)
    local frameTitle = BitmapText.new("assets/ui/ui-18.fnt")
    local graphicAssetsFont = BitmapText.new("assets/ui/roboto-bold-black.fnt")
    local fontsAssetsFont = BitmapText.new("assets/ui/roboto-bold-black.fnt")
    local soundAssetsFont = BitmapText.new("assets/ui/roboto-bold-black.fnt")

    local graphicAssetsList = BitmapText.new("assets/ui/roboto-regular-black.fnt")
    local fontAssetsList = BitmapText.new("assets/ui/roboto-regular-black.fnt")
    local soundAssetsList = BitmapText.new("assets/ui/roboto-regular-black.fnt")

    function creditsFrame:load()
        frame:load()
        blueFrame:load()
        frameTitle:load()
        graphicAssetsFont:load()
        graphicAssetsList:load()
        fontsAssetsFont:load()
        fontAssetsList:load()
        soundAssetsFont:load()
        soundAssetsList:load()
    end

    function creditsFrame:update(dt)
        if not creditsFrame.visible then
            return
        end

        if creditsFrame.animation == "show" then
            creditsFrame.offsetX = creditsFrame.offsetX - (creditsFrame.moveSpeed * dt)
            if creditsFrame.offsetX <= 0 then
                creditsFrame.offsetX = 0
                creditsFrame.animation = "none"
            end
        end

        if creditsFrame.animation == "hide" then
            creditsFrame.offsetX = creditsFrame.offsetX + (moveSpeed * dt)
            if creditsFrame.offsetX > screenManager.getWindowWidth() then
                creditsFrame.offsetX = screenManager.getWindowWidth()
                creditsFrame.animation = "none"
                creditsFrame.visible = false
            end
        end
        frame:setPosition(creditsFrame.x + creditsFrame.offsetX, creditsFrame.y)
        blueFrame:setPosition(creditsFrame.x + creditsFrame.offsetX, creditsFrame.y - 30)
    end

    function creditsFrame:draw()
        if not creditsFrame.visible then
            return
        end
        blueFrame:draw()
        frame:draw()
        frameTitle:draw(creditsFrame.x + creditsFrame.offsetX + (creditsFrame.width / 2) + 7, creditsFrame.y - 13, creditsFrame.title, 0, "center", "center")

        local graphicsTop = 20
        local fontsTop = 100
        local soundTop = 220

        graphicAssetsFont:draw(creditsFrame.x + creditsFrame.offsetX + 20, creditsFrame.y + graphicsTop, "Graphics Assets", 0, "left")
        graphicAssetsList:draw(creditsFrame.x + creditsFrame.offsetX + 35, creditsFrame.y + graphicsTop + 20, creditsFrame.graphicAssetsList, 0, "left")

        fontsAssetsFont:draw(creditsFrame.x + creditsFrame.offsetX + 20, creditsFrame.y + fontsTop, "Fonts Assets", 0, "left")
        fontAssetsList:draw(creditsFrame.x + creditsFrame.offsetX + 35, creditsFrame.y + fontsTop + 20, creditsFrame.fontAssetsList, 0, "left")

        soundAssetsFont:draw(creditsFrame.x + creditsFrame.offsetX + 20, creditsFrame.y + soundTop, "Sound Assets", 0, "left")
        soundAssetsList:draw(creditsFrame.x + creditsFrame.offsetX + 35, creditsFrame.y + soundTop + 20, creditsFrame.soundAssetsList, 0, "left")
    end

    function creditsFrame:unload()
        frame:unload()
        blueFrame:unload()
        frameTitle:unload()
        graphicAssetsFont:unload()
        graphicAssetsList:unload()
        fontsAssetsFont:unload()
        fontAssetsList:unload()
        soundAssetsFont:unload()
        soundAssetsList:unload()
    end

    function creditsFrame:hide()
        creditsFrame.animation = "hide"
    end

    function creditsFrame:show()
        creditsFrame.visible = true
        creditsFrame.offsetX = screenManager.getWindowWidth()
        creditsFrame.animation = "show"
    end

    function creditsFrame:isVisible()
        return creditsFrame.visible
    end

    return creditsFrame
end

return CreditsFrame
