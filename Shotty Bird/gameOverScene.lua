-----------------------------------------------------------------------------------------
--
-- gameOverScene.lua
-- Shotty Bird
--
-- Created by Jorge Tapia on 6/09/16.
-- Copyright © 2016 Shotty Bird. All rights reserved.
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
 
local parallax = require("parallax")

local score = 0

local sounds = {
   gameOver = audio.loadSound("sounds/game_over_music.mp3"),
   bird = audio.loadSound("sounds/bird.mp3"),
   explosion = audio.loadSound("sounds/explosion.mp3"),
   screenshot = audio.loadSound("sounds/screenshot.mp3")
}

local gameOver = nil
local panel = nil
local scoreText = nil
local bestText = nil
local backButton = nil
local playButton = nil
local leaderboardButton = nil
local shareButton = nil

local strokeText = require("com.ponywolf.strokeText")
local textOptions = {
   text = "",
   x = display.contentCenterX + 5,
   y = display.contentCenterY,
   font = "assets/fonts/Kenney-Bold.ttf",
   fontSize = 40,
   align = "center",
   color = { 1,1,1,1 },
   strokeColor = { 0, 0, 0, 1 },
   strokeWidth = 3
}

local function handleBackButton(tap)
   local function gotoMainMenu(event)
      if event.completed then
         composer.gotoScene("mainMenuScene", { effect = "crossFade", time = 500 })
         composer.removeScene("gameOverScene")
      end
   end

   audio.play(sounds["bird"], { onComplete = gotoMainMenu })
end

local function handlePlayButton(tap)
   local function gotoGame(event)
      if event.completed then
         composer.gotoScene("gameScene", { effect = "crossFade", time = 500, params = { parallaxIndex = parallax.currentIndex } })
         composer.removeScene("gameOverScene")
      end
   end

   audio.play(sounds["explosion"], { onComplete = gotoGame })
end

local function handleShareButton(tap)
   local function share(event)
      if event.completed then
         local serviceName = tap.target.serviceName
         local isAvailable = native.canShowPopup( "social", serviceName )
       
         -- If it is possible to show the popup
         if isAvailable then
            local listener = {}
            function listener:popup( event )
               print( "name(" .. event.name .. ") type(" .. event.type .. ") action(" .. tostring(event.action) .. ") limitReached(" .. tostring(event.limitReached) .. ")" )       
            end

            local birdText = ""
            if score == 1 then
               birdText = "bird"
            else
               birdText = "birds"
            end

            -- Take screenshot
            os.remove(system.pathForFile("score.png", system.TemporaryDirectory))

            local sceneGroup = scene.view
            display.save(sceneGroup, { filename = "score.png", baseDir = system.TemporaryDirectory, isFullResolution = false })
       
            -- Show the popup
            native.showPopup( "social",
            {
               service = serviceName, -- The service key is ignored on Android.
               message = "I just shot down " .. score .. " " .. birdText .. " in @shottybird. Download now for FREE. #happyhunting",
               listener = listener,
               image = {
                  { filename = "score.png", baseDir = system.TemporaryDirectory }
               },
               url =
               { 
                  "https://play.google.com/store/apps/details?id=co.profapps.shottybird"
               }
            })
         else
            native.showAlert( "Cannot send " .. serviceName .. " message.", "Please setup your " .. serviceName .. " account or check your network connection.", { "Dismiss" } )
         end
      end
   end

   audio.play(sounds["screenshot"], { onComplete = share })
end

-- "scene:create()"
function scene:create(event)
   local sceneGroup = self.view
 
   local params = event.params
   local parallaxIndex = params.parallaxIndex
   score = params.score

   parallax.init(sceneGroup, false, parallaxIndex)
   
   panel = display.newImage("assets/game_over/score_panel.png")
   panel:scale(0.4, 0.3)
   panel.x = display.contentCenterX
   panel.y = display.contentCenterY
   sceneGroup:insert(panel)

   scoreText = strokeText.new(textOptions)
   scoreText:update(tostring(score))
   sceneGroup:insert(scoreText)

   -- TODO: validate best score, new record and 0
   bestText = display.newText("", display.contentCenterX + 2, display.contentCenterY + 42, "assets/fonts/Kenney-Bold.ttf", 9)
   bestText:setFillColor(205 / 255, 164 / 255, 0)
   sceneGroup:insert(bestText)

   if score == 0 then
      bestText.text = "Time your shots and try again"
   else
      bestText.text = "Your best is " .. score
   end

   gameOver = display.newImage("assets/game_over/game_over.png", display.contentCenterX, panel.contentHeight / 2 + 20)
   gameOver:scale(0.4, 0.4)
   sceneGroup:insert(gameOver)

   leaderboardButton = display.newImage("assets/game_over/leaderboard_button_icon.png", display.contentCenterX, panel.y + panel.contentHeight / 2 + 22)
   leaderboardButton.x = leaderboardButton.x + leaderboardButton.contentWidth / 4 + 1.25
   leaderboardButton:scale(0.5, 0.5)
   sceneGroup:insert(leaderboardButton)

   playButton = display.newImage("assets/game_over/replay_button.png", leaderboardButton.x - leaderboardButton.width / 2 - 5, leaderboardButton.y)
   playButton:scale(0.5, 0.5)
   playButton:addEventListener("tap", handlePlayButton)
   sceneGroup:insert(playButton)

   backButton = display.newImage("assets/back_button.png", playButton.x - playButton.width / 2 - 5, leaderboardButton.y)
   backButton:scale(0.5, 0.5)
   backButton:addEventListener("tap", handleBackButton)
   sceneGroup:insert(backButton)

   shareButton = display.newImage("assets/game_over/share_button.png", leaderboardButton.x + leaderboardButton.width / 2 + 5, leaderboardButton.y)
   shareButton:scale(0.5, 0.5)
   shareButton.serviceName = "share"
   shareButton:addEventListener("tap", handleShareButton)
   sceneGroup:insert(shareButton)
end
 
-- "scene:show()"
function scene:show(event)
   local sceneGroup = self.view
   local phase = event.phase
 
   if phase == "did" then
      audio.play(sounds["gameOver"])
      parallax.start()
   end
end
 
-- "scene:hide()"
function scene:hide(event)
   local sceneGroup = self.view
end
 
-- "scene:destroy()"
function scene:destroy(event)
   local sceneGroup = self.view

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
