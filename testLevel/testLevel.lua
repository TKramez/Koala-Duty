----------------------------------------------------------------------------------
--
-- testLevel.lua
--
-- Authors: Eric Noble and Tyler Kramer
-- Purpose: Serve as the main level demonstrating Koala Duty.
----------------------------------------------------------------------------------

local scene = storyboard.newScene()
    

local physics = require("physics")
physics.start()

local map = lime.loadMap("testLevel/testLevel_other.tmx")
local visual = lime.createVisual(map)
local physical = lime.buildPhysical(map)
isBossSpawned = false

mapoffset = 0
distance = 8
spawntimer = nil
spawnrand = math.random(1,5) * 8

----------------------------------------------------------------------------------
--
--	NOTE:
--
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

function spawn_boss()
    isBossSpawned = true
    local destructor = npc.loadDestructor(0, 0, map)
    local layer = map:getTileLayer("Objects")
    layer:addObject(destructor.visual)
    destructor.visual.x = math.abs((map.width - 2) * 32)
    destructor.visual.y = 110
    ai.add(destructor)
end

function check_spawn_boss()
    local x, y = map:getPosition()
    local pos = math.abs(x - display.contentWidth) / 32
    if pos == map.width then
        timer.performWithDelay(3000, spawn_boss)
    else
        timer.performWithDelay(1000, check_spawn_boss)
    end
end

--[[
    spawn_enemy sets one of three enemies offscreen, places them in
    the passed layer, and adds them to the ai.
--]]
function spawn_enemy(layer)
     local r = math.random(3)
     local x = character.visual.x + display.contentWidth*1.5
     local y = 100

     if r == 1 then
         spawn_bee(map:getTileLayer("Objects"), x, y)
     elseif r == 2 then
         spawn_poacher(map:getTileLayer("Objects"), x, y)
     elseif r == 3 then
         spawn_porcupine(map:getTileLayer("Objects"), x, y)
     end
end

--[[
    spawn_porcupine places a porcupine in the passed layer at the
    passed coordinates and adds it to the ai.
]]--
function spawn_porcupine(layer, x, y)
    local porcupine = npc.loadPorcupine(0,0)
    layer:addObject(porcupine.visual)
    porcupine.visual.x = x
    porcupine.visual.y = y
    ai.add(porcupine)
end

--[[
    spawn_bee places a bee in the passed layer at the
    passed coordinates and adds it to the ai.
]]--
function spawn_bee(layer, x, y)
    local bee = npc.loadBee(0, 0)
    layer:addObject(bee.visual)
    bee.visual.x = x
    ai.add(bee)

    local r = math.random(1,80)
    bee.visual.y = y + (r-40)
end

--[[
    spawn_bee places a bee in the passed layer at the
    passed coordinates and adds it to the ai.
]]--
function spawn_poacher(layer, x, y)
    local poacher = npc.loadPoacher(0,0)
    layer:addObject(poacher.visual)
    poacher.visual.x = x
    poacher.visual.y = y
    ai.add(poacher)
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene(event)
	local group = self.view

    map:move(40, 0)
    mapoffset = mapoffset + 40
	control.draw()

	character.loadKoala(50, 50, map)
	ai.start()

    --Unused category to ignore collisions.
    local colfilter = {categoryBits = 2, maskBits = 1}
	physics.addBody(character.visual, {filter = colfilter, bounce = 0, friction = 1, shape = character.shape})
    local stagelayer = map:getTileLayer("Objects")
    stagelayer:addObject(character.visual)

	control.setCharacter(character)
	control.start()

    place_health()
    place_cooldown()
    place_lives(lives)

    timer.performWithDelay(1000, check_spawn_boss)

	-----------------------------------------------------------------------------

	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)

	-----------------------------------------------------------------------------

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	ai.stop()
    physics.stop()
	control.remove()
	character.remove()
    ai.removeall()
    visual:removeSelf()
    visual = nil
    remove_lives()
    remove_health()
    remove_cooldown()
    --print("Hello")
	-----------------------------------------------------------------------------

	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

	-----------------------------------------------------------------------------

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view

	-----------------------------------------------------------------------------

	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)

	-----------------------------------------------------------------------------

end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene
