-----------------------------------------------------------------------------------------
--
-- mainMenuScene.lua
-- Shotty Bird
--
-- Created by Jorge Tapia on 6/08/16.
-- Copyright © 2016 Shotty Bird. All rights reserved.
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local scene = composer.newScene()

local parallax = require("parallax")
local zLayer0 = display.newGroup()

local mute = false
local music = audio.loadStream("sounds/menu_music.mp3")
local sounds = {
   bird = audio.loadSound("sounds/bird.mp3")
}

local logo
local playButton
local leaderboardButton
local creditsButton
local twitterButton
local facebookButton
local unmuteButton
local muteButton

local function handlePlayButton(tap)
   composer.gotoScene("gameScene", { effect = "fade", time = 300, params = { muteValue = mute, parallaxIndex = parallax.currentIndex } })
end

local function handleLeaderboardButton(tap)
   audio.play(sounds["bird"])
   print("Go to leaderboard....")
end

local function handleCreditsButton(tap)
   audio.play(sounds["bird"])
   print("Go to credits....")
end

local function handleTwitterButton(tap)
   audio.play(sounds["bird"])
   print("Go to Twitter....")
end

local function handleFacebookButton(tap)
   audio.play(sounds["bird"])
   print("Go to Facebook....")
end

local function handleMuteButton(tap)
   audio.setVolume(0.0)
   muteButton.isVisible = false
   unmuteButton.isVisible = true
   mute = true
end

local function handleUnmuteButton(tap)
   audio.setVolume(1.0)
   unmuteButton.isVisible = false
   muteButton.isVisible = true
   mute = false
end

-- "scene:create()"
function scene:create( event )
   local sceneGroup = self.view

   parallax.init(sceneGroup, false)
   sceneGroup:insert(zLayer0)

   logo = display.newImage("assets/main_menu/logo.png")
   logo:scale(0.35, 0.35)
   logo.x = display.contentWidth / 2
   logo.y = 20 + logo.contentHeight / 2
   zLayer0:insert(logo)

   playButton = display.newImage("assets/main_menu/play_button.png")
   playButton:scale(0.35, 0.35)
   playButton.x = display.contentWidth / 2
   playButton.y = display.contentHeight / 2
   playButton:addEventListener("tap", handlePlayButton)
   zLayer0:insert(playButton)

   leaderboardButton = display.newImage("assets/main_menu/leaderboard_button.png")
   leaderboardButton:scale(0.35, 0.35)
   leaderboardButton.x = display.contentWidth / 2
   leaderboardButton.y =  5 + playButton.y + leaderboardButton.contentHeight
   leaderboardButton:addEventListener("tap", handleLeaderboardButton)
   zLayer0:insert(leaderboardButton)

   creditsButton = display.newImage("assets/main_menu/credits_button.png")
   creditsButton:scale(0.35, 0.35)
   creditsButton.x = display.contentWidth / 2
   creditsButton.y =  5 + leaderboardButton.y + creditsButton.contentHeight
   creditsButton:addEventListener("tap", handleCreditsButton)
   zLayer0:insert(creditsButton)

   twitterButton = display.newImage("assets/twitter_button.png")
   twitterButton:scale(0.35, 0.35)
   twitterButton.x = 25
   twitterButton.y = display.contentHeight - 20
   twitterButton:addEventListener("tap", handleTwitterButton)
   zLayer0:insert(twitterButton)

   facebookButton = display.newImage("assets/facebook_button.png")
   facebookButton:scale(0.35, 0.35)
   facebookButton.x = 10 + twitterButton.x + facebookButton.contentWidth
   facebookButton.y = twitterButton.y
   facebookButton:addEventListener("tap", handleFacebookButton)
   zLayer0:insert(facebookButton)

   unmuteButton = display.newImage("assets/unmute_button.png")
   unmuteButton:scale(0.35, 0.35)
   unmuteButton.x = display.contentWidth - 25
   unmuteButton.y = twitterButton.y
   unmuteButton:addEventListener("tap", handleUnmuteButton)
   unmuteButton.isVisible = false
   zLayer0:insert(unmuteButton) 
   
   muteButton = display.newImage("assets/mute_button.png")
   muteButton:scale(0.35, 0.35)
   muteButton.x = unmuteButton.x
   muteButton.y = unmuteButton.y
   muteButton:addEventListener("tap", handleMuteButton)
   zLayer0:insert(muteButton)
end

-- "scene:show()"
function scene:show( event )
   local sceneGroup = self.view
   local phase = event.phase

   if phase == "did" then
      parallax.start()
      audio.play(music, { loops = -1 })
   end
end

-- "scene:hide()"
function scene:hide( event )
   local sceneGroup = self.view
   local phase = event.phase

   if phase == "will" then
      audio.stop()
   elseif phase == "did" then
      -- Called immediately after scene goes off screen.
   end
end

-- "scene:destroy()"
function scene:destroy( event )
   local sceneGroup = self.view
   sceneGroup:remove(zLayer0)
   
   zLayer0 = nil
   audio.stop()
   parallax.stop()

   for s, v in pairs(sounds) do
       audio.dispose(sounds[s])
       sounds[s] = nil
   end

   audio.dispose(music)
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
