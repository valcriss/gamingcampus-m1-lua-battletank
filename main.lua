-- Importation des modules
local ScreenManager = require "models.screen.ScreenManager"
local ScenesManager = require "models.scenes.ScenesManager"
FirstScene = require "scenes.FirstScene"
SecondScene = require "scenes.SecondScene"

if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

io.stdout:setvbuf "no"

-- Déclaration des variables globales
screenManager = ScreenManager:new()
scenesManager = ScenesManager:new()

-- Déclaration des variables locales
local firstScene = FirstScene.new("firstScene", 0)

-- Functions
function love.load()
    screenManager:init(1366, 768)
    scenesManager:addScene(firstScene)
end

function love.update(dt)
    scenesManager:update(dt)
end

function love.draw()
    scenesManager:draw()
end

function love.resize(_, _)
    screenManager:resize()
end
