-----------------------------------------------------------------------------------------
--
-- main.lua
-- Shotty Bird
--
-- Created by Jorge Tapia on 6/06/16.
-- Copyright © 2016 Shotty Bird. All rights reserved.
--
-----------------------------------------------------------------------------------------

gameNetwork = require("gameNetwork")
playerName = nil
highestScore = 0

local function scoresListener(event)
	if event then
		if event.data and event.data[1] and event.data[1].value then
			highestScore = event.data[1].value
			print(playerName .. "'s highest score is: " .. highestScore)
		end
	end
end
 
local function loadLocalPlayerCallback(event)
   	playerName = event.data.alias
   	print("Logged in to Google Play Games as " .. playerName)
   
   	gameNetwork.request("loadScores",
   	{
   		leaderboard =
		{
			category = "CgkI_7aYvaIVEAIQAQ",
			playerScope = "FriendsOnly",
			timeScope = "AllTime",
			range = { 1, 1 },
			playerCentered = true
		},
		listener = scoresListener
	})
end
 
local function gameNetworkLoginCallback(event)
   gameNetwork.request("loadLocalPlayer", { listener = loadLocalPlayerCallback })
   return true
end
 
local function gpgsInitCallback(event)
   gameNetwork.request("login", { userInitiated = true, listener = gameNetworkLoginCallback })
end
 
local function gameNetworkSetup()
   gameNetwork.init("google", gpgsInitCallback)
end

------ HANDLE SYSTEM EVENTS ------
local function systemEvents(event)
	if event.type == "applicationStart" then
      	gameNetworkSetup()
  	elseif event.type == "applicationResume" then
  		gameNetworkSetup()
   	end

   	return true
end

Runtime:addEventListener("system", systemEvents)

-- Start at Main Menu scene
local composer = require("composer")
composer.gotoScene("mainMenuScene", { effect = "fade", time = 500 })
