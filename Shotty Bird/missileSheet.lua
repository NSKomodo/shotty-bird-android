--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:e2369c35dbe0218f20b6b455f34f0d57:842390809e48d7c57468794cfb8284ea:20a2a267a130056cafd4e0bf69c4898e$
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
            -- missile_1
            x=1,
            y=1,
            width=150,
            height=136,

            sourceX = 0,
            sourceY = 14,
            sourceWidth = 150,
            sourceHeight = 150
        },
        {
            -- missile_2
            x=1,
            y=139,
            width=150,
            height=130,

            sourceX = 0,
            sourceY = 14,
            sourceWidth = 150,
            sourceHeight = 150
        },
        {
            -- missile_3
            x=1,
            y=271,
            width=150,
            height=120,

            sourceX = 0,
            sourceY = 14,
            sourceWidth = 150,
            sourceHeight = 150
        },
    },
    
    sheetContentWidth = 152,
    sheetContentHeight = 392
}

SheetInfo.frameIndex =
{

    ["missile_1"] = 1,
    ["missile_2"] = 2,
    ["missile_3"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
