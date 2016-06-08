-----------------------------------------------------------------------------------------
--
-- gameScene.lua
-- Shotty Bird
--
-- Created by Jorge Tapia on 6/08/16.
-- Copyright © 2016 Shotty Bird. All rights reserved.
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------

local parallax = require("parallax")

local zLayer0 = display.newGroup()
local zLayer1 = display.newGroup()
local zLayer2 = display.newGroup()
local zLayer3 = display.newGroup()
local zLayer4 = display.newGroup()
local zLayer5 = display.newGroup()

local lastUpdateTime = 0.0
local lastSpawnTime = 0.0
local lastShotFiredTime = 0.0

local score = 0

local music = audio.loadStream("sounds/gameplay_music.wav")
local sounds = {
    shot = audio.loadSound("sounds/shot.wav"),
    explosion = audio.loadSound("sounds/explosion.wav"),
    bird = audio.loadSound("sounds/bird.wav"),
    flap = audio.loadSound("sounds/wing_flap.wav")
}

local function spawnBird()
   math.randomseed(os.time())
   local zPosition = math.random(1, 4)

   -- TODO: implement as sprites and randomize birds
   local bird = display.newImage("assets/birds/yellow_fat_bird/yellow_fat_bird_1.png")
   bird.zPosition = zPosition
   bird.name = "bird"

   if zPosition == 4 then
      bird:scale(0.6, 0.6)
      zLayer4:insert(bird)
   elseif zPosition == 3 then
      bird:scale(0.45, 0.45)
      zLayer3:insert(bird)
   elseif zPosition == 2 then
      bird:scale(0.35, 0.35)
      zLayer2:insert(bird)
   elseif zPosition == 1 then
      bird:scale(0.2, 0.2)
      zLayer1:insert(bird)
   end

   bird.x = display.contentWidth + bird.contentWidth / 2
   bird.y = math.random(20 + bird.contentHeight / 2, display.contentHeight - bird.contentHeight)

   local function removeBird(bird)
      audio.play(sounds["bird"])
      bird:removeSelf()
      bird = nil
   end

   local speed = math.random(2, 5)
   transition.to(bird, { time = speed * 1000, x = -(bird.contentWidth / 2), y = bird.y, onComplete = removeBird })
   audio.play(sounds["flap"])
end

local function update(event)
   local timeSinceLast = event.time - lastUpdateTime
   lastUpdateTime = system.getTimer()

   if timeSinceLast > 1000 then
      timeSinceLast = 1 / 60 * 1000
   end

   lastSpawnTime = lastSpawnTime + timeSinceLast

   if lastSpawnTime > 1000 then
      spawnBird()
      lastSpawnTime = 0.0
   end
end

local function hasCollided( obj1, obj2 )
    if obj1 == nil or obj2 == nil then
        return false
    end

    local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
    local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
    local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
    local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
 
    return (left or right) and (up or down)
end

-- TODO: add explosion animation
local function validateCollision(missile)
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

                     missile:removeSelf()
                     transition.cancel(zLayer1[i])
                     zLayer1[i]:removeSelf()
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
   -- TODO: prevent missile spamming and add sounds
   audio.play(sounds["shot"])

   local missile = display.newImage("assets/missile/missile_1.png")
   missile.x = tap.x
   missile.y = tap.y
   missile.zPosition = 5
   missile.name = "missile"
   missile:scale(0.6, 0.6)
   zLayer5:insert(missile)

   transition.to(missile, { time = 200, xScale = 0.5, yScale = 0.5, onComplete = validateCollision })
end

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   parallax.init(sceneGroup, true)

   sceneGroup:insert(zLayer0)
   sceneGroup:insert(zLayer1)
   sceneGroup:insert(zLayer2)
   sceneGroup:insert(zLayer3)
   sceneGroup:insert(zLayer4)
   sceneGroup:insert(zLayer5)

   Runtime:addEventListener("tap", shoot)
end

-- "scene:show()"
function scene:show(event)

   local sceneGroup = self.view
   local phase = event.phase

   if phase == "did" then
      Runtime:addEventListener("enterFrame", update)
      parallax.start()
      audio.play(music, { loops = -1 })
   end
end

-- "scene:hide()"
function scene:hide(event)

   local sceneGroup = self.view
   local phase = event.phase

   if phase == "will" then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
   elseif phase == "did" then
      -- Called immediately after scene goes off screen.
   end
end

-- "scene:destroy()"
function scene:destroy(event)

   local sceneGroup = self.view

   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
   sceneGroup:remove(zLayer0)
   sceneGroup:remove(zLayer1)
   sceneGroup:remove(zLayer2)
   sceneGroup:remove(zLayer3)
   sceneGroup:remove(zLayer4)
   sceneGroup:remove(zLayer5)

   zLayer0 = nil
   zLayer1 = nil
   zLayer2 = nil
   zLayer3 = nil
   zLayer4 = nil
   zLayer5 = nil

   parallax = nil

   audio.stop()

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
