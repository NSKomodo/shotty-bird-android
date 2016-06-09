--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:604325f0f8f6a5af3dd76e06a4941d6b:24208208c6623987e8d1f104a13e265c:9feadb688cda4c8b3252c2d455a26ec6$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- blue_normal_bird_1
            x=1,
            y=1,
            width=211,
            height=129,

        },
        {
            -- blue_normal_bird_2
            x=1,
            y=263,
            width=211,
            height=103,

            sourceX = 0,
            sourceY = 26,
            sourceWidth = 211,
            sourceHeight = 129
        },
        {
            -- green_fat_bird_1
            x=1,
            y=773,
            width=190,
            height=153,

        },
        {
            -- green_fat_bird_2
            x=1,
            y=1083,
            width=190,
            height=151,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 190,
            sourceHeight = 153
        },
        {
            -- green_skinny_bird_1
            x=1,
            y=473,
            width=210,
            height=75,

        },
        {
            -- green_skinny_bird_2
            x=1,
            y=550,
            width=210,
            height=67,

            sourceX = 0,
            sourceY = 8,
            sourceWidth = 210,
            sourceHeight = 75
        },
        {
            -- orange_normal_bird_1
            x=1,
            y=132,
            width=211,
            height=129,

        },
        {
            -- orange_normal_bird_2
            x=1,
            y=368,
            width=211,
            height=103,

            sourceX = 0,
            sourceY = 26,
            sourceWidth = 211,
            sourceHeight = 129
        },
        {
            -- red_skinny_bird_1
            x=1,
            y=619,
            width=205,
            height=75,

        },
        {
            -- red_skinny_bird_2
            x=1,
            y=696,
            width=205,
            height=75,

        },
        {
            -- yellow_fat_bird_1
            x=1,
            y=928,
            width=190,
            height=153,

        },
        {
            -- yellow_fat_bird_2
            x=1,
            y=1236,
            width=190,
            height=149,

            sourceX = 0,
            sourceY = 4,
            sourceWidth = 190,
            sourceHeight = 153
        },
    },
    
    sheetContentWidth = 213,
    sheetContentHeight = 1386
}

SheetInfo.frameIndex =
{

    ["blue_normal_bird_1"] = 1,
    ["blue_normal_bird_2"] = 2,
    ["green_fat_bird_1"] = 3,
    ["green_fat_bird_2"] = 4,
    ["green_skinny_bird_1"] = 5,
    ["green_skinny_bird_2"] = 6,
    ["orange_normal_bird_1"] = 7,
    ["orange_normal_bird_2"] = 8,
    ["red_skinny_bird_1"] = 9,
    ["red_skinny_bird_2"] = 10,
    ["yellow_fat_bird_1"] = 11,
    ["yellow_fat_bird_2"] = 12,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
