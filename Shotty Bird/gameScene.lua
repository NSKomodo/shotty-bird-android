-----------------------------------------------------------------------------------------
--
-- gameScene.lua
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
local zLayer1 = display.newGroup()
local zLayer2 = display.newGroup()
local zLayer3 = display.newGroup()
local zLayer4 = display.newGroup()
local zLayer5 = display.newGroup()
local zLayer6 = display.newGroup()

local strokeText = require("com.ponywolf.strokeText")
local textOptions = {
   text = "0",
   x = display.contentWidth - 10,
   y = 20,
   font = "assets/fonts/Kenney-Bold.ttf",
   fontSize = 17,
   align = "right",
   color = { 1,1,1,1 },
   strokeColor = { 0, 0, 0, 1 },
   strokeWidth = 1.5
}

local life1 = nil
local death1 = nil

local life2 = nil
local death2 = nil

local life3 = nil
local death3 = nil

local unmuteButton = nil
local muteButton = nil

local birdSheetInfo = require("birdSheet")
local birdImageSheet = graphics.newImageSheet("assets/birds/birdSheet.png", birdSheetInfo:getSheet())

local missileSheetInfo = require("missileSheet")
local missileImageSheet = graphics.newImageSheet("assets/missile/missileSheet.png", missileSheetInfo:getSheet())

local explosionSheetInfo = require("explosionSheet")
local explosionImageSheet = graphics.newImageSheet("assets/explosion/explosionSheet.png", explosionSheetInfo:getSheet())

local lastUpdateTime = 0.0
local lastSpawnTime = 0.0
local lastShotFiredTime = 0.0

local lives = 3
local score = 0

local mute = false
local music = audio.loadStream("sounds/gameplay_music.mp3")
local sounds = {
   bird = audio.loadSound("sounds/bird.mp3"),
   flap = audio.loadSound("sounds/wing_flap.mp3"),
   shot = audio.loadSound("sounds/shot.mp3"),
   explosion = audio.loadSound("sounds/explosion.mp3")
}

local function handleMuteButton(tap)
   audio.setVolume(0.0)
   muteButton.isVisible = false
   unmuteButton.isVisible = true
end

local function handleUnmuteButton(tap)
   audio.setVolume(1.0)
   unmuteButton.isVisible = false
   muteButton.isVisible = true
end

local function spawnBird()
   math.randomseed(system.getTimer())
   local zPosition = math.random(1, 4)

   local birds = { 1, 3, 5, 7, 9, 11 }
   local birdIndex = math.random(1, #birds)
   local randomBird = birds[birdIndex]

   local sequences_flyingBird = {
       {
           name = "fly",
           start = randomBird,
           count = 2,
           time = 200,
           loopCount = 0,
           loopDirection = "forward"
       }
   }

   local bird = display.newSprite(birdImageSheet, sequences_flyingBird)
   bird.zPosition = zPosition
   bird.name = "bird"

   if zPosition == 4 then
      bird:scale(0.5, 0.5)
      zLayer4:insert(bird)
   elseif zPosition == 3 then
      bird:scale(0.425, 0.425)
      zLayer3:insert(bird)
   elseif zPosition == 2 then
      bird:scale(0.325, 0.325)
      zLayer2:insert(bird)
   elseif zPosition == 1 then
      bird:scale(0.25, 0.25)
      zLayer1:insert(bird)
   end

   bird.x = display.contentWidth + bird.contentWidth / 2
   bird.y = math.random(20 + bird.contentHeight / 2, display.contentHeight - bird.contentHeight)
   bird:play()

   local function removeBird(bird)
      audio.play(sounds["bird"])
      bird:removeSelf()
      bird = nil

      lives = lives - 1

      if lives == 2 then
         life1.isVisible = false
         death1.isVisible = true
      elseif lives == 1 then
         life2.isVisible = false
         death2.isVisible = true
      end

      if lives == 0 then
         life3.isVisible = false
         death3.isVisible = true

         transition.cancel()
         composer.gotoScene("gameOverScene", { effect = "crossFade", time = 200, params = { parallaxIndex = parallax.currentIndex, score = score } })
         composer.removeScene("gameScene")
      end
   end

   local speed = math.random(2500, 4000)
   bird.speed = speed

   transition.to(bird, { time = speed, x = -(bird.contentWidth / 2), y = bird.y, onComplete = removeBird })
   audio.play(sounds["flap"])
end

local function hasCollided(obj1, obj2)
    if obj1 == nil or obj2 == nil then
        return false
    end

    local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
    local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
    local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
    local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
 
    return (left or right) and (up or down)
end

local function handleExplosion(event)
   if event.phase == "ended" then
      event.target:removeSelf()
      event.target = nil
   end
end

local function explode(xPos, yPos, xScale, yScale, zLayer)
   local sequences_explosion = {
      {
        name = "explode",
        frames = { 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3, 4 },
        time = 350,
        loopCount = 1
      }
   }

   local explosion = display.newSprite(explosionImageSheet, sequences_explosion)
   explosion.x = xPos
   explosion.y = yPos
   explosion:scale(xScale, yScale)
   zLayer:insert(explosion)
   explosion:addEventListener("sprite", handleExplosion)
   explosion:play()
end

local function validateCollision(missile)
   local xPos = missile.x
   local yPos = missile.y

   missile.zPosition = missile.zPosition - 1

   if missile.zPosition == -4 then
      missile:removeSelf()
      return
   else
      local xScale = missile.xScale - 0.1
      local yScale = missile.yScale - 0.1

      if xScale > 0 and yScale > 0 then
         if missile.zPosition == 4 then
            zLayer5:remove(missile)
            zLayer4:insert(missile)

            for i = 1, zLayer4.numChildren do
               if zLayer4[i].name == "bird" then
                  if hasCollided(missile, zLayer4[i]) then
                     audio.play(sounds["explosion"])

                     missile:removeSelf()
                     transition.cancel(zLayer4[i])
                     zLayer4[i]:removeSelf()
                     zLayer4[i] = nil

                     explode(xPos, yPos, 0.35, 0.35, zLayer4)
                     score = score + 1
                     
                     if score == 10 or score == 20 or score == 100 or score == 200 or score == 1000 or score == 2000 then
                        scoreText.x = scoreText.x - 5
                     end
                     
                     scoreText:update(tostring(score))
                     return
                  end
               end
            end
         elseif missile.zPosition == 3 then
            zLayer4:remove(missile)
            zLayer3:insert(missile)

            for i = 1, zLayer3.numChildren do
               if zLayer3[i].name == "bird" then
                  if hasCollided(missile, zLayer3[i]) then
                     audio.play(sounds["explosion"])

                     missile:removeSelf()
                     transition.cancel(zLayer3[i])
                     zLayer3[i]:removeSelf()
                     zLayer3[i] = nil

                     explode(xPos, yPos, 0.25, 0.25, zLayer3)
                     score = score + 1

                     if score == 10 or score == 20 or score == 100 or score == 200 or score == 1000 or score == 2000 then
                        scoreText.x = scoreText.x - 5
                     end

                     scoreText:update(tostring(score))
                     return
                  end
               end
            end
         elseif missile.zPosition == 2 then
            zLayer3:remove(missile)
            zLayer2:insert(missile)

            for i = 1, zLayer2.numChildren do
               if zLayer2[i].name == "bird" then
                  if hasCollided(missile, zLayer2[i]) then
                     audio.play(sounds["explosion"])

                     missile:removeSelf()
                     transition.cancel(zLayer2[i])
                     zLayer2[i]:removeSelf()
                     zLayer2[i] = nil

                     explode(xPos, yPos, 0.2, 0.2, zLayer2)
                     score = score + 1

                     if score == 10 or score == 20 or score == 100 or score == 200 or score == 1000 or score == 2000 then
                        scoreText.x = scoreText.x - 5
                     end

                     scoreText:update(tostring(score))
                     return
                  end
               end
            end
         elseif missile.zPosition == 1 then
            zLayer2:remove(missile)
            zLayer1:insert(missile)

            for i = 1, zLayer1.numChildren do
               if zLayer1[i].name == "bird" then
                  if hasCollided(missile, zLayer1[i]) then
                     audio.play(sounds["explosion"])

                     if zLayer1[i].speed == 2500 then
                        gameNetwork.request("unlockAchievement",
                        {
                           achievement = { identifier = "CgkI_7aYvaIVEAIQCQ", percentComplete = 100, showsCompletionBanner = true }
                        })
                     end

                     missile:removeSelf()
                     transition.cancel(zLayer1[i])
                     zLayer1[i]:removeSelf()

                     explode(xPos, yPos, 0.15, 0.15, zLayer1)
                     score = score + 1

                     if score == 10 or score == 20 or score == 100 or score == 200 or score == 1000 or score == 2000 then
                        scoreText.x = scoreText.x - 5
                     end

                     scoreText:update(tostring(score))
                     return
                  end
               end
            end
         else
            zLayer1:remove(missile)
            zLayer0:insert(missile)
         end

         transition.to(missile, { time = 100, xScale = xScale, yScale = yScale, onComplete = validateCollision })
      else
         missile:removeSelf()
         return
      end
   end
end

local function shoot(tap)
   audio.play(sounds["shot"])

   local sequences_missile = {
       {
           name = "shoot",
           start = 1,
           count = 3,
           time = 100,
           loopCount = 0,
           loopDirection = "forward"
       }
   }

   local missile = display.newSprite(missileImageSheet, sequences_missile)
   missile.x = tap.x
   missile.y = tap.y
   missile.zPosition = 5
   missile.name = "missile"
   missile:scale(0.6, 0.6)
   missile:play()
   zLayer5:insert(missile)

   transition.to(missile, { time = 200, xScale = 0.5, yScale = 0.5, onComplete = validateCollision })
end

local function update(event)
   local timeSinceLast = event.time - lastUpdateTime
   lastUpdateTime = system.getTimer()

   if timeSinceLast > 1000 then
      timeSinceLast = 1 / 60 * 1000
   end

   lastSpawnTime = lastSpawnTime + timeSinceLast

   if score <= 10 then
      if lastSpawnTime > 2200 then
         spawnBird()
         lastSpawnTime = 0.0
      end
   elseif score > 10 and score <= 20 then
      if lastSpawnTime > 2000 then
         spawnBird()
         lastSpawnTime = 0.0
      end
   elseif score > 20 and score <= 25 then
      if lastSpawnTime > 1800 then
         spawnBird()
         lastSpawnTime = 0.0
      end
   elseif score > 25 and score <= 35 then
      if lastSpawnTime > 1600 then
         spawnBird()
         lastSpawnTime = 0.0
      end
   elseif score > 35 and score <= 40 then
      if lastSpawnTime > 1400 then
         spawnBird()
         lastSpawnTime = 0.0
      end
   elseif score > 40 and score <= 45 then
      if lastSpawnTime > 1200 then
         spawnBird()
         lastSpawnTime = 0.0
      end
   elseif score > 45 and score <= 50 then
      if lastSpawnTime > 1150 then
         spawnBird()
         lastSpawnTime = 0.0
      end
   elseif score > 50 and score <= 55 then
      if lastSpawnTime > 1100 then
         spawnBird()
         lastSpawnTime = 0.0
      end
   elseif score > 55 and score <= 60 then
      if lastSpawnTime > 1050 then
         spawnBird()
         lastSpawnTime = 0.0
      end
   elseif score > 60 and score <= 65 then
      if lastSpawnTime > 1000 then
         spawnBird()
         lastSpawnTime = 0.0
      end
   elseif score > 65 and score <= 70 then
      if lastSpawnTime > 950 then
         spawnBird()
         lastSpawnTime = 0.0
      end
   elseif score > 70 and score <= 80 then
      if lastSpawnTime > 900 then
         spawnBird()
         lastSpawnTime = 0.0
      end
   elseif score > 80 and score <= 90 then
      if lastSpawnTime > 850 then
         spawnBird()
         lastSpawnTime = 0.0
      end
   elseif score > 90 and score <= 100 then
      if lastSpawnTime > 800 then
         spawnBird()
         lastSpawnTime = 0.0
      end
   elseif score > 100 and score <= 110 then
      if lastSpawnTime > 750 then
         spawnBird()
         lastSpawnTime = 0.0
      end
   elseif score > 110 and score <= 120 then
      if lastSpawnTime > 700 then
         spawnBird()
         lastSpawnTime = 0.0
      end
   elseif score > 120 and score <= 320 then
      if lastSpawnTime > 650 then
         spawnBird()
         lastSpawnTime = 0.0
      end
   else
      if lastSpawnTime > 600 then
         spawnBird()
         lastSpawnTime = 0.0
      end
   end
end

-- "scene:create()"
function scene:create(event)
   local sceneGroup = self.view

   local params = event.params
   local parallaxIndex = params.parallaxIndex

   parallax.init(sceneGroup, true, parallaxIndex)
   parallax.start()

   sceneGroup:insert(zLayer0)
   sceneGroup:insert(zLayer1)
   sceneGroup:insert(zLayer2)
   sceneGroup:insert(zLayer3)
   sceneGroup:insert(zLayer4)
   sceneGroup:insert(zLayer5)
   sceneGroup:insert(zLayer6)

   life1 = display.newImage("assets/gameplay/life.png")
   life1:scale(0.5, 0.5)
   life1.x = 20
   life1.y = 20
   zLayer6:insert(life1)

   death1 = display.newImage("assets/gameplay/death.png")
   death1:scale(life1.xScale, life1.yScale)
   death1.x = life1.x
   death1.y = life1.y
   death1.isVisible = false
   zLayer6:insert(death1)

   life2 = display.newImage("assets/gameplay/life.png")
   life2:scale(0.5, 0.5)
   life2.x = life1.x + life2.contentWidth + 2.5
   life2.y = life1.y
   zLayer6:insert(life2)

   death2 = display.newImage("assets/gameplay/death.png")
   death2:scale(life2.xScale, life2.yScale)
   death2.x = life2.x
   death2.y = life2.y
   death2.isVisible = false
   zLayer6:insert(death2)

   life3 = display.newImage("assets/gameplay/life.png")
   life3:scale(0.5, 0.5)
   life3.x = life2.x + life3.contentWidth + 2.5
   life3.y = life2.y
   zLayer6:insert(life3)

   death3 = display.newImage("assets/gameplay/death.png")
   death3:scale(life3.xScale, life3.yScale)
   death3.x = life3.x
   death3.y = life3.y
   death3.isVisible = false
   zLayer6:insert(death3)

   unmuteButton = display.newImage("assets/unmute_button.png")
   unmuteButton:scale(0.5, 0.5)
   unmuteButton.x = display.contentWidth - 25
   unmuteButton.y = display.contentHeight - 25
   unmuteButton:addEventListener("tap", handleUnmuteButton)
   zLayer6:insert(unmuteButton) 

   muteButton = display.newImage("assets/mute_button.png")
   muteButton:scale(0.5, 0.5)
   muteButton.x = unmuteButton.x
   muteButton.y = unmuteButton.y
   muteButton:addEventListener("tap", handleMuteButton)
   zLayer6:insert(muteButton)

   if audio.getVolume() == 0 then
      unmuteButton.isVisible = true
      muteButton.isVisible = false
   else
      unmuteButton.isVisible = false
      muteButton.isVisible = true
   end

   scoreText = strokeText.new(textOptions)
   zLayer6:insert(scoreText)
end

-- "scene:show()"
function scene:show(event)
   local sceneGroup = self.view
   local phase = event.phase

   if phase == "did" then
      audio.play(music, { loops = -1 })
      
      Runtime:addEventListener("enterFrame", update)
      Runtime:addEventListener("tap", shoot)
   end
end

-- "scene:hide()"
function scene:hide(event)
   local sceneGroup = self.view
   local phase = event.phase

   if phase == "will" then
      audio.stop()

      Runtime:removeEventListener("enterFrame", update)
      Runtime:removeEventListener("tap", shoot)
   elseif phase == "did" then
      -- Called immediately after scene goes off screen.
   end
end

-- "scene:destroy()"
function scene:destroy(event)
   local sceneGroup = self.view

   sceneGroup:remove(zLayer0)
   sceneGroup:remove(zLayer1)
   sceneGroup:remove(zLayer2)
   sceneGroup:remove(zLayer3)
   sceneGroup:remove(zLayer4)
   sceneGroup:remove(zLayer5)
   sceneGroup:remove(zLayer6)

   zLayer0 = nil
   zLayer1 = nil
   zLayer2 = nil
   zLayer3 = nil
   zLayer4 = nil
   zLayer5 = nil
   zLayer6 = nil

   audio.stop()

   for s, v in pairs(sounds) do
       audio.dispose(sounds[s])
       sounds[s] = nil
   end

   audio.dispose(music)

   Runtime:removeEventListener("enterFrame", update)
   Runtime:removeEventListener("tap", shoot)
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

---------------------------------------------------------------------------------

return scene
