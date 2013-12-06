------------------------------------------------------------
--  artificialIntelligence.lua
--
--  Authors: Tyler Kramer and Eric Noble
--  Purpose: Provide intelligence for NPCs and Bosses.
------------------------------------------------------------
artificialIntelligence = {}

artificialIntelligence.enemies = {}
artificialIntelligence.isStarted = false

--[[
    doMovement causes a passed object to move to the left
    indefinitely.
]]--
local function doMovement(object, num, isMoveRight)
    isMoveRight = false
	if artificialIntelligence.isStarted and not object.stop then
		object.moveLeft()

		timer.performWithDelay(100, function() return doMovement(object, 20, false) end)

	end
end

--[[
    artificialIntelligence.add adds the passed object to a map
    of enemies and begins their movement.
]]--
function artificialIntelligence.add(object)
    object.stop = false
    if object.name == "boss" then
        object.bossFight()
    else
	   doMovement(object, 20, false)
    end
    table.insert(artificialIntelligence.enemies, object)

end

--[[
    artificialIntelligence.moveall moves all enemies a specified
    distance.
]]--
function artificialIntelligence.moveall(dst)
    for k,v in pairs(artificialIntelligence.enemies) do
            v.visual.x = v.visual.x + dst
    end
end

--[[
    artificialIntelligence.removeall removes all enemies and their
    rects from the screen.
]]--
function artificialIntelligence.removeall()
    for k,v in pairs(artificialIntelligence.enemies) do
        v.visual:removeSelf()
        v.visual = nil
        v.rect:removeSelf()
        v.rect = nil
        v.hrect:removeSelf()
        v.hrect = nil
        v.hbrect:removeSelf()
        v.hbrect = nil
    end
end

--[[
    artificialIntelligence.start starts the AI.
]]--
function artificialIntelligence.start()
	artificialIntelligence.isStarted = true
end

--[[
    artificialIntelligence.start stops the AI.
]]--
function artificialIntelligence.stop()
	artificialIntelligence.isStarted = false
end

return artificialIntelligence
