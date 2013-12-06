----------------------------------------------------------------------------------
--
-- menu_main.lua
--
-- Evan J. Travis
-- Eric Noble
----------------------------------------------------------------------------------
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require("widget")

--------------------------------------------

-- forward declarations and other locals
local playBtn
local instrBtn
local logo

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	-- go to level1.lua scene
	storyboard.gotoScene( "testLevel.testLevel")
	
	return true	-- indicates successful touch
end

-- 'onRelease' event listener for playBtn
local function onInstrBtnRelease()
	
	-- go to level1.lua scene
	storyboard.gotoScene( "instr", "fade", 500 )
	
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
	--background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = display.contentWidth/2,display.contentHeight/2

    logo = display.newImage("MEDIA/koaladuty_logo.png", 0, 0)
    logo.x, logo.y = display.contentWidth/2, display.contentHeight/2 - 50
	
	-- create a widget button (which will loads testLevel.lua on release)
	playBtn = widget.newButton{
		label="Play",
		labelColor = { default={255}, over={128} },
		defaultFile="button.png",
		overFile="button-over.png",
		width=154, height=40,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn.x = display.contentWidth*0.5 - 85 
	playBtn.y = display.contentHeight - 50

	-- create a widget button (which will load instructions on release)
    instrBtn = widget.newButton{
        label="Instructions",
        labelColor = { default={255}, over={128} },
        defaultFile="button.png",
        overFile="button-over.png",
        width=154, height=40,
        onRelease = onInstrBtnRelease
    }

	instrBtn:setReferencePoint( display.CenterReferencePoint )
	instrBtn.x = display.contentWidth*0.5 + 85 
	instrBtn.y = display.contentHeight - 50
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( playBtn )
    group:insert( instrBtn )
    group:insert( logo )
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
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end

	if instrBtn then
		instrBtn:removeSelf()	-- widgets must be manually removed
		instrBtn = nil
	end

    if logo then
        logo:removeSelf()
        logo = nil
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
