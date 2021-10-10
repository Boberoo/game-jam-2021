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

local door = display.newImageRect( "Images/Door.png", 80, 80 )
door.x = display.contentCenterX+36
door.y = display.contentCenterY+87
door.rotation = 270

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

john.x = display.contentCenterX
john.y = display.contentCenterY+250
john:scale(0.125, 0.125)

local ughSound = audio.loadSound( "Audio/Ugh1.m4a" )
--audio.play( ughSound )
local ughSound = audio.loadSound( "Audio/Snore.m4a" )



local physics = require( "physics" )
physics.start()
physics.setGravity( 0, -0.1 )

physics.addBody( backWall, "static" )
physics.addBody( sideWallLeft, "static" )
physics.addBody( sideWallRight, "static" )
physics.addBody( door, "static", { radius=20 } )
physics.addBody( john, "dynamic", { radius=20, bounce=0.01, density=5.0, friction=0.9 } )

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
        john.isVisible = true
    else
        moveJohn(event.xGravity)
    end    
end
  
Runtime:addEventListener( "accelerometer", onAccelerate )

local function onReachHome ()
  --display.remove( john )
  john.isVisible = false
  
  local pSystem = physics.newParticleSystem( { filename = "Images/Z.png", radius = 20} )
  pSystem:createGroup(
    {
        flags = { "elastic", "reactive" },
        x = door.x,
        y = door.y,
        color = { 0, 0.8, 0.5, 1 },
        shape = { 0,0, 34,34, 0,64 },
        --lifetime = 30
        linearVelocityX = 0.1,
        linearVelocityY = 0.1 
    })
  audio.play( snoreSound )   
 
end

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2
 
        if ( ( obj1 == john ) or
             ( obj2 == john ) ) then
            if ( ( obj1 == door ) or
                 ( obj2 == door ) ) then
                timer.performWithDelay( 30, function()
                  onReachHome() --can;t start a partical system otherwise
                end, 1)
                
            else
                audio.play( ughSound )   
            end            
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






