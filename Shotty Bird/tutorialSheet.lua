--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:0c8a2bdebbd800d3f21ee57685ebf1db:7f4ceca7093aab084d504c545445ad0c:a7dfb0b653a363b41301f082f42dba69$
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
            -- tutorial_1
            x=1,
            y=1,
            width=924,
            height=538,

            sourceX = 100,
            sourceY = 117,
            sourceWidth = 1024,
            sourceHeight = 768
        },
        {
            -- tutorial_2
            x=1,
            y=541,
            width=918,
            height=538,

            sourceX = 100,
            sourceY = 117,
            sourceWidth = 1024,
            sourceHeight = 768
        },
        {
            -- tutorial_3
            x=1,
            y=1081,
            width=824,
            height=538,

            sourceX = 100,
            sourceY = 117,
            sourceWidth = 1024,
            sourceHeight = 768
        },
        {
            -- tutorial_4
            x=827,
            y=1081,
            width=824,
            height=538,

            sourceX = 100,
            sourceY = 117,
            sourceWidth = 1024,
            sourceHeight = 768
        },
        {
            -- tutorial_5
            x=921,
            y=541,
            width=824,
            height=538,

            sourceX = 100,
            sourceY = 117,
            sourceWidth = 1024,
            sourceHeight = 768
        },
    },
    
    sheetContentWidth = 1746,
    sheetContentHeight = 1620
}

SheetInfo.frameIndex =
{

    ["tutorial_1"] = 1,
    ["tutorial_2"] = 2,
    ["tutorial_3"] = 3,
    ["tutorial_4"] = 4,
    ["tutorial_5"] = 5,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
