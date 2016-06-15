-----------------------------------------------------------------------------------------
--
-- gpgs.lua
-- Shotty Bird
--
-- Created by Jorge Tapia on 6/15/16.
-- Copyright © 2016 Shotty Bird. All rights reserved.
--
-----------------------------------------------------------------------------------------

local M = {}

M.gameNetwork = require("gameNetwork")
M.playerName = nil
M.highestScore = 0

local function scoresListener(event)
	if event then
		if event.data and event.data[1] and event.data[1].value then
			M.highestScore = event.data[1].value
			print(M.playerName .. "'s highest score is: " .. M.highestScore)
		end
	end
end
 
local function loadLocalPlayerCallback(event)
   	M.playerName = event.data.alias
   	print("Logged in to Google Play Games as " .. M.playerName)
   
   	M.gameNetwork.request("loadScores",
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
   M.gameNetwork.request("loadLocalPlayer", { listener = loadLocalPlayerCallback })
   return true
end
 
local function gpgsInitCallback(event)
   M.gameNetwork.request("login", { userInitiated = true, listener = gameNetworkLoginCallback })
end
 
function M.gameNetworkSetup()
   M.gameNetwork.init("google", gpgsInitCallback)
end

return M
