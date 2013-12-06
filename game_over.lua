----------------------------------------------------------------------------------
--
-- testLevel.lua
--
-- Authors: Eric Noble and Tyler Kramer
-- Purpose: Serve as the main level demonstrating Koala Duty.
----------------------------------------------------------------------------------

local storyboard = require("storyboard")
local scene = storyboard.newScene()

----------------------------------------------------------------------------------
--
--  NOTE:
--
--  Code outside of listener functions (below) will only be executed once,
--  unless storyboard.removeScene() is called.
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local function restart(event)
    storyboard.gotoScene("menu_main")
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene(event)
    local group = self.view

    group:insert(display.newText("Game Over", display.contentWidth / 2, display.contentHeight / 2, system.nativefont, 32))
    group:insert(display.newText("Touch anywhere to play again", 100, 100, system.nativefont, 16))
    Runtime:addEventListener( "touch", restart)

    -----------------------------------------------------------------------------

    --  INSERT code here (e.g. start timers, load audio, start listeners, etc.)

    -----------------------------------------------------------------------------

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
    local group = self.view
    Runtime:removeEventListener("touch", restart)

    -----------------------------------------------------------------------------

    --  INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

    -----------------------------------------------------------------------------

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
    local group = self.view

    -----------------------------------------------------------------------------

    --  INSERT code here (e.g. remove listeners, widgets, save state, etc.)

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
