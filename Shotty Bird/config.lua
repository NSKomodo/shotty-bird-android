-----------------------------------------------------------------------------------------
--
-- config.lua
-- Shotty Bird
--
-- Created by Jorge Tapia on 6/06/16.
-- Copyright © 2016 Shotty Bird. All rights reserved.
--
-----------------------------------------------------------------------------------------

local aspectRatio = display.pixelHeight / display.pixelWidth
 
application = {
   content = {
      width = aspectRatio > 1.5 and 320 or math.floor(480 / aspectRatio),
      height = aspectRatio < 1.5 and 480 or math.floor(320 * aspectRatio),
      scale = "letterBox",
      fps = 60,
      audioPlayFrequency = 44100,
   },
}
