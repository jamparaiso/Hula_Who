
print ("SPLASHSCREEN MODULE---------------------------------------------")
--module declaration
local storyboard = require("storyboard")

local myData = require("myData")
local systemConfigurations = require ( "systemConfigurations" )
local scene = storyboard.newScene()

--variable declaration
--screen height and width, this was declared in myData.lua
local _H = myData._H
local _W = myData._W
local _HH = myData._HH
local _HW = myData._HW
local fontStyle = myData.fontStyle
local enableSound = systemConfigurations.gameSound
local enableMusic = systemConfigurations.gameMusic
local screenGroup

print ("SOUND ENABLED:")
print (enableSound)
print ("MUSIC ENABLED:")
print (enableMusic)
print ("FONT USED: "..fontStyle)
print ("SCREEN WIDTH: " .. _W)
print ("SCREEN HEIGHT: " .. _H)

local myTimer

local gameLogo
local background
local loadText


--called when the scene's view does not exist
function scene:createScene ( event )

	--think of this function is the preparation of the props in theater presentation
	screenGroup = self.view --this is important bcos all objects in the scenes are in here

	--introduce loadingImage display object

	--background image
	 background=display.newImageRect (  "images/background.png" , _W,_H )
			background.x=_W * 0.5 ; background.y=_H *0.5

	--loading text
	loadtext=display.newText(  "Loading...", _HH, _HW, fontStyle, 25 )
	loadtext:setReferencePoint ( display.CenterRefencePoint )
	loadtext.x=_HW ; loadtext.y=_HH+80

	--gamelogo
	gameLogo = display.newImageRect (  "images/logosmall.png",200,200)
	gameLogo:setReferencePoint ( display.CenterReferencePoint )
	gameLogo.x=_HW ; gameLogo.y=_HH-50
	
	--add all images to a group, by doing this it easy to remove them from the memory
	screenGroup:insert ( background )
	screenGroup:insert ( loadtext )
	screenGroup:insert ( gameLogo )

end

--called immediately after scene has moved onscreen
function scene: enterScene ( event )

	--think of this function where the theater play in motion. all the animations, interactions are in here.

		local goToMenu = function()

			--switches into the mainmenu
			storyboard.gotoScene( "mainmenu","crossFade", 300 )		
		end

			--time of transition into mainmenu
			myTimer = timer.performWithDelay ( 2000 , goToMenu , 1 )			
end

--called when scene is about to move offscreen
function scene:exitScene()
	--in this scene think of a theather play when its over, all the used props and everything will be removed in this scene
	screenGroup:removeSelf()
	screenGroup=nil
		if myTimer then timer.cancel ( myTimer )
		end --this will cancel the timer function above
	print("SPLASHSCREEN MODULE UNLOADED-----------------------------------------")
end

function scene:didExitScene()

	storyboard.removeScene("splashScreen") --removes this scene on the memory	
end

--called prior to the removal of scene's "view" (display group)
function scene:destroyScene ( event )

end	

--add event listeners for all the scene events and return scene.
--"createScene" event is dispatched if scene's view does not exist
scene:addEventListener ( "createScene", scene )

--"enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener ( "enterScene", scene )

--"exitScene" event is dispatched before next scene's transition begins
scene:addEventListener ( "exitScene", scene )

--“didExitScene” event is dispatched immediately after the scene has transitioned out
scene:addEventListener ( "didExitScene", scene )

--"destroyScene" event is dispatched before view is unloaded, which can be
scene:addEventListener ( "destroyScene", scene )

return scene
