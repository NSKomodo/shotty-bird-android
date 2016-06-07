-----------------------------------------------------------------------------------------
--
-- parallax.lua
-- Shotty Bird
--
-- Created by Jorge Tapia on 6/07/16.
-- Copyright © 2016 Shotty Bird. All rights reserved.
--
-----------------------------------------------------------------------------------------
local P = {}
P.ready = false

local gameSpeed = 14.0
local menuSpeed = 2.0
local gameplay = false

local function scroll(layer, event)
	if (layer.x < layer.contentWidth) then
		layer.x = layer.x + layer.speed
	else
		if (gameplay) then
			-- TODO: compensate for gameplay speeds
		else
			layer.x = -(layer.contentWidth - 3)
		end
	end
end

local layer1 = {}
local layer1Clone = {}

local layer2 = {}
local layer2Clone = {}

local layer3 = {}
local layer3Clone = {}

local layer4 = {}
local layer4Clone = {}

local layer5 = {}
local layer5Clone = {}

function P.init(layers, forGameplay)
	if (#layers ~= 5) then
		print("The layers table must contain exactly 5 elements.")
		return
	else
		gameplay = forGameplay
		
		local speed5 = 0.0
		local speed4 = 0.0
		local speed3 = 0.0
		local speed2 = 0.0
		local speed1 = 0.0

		if (forGameplay) then
			speed5 = 1
			speed4 = 2
			speed3 = 6
			speed2 = 10
			speed1 = gameSpeed
		else
			speed5 = 0.1
			speed4 = 0.25
			speed3 = 0.75
			speed2 = 1.0
			speed1 = menuSpeed
		end

		layer5 = display.newImageRect(layers[1], display.contentWidth * 2, display.contentHeight * 2)
		layer5.x = layer5.width / 2
		layer5.enterFrame = scroll
		layer5.speed = speed5

		layer5Clone = display.newImageRect(layers[1], display.contentWidth * 2, display.contentHeight * 2)
		layer5Clone.x = -layer5.x
		layer5Clone.enterFrame = scroll
		layer5Clone.speed = speed5

		layer4 = display.newImageRect(layers[2], display.contentWidth * 2, display.contentHeight * 2)
		layer4.x = layer4.width / 2
		layer4.enterFrame = scroll
		layer4.speed = speed4

		layer4Clone = display.newImageRect(layers[2], display.contentWidth * 2, display.contentHeight * 2)
		layer4Clone.x = -layer4.x
		layer4Clone.enterFrame = scroll
		layer4Clone.speed = speed4

		layer3 = display.newImageRect(layers[3], display.contentWidth * 2, display.contentHeight * 2)
		layer3.x = layer3.width / 2
		layer3.enterFrame = scroll
		layer3.speed = speed3

		layer3Clone = display.newImageRect(layers[3], display.contentWidth * 2, display.contentHeight * 2)
		layer3Clone.x = -layer3.x
		layer3Clone.enterFrame = scroll
		layer3Clone.speed = speed3

		layer2 = display.newImageRect(layers[4], display.contentWidth * 2, display.contentHeight * 2)
		layer2.x = layer2.width / 2
		layer2.enterFrame = scroll
		layer2.speed = speed2

		layer2Clone = display.newImageRect(layers[4], display.contentWidth * 2, display.contentHeight * 2)
		layer2Clone.x = -layer2.x
		layer2Clone.enterFrame = scroll
		layer2Clone.speed = speed2

		layer1 = display.newImageRect(layers[5], display.contentWidth * 2, display.contentHeight * 2)
		layer1.x = layer1.width / 2
		layer1.enterFrame = scroll
		layer1.speed = speed1

		layer1Clone = display.newImageRect(layers[5], display.contentWidth * 2, display.contentHeight * 2)
		layer1Clone.x = -layer1.x
		layer1Clone.enterFrame = scroll
		layer1Clone.speed = speed1

		P.ready = true
	end
end
 
function P.start()
	if (P.ready) then
	    Runtime:addEventListener("enterFrame", layer1)
		Runtime:addEventListener("enterFrame", layer1Clone)

		Runtime:addEventListener("enterFrame", layer2)
		Runtime:addEventListener("enterFrame", layer2Clone)

		Runtime:addEventListener("enterFrame", layer3)
		Runtime:addEventListener("enterFrame", layer3Clone)

		Runtime:addEventListener("enterFrame", layer4)
		Runtime:addEventListener("enterFrame", layer4Clone)

		Runtime:addEventListener("enterFrame", layer5)
		Runtime:addEventListener("enterFrame", layer5Clone)
	else
		print("Parallax is not initialized")
	end
end

function P.stop()
	if (P.ready) then
		Runtime:removeEventListener("enterFrame", layer1)
		Runtime:removeEventListener("enterFrame", layer1Clone)
		
		Runtime:removeEventListener("enterFrame", layer2)
		Runtime:removeEventListener("enterFrame", layer2Clone)
		
		Runtime:removeEventListener("enterFrame", layer3)
		Runtime:removeEventListener("enterFrame", layer3Clone)
		
		Runtime:removeEventListener("enterFrame", layer4)
		Runtime:removeEventListener("enterFrame", layer4Clone)
		
		Runtime:removeEventListener("enterFrame", layer5)
		Runtime:removeEventListener("enterFrame", layer5Clone)

		layer1 = nil
		layer1Clone = nil
		
		layer2 = nil
		layer2Clone = nil
		
		layer3 = nil
		layer3Clone = nil
		
		layer4 = nil
		layer4Clone = nil
		
		layer5 = nil
		layer5Clone = nil

		P.ready = false
	else
		print("Parallax is not initialized")
	end
end
 
return P
