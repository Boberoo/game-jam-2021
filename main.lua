-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------


local background = display.newImageRect( "Images/Background.png", 360, 570 )
background.x = display.contentCenterX
background.y = display.contentCenterY

local backWall = display.newImageRect( "Images/Clouds.png", 360, 425 )
backWall.x = display.contentCenterX
backWall.y = display.contentCenterY-180
backWall.alpha = 0.9

local sideWallLeft = display.newImageRect( "Images/SideWall.png", 10, 570 )
sideWallLeft.x = display.contentCenterX-160
sideWallLeft.y = display.contentCenterY
sideWallLeft.alpha = 0.1

local sideWallRight = display.newImageRect( "Images/SideWall.png", 10, 570 )
sideWallRight.x = display.contentCenterX+160
sideWallRight.y = display.contentCenterY
sideWallRight.alpha = 0.1

--local background = display.newImageRect( "Floor.png", 360, 570 )
--floor.path.x4 = -50
--floor.path.x1 = 50


--local john = display.newImageRect( "Images/JohnWalking.gif", 62, 62 )


local sheetOptions =
{
    width = 665,
    height = 702,
    numFrames = 2
}

local sheet_johnWalking = graphics.newImageSheet( "Images/JohnWalking.png", sheetOptions )
local sequences_johnWalking = {
    -- first sequence (consecutive frames)
    {
        name = "normalWalk",
        start = 1,
        count = 2,
        time = 800,
        loopCount = 0
    }
}

local john = display.newSprite( sheet_johnWalking, sequences_johnWalking )

-ohn.x = display.contentCenterX
john.y = display.contentCenterY+250

local ughSound = audio.loadSound( "Audio/Ugh1.m4a" )
--audio.play( ughSound )



local physics = require( "physics" )
physics.start()
physics.setGravity( 0, -0.1 )

physics.addBody( backWall, "static" )
physics.addBody( sideWallLeft, "static" )
physics.addBody( sideWallRight, "static" )
physics.addBody( john, "dynamic", { radius=50, bounce=0.01, density=5.0, friction=0.9 } )

john:play()

local function moveJohn(x)
    john:applyLinearImpulse( x * 2, 0, john.x, john.y )
end
 
--john:addEventListener( "key", moveJohn )

local function onAccelerate( event )
    --print( event.name, event.xGravity, event.yGravity, event.zGravity )
    if event.isShake then
        john.y = 570
        john.x = display.contentCenterX
    else
        moveJohn(event.xGravity)
    end    
end
  
Runtime:addEventListener( "accelerometer", onAccelerate )

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
 
        if ( ( obj1 == john ) or
             ( obj2 == john ) ) then
            
            --display.remove( obj1 )
           
            audio.play( ughSound )            
        end
    end
end 

Runtime:addEventListener( "collision", onCollision )

local textOptions = 
{
    text = "",
    x = 180,
    y = 60,
    width = 200,
    font = native.systemFont,
    fontSize = 28
}
local instructions = display.newText( textOptions )
instructions:setFillColor( 0.1, 0.1, 0.1 )


local function onTouch( event )
    if ( event.phase == "began" ) then
        if ( physics.paused ) then
            instructions.text = ""
            physics.paused = false
        else
            instructions.text = "Help John home by tilting your phone to guide him. Tap anywhere to continue"
            physics.paused = true
        end
    end
end 

Runtime:addEventListener( "touch", onTouch )



