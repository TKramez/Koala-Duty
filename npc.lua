--------------------------------------------------
--  npc.lua
--
--  Authors: Tyler Kramer and Eric Noble
--  Purpose: Loading and Management of NPCs
--------------------------------------------------

--DEBUG ITEMS---------------------------
--  (only appear when debug flag set)
npc = {}
hb_col = 00
----------------------------------------

if (debug) then
    hb_col = 30
end

--[[
    npc.loadDestructor takes care of loading spritesheets, data,
    and initializing a destructor.  The destructor is placed at
    the passed coordinates.
    The function returns a destructor object.
]]--
function npc.loadDestructor(x, y)
    local destructor = {}
    destructor.leftArm = npc.load("MEDIA/ss_Destructor-Arm.png",
        {
            {
                name = "idle",
                frames = {1, 2, 3, 4, 2},
                time = 800,
                loopCount = 0,
                loopDirection = "foward"
            },
            {
                name = "start_fly",
                frames = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14},
                time = 800,
                loopCount = 1,
                loopDirection = "foward"
            },
            {
                name = "fly_loop",
                frames = {15, 16},
                time = 800,
                loopCount = 0,
                loopDirection = "foward"
            },
            {
                name = "stop_fly",
                frames = {17, 18, 19, 20, 21},
                time = 800,
                loopCount = 1,
                loopDirection = "foward"
            },
            {
                name = "start_lazer",
                frames = {22, 23, 24, 25},
                time = 800,
                loopCount = 1,
                loopDirection = "foward"
            },
            {
                name = "lazer_loop",
                frames = {26, 27},
                time = 800,
                loopCount = 0,
                loopDirection = "foward"
            },
            {
                name = "stop_lazer",
                frames = {25, 24, 23, 28, 22},
                time = 800,
                loopCount = 1,
                loopDirection = "foward"
            }
        },
        {
            width = 318,
            height = 136,
            numFrames = 28,
            sheetContentWidth = 954,
            sheetcontentHeight = 1360
        },
        x - 22, y + 6, "leftArm"
    )
    destructor.body = npc.load("MEDIA/ss_Destructor-Body.png",
        {
            {
                name = "idle",
                frames = {1, 2, 3, 4, 5, 6},
                time = 800,
                loopCount = 0,
                loopDirection = "forward"
            },
            {
                name = "forward",
                frames = {7, 8, 9},
                time = 800,
                loopCount = 1,
                loopDirection = "forward"
            },
            {
                name = "backward",
                frames = {10, 11, 12},
                time = 800,
                loopCount = 1,
                loopDirection = "foward"
            }
        },
        {
            width = 152,
            height = 236,
            numFrames = 12,
            sheetContentWidth = 456,
            sheetcontentHeight = 944
        },
        x, y, "body"
    )
    destructor.rightArm = npc.load("MEDIA/ss_Destructor-Arm.png",
        {
            {
                name = "idle",
                frames = {1, 2, 3, 4, 2},
                time = 800,
                loopCount = 0,
                loopDirection = "foward"
            },
            {
                name = "start_fly",
                frames = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14},
                time = 800,
                loopCount = 1,
                loopDirection = "foward"
            },
            {
                name = "fly_loop",
                frames = {15, 16},
                time = 800,
                loopCount = 0,
                loopDirection = "foward"
            },
            {
                name = "stop_fly",
                frames = {17, 18, 19, 20, 21},
                time = 800,
                loopCount = 1,
                loopDirection = "foward"
            },
            {
                name = "start_lazer",
                frames = {22, 23, 24, 25},
                time = 800,
                loopCount = 1,
                loopDirection = "foward"
            },
            {
                name = "lazer_loop",
                frames = {26, 27},
                time = 800,
                loopCount = 0,
                loopDirection = "foward"
            },
            {
                name = "stop_lazer",
                frames = {25, 24, 23, 28, 22},
                time = 800,
                loopCount = 1,
                loopDirection = "foward"
            }
        },
        {
            width = 318,
            height = 136,
            numFrames = 28,
            sheetContentWidth = 954,
            sheetcontentHeight = 1360
        },
        x + 106, y + 50, "rightArm"
    )

    destructor.moveRight = function()
        destructor.visual.xScale = 1
        destructor.visual.x = destructor.visual.x - destructor.speed
        destructor.get_rect()
        destructor.get_hprects()
    end
    destructor.moveLeft = function()
        destructor.visual.xScale = 1
        destructor.visual.x = destructor.visual.x - destructor.speed
        destructor.get_rect()
        destructor.get_hprects()
    end

    destructor.bossFight = function()
        print("WE'RE ALL GOING TO DIE!")
        destructor.get_rect()
        destructor.get_hprects()
    end

    destructor.body.visual:setSequence("idle")
    destructor.body.visual:play()
    destructor.rightArm.visual:setSequence("idle")
    destructor.rightArm.visual:play()
    destructor.leftArm.visual:setSequence("idle")
    destructor.leftArm.visual:play()

    destructor.visual = display.newGroup()
    destructor.visual:insert(destructor.leftArm.visual)
    destructor.visual:insert(destructor.body.visual)
    destructor.visual:insert(destructor.rightArm.visual)

    destructor.get_rect = function()
        destructor.rect.x = destructor.visual.x - mapoffset - destructor.visual.xScale * destructor.visual.width/2
        destructor.rect.y = destructor.visual.y - destructor.visual.height/2

        return destructor.rect
    end
    --[[
        destructor.get_hprects returns the rects forming the hp bar for a
        destructor.  The rects are first updated according to the destructor's
        position and amount of health.
    ]]--
    destructor.get_hprects = function()
        destructor.hbrect:setReferencePoint(display.TopCenterReferencePoint)
        destructor.hrect:setReferencePoint(display.TopCenterReferencePoint)
        destructor.hbrect.x = destructor.visual.x - mapoffset + destructor.visual.xScale * 39
        destructor.hrect.x = destructor.visual.x - mapoffset + destructor.visual.xScale * 40
        destructor.hbrect.y = destructor.visual.y

        local hrecth = math.floor(destructor.health/destructor.mhealth * 36)
        destructor.hrect.height = hrecth
        if (hrecth <= 0) then
            destructor.screwup = true
        end
        destructor.hrect.y = destructor.visual.y + 1 + (36-hrecth)


        return hbrect,hrect
    end
    --[[
        destructor.hide_hprects sets the alpha value of the destructor's hp_rects
        to the passed value.
    ]]--
    destructor.hide_hprects = function(alpha)
        destructor.hbrect.alpha = alpha
        if destructor.screwup then
            destructor.hrect.alpha = 0
        else
            destructor.hrect.alpha = alpha
        end
    end
    --[[
        delay_fadeout fades the hp_rects of the destructor after a set delay.
    ]]--
    destructor.delay_fadeout = function()
        destructor.dtimer = timer.performWithDelay(800, destructor.fadeout_hprects, 1)
    end
    --[[
        destructor.fadeout_hprects fades the hp_rects of the destructor gradually.
    ]]--
    destructor.fadeout_hprects = function()
        local alpha = destructor.hrect.alpha - 0.2
        if alpha >= 0 then
            destructor.hide_hprects(alpha)
            destructor.dtimer = timer.performWithDelay(40, destructor.fadeout_hprects, 1)
        else
            destructor.hide_hprects(0)
            destructor.dtimer = nil
        end
    end
    --[[
        destructor.adjust_health adds the specified amt to the destructor's health.
        Upon adjusting health, the health bars are unhidden and then
        faded after a delay.
    ]]--
    destructor.adjust_health = function(amt)
        print(amt)
        destructor.health = destructor.health + amt
        if destructor.health <= 0 and not destructor.dying then
            if destructor.dtimer ~= nil then timer.cancel(destructor.dtimer) end
            destructor.get_hprects()
            destructor.delay_fadeout()
            destructor.dying = true
            destructor.stop = true
            destructor.health = 0
            --destructor.visual:setSequence("die")
            --destructor.visual:play()
            local closure = function () return npc.delay_death(destructor) end
            timer.performWithDelay(200, closure, 1)
        else
            destructor.get_hprects()
        end
        return destructor.health
    end


    local colfilter = {categoryBits = 8, maskBits = 1}
    physics.addBody(destructor.visual, "static", {filter = colfilter, isSensor = true})

    destructor.rect = display.newRect(x, y, 152, 236)
    destructor.rect:setReferencePoint(display.TopLeftReferencePoint)
    destructor.rect:setFillColor(255,255,255,hb_col)

    destructor.hbrect = display.newRect(x+114,y,6,40)
    destructor.hbrect:setFillColor(0,0,0)
    destructor.hrect = display.newRect(x+115,y+1,4,38)
    destructor.hrect:setFillColor(255,0,0)

    destructor.mhealth = 1000.0
    destructor.health = destructor.mhealth

    destructor.screwup = false


    destructor.hide_hprects(0.0)

    destructor.speed = 10

    destructor.name = "boss"
    destructor.stop = true
    destructor.dying = false
    destructor.deathcount = 8

    return destructor
end

--[[
    npc.loadBee takes care of loading spritesheets, data,
    and initializing a bee.  The bee is placed at
    the passed coordinates.

    The function returns a bee object.
]]--
function npc.loadBee(x, y)
	local bee = npc.load("MEDIA/ss_bee.png",
		{
            {
                name = "flycycle",
                frames = {1, 2, 3, 4},
                time = 400,
                loopCount = 0,
                loopDirection = "forward"
            },
            {
                name = "attack",
                frames = {1, 5, 6, 7, 8},
                time = 400,
                loopCount = 1,
                loopDirection = "forward"
            },
            {
                name = "die",
                frames = {9},
                time = 1000,
                loopCount = 1,
                loopDirection = "forward"
            }
		},
		{
			width = 56,
			height = 56,
			numFrames = 9,
			sheetContentWidth = 168,
			sheetContentHeight = 168
		},
		x, y, "bee"
	)

    --[[
        bee.moveRight moves the bee right (currently not used).
    ]]--
	bee.moveRight = function ()
                        bee.visual.xScale = -1
                        bee.visual.x = bee.visual.x + bee.speed
                        bee.get_rect()
                        bee.get_hprects()
					end
    --[[
        bee.moveLeft moves the bee left and detects when the bee is
        offscreen.  At this point, character health is decreased.
    ]]--
	bee.moveLeft = function()
                        bee.visual.xScale = 1
                        bee.visual.x = bee.visual.x - bee.speed
                        bee.get_rect()
                        bee.get_hprects()
                        if (bee.visual.x - (mapoffset-bee.visual.width)) < 0 then
                            bee.stop = true
                            character.health = character.health - 10
                            update_health(character.health/character.mhealth)
                            npc.remove(bee)
                        end
				   end
    --[[
        bee.attack (not implemented)
    ]]--
    bee.attack = function()
                    print "Bee says pew"
                 end
    --[[
        bee.get_rect returns the rect representing the bee's hitbox.  The
        rect is first updated according to bee position.
    ]]--
    bee.get_rect = function()
        bee.rect.x = bee.visual.x - mapoffset - bee.visual.xScale * bee.visual.width/2
        bee.rect.y = bee.visual.y - bee.visual.height/2

        return bee.rect
    end
    --[[
        bee.get_hprects returns the rects forming the hp bar for a
        bee.  The rects are first updated according to the bee's
        position and amount of health.
    ]]--
    bee.get_hprects = function()
        bee.hbrect:setReferencePoint(display.TopCenterReferencePoint)
        bee.hrect:setReferencePoint(display.TopCenterReferencePoint)
        bee.hbrect.x = bee.visual.x - mapoffset + bee.visual.xScale * 39
        bee.hrect.x = bee.visual.x - mapoffset + bee.visual.xScale * 40
        bee.hbrect.y = bee.visual.y

        local hrecth = math.floor(bee.health/bee.mhealth * 36)
        bee.hrect.height = hrecth
        if (hrecth <= 0) then
            bee.screwup = true
        end
        bee.hrect.y = bee.visual.y + 1 + (36-hrecth)


        return hbrect,hrect
    end
    --[[
        bee.hide_hprects sets the alpha value of the bee's hp_rects
        to the passed value.
    ]]--
    bee.hide_hprects = function(alpha)
        bee.hbrect.alpha = alpha
        if bee.screwup then
            bee.hrect.alpha = 0
        else
            bee.hrect.alpha = alpha
        end
    end
    --[[
        delay_fadeout fades the hp_rects of the bee after a set delay.
    ]]--
    bee.delay_fadeout = function()
        bee.dtimer = timer.performWithDelay(800, bee.fadeout_hprects, 1)
    end
    --[[
        bee.fadeout_hprects fades the hp_rects of the bee gradually.
    ]]--
    bee.fadeout_hprects = function()
        local alpha = bee.hrect.alpha - 0.2
        if alpha >= 0 then
            bee.hide_hprects(alpha)
            bee.dtimer = timer.performWithDelay(40, bee.fadeout_hprects, 1)
        else
            bee.hide_hprects(0)
            bee.dtimer = nil
        end
    end
    --[[
        bee.adjust_health adds the specified amt to the bee's health.
        Upon adjusting health, the health bars are unhidden and then
        faded after a delay.
    ]]--
    bee.adjust_health = function(amt)
        bee.health = bee.health + amt
        if bee.health <= 0 and not bee.dying then
            if not bee.dtimer == nil then timer.cancel(bee.dtimer) end
            bee.get_hprects()
            bee.delay_fadeout()
            bee.dying = true
            bee.stop = true
            bee.health = 0
            bee.visual:setSequence("die")
            bee.visual:play()
            local closure = function () return npc.delay_death(bee) end
            timer.performWithDelay(200, closure, 1)
        end
        return bee.health
    end


    local colfilter = {categoryBits = 8, maskBits = 1}
    physics.addBody(bee.visual, "static", {filter = colfilter, isSensor = true})

    bee.rect = display.newRect(x, y, 56, 56)
    bee.rect:setReferencePoint(display.TopLeftReferencePoint)
    bee.rect:setFillColor(255,255,255,hb_col)

    bee.hbrect = display.newRect(x+114,y,6,40)
    bee.hbrect:setFillColor(0,0,0)
    bee.hrect = display.newRect(x+115,y+1,4,38)
    bee.hrect:setFillColor(255,0,0)

    bee.health = 50.0
    bee.mhealth = 50.0
    bee.screwup = false

    bee.hide_hprects(0.0)

    bee.speed = math.random(6,8)

	return bee
end

--[[
    npc.loadPoacher takes care of loading spritesheets, data,
    and initializing a poacher.  The poacher is placed at
    the passed coordinates.
    The function returns a poacher object.
]]--
function npc.loadPoacher(x, y)
    local poacher = npc.load("MEDIA/ss_Poacher.png",
        {
            {
                name = "stand",
                frames = {1},
                time = 800,
                loopCount = 1,
                loopDirection = "forward"
            },
            {
                name = "walk",
                frames = {2, 3, 4, 5},
                time = 800,
                loopCount = 0,
                loopDirection = "forward"
            },
            {
                name = "attack",
                frames = {1, 6, 7, 8, 9, 10},
                time = 800,
                loopCount = 1,
                loopDirection = "forward"
            },
            {
                name = "die",
                frames = {1, 11, 12, 13, 14, 15},
                time = 800,
                loopCount = 1,
                loopDirection = "forward"
            }
        },
        {
            width = 114,
            height = 106,
            numFrames = 15,
            sheetContentWidth = 682,
            sheetcontentHeight = 1060
        },
        x, y,
        "poacher"
        )
    --[[
        poacher.moveRight moves the poacher right (currently not used).
    ]]--
    poacher.moveRight = function()
                            if (poacher.visual.xScale == 1) then
                                poacher.visual.xScale = -1
                                poacher.visual.x = poacher.visual.x + 40
                            end
                            poacher.visual.x = poacher.visual.x + poacher.speed
                            poacher.get_rect()
                            poacher.get_hprects()

                        end
    --[[
        poacher.moveLeft moves the poacher left and detects when the poacher is
        offscreen.  At this point, character health is decreased.
    ]]--
    poacher.moveLeft = function()
                            if (poacher.visual.xScale == -1) then
                                poacher.visual.xScale = 1
                                poacher.visual.x = poacher.visual.x - 40
                            end
                            poacher.visual.x = poacher.visual.x - poacher.speed
                            poacher.get_rect()
                            poacher.get_hprects()
                            if (poacher.visual.x - (mapoffset - poacher.visual.width)) < 0 then
                                poacher.stop = true
                                character.health = character.health - 15
                                update_health(character.health/character.mhealth)
                                npc.remove(poacher)
                            end
                       end
    --[[
        poacher.attack (not implemented)
    ]]--
    poacher.attack = function()
                        print "Poacher says pew."
                     end

    --[[
        poacher.get_rect returns the rect representing the poacher's
        hitbox.  The rect is first updated according to poacher position.
    ]]--
    poacher.get_rect = function()
        if (poacher.visual.xScale == 1) then
            poacher.rect.x = poacher.visual.x - mapoffset - poacher.visual.width/2 + 80
            poacher.rect.y = poacher.visual.y - poacher.visual.height/2
        elseif (poacher.visual.xScale == -1) then
            poacher.rect.x = poacher.visual.x - mapoffset + poacher.visual.width/2 - 80
            poacher.rect.y = poacher.visual.y - poacher.visual.height/2
        end

        return poacher.rect
    end

    --[[
        poacher.get_hprects returns the rects forming the hp bar for a
        poacher.  The rects are first updated according to the poacher's
        position and amount of health.
    ]]--
    poacher.get_hprects = function()
        poacher.hbrect:setReferencePoint(display.TopCenterReferencePoint)
        poacher.hrect:setReferencePoint(display.TopCenterReferencePoint)
        poacher.hbrect.x = poacher.visual.x - mapoffset + poacher.visual.xScale * 59
        poacher.hrect.x = poacher.visual.x - mapoffset + poacher.visual.xScale * 60
        poacher.hbrect.y = poacher.visual.y

        local hrecth = math.floor(poacher.health/poacher.mhealth * 36)
        poacher.hrect.height = hrecth
        if (hrecth <= 0) then
            poacher.screwup = true
            end
        poacher.hrect.y = poacher.visual.y + 1 + (36-hrecth)


        return hbrect,hrect
    end

    --[[
        poacher.hide_hprects sets the alpha value of the poacher's hp_rects
        to the passed value.
    ]]--
    poacher.hide_hprects = function(alpha)
        poacher.hbrect.alpha = alpha
        if poacher.screwup then
            poacher.hrect.alpha = 0
        else
            poacher.hrect.alpha = alpha
        end
    end

    --[[
        delay_fadeout fades the hp_rects of the poacher after a set delay.
    ]]--
    poacher.delay_fadeout = function()
        poacher.dtimer = timer.performWithDelay(800, poacher.fadeout_hprects, 1)
    end

    --[[
        poacher.fadeout_hprects fades the hp_rects of the poacher gradually.
    ]]--
    poacher.fadeout_hprects = function()
        local alpha = poacher.hrect.alpha - 0.2
        if alpha >= 0 then
            poacher.hide_hprects(alpha)
            poacher.dtimer = timer.performWithDelay(40, poacher.fadeout_hprects, 1)
        else
            poacher.hide_hprects(0)
            poacher.dtimer = nil
        end
    end

    --[[
        poacher.adjust_health adds the specified amt to the poacher's
        health.  Upon adjusting health, the health bars are unhidden and
        then faded after a delay.
    ]]--
    poacher.adjust_health = function(amt)
        poacher.health = poacher.health + amt
        if poacher.health <= 0 and not poacher.dying then
            if not poacher.dtimer == nil then timer.cancel(poacher.dtimer) end
            poacher.get_hprects()
            poacher.delay_fadeout()
            poacher.dying = true
            poacher.stop = true
            poacher.health = 0
            poacher.visual:setSequence("die")
            poacher.visual:play()
            local closure = function () return npc.delay_death(poacher) end
            timer.performWithDelay(1200, closure, 1)
        end
        return poacher.health
    end

    poacher.shape = {0-poacher.visual.width/2, 0-poacher.visual.height/2, poacher.visual.width/2, 0-poacher.visual.height/2, poacher.visual.width/2, poacher.visual.height/2-4, 0-poacher.visual.width/2, poacher.visual.height/2-4}

    local colfilter = {categoryBits = 4, maskBits = 1}
    physics.addBody(poacher.visual, {filter = colfilter, friction = 1.0, bounce = 0, shape = poacher.shape})
    poacher.visual:setSequence("walk")
    poacher.visual:play()


    poacher.rect = display.newRect(x+78, y, 36, 106)
    poacher.rect:setFillColor(255,255,255,hb_col)
    poacher.rect:setReferencePoint(display.TopLeftReferencePoint)

    poacher.health = 90.0
    poacher.mhealth = 90.0
    poacher.screwup = false

    poacher.hbrect = display.newRect(x+114,y,6,40)
    poacher.hbrect:setFillColor(0,0,0)
    poacher.hrect = display.newRect(x+115,y+1,4,38)
    poacher.hrect:setFillColor(255,0,0)
    poacher.hide_hprects(0.0)

    poacher.speed = math.random(10,14)
    return poacher
end


--[[
    npc.loadPorcupine takes care of loading spritesheets, data,
    and initializing a porcupine.  The porcupine is placed at
    the passed coordinates.
    The function returns a porcupine object.
]]--
function npc.loadPorcupine(x, y)
    local porcupine = npc.load("MEDIA/ss_Porcupine.png",
        {
            {
                name = "walk",
                frames = {2, 3, 4, 5},
                time = 800,
                loopCount = 0,
                loopDirection = "forward"
            },
            {
                name = "die",
                frames = {14, 15},
                time = 800,
                loopCount = 1,
                loopDirection = "forward"
            }
        },
        {
            width = 82,
            height = 42,
            numFrames = 15,
            sheetContentWidth = 246,
            sheetcontentHeight = 210
        },
        x, y,
        "porcupine"
        )
    --[[
        porcupine.moveRight moves the porcupine right (currently not used).
    ]]--
    porcupine.moveRight = function()
                            if (porcupine.visual.xScale == 1) then
                                porcupine.visual.xScale = -1
                                porcupine.visual.x = porcupine.visual.x + 40
                            end
                            porcupine.visual.x = porcupine.visual.x + porcupine.speed
                            porcupine.get_rect()
                            porcupine.get_hprects()

                        end
    --[[
        porcupine.moveLeft moves the porcupine left and detects when the
        porcupine is offscreen.  At this point, character health is
        decreased.
    ]]--
    porcupine.moveLeft = function()
                            if (porcupine.visual.xScale == -1) then
                                porcupine.visual.xScale = 1
                                porcupine.visual.x = porcupine.visual.x - 40
                            end
                            porcupine.visual.x = porcupine.visual.x - porcupine.speed
                            porcupine.get_rect()
                            porcupine.get_hprects()
                            if (porcupine.visual.x - (mapoffset - porcupine.visual.width)) < 0 then
                                porcupine.stop = true
                                character.health = character.health - 5
                                update_health(character.health/character.mhealth)
                                npc.remove(porcupine)
                            end
                       end
    --[[
        porcupine.attack (not implemented)
    ]]--
    porcupine.attack = function()
                        print "Porcupine says pew."
                     end

    --[[
        porcupine.get_rect returns the rect representing the porcupine's
        hitbox.  The rect is first updated according to porcupine position.
    ]]--
    porcupine.get_rect = function()
        if (porcupine.visual.xScale == 1) then
            porcupine.rect.x = porcupine.visual.x - mapoffset + 20 - porcupine.visual.width/2
            porcupine.rect.y = porcupine.visual.y - porcupine.visual.height/2
        elseif (porcupine.visual.xScale == -1) then
            porcupine.rect.x = porcupine.visual.x - mapoffset - 20 + porcupine.visual.width/2
            porcupine.rect.y = porcupine.visual.y - porcupine.visual.height/2
        end

        return porcupine.rect
    end

    --[[
        porcupine.get_hprects returns the rects forming the hp bar for a
        porcupine.  The rects are first updated according to the porcupine's
        position and amount of health.
    ]]--
    porcupine.get_hprects = function()
        porcupine.hbrect:setReferencePoint(display.TopCenterReferencePoint)
        porcupine.hrect:setReferencePoint(display.TopCenterReferencePoint)
        porcupine.hbrect.x = porcupine.visual.x - mapoffset + porcupine.visual.xScale * 59
        porcupine.hrect.x = porcupine.visual.x - mapoffset + porcupine.visual.xScale * 60
        porcupine.hbrect.y = porcupine.visual.y - 25

        local hrecth = math.floor(porcupine.health/porcupine.mhealth * 36)
        porcupine.hrect.height = hrecth
        if (hrecth <= 0) then
            porcupine.screwup = true
            end
        porcupine.hrect.y = porcupine.visual.y + 1 + (36-hrecth) - 25


        return hbrect,hrect
    end

    --[[
        porcupine.hide_hprects sets the alpha value of the porcupine's hp_rects
        to the passed value.
    ]]--
    porcupine.hide_hprects = function(alpha)
        porcupine.hbrect.alpha = alpha
        if porcupine.screwup then
            porcupine.hrect.alpha = 0
        else
            porcupine.hrect.alpha = alpha
        end
    end

    --[[
        delay_fadeout fades the hp_rects of the porcupine after a set delay.
    ]]--
    porcupine.delay_fadeout = function()
        porcupine.dtimer = timer.performWithDelay(800, porcupine.fadeout_hprects, 1)
    end

    --[[
        porcupine.fadeout_hprects fades the hp_rects of the porcupine gradually.
    ]]--
    porcupine.fadeout_hprects = function()
        local alpha = porcupine.hrect.alpha - 0.2
        if alpha >= 0 then
            porcupine.hide_hprects(alpha)
            porcupine.dtimer = timer.performWithDelay(40, porcupine.fadeout_hprects, 1)
        else
            porcupine.hide_hprects(0)
            porcupine.dtimer = nil
        end
    end

    --[[
        porcupine.adjust_health adds the specified amt to the porcupine's
        health.  Upon adjusting health, the health bars are unhidden
        and then faded after a delay.
    ]]--
    porcupine.adjust_health = function(amt)
        print (amt)
        porcupine.health = porcupine.health + amt
        if porcupine.health <= 0 and not porcupine.dying then
            if not porcupine.dtimer == nil then timer.cancel(porcupine.dtimer) end
            porcupine.get_hprects()
            porcupine.delay_fadeout()
            porcupine.dying = true
            porcupine.stop = true
            porcupine.health = 0
            porcupine.visual:setSequence("die")
            porcupine.visual:play()
            local closure = function () return npc.delay_death(porcupine) end
            timer.performWithDelay(400, closure, 1)
        end
        return porcupine.health
    end

    local colfilter = {categoryBits = 16, maskBits = 1}
    physics.addBody(porcupine.visual, {filter = colfilter, friction = 1.0, bounce = 0, })
    porcupine.visual:setSequence("walk")
    porcupine.visual:play()


    porcupine.rect = display.newRect(x+20, y-10, 62, 52)
    porcupine.rect:setReferencePoint(display.TopLeftReferencePoint)
    porcupine.rect:setFillColor(255,255,255,hb_col)

    porcupine.health = 30.0
    porcupine.mhealth = 30.0
    porcupine.screwup = false

    porcupine.hbrect = display.newRect(x+86,y,6,40)
    porcupine.hbrect:setFillColor(0,0,0)
    porcupine.hrect = display.newRect(x+87,y+1,4,38)
    porcupine.hrect:setFillColor(255,0,0)
    porcupine.hide_hprects(0.0)


    porcupine.speed = math.random(16,20)
    return porcupine
end


--[[
    npc.load takes care of the generic methods for loading
    an npc.  The function returns a data object.
]]--
function npc.load(path, sequenceData, sheetData, x, y, name)
	local data = {}
	local sheet = graphics.newImageSheet(path, sheetData)
	local visual = display.newSprite(sheet, sequenceData)

	visual.x = x
	visual.y = y
	visual.isFixedRotation = true

	data.visual = visual
	data.visual:play()
	data.name = name
    data.stop = true
    data.dying = false
    data.deathcount = 8

	return data
end

--[[
    npc.die causes the passed enemmy to blink and then be 'removed'.
]]--
function npc.die(enemy)
    if (enemy.deathcount == 0 or enemy.name == "boss") then
        npc.remove(enemy)
    else
        enemy.visual.alpha = enemy.deathcount % 2
        enemy.deathcount = enemy.deathcount - 1
        local closure = function () return npc.die(enemy) end
        timer.performWithDelay(60, closure)
    end
end

--[[
    npc.delay_death is used to allow the passed enemy's death
    animation to play.
]]--
function npc.delay_death(enemy)
    local closure = function () return npc.die(enemy) end
    timer.performWithDelay(60, closure)
end

--[[
    npc.remove removes as much of an enemy as possible.  The
    rest is to be removed after stopping physics.
]]--
function npc.remove(enemy)
    if enemy ~= nil then
        enemy.visual.alpha = 0
        enemy.hide_hprects(0.0)
    end
end

return npc
