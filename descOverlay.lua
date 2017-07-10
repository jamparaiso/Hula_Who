
local storyboard = require ( "storyboard" )
local systemConfigurations = require ( "systemConfigurations" )
local myData = require ( "myData" )
local widget = require ("widget")
local scene = storyboard.newScene()

local _H = myData._H
local _W = myData._W
local _HH = myData._HH
local _HW = myData._HW
local fontStyle = myData.fontStyle
local tapSound = myData.tapSound
local backMusic = myData.backMusic
local enableSound = systemConfigurations.gameSound
local enableMusic = systemConfigurations.gameMusic

local screenGroup
local button = display.newGroup ( )

local hintDesc
local background
local timerEvent

local function exitOverlay(event)
	storyboard.hideOverlay()
end	

function scene:createScene()
	screenGroup = self.view

end

function scene:enterScene()
	
background = display.newRect(  0, 0, _W, _H )
background:setFillColor ( 0, 0, 0  )
background.alpha = 0.7

	
local briefDesc = myData.questionDescription
    hintDesc = native.newTextBox ( 0, 0, _W * .93,  _W*.69 )
	hintDesc.font = native.newFont ( fontStyle ,20 )
	hintDesc.hasBackground = true
	hintDesc.isEditable = false
	hintDesc.align = "left"
	hintDesc.x = _W * 0.5 ; hintDesc.y = _H * 0.76
	local hintText = briefDesc
	hintDesc.text = hintText .. "   Source:Just the Facts: Inventions and Discoveries"

local warnText = display.newText ("This will automatically close in: ",0,0,fontStyle,_H*0.04)
	  warnText.x = _W * 0.5 ; warnText.y = 50
	  warnText:setTextColor (255,255,255)
	  
local textTime = display.newText("15",0,0,Arial,_H*0.04)
	  textTime.x = _W * 0.5 ; textTime.y = 70
	  textTime:setTextColor(255,255,255)

local textDbl = display.newText("Double tap the image to manually close.",0,0,fontStyle,_H * .03)
	  textDbl.x = _W * .5 ; textDbl.y = 95		 
	
	button:insert(background)
	button:insert(warnText)
	button:insert(textTime)
	button:insert(textDbl)
	button:insert(hintDesc)
	
local levelTime = 15 --seconds until a hint automatically close
			countTime = function(event)
			levelTime = levelTime - 1
			textTime.text = levelTime
				if (levelTime <= 0) then

						storyboard.hideOverlay()

				end	
		end	
		timerEvent = timer.performWithDelay ( 1000, countTime ,levelTime )
local function dblTap(event)
	print(event.numTaps)
	if event.numTaps == 2 then
		background:removeEventListener ( "tap", dblTap )
		hintDesc:removeEventListener ( "tap", dblTap )
		storyboard.hideOverlay()
	end	
end
hintDesc:addEventListener ( "tap", dblTap )		
background:addEventListener ( "tap", dblTap )
end

function scene:exitScene()
	timer.cancel ( timerEvent )
	screenGroup:removeSelf()
	screenGroup = nil
	button:removeSelf()
	button = nil
end

function scene:didExitScene()
	storyboard.removeScene("descOverlay")
end

scene:addEventListener ( "createScene", scene )
scene:addEventListener ( "enterScene", scene )
scene:addEventListener ( "exitScene", scene )
scene:addEventListener ( "didExitScene", scene )

return scene			