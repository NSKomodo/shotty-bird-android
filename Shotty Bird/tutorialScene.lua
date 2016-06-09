-----------------------------------------------------------------------------------------
--
-- tutorialScene.lua
-- Shotty Bird
--
-- Created by Jorge Tapia on 6/09/16.
-- Copyright © 2016 Shotty Bird. All rights reserved.
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local parallax = require("parallax")
 
local tutorialSheetInfo = require("tutorialSheet")
local tutorialImageSheet = graphics.newImageSheet("assets/tutorial/tutorialSheet.png", tutorialSheetInfo:getSheet())
local sequence_tutorial = {
	{
		name = "tutorial",
		start = 1,
		count = 5,
		time = 2200,
		loopCount = 0,
		loopDirection = "forward"
	}
}
local tutorial = display.newSprite(tutorialImageSheet, sequence_tutorial)

local sounds = {
	explosion = audio.loadSound("sounds/explosion.mp3")
}

local function gotoGame(event)
	if event.completed then
		composer.gotoScene("gameScene", { effect = "crossFade", time = 300, params = { parallaxIndex = parallax.currentIndex } })
		composer.removeScene("tutorialScene")
	end
end

local function handleTap(tap)
	Runtime:removeEventListener("tap", handleTap)
	audio.play(sounds["explosion"], { onComplete = gotoGame })
end
 
-- "scene:create()"
function scene:create(event)
	local sceneGroup = self.view
   	local params = event.params
   	local parallaxIndex = params.parallaxIndex

   	parallax.init(sceneGroup, false, parallaxIndex)
   	parallax.start()

	tutorial:scale(0.5, 0.5)
	tutorial.x = display.contentWidth / 2
	tutorial.y = display.contentHeight / 2
	sceneGroup:insert(tutorial)
end
 
-- "scene:show()"
function scene:show(event)
	local sceneGroup = self.view
   	local phase = event.phase
 
	if ( phase == "did" ) then
		tutorial:play()
		Runtime:addEventListener("tap", handleTap)
	end
end
 
-- "scene:hide()"
function scene:hide(event)
	local sceneGroup = self.view
end
 
-- "scene:destroy()"
function scene:destroy(event)
	local sceneGroup = self.view
	sceneGroup:remove(tutorial)

 	audio.stop()

	for s, v in pairs(sounds) do
	   audio.dispose(sounds[s])
	   sounds[s] = nil
	end
end
 
---------------------------------------------------------------------------------
 
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
---------------------------------------------------------------------------------
 
return scene
