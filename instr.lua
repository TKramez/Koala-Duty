----------------------------------------------------------------------------------
--
-- instr.lua
--
-- Authors: Eric Noble and Evan Travis
-- Purpose: Provide a screen for instructions.
----------------------------------------------------------------------------------
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require("widget")

--------------------------------------------

-- forward declarations and other locals
local backBtn
local backrect
local dsptxt

local instrtxt = "Controls: \n  MOVE with the analog stick.\n  SHOOT with the left button.\n  JUMP with the right button.\n\n  HEALTH is displayed in red.\n  COOLDOWN for the weapon is displayed in blue.\n\nYour goal is to defend your jungle!  Each time\n you fail to destroy an enemy, you lose health.\n Keep your health as high as possible, take on\n the final boss at the end, and save your jungle!\n "


-- 'onRelease' event listener for backBtn 
local function onInstrBtnRelease()
	
	-- go to level1.lua scene
	storyboard.gotoScene( "menu_main", "fade", 500 )
	
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

	-- display a background image
	local background = display.newImageRect( "bkgrd_jungle-1.png", display.contentWidth+80, display.contentHeight )
	background.x, background.y = display.contentWidth/2,display.contentHeight/2

    -- display a translucent rect for text background
    backrect = display.newRect(0,0,display.contentWidth-100, display.contentHeight-20)
    backrect.x = display.contentWidth/2
    backrect.y = display.contentHeight/2
    backrect.alpha = 0.7
    backrect:setReferencePoint(display.CenterReferencePoint)

    dsptxt = display.newText(instrtxt, 0,0, native.systemFont, 14)
	dsptxt.x = display.contentWidth/2
	dsptxt.y = display.contentHeight/2 - 20
    dsptxt:setTextColor(0,0,0)

	-- create a widget button (which will load menu_main on release)
    backBtn = widget.newButton{
        label="Back",
        labelColor = { default={255}, over={128} },
        defaultFile="button.png",
        overFile="button-over.png",
        width=154, height=40,
        onRelease = onInstrBtnRelease
    }

	backBtn:setReferencePoint( display.CenterReferencePoint )
	backBtn.x = display.contentWidth*0.5 + 85 
	backBtn.y = display.contentHeight - 50
	
	-- all display objects must be inserted into group
	group:insert( background )
    group:insert( backrect )
    group:insert( dsptxt )
    group:insert( backBtn )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	

	if backBtn then
		backBtn:removeSelf()	-- widgets must be manually removed
		backBtn = nil
	end

	if dsptxt then
		dsptxt:removeSelf()	-- widgets must be manually removed
		dsptxt = nil
	end
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
