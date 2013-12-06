-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- authors: Eric Noble and Tyler Kramer
-- purpose: Initializing and driving application.
-----------------------------------------------------------------------------------------

debug = false

storyboard = require "storyboard"
display.setStatusBar(display.HiddenStatusBar)

lime = require("lime.lime")
lime.enableDebugMode()
system.activate("multitouch")

joyStickLib = require("lib_analog_stick")
local stickSize = 48;
joyStickSettings = {
	x = stickSize,
	y = display.contentHeight - stickSize,
	thumbSize = 24,
	borderSize = stickSize,
	snapBackSpeed = .1,
	R = 255,
	G = 255,
	B = 255
}

control = require("control")
character = require("character")
npc = require("npc")
ai = require("artificialIntelligence")

-- load menu_main
storyboard.gotoScene("menu_main")

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc.):

lives = 3
img_lives = {}
bhealth = nil
fhealth = nil
bcool = nil
fcool = nil
isBossSpawned = false

--[[
    place_lives places a number of life icons equivalent to the
    passed integer.
]]--
function place_lives()
    for i = lives, 1, -1 do
        local life = display.newImage("MEDIA/ic_life.png")
        life:setReferencePoint(display.TopRightReferencePoint)
        life.x = display.contentWidth - 10 - 35 * (i - 1)
        life.y = 40
        img_lives[(i - 1)] = life
    end
end

--[[
    remove_lives removes all lives from the screen.
]]--
function remove_lives()
    for k,v in pairs(img_lives) do
        if (v ~= nil) then
            v:removeSelf()
            img_lives[k] = nil
        end
    end
end

--[[
    place_health places the healthbar on screen.
]]--
function place_health()
    bhealth = display.newRect(0,0, 120, 16)
    bhealth:setReferencePoint(display.TopRightReferencePoint)
    bhealth.x = display.contentWidth - 10
    bhealth.y = 10
    bhealth:setFillColor(0,0,0)
    fhealth = display.newRect(0,0, 116, 12)
    fhealth:setReferencePoint(display.TopRightReferencePoint)
    fhealth.x = display.contentWidth - 12
    fhealth.y = 12
    fhealth:setFillColor(255,0,0)
end

--[[
    remove_health removes the healthbar on screen.
]]--
function remove_health()
    bhealth:removeSelf()
    bhealth = nil
    fhealth:removeSelf()
    fhealth = nil
end

--[[
    update_health updates the size of the inner health bar
    to reflect the passed percentage of health.
]]--
function update_health(percent)
    percent = math.max(percent, 0)
    if percent == 0 then
        lives = lives - 1
        remove_lives()
        place_lives()
        character.resetHealth()
        percent = 1
        if lives == 0 then
            print("Game over")
            --storyboard.gotoScene("game_over")
            lives = 3
        elseif not isBossSpawned then
            --storyboard.gotoScene("testLevel.testLevel")
        end
    end
    fhealth.width = percent * 116
    fhealth:setReferencePoint(display.TopRightReferencePoint)
    fhealth.x = display.contentWidth - 12
end

--[[
    place_cooldown places the cooldown bar on screen.
]]--
function place_cooldown()
    bcool= display.newRect(0,0, 100, 6)
    bcool:setReferencePoint(display.TopRightReferencePoint)
    bcool.x = display.contentWidth - 10
    bcool.y = 28
    bcool:setFillColor(0,0,0)
    fcool= display.newRect(0,0, 96, 2)
    fcool:setReferencePoint(display.TopRightReferencePoint)
    fcool.x = display.contentWidth - 12
    fcool.y = 30
    fcool:setFillColor(120,140,255)
end

--[[
    remove_cooldown removes the cooldown on screen.
]]--
function remove_cooldown()
    bcool:removeSelf()
    bcool = nil
    fcool:removeSelf()
    fcool = nil
end

--[[
    update_cooldown updates the size of the inner cooldown bar
    to reflect the cooldown time via a passed percentage.
]]--
function update_cooldown(percent)
    fcool.width = percent * 96
    fcool:setReferencePoint(display.TopRightReferencePoint)
    fcool.x = display.contentWidth - 12
end
