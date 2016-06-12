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
   itsprof:scale(0.4, 0.4)
   itsprof.x = display.contentCenterX
   itsprof.y = itsprof.height / 2 - 30
   itsprof:addEventListener("tap", handleProf)
   sceneGroup:insert(itsprof)

   jpalbuja = display.newImage("assets/credits/jpalbuja.png")
   jpalbuja:scale(0.4, 0.4)
   jpalbuja.x = display.contentCenterX
   jpalbuja.y = itsprof.y + jpalbuja.height / 2
   jpalbuja:addEventListener("tap", handleJP)
   sceneGroup:insert(jpalbuja)

   backButton = display.newImage("assets/back_button.png")
   backButton:scale(0.5, 0.5)
   backButton.x = 25
   backButton.y = display.contentHeight - 25
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
