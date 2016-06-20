-----------------------------------------------------------------------------------------
--
-- admob.lua
-- Shotty Bird
--
-- Created by Jorge Tapia on 6/19/16.
-- Copyright © 2016 Shotty Bird. All rights reserved.
--
-----------------------------------------------------------------------------------------

local M = {}

-- AdMob
local instance = require("ads")
local adUnit = "ca-app-pub-5774553422556987/6814602958"
local adProvider = "admob"
local initialized = false

local function adListener(event)
	local msg = event.response
   	print("Message from the ads library: ", msg)
 
   	if (event.isError ) then
      	print("Error, no ad received", msg)
   	else
   		print("Ad loaded...")
   	end
end

function M.init()
	instance.init(adProvider, adUnit, adListener)
	initialized = true
end

function M.show()
	assert(initialized, "AdMob module not initialized. To initialize it call the init method.")
	instance.show("banner", { x = 0, y = display.contentHeight, testMode = false, appId = adUnit })
end

function M.hide()
	assert(initialized, "AdMob module not initialized. To initialize it call the init method.")
	instance.hide()
end

return M
