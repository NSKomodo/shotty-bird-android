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

local composer = require("composer")
local options = {
   effect = "fade",
   time = 500
}

composer.gotoScene("gameScene", options)
