----------------------------------------------------
--  character.lua
--
--  Authors: Eric Noble and Tyler Kramer
--  Purpose: Loading and Management of main character.
----------------------------------------------------

character = {}

--[[
    character.loadKoala loads the koala object and places it at
    a given x, y coordinate and gives it control of a passed map.
]]--
function character.loadKoala(x, y, map)
    --Load top spritesheet.
	local dataTop =
	{
		path = "MEDIA/ss_Koala-top.png",
		sequenceData = {
			name = "top",
			start = 1,
			count = 5,
			time = 800,
			loopCount = 0,
			loopDirection = "forward"
		},
		sheetData = {
			width = 70,
			height = 81,
			numFrames = 5,
			sheetContentWidth = 140,
			sheetContentHeight = 246
		},
		standingFrame = 2,
		jumpingFrame = 1
	}

    --Load bottom spritesheet.
	local dataBot =
	{
		path = "MEDIA/ss_Koala-bottom.png",
		sequenceData = {{name = "bot", start = 1, count = 7, time = 800, loopCount = 0, loopDirection = "forward"},
						 name = "run", start = 1, count = 6, time = 800, loopCount = 1, loopDirection = "forward"},
		sheetData = {width = 68, height = 34, numFrames = 7, sheetContentWidth = 136, sheetContentHeight = 136},
		standingFrame = 7,
		jumpingFrame = 2
	}
	local aimDirection = {
		downAngle = 1,
		upAngle = 4,
		up = 5,
		straight = 2
	}
    local shootPoints = {
        downAngle = {64, 10, 82},
        upAngle = {62, 12, 20},
        up = {36, 38, 0},
        straight = {72, 2, 48}
    }

    --Group top and bottom.
	character.loadTwoParter(dataTop, dataBot, x, y, map, aimDirection, shootPoints)
	character.shape = {0, 0, character.visual.width, 0, character.visual.width, character.visual.height+8, 0, character.visual.height+8}
end

--[[
    loadTwoParter takes the top and bottom data and groups them
    in a display group then finishes instantiating the character.
    The group is under visual.  The function then instantiates
    character fields as well.
]]--
function character.loadTwoParter(dataTop, dataBot, x, y, map, aimDirection, shootPoints)
	character.top = character.load(dataTop["path"], x, y, dataTop["sequenceData"], dataTop["sheetData"], dataTop["standingFrame"], dataTop["jumpingFrame"])
	character.bot = character.load(dataBot["path"], x - 6, y + 34, dataBot["sequenceData"], dataBot["sheetData"], dataBot["standingFrame"], dataBot["jumpingFrame"])

	character.visual = display.newGroup()
	character.visual:insert(character.top.visual)
	character.visual:insert(character.bot.visual)
	character.visual:setReferencePoint(display.CenterReferencePoint)
	character.aimDirection = aimDirection
    character.shootPoints = shootPoints

	character.map = map
    character.visual.friction = 1
    character.visual.isFixedRotation = true

	character.canJump = true
	character.isStopped = true

    character.dmg = 15
    character.shots = 3

    character.health = 200
    character.mhealth = 200
end

--[[
    character.shoot determines the angle the character is aiming and
    creates the specified shot.  Randomness is introduced by y and
    x variations in the ending cordinate of the shot line.
]]--
function character.shoot()
    local y_vari = 0
    local x_vari = 0
    if (character.top.visual.frame == character.aimDirection["downAngle"]) then
        x_vari = (math.random(6) - 3) * 2
        y_vari = (math.random(6) - 3) * 2
        character.create_shot("downAngle", character.visual.xScale, x_vari, y_vari)
    elseif (character.top.visual.frame == character.aimDirection["upAngle"]) then
        x_vari = (math.random(6) - 3) * 2
        y_vari = (math.random(6) - 3) * 2
        character.create_shot("upAngle", character.visual.xScale, x_vari, y_vari)
    elseif (character.top.visual.frame == character.aimDirection["up"]) then
        x_vari = (math.random(8) - 4) * 2
        character.create_shot("up", character.visual.xScale, x_vari, y_vari)
    elseif (character.top.visual.frame == character.aimDirection["straight"]) then
        y_vari = (math.random(8) - 4) * 2
        character.create_shot("straight", character.visual.xScale, x_vari, y_vari)

    end
end

--[[
    character.create_shot takes the specified aim direction,
    char direction, and specified variance in the endpoint of the
    shot and creates the shot. A shot is both a line and map of
    coordinates.  The line is drawn to screen and then the line and
    map are passed to fade_shot.  Collisions are also detected here.
]]--
function character.create_shot(aimDirection, charDirection, x_vari, y_vari)
        local x1, y1, x2, y2
        local shot_i

        character.visual:setReferencePoint(display.TopLeftReferencePoint)
        if (charDirection == -1) then
            x1=character.visual.x - mapoffset + character.shootPoints[aimDirection][2]
            x2=character.visual.x - mapoffset + character.shootPoints[aimDirection][2]
        elseif (charDirection == 1) then
            x1=character.visual.x - mapoffset + character.shootPoints[aimDirection][1]
            x2=character.visual.x - mapoffset + character.shootPoints[aimDirection][1]
        end
        y1=character.visual.y + character.shootPoints[aimDirection][3]
        y2=character.visual.y + character.shootPoints[aimDirection][3]

        if (aimDirection == "straight") then
            x2 = x2 + (charDirection * 180)
            y2 = y2 + y_vari
            shot_i = {x1, y1, x2, y2, "x"}
        elseif (aimDirection =="upAngle") then
            x2 = x2 + (charDirection * 128) + x_vari
            y2 = y2 - 128 + y_vari
            if charDirection == 1 then
                shot_i = {x1, y1, x2, y2, "xy"}
            else
                shot_i = {x1, y1, x2, y2, "yx"}
            end
        elseif (aimDirection =="downAngle") then
            x2 = x2 + (charDirection * 128) + x_vari
            y2 = y2 + 128 + y_vari
            if charDirection == 1 then
                shot_i = {x1, y1, x2, y2, "xy"}
            else
                shot_i = {x1, y1, x2, y2, "yx"}
            end
        elseif (aimDirection == "up") then
            x2 = x2 + x_vari
            y2 = y2 - 180
            shot_i = {x1, y1, x2, y2, "y"}
        end
        local shot = display.newLine(x1,y1,x2,y2)
	    character.visual:setReferencePoint(display.CenterReferencePoint)
        shot:setColor(230, 230, 230, 255)
        shot.width = 2


        character.detect_shot(shot_i)

        local closure = function () return character.fade_shot(shot, shot_i) end
        timer.performWithDelay(10, closure, 1)
end

--[[
    character.fade_shot makes the passed shot pretty.  Using a specified
    general direction, a bullet is drawn at the end of the shot path.
    Both are faded with delayed calls to this method.  Ultimately,
    the shot is removed once fully faded.
]]--
function character.fade_shot(shot, shot_i)
    local closure
    alpha = shot.alpha - 0.1

    if (alpha <= 0.0) then
        shot:removeSelf()
    elseif (alpha <= 0.8) then
        shot:removeSelf()
        if (shot_i[5] == "x") then
            shot = display.newLine(shot_i[3]-4, shot_i[4], shot_i[3], shot_i[4])
        elseif (shot_i[5] == "y") then
            shot = display.newLine(shot_i[3], shot_i[4]-4, shot_i[3], shot_i[4])
        elseif (shot_i[5] == "xy") then
            shot = display.newLine(shot_i[3]-3, shot_i[4]-3, shot_i[3], shot_i[4])
        elseif (shot_i[5] == "yx") then
            shot = display.newLine(shot_i[3]+3, shot_i[4]-3, shot_i[3], shot_i[4])
        end
        shot:setColor(0,0,0,255)
        shot.width = 2
        shot.alpha = alpha
        closure = function () return character.fade_shot(shot, shot_i) end
        timer.performWithDelay(20, closure)
    else
        shot.alpha = alpha
        closure = function () return character.fade_shot(shot, shot_i) end
        timer.performWithDelay(20, closure)
    end
end

--[[
    character.detect_shot iterates through the list of all enemies
    generated as enemies are added to the AI.  The function determines
    if the shot intersects any of the lines of an enemies hit box.  If
    a collision has ocurred, health is adjusted and displayed.  The
    health boxes are is faded via delayed calls.
]]--
function character.detect_shot(shot_i)
     for k,v in pairs(ai.enemies) do
         if (v ~= nil) then
             local l = character.is_intersect(shot_i[1], shot_i[2], shot_i[3], shot_i[4], v.rect.x, v.rect.y, v.rect.x, v.rect.y+v.rect.height)
             local r = character.is_intersect(shot_i[1], shot_i[2], shot_i[3], shot_i[4], v.rect.x+v.rect.width, v.rect.y, v.rect.x+v.rect.width, v.rect.y+v.rect.height)
             local u = character.is_intersect(shot_i[1], shot_i[2], shot_i[3], shot_i[4], v.rect.x, v.rect.y, v.rect.x+v.rect.width, v.rect.y)
             local d = character.is_intersect(shot_i[1], shot_i[2], shot_i[3], shot_i[4], v.rect.x, v.rect.y+v.rect.height, v.rect.x+v.rect.width, v.rect.y+v.rect.height)

             if (l or r or u or d) then
                 if not v.dying then
                     print(v.name)
                     if v.name ~= "boss" then
                        v.visual:setFillColor(255,0,0)
                        local closure = function () return character.revert_color(v) end
                        timer.performWithDelay(15, closure)
                     end
                     local health = v.adjust_health(-character.dmg)
                     if (v.dtimer == nil) then
                         v.hide_hprects(1.0)
                         v.delay_fadeout()
                     else
                         v.hide_hprects(1.0)
                         timer.cancel(v.dtimer)
                         v.delay_fadeout()
                     end
                end
             end
        end

     end
end

--[[
    character.revert_color removes any color mask from the specified
    character or enemy object.
]]--
function character.revert_color(v)
    v.visual:setFillColor(255,255,255)
end

--[[
    character.is_intersect accepts two lines (x1,y1 -> x2,y2) and
    (x3,y3 -> x4,y4) respectively and performs their dot product.
    Using the dot product, it is determined if a collision has
    ocurred.

    This method was modified for our purposes and obtained from:
    "code.google.com/p/lua-files/brows/path_line.lua", last
    modified by cosmin.apreuetsei@google.com.

    Returns true on intersect, false otherwise.
]]--
function character.is_intersect(x1, y1, x2, y2, x3, y3, x4, y4)
    local d = (y4-y3) * (x2 - x1) - (x4 - x3) * (y2 - y1)
    if (d == 0) then return false end
    t1 = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / d
    t2 = ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)) /d
    if ((t1 >= 0 and t1 <= 1) and (t2 >= 0 and t2 <=1)) then
        return true
    else
        return false
    end
end

--[[
    character.aim adjusts the displayed character corresponding
    to the passed direction and orientation.
]]--
function character.aim(direction, where)
	if where == "left" then
		character.visual.xScale = -1
	else
		character.visual.xScale = 1
	end

	character.top.visual:setFrame(character.aimDirection[direction])
end

--[[
    character.load contains generic items for the loading of a character.
    Instantiates the character object and returns that object.
]]--
function character.load(path, x, y, sequenceData, sheetData, standingFrame, jumpingFrame)
	local data = {}
	local sheet = graphics.newImageSheet(path, sheetData)
	local visual = display.newSprite(sheet, sequenceData)

	visual.x = x
	visual.y = y
	visual.isFixedRotation = true
	visual:setSequence("run")
	visual:setFrame(standingFrame)

	data.visual = visual
	data.standing = standingFrame
	data.jumping = jumpingFrame

	return data
end

--[[
    character.isInMiddleOfMap determines if the character is in the
    middle of the map.  Returns true or false accordingly.
]]--
function character.isInMiddleOfMap()
	local middle = display.contentWidth/ 2
	if (middle - 6) <= character.visual.x and character.visual.x <= (middle + 6) then
		return true
	end

	return false
end

--[[
    character.checkCanJump checks if a character can jump
    or not, removes itself when the character can jump.
]]--
function character.checkCanJump()
	local x, y = character.visual:getLinearVelocity()
	if math.floor(math.abs(y)) == 0 then
		character.canJump = true
		Runtime:removeEventListener("enterFrame", checkCanJump)
	end
end

--[[
    character.jump causes the character to perform a jumping motion
    and sets a flag so that the character cannot jump again until
    landing.
]]--
function character.jump()
	if character.canJump then
		character.bot.visual:setFrame(character.bot.jumping)
		local x, y = character.visual:getLinearVelocity()
		character.visual:setLinearVelocity(x, y - 250)
		character.canJump = false
		Runtime:addEventListener("enterFrame", character.checkCanJump)
	end
end

--[[
    character.stop stops the character and animations.
]]--
function character.stop()
	if character.canJump then
		character.top.visual:setFrame(character.top.standing)
		character.bot.visual:pause()
		character.bot.visual:setFrame(character.bot.standing)
	end
end

--[[
    character.moveRight moves the character right (playing the
    animation).  As the character moves, the character:
      . interacts with the map
      . causes enemies to spawn
    The map is only moved as the character goes right, and with the
    exception of both ends, the character is kept in the middle of
    the screen.
]]--
function character.moveRight()
	character.isStopped = false
	character.visual.xScale = 1
	local x, y = character.visual:getLinearVelocity()
    character.visual:setLinearVelocity(0,y)
	local x, y = character.map:getPosition()
	local pos = math.abs(x - display.contentWidth) / 32
    if character.visual.x < character.map.width*32 - character.visual.width/2 then
        if(distance % spawnrand == 0) then
            if (mapoffset < (character.map.width*32 - 2*display.contentWidth)) then
                spawn_enemy(character.map:getTileLayer("Objects"))
                spawnrand = math.random(5,35) * 8
            end
        end
        if character.visual.x >= mapoffset + display.contentWidth/2 then
            character.visual.x = character.visual.x + 8
            if mapoffset < (character.map.width*32 - display.contentWidth) then
                mapoffset = mapoffset + 8
                distance = distance + 8
            end
            character.map:move(8,0)
        else
            character.visual.x = character.visual.x + 8
            distance = distance + 8
        end
    end
	if character.canJump then
		character.bot.visual:play()
	end
end

function character.resetHealth()
    character.health = character.mhealth
end

--[[
    character.moveLeft moves the character left.  The function
    flips the character's orientation and moves the character
    left (playing animation).
]]--
function character.moveLeft()
	local x, y = character.visual:getLinearVelocity()
    character.visual:setLinearVelocity(0,y)
	character.visual.xScale = -1
	if character.visual.x - mapoffset - 8  > 0 then
        character.visual.x = character.visual.x - 8
		if character.canJump then
			character.bot.visual:play()
		end
	end
end

--[[
    character.remove removes the character
]]--
function character.remove()
	character.visual:removeSelf()
	character.visual = nil
end

return character
