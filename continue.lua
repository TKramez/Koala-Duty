----------------------------------------------------------------------------------
--
-- instr.lua
--
-- Authors: Eric Noble and Evan Travis
-- Purpose: Provide a screen for instructions.
----------------------------------------------------------------------------------
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require("widget")

local liveimg
local livetxt

--------------------------------------------

-- forward declarations and other locals

local function onCont()
	
	-- go to level1.lua scene
	storyboard.gotoScene( "testLevel.testLevel")
	
	return true	-- indicates successful touch
end



-------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    storyboard.removeScene("testLevel.testLevel")
	local group = self.view
    liveimg = display.newImage("MEDIA/ic_life.png")
    liveimg.x = display.contentWidth/2 - 26
    liveimg.y = display.contentHeight/2
    livetxt = display.newText(" x "..lives, 0, 0, native.systemFont, 16)
    livetxt.x = display.contentWidth/2 + 2 
    livetxt.y = display.contentHeight/2
	
	-- all display objects must be inserted into group
    group:insert( liveimg )
    group:insert( livetxt )
    timer.performWithDelay(1000, onCont, 1)
	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
    liveimg:removeSelf()
    liveimg = nil
    livetxt:removeSelf()
    livetxt = nil
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
end

-------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene
