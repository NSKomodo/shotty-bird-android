-----------------------------------------------------------------------------------------
--
-- config.lua
-- Shotty Bird
--
-- Created by Jorge Tapia on 6/06/16.
-- Copyright © 2016 Shotty Bird. All rights reserved.
--
-----------------------------------------------------------------------------------------

--[[
local dpi = system.getInfo("androidDisplayApproximateDpi")
local targetFPS = 60

if dpi and dpi < 320 then
    targetFPS = 30
end
]]--

application = {
    content = {
        width = 768,
        height = 1024,
        scale = "adaptive",
        fps = 60,
        audioPlayFrequency = 44100,

        imageSuffix =
        {
            ["@2x"] = 1.5,
            ["@3x"] = 3.0,
        },
    },
}
