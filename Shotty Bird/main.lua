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

	if (zPosition == 4) then
		bird:scale(0.6, 0.6)
		zLayer4:insert(bird)
	elseif (zPosition == 3) then
		bird:scale(0.45, 0.45)
		zLayer3:insert(bird)
	elseif (zPosition == 2) then
		bird:scale(0.35, 0.35)
		zLayer2:insert(bird)
	elseif (zPosition == 1) then
		bird:scale(0.2, 0.2)
		zLayer1:insert(bird)
	end

	bird.x = display.contentWidth + bird.contentWidth / 2
	bird.y = math.random(20 + bird.contentHeight / 2, display.contentHeight - bird.contentHeight)

	local function removeBird()
		-- TODO: play sound
		bird:removeSelf()
	end

	local speed = math.random(2, 5)
	transition.to(bird, { time = speed * 1000, x = -(bird.contentWidth / 2), y = bird.y, onComplete = removeBird })
end

local function update(event)
	local timeSinceLast = event.time - lastUpdateTime
	lastUpdateTime = system.getTimer()

	if (timeSinceLast > 1000) then
		timeSinceLast = 1 / 60 * 1000
	end

	lastSpawnTime = lastSpawnTime + timeSinceLast

	if (lastSpawnTime > 650) then
		spawnBird()
		lastSpawnTime = 0.0
	end
end

Runtime:addEventListener("enterFrame", update)
