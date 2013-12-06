-------------------------------------------------
--  control.lua
--
--  Authors: Tyler Kramer and Eric Noble
--  Purpose: Connect objects to the analog stick and buttons.
-------------------------------------------------

control = {}
local canshoot = true
local shotcount = 0
local coolcount = -0.2

--[[
    jump is to be used when a control indicates character 
    should jump.
]]--
local function jump(self, event)
	if event.phase == "began" then
		if control.character ~= nil then
			control.character.jump()
		end
	end
end

--[[
    setCharacter sets the character that the control should
    affect.
]]--
function control.setCharacter(char)
	control.character = char
end

--[[
    shoot is to be used when a control indicates a character
    should shoot.
]]--
function shoot(self, event)
    if (event.phase == "began") then
        if (canshoot) then
            canshoot = false
            timer.performWithDelay(60, auto_shoot, 3)
        end
    end
end

--[[
    auto_shoot emulates a burst.  Using the global shotcount,
    auto_shoot performs shoot with a delay that many times and
    upates the cooldown.
]]--
function auto_shoot()
    control.character.shoot()
    shotcount = shotcount + 1
    if (shotcount == 3) then
        shotcount = 0
        update_cooldown(0.01)
        timer.performWithDelay(20, refresh_cooldown)
        timer.performWithDelay(200, delay_shoot)
    else
        update_cooldown(1.0-shotcount/control.character.shots)
    end
end

--[[
    delay_shoot emulates a delay between bursts, it is to be
    performed with delay and simply sets the appropriate flag 
    to true.
]]--
function delay_shoot()
    canshoot = true
end

--[[
    refresh_cooldown increments the cooldown by 0.2 and
    updates the corresponding HUD bar.
]]--
function refresh_cooldown()
    coolcount = coolcount + 0.2
    if coolcount < 1.0 then
        update_cooldown(coolcount)
        timer.performWithDelay(40, refresh_cooldown)
    else
        update_cooldown(1)
        coolcount = -0.2
    end
end

--[[
    joyStickCheck calls functions corresponding to the
    current state of the joystick.  These functions 
    include aiming as well as movement.
]]--
function joyStickCheck(event)
	if control.character ~= nil then
		local distance = control.joystick:getDistance()
		
		if distance > 5 then
			local angle = control.joystick:getAngle()
			if distance > 20 then
				if angle > 0 and angle < 180 then
					control.character.moveRight()
				elseif angle > 180 and angle < 360 then
					control.character.moveLeft()
				else
					character.stop()
				end
			end
			if (337.5 < angle and angle <= 360) then
				character.aim("up", "left")
			elseif (0 <= angle and angle < 22.5) then
				character.aim("up", "right")
			elseif (22.5 <= angle and angle < 67.5) then
				character.aim("upAngle", "right")
			elseif (292.5 <= angle and angle < 337.5) then
				character.aim("upAngle", "left")
			elseif (67.5 <= angle and angle < 112.5) then
				character.aim("straight", "right")
			elseif (247.5 <= angle and angle < 292.5) then
				character.aim("straight", "left")
			elseif (112.5 <= angle and angle < 180) then
				character.aim("downAngle", "right")
			elseif (180 <= angle and angle < 247.5) then
				character.aim("downAngle", "left")
			end
		else
			character.stop()
		end
	end
end

--[[
    control.draw draws the joystick on the screen.
]]--
function control.draw()
	control.joystick = joyStickLib.NewStick(joyStickSettings)

	control.jumpButton = display.newCircle(display.contentWidth - 25, display.contentHeight - 70, 30)
	control.jumpButton.touch = jump
	control.jumpButton:addEventListener("touch", control.jumpButton)

	control.shootButton = display.newCircle(control.jumpButton.x - 70, control.jumpButton.y + 25, 30)
	control.shootButton.touch = shoot
	control.shootButton:addEventListener("touch", control.shootButton)
end

--[[
    control.start adds an eventlistener for registering joystick
    movements/state.
]]--
function control.start()
	Runtime:addEventListener("enterFrame", joyStickCheck)
end

--[[
    control.remove removes the joystick from the screen.
]]--
function control.remove()
	Runtime:removeEventListener("enterFrame", joyStickCheck)

	control.joystick:delete()
	control.joystick = nil

	control.jumpButton:removeSelf()
	control.jumpButton = nil

	control.character = nil
end

return control
