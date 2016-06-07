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

--[[
-- In pixels
local maxSpeed = 2.0 -- pixels per frame

local function scroll(self, event)
	if (self.x < self.contentWidth) then
		self.x = self.x + self.speed
	else
		self.x = -(self.contentWidth - 3)
	end
end

local layer = display.newImageRect("assets/bgs/bg1/bg1_layer1.png", display.contentWidth * 2, display.contentHeight * 2)
layer.x = layer.width / 2
layer.enterFrame = scroll
layer.speed = maxSpeed

local layerClone = display.newImageRect("assets/bgs/bg1/bg1_layer1.png", display.contentWidth * 2, display.contentHeight * 2)
layerClone.x = -layer.x
layerClone.enterFrame = scroll
layerClone.speed = maxSpeed

Runtime:addEventListener("enterFrame", layer)
Runtime:addEventListener("enterFrame", layerClone)
]]--

--[[]]--
local parallax = require("parallax")
display.setDefault("background", 1, 1, 1)

parallax.init({ "assets/bgs/bg1/bg1_layer5.png", "assets/bgs/bg1/bg1_layer4.png", "assets/bgs/bg1/bg1_layer3.png", "assets/bgs/bg1/bg1_layer2.png", "assets/bgs/bg1/bg1_layer1.png" }, false)
parallax.start()

