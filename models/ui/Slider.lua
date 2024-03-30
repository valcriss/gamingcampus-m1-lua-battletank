local Component    = require "models.scenes.Component"
local Image        = require "models.images.Image"
local SliderButton = require "models.ui.SliderButton"
local BitmapText   = require "models.texts.BitmapText"
---@class Slider
Slider             = {}

Slider.new         = function(name, x, y, value)
    value        = value or 0
    local slider = Component.new(
            name,
            {
                value = value
            },
            x,
            y
    )

    setmetatable(slider, Slider)
    Slider.__index          = Slider

    local leftSliderButton  = SliderButton.new(slider.name .. "_leftSliderButton", "assets/ui/sliderButtonLeft.png", slider.bounds.x, slider.bounds.y, function() slider.data.value = math.max(0, slider.data.value - .1) end)
    local sliderStart       = Image.new(slider.name .. "_sliderStart", "assets/ui/sliderEnd.png", slider.bounds.x, slider.bounds.y)
    local sliderEnd         = Image.new(slider.name .. "_sliderEnd", "assets/ui/sliderEnd.png", slider.bounds.x, slider.bounds.y)
    local sliderBar         = Image.new(slider.name .. "_sliderBar", "assets/ui/sliderHorizontal.png", slider.bounds.x, slider.bounds.y)
    local sliderMark        = Image.new(slider.name .. "_sliderMark", "assets/ui/sliderMark.png", slider.bounds.x, slider.bounds.y)
    local rightSliderButton = SliderButton.new(slider.name .. "_rightSliderButton", "assets/ui/sliderButtonRight.png", slider.bounds.x + slider.bounds.width, slider.bounds.y, function() slider.data.value = math.min(1, slider.data.value + .1) end)
    local valueText         = BitmapText.new(slider.name .. "_valueText", "assets/ui/ui-18.fnt", slider.data.value * 100, "center", "center", 0, 0, nil, nil, nil, 0.85)

    slider.addComponent(leftSliderButton)
    slider.addComponent(rightSliderButton)
    slider.addComponent(sliderBar)
    slider.addComponent(sliderStart)
    slider.addComponent(sliderEnd)
    slider.addComponent(sliderMark)
    slider.addComponent(valueText)

    function slider.update(_)
        leftSliderButton.setPosition(slider.bounds.x, slider.bounds.y)
        sliderStart.setPosition(slider.bounds.x + leftSliderButton.bounds.width + 10, slider.bounds.y + leftSliderButton.bounds.height / 2)
        sliderBar.setPosition(sliderStart.bounds.x + sliderBar.getWidth() / 2, slider.bounds.y + leftSliderButton.bounds.height / 2)
        sliderEnd.setPosition(sliderBar.bounds.x + sliderBar.getWidth() / 2 + sliderEnd.getWidth() / 2, slider.bounds.y + leftSliderButton.bounds.height / 2)
        rightSliderButton.setPosition(sliderEnd.bounds.x + sliderEnd.bounds.width, slider.bounds.y)
        local markPositionX = sliderStart.bounds.x + (sliderBar.getWidth() * slider.data.value) + 2
        sliderMark.setPosition(markPositionX, slider.bounds.y + leftSliderButton.bounds.height / 2)
        valueText.setContent(math.floor(slider.getValue() * 100) .. " %")
        valueText.setPosition(sliderBar.bounds.x, slider.bounds.y + 35)

    end

    function slider.getValue()
        return slider.data.value
    end

    return slider
end

return Slider
