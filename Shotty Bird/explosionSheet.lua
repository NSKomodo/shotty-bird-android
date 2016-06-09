--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:cb6dff59dd1a1527c863ee8235dc9ca3:5ffce9d93925cdfc8cb98cfdda580c83:e1d993b00219563d688ca38f5880bc54$
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
            -- explosion9
            x=429,
            y=1,
            width=198,
            height=208,

            sourceX = 0,
            sourceY = 18,
            sourceWidth = 214,
            sourceHeight = 238
        },
        {
            -- explosion10
            x=217,
            y=1,
            width=210,
            height=214,

            sourceX = 0,
            sourceY = 15,
            sourceWidth = 214,
            sourceHeight = 238
        },
        {
            -- explosion11
            x=565,
            y=211,
            width=198,
            height=202,

            sourceX = 8,
            sourceY = 20,
            sourceWidth = 214,
            sourceHeight = 238
        },
        {
            -- explosion12
            x=769,
            y=1,
            width=91,
            height=91,

            sourceX = 12,
            sourceY = 19,
            sourceWidth = 107,
            sourceHeight = 119
        },
        {
            -- explosion_1
            x=769,
            y=94,
            width=56,
            height=58,

            sourceX = 70,
            sourceY = 90,
            sourceWidth = 214,
            sourceHeight = 238
        },
        {
            -- explosion_2
            x=765,
            y=297,
            width=118,
            height=100,

            sourceX = 37,
            sourceY = 52,
            sourceWidth = 214,
            sourceHeight = 238
        },
        {
            -- explosion_3
            x=765,
            y=167,
            width=120,
            height=128,

            sourceX = 37,
            sourceY = 52,
            sourceWidth = 214,
            sourceHeight = 238
        },
        {
            -- explosion_4
            x=629,
            y=1,
            width=138,
            height=164,

            sourceX = 37,
            sourceY = 39,
            sourceWidth = 214,
            sourceHeight = 238
        },
        {
            -- explosion_5
            x=187,
            y=241,
            width=178,
            height=200,

            sourceX = 16,
            sourceY = 22,
            sourceWidth = 214,
            sourceHeight = 238
        },
        {
            -- explosion_6
            x=1,
            y=241,
            width=184,
            height=200,

            sourceX = 10,
            sourceY = 22,
            sourceWidth = 214,
            sourceHeight = 238
        },
        {
            -- explosion_7
            x=1,
            y=1,
            width=214,
            height=238,

        },
        {
            -- explosion_8
            x=367,
            y=217,
            width=196,
            height=218,

            sourceX = 0,
            sourceY = 10,
            sourceWidth = 214,
            sourceHeight = 238
        },
    },
    
    sheetContentWidth = 886,
    sheetContentHeight = 442
}

SheetInfo.frameIndex =
{

    ["explosion9"] = 1,
    ["explosion10"] = 2,
    ["explosion11"] = 3,
    ["explosion12"] = 4,
    ["explosion_1"] = 5,
    ["explosion_2"] = 6,
    ["explosion_3"] = 7,
    ["explosion_4"] = 8,
    ["explosion_5"] = 9,
    ["explosion_6"] = 10,
    ["explosion_7"] = 11,
    ["explosion_8"] = 12,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
