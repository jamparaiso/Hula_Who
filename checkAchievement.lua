
local storyboard = require ( "storyboard" )
local myData = require ( "myData" )
local systemConfigurations = require ( "systemConfigurations" )
local scene = storyboard.newScene()

local _H = myData._H
local _W = myData._W
local _HH = myData._HH
local _HW = myData._HW
local fontStyle = myData.fontStyle
local tapSound = myData.tapSound
local clockTick = myData.clockTick
local backMusic = myData.backMusic
local enableSound = systemConfigurations.gameSound
local enableMusic = systemConfigurations.gameMusic

local screenGroup = display.newGroup ( )
local achievementPopUp
local whatAch = myData.whatAch
local achText

function scene:createScene()

if whatAch == nil then
	whatAch = "What achievement"
end	

		achievementPopUp = display.newImageRect ("images/achievementOverlay.png", 318, 150 )
		achievementPopUp.x = _W / 2 ; achievementPopUp.y =-120
		
		achText = display.newText( whatAch, 90, -120, fontStyle, _H * 0.033 )
		achText:setTextColor (239, 102, 0)
		achText:setReferencePoint ( display.CenterLeftReferencePoint )
		
		screenGroup:insert(achievementPopUp)
		screenGroup:insert(achText)
	
end

function scene:enterScene()
	
local getMeOut = function()
transition.to(achievementPopUp, {time = 500, y = -120, transition = easing.inExpo , })
transition.to(achText, {time = 500, y = -120, transition = easing.inExpo , })
storyboard.hideOverlay()	
end		
	
transition.to(achievementPopUp, {time = 500, y = 75, transition = easing.outExpo , })
transition.to(achText, {time = 500, y = 40, transition = easing.outExpo , })

timer.performWithDelay (2000, getMeOut )
end

function scene:exitScene()
 achievementPopUp = nil
 achText= nil
 screenGroup:removeSelf()
 screenGroup = nil
end

function scene:didExitScene()
	storyboard.removeScene("checkAchievement")
end

scene:addEventListener ( "createScene", scene )
scene:addEventListener ( "enterScene", scene )
scene:addEventListener ( "exitScene", scene )
scene:addEventListener ( "didExitScene", scene )

return scene			