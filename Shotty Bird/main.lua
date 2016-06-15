-----------------------------------------------------------------------------------------
--
-- main.lua
-- Shotty Bird
--
-- Created by Jorge Tapia on 6/06/16.
-- Copyright © 2016 Shotty Bird. All rights reserved.
--
-----------------------------------------------------------------------------------------

gpgs = require("gpgs")

------ HANDLE SYSTEM EVENTS ------
local function systemEvents(event)
	if event.type == "applicationStart" then
      	gpgs.gameNetworkSetup()
  	elseif event.type == "applicationResume" then
  		gpgs.gameNetworkSetup()
   	end

   	return true
end

Runtime:addEventListener("system", systemEvents)

-- Start at Main Menu scene
local composer = require("composer")
composer.gotoScene("mainMenuScene", { effect = "fade", time = 500 })
