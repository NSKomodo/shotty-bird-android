-----------------------------------------------------------------------------------------
--
-- credistScene.lua
-- Shotty Bird
--
-- Created by Jorge Tapia on 6/09/16.
-- Copyright © 2016 Shotty Bird. All rights reserved.
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local scene = composer.newScene()

local parallax = require("parallax")

local itsprof = nil
local jpalbuja = nil
local backButton = nil

local sounds = {
   bird = audio.loadSound("sounds/bird.mp3")
}

local function handleProf(tap)
   system.openURL("http://twitter.com/itsProf")
end

local function handleJP(tap)
   system.openURL("http://twitter.com/jpalbuja")
end

local function handleBackButton(tap)
   local function gotoMainMenu(event)
      if event.completed then
         composer.gotoScene("mainMenuScene", { effect = "slideDown", time = 500 })
         composer.removeScene("creditsScene")
      end
   end

   audio.play(sounds["bird"], { onComplete = gotoMainMenu })
end

-- "scene:create()"
function scene:create( event )
   local sceneGroup = self.view

   local params = event.params
   local parallaxIndex = params.parallaxIndex

   parallax.init(sceneGroup, false, parallaxIndex)
   parallax.start()

   itsprof = display.newImage("assets/credits/itsprof.png")
   itsprof:scale(0.5, 0.5)
   itsprof.x = display.contentCenterX
   itsprof.y = display.contentCenterY - itsprof.height / 4 - 15
   itsprof:addEventListener("tap", handleProf)
   sceneGroup:insert(itsprof)

   jpalbuja = display.newImage("assets/credits/jpalbuja.png")
   jpalbuja:scale(0.5, 0.5)
   jpalbuja.x = display.contentCenterX
   jpalbuja.y = display.contentCenterY + jpalbuja.height / 4 + 15
   jpalbuja:addEventListener("tap", handleJP)
   sceneGroup:insert(jpalbuja)

   backButton = display.newImage("assets/back_button.png")
   backButton:scale(0.6, 0.6)
   backButton.x = 30
   backButton.y = display.contentHeight - 30
   backButton:addEventListener("tap", handleBackButton)
   sceneGroup:insert(backButton)
end
 
-- "scene:show()"
function scene:show(event)
   local sceneGroup = self.view
end
 
-- "scene:hide()"
function scene:hide(event)
   local sceneGroup = self.view
end
 
-- "scene:destroy()"
function scene:destroy(event)
   local sceneGroup = self.view
   sceneGroup:remove(itsprof)
   sceneGroup:remove(jpalbuja)
   sceneGroup:remove(backButton)

   itsprof = nil
   jpalbuja = nil
   backButton = nil

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
