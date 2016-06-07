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

local bg1 = { "assets/bgs/bg1/bg1_layer5.png", "assets/bgs/bg1/bg1_layer4.png", "assets/bgs/bg1/bg1_layer3.png", "assets/bgs/bg1/bg1_layer2.png", "assets/bgs/bg1/bg1_layer1.png" }

local parallax = require("parallax")
parallax.init(bg1, true)
parallax.start()
