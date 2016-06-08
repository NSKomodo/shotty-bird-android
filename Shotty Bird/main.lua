-----------------------------------------------------------------------------------------
--
-- main.lua
-- Shotty Bird
--
-- Created by Jorge Tapia on 6/06/16.
-- Copyright © 2016 Shotty Bird. All rights reserved.
--
-----------------------------------------------------------------------------------------

display.setDefault("background", 1, 1, 1)

local parallax = require("parallax")
parallax.init(true)
parallax.start()

local zLayer0 = display.newGroup()
local zLayer1 = display.newGroup()
local zLayer2 = display.newGroup()
local zLayer3 = display.newGroup()
local zLayer4 = display.newGroup()
local zLayer5 = display.newGroup()

local lastUpdateTime = 0.0
local lastSpawnTime = 0.0
local lastShotFiredTime = 0.0

local score = 0

local function spawnBird()
	math.randomseed(os.time())
	local zPosition = math.random(1, 4)

	-- TODO: implement as sprites
	local bird = display.newImage("assets/birds/yellow_fat_bird/yellow_fat_bird_1.png")
	bird.zPosition = zPosition
	bird.name = "bird"

	if zPosition == 4 then
		bird:scale(0.6, 0.6)
		zLayer4:insert(bird)
	elseif zPosition == 3 then
		bird:scale(0.45, 0.45)
		zLayer3:insert(bird)
	elseif zPosition == 2 then
		bird:scale(0.35, 0.35)
		zLayer2:insert(bird)
	elseif zPosition == 1 then
		bird:scale(0.2, 0.2)
		zLayer1:insert(bird)
	end

	bird.x = display.contentWidth + bird.contentWidth / 2
	bird.y = math.random(20 + bird.contentHeight / 2, display.contentHeight - bird.contentHeight)

	local function removeBird(bird)
		bird:removeSelf()
		bird = nil
	end

	local speed = math.random(2, 5)
	transition.to(bird, { time = speed * 1000, x = -(bird.contentWidth / 2), y = bird.y, onComplete = removeBird })
end

local function update(event)
	local timeSinceLast = event.time - lastUpdateTime
	lastUpdateTime = system.getTimer()

	if timeSinceLast > 1000 then
		timeSinceLast = 1 / 60 * 1000
	end

	lastSpawnTime = lastSpawnTime + timeSinceLast

	if lastSpawnTime > 1000 then
		spawnBird()
		lastSpawnTime = 0.0
	end
end

local function hasCollided( obj1, obj2 )
    if obj1 == nil or obj2 == nil then
        return false
    end

    local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
    local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
    local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
    local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
 
    return (left or right) and (up or down)
end

local function validateCollision(missile)
	missile.zPosition = missile.zPosition - 1

	if missile.zPosition == -4 then
		missile:removeSelf()
		return
	else
		local xScale = missile.xScale - 0.1
		local yScale = missile.yScale - 0.1

		if xScale > 0 and yScale > 0 then
			if missile.zPosition == 4 then
				zLayer5:remove(missile)
				zLayer4:insert(missile)

				for i = 1, zLayer4.numChildren do
					if zLayer4[i].name == "bird" then
						if hasCollided(missile, zLayer4[i]) then
							missile:removeSelf()
							transition.cancel(zLayer4[i])
							zLayer4[i]:removeSelf()
							return
						end
					end
				end
			elseif missile.zPosition == 3 then
				zLayer4:remove(missile)
				zLayer3:insert(missile)

				for i = 1, zLayer3.numChildren do
					if zLayer3[i].name == "bird" then
						if hasCollided(missile, zLayer3[i]) then
							missile:removeSelf()
							transition.cancel(zLayer3[i])
							zLayer3[i]:removeSelf()
							return
						end
					end
				end
			elseif missile.zPosition == 2 then
				zLayer3:remove(missile)
				zLayer2:insert(missile)

				for i = 1, zLayer2.numChildren do
					if zLayer2[i].name == "bird" then
						if hasCollided(missile, zLayer2[i]) then
							missile:removeSelf()
							transition.cancel(zLayer2[i])
							zLayer2[i]:removeSelf()
							return
						end
					end
				end
			elseif missile.zPosition == 1 then
				zLayer2:remove(missile)
				zLayer1:insert(missile)

				for i = 1, zLayer1.numChildren do
					if zLayer1[i].name == "bird" then
						if hasCollided(missile, zLayer1[i]) then
							missile:removeSelf()
							transition.cancel(zLayer1[i])
							zLayer1[i]:removeSelf()
							return
						end
					end
				end
			else
				zLayer1:remove(missile)
				zLayer0:insert(missile)
			end

			transition.to(missile, { time = 100, xScale = xScale, yScale = yScale, onComplete = validateCollision })
		else
			missile:removeSelf()
			return
		end
	end
end


local function shoot(tap)
	-- TODO: prevent missile spamming and add sounds
	local missile = display.newImage("assets/missile/missile_1.png")
	missile.x = tap.x
	missile.y = tap.y
	missile.zPosition = 5
	missile.name = "missile"
	missile:scale(0.6, 0.6)
	zLayer5:insert(missile)

	transition.to(missile, { time = 200, xScale = 0.5, yScale = 0.5, onComplete = validateCollision })
end

Runtime:addEventListener("enterFrame", update)
Runtime:addEventListener("tap", shoot)
