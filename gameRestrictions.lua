
print ("game restrictions module-----------------------------")

local myData = require ("myData")
local widget = require ("widget")

local systemConfigurations = require ( "systemConfigurations" )
local storyboard = require( "storyboard" )
local ancientRestrictions = require ("ancientRestrictions")
local middleRestrictions = require ( "middleRestrictions" )
local earlyRestrictions = require ( "earlyRestrictions" )
local modernRestrictions = require ( "modernRestrictions" )
local funcGetPlayerDat = require ("funcGetPlayerDat")
local scene = storyboard.newScene()
local json = require ("json")
local gameSettings = { }

local function loadSysConfig()

	local function loadSystemConfig (filename)
		local path = system.pathForFile (filename,system.DocumentsDirectory )
		local contents = ""
		local myTable = { }
		local file = io.open ( path ,"r" )
	
			if file then
				local contents = file:read ("*a")
				myTable = json.decode( contents )
				io.close (file)
				return myTable	
			end
				return nil
	end

 gameSettings = loadSystemConfig ("systemConfiguration.json")

 end
--gets the currents system settings 
loadSysConfig()
local _H = myData._H
local _W = myData._W
local _HH = myData._HH
local _HW = myData._HW
local fontStyle = myData.fontStyle
local tapSound = myData.tapSound
local backMusic = myData.backMusic
local enableSound = gameSettings.soundOn
local enableMusic = gameSettings.musicOn

--updates the player data in myData
local playerID
playerID = myData.currentPlayerID


local upPlayerData = {}
upPlayerData = funcGetPlayerDat.getPlayerDat("playerDB.sqlite" , playerID)


myData.playerDat = upPlayerData

local upCurEra = upPlayerData.current_Era
print ("player Era: " .. upCurEra)
local upCurLevel = upPlayerData.current_Level
print ("player Level: " .. upCurLevel)

local levelRes = {}
local timeRes
local corAns
local wroAns
local level

local function goToPlay(event)
	local phase = event.phase
		if phase == "ended" then

					if enableSound == true then
						audio.play(tapSound)
					end
					storyboard.gotoScene("gameProper",{
						effect = "slideLeft",
						time = 250,
						})	
		end		 
end

local function backToMenu(event)
	local phase = event.phase
		if phase =="ended" then

					if enableSound == true then
						audio.play(tapSound)
					end
					storyboard.gotoScene("selectLevel",{
						effect = "slideRight",
						time = 250,
						})
		end	
end	

local function whatEra()
	if tonumber(upCurEra) == 1 then
		print ("ancient period")
		levelRes = ancientRestrictions.selectRestriction(upCurLevel)
		myData.levelRestriction = levelRes
		timeRes = levelRes.timeRes
		corAns = levelRes.corAns
		wroAns = levelRes.wroAns

	elseif tonumber(upCurEra) == 2 then
		print ("middle ages")
		levelRes = middleRestrictions.selectRestriction(upCurLevel)
		myData.levelRestriction = levelRes
		timeRes = levelRes.timeRes
		corAns = levelRes.corAns
		wroAns = levelRes.wroAns
	
	elseif tonumber(upCurEra) == 3 then
		print ("early modern age")
		levelRes = earlyRestrictions.selectRestriction(upCurLevel)
		myData.levelRestriction = levelRes
		timeRes = levelRes.timeRes
		corAns = levelRes.corAns
		wroAns = levelRes.wroAns
		
	elseif tonumber(upCurEra) == 4 then
		print ("modern age")
		levelRes = modernRestrictions.selectRestriction(upCurLevel)
		myData.levelRestriction = levelRes
		timeRes = levelRes.timeRes
		corAns = levelRes.corAns
		wroAns = levelRes.wroAns
	end
end
whatEra()

local screenGroup
local button = display.newGroup ( )

function scene:createScene()
	screenGroup = self.view
	
	local background = display.newImageRect ( "images/background.png",  _W, _H )
			  background.x = _W * 0.5 ; background.y = _H * 0.5
			  
	local backWrapper = display.newRoundedRect(  100, 100, 250, 150, 15 )
			backWrapper.x = 160 ; backWrapper.y = 310
			backWrapper:setFillColor ( 249, 255, 137)		  
		
	local gameLogo = display.newImageRect ( "images/logosmall.png"  ,200 ,200 )
			   gameLogo:setReferencePoint ( display.CenterReferencePoint )
			   gameLogo.x =160  ; gameLogo.y = 130
			   
	local timePic = display.newImageRect ( "images/time.png"  , 25, 25 )
			 timePic.x = 70 ; timePic.y = 290
			 
	local checkPic = display.newImageRect ( "images/check.png" ,25 ,25 )
			 checkPic.x = 70 ; checkPic.y = 320
			 
	local failPic = display.newImageRect ( "images/fail.png"  , 25, 25 )
			failPic.x = 70; failPic.y = 350
			
	local textRestrict = display.newText( "Level "..upCurLevel .. " mechanics", 100, 100, fontStyle, _W * 0.07 )
			textRestrict:setTextColor ( 250, 183, 0 )
			textRestrict.x = 160 ; textRestrict.y = 250
			
	local textTimeLimit = display.newText( timeRes .. " seconds per question", 100, 100, fontStyle, _W * 0.04 )
			textTimeLimit:setTextColor ( 0, 0, 0 )
			textTimeLimit:setReferencePoint ( display.CenterLeftReferencePoint )
			textTimeLimit.x = 100 ; textTimeLimit.y = 290
			
	local textCorrect = display.newText( corAns .. " correct answers", 100, 100, fontStyle, _W * 0.04 )
			textCorrect:setTextColor ( 0, 0, 0 )
			textCorrect:setReferencePoint ( display.CenterLeftReferencePoint )
			textCorrect.x = 100 ; textCorrect.y = 320
			
	local textWrong = display.newText( wroAns .. " wrong answers", 100, 100, fontStyle, _W * 0.04 )
			textWrong:setTextColor ( 0, 0, 0 )
			textWrong:setReferencePoint ( display.CenterLeftReferencePoint )
			textWrong.x = 100 ; textWrong.y = 350							
			
			screenGroup:insert(background)
			screenGroup:insert(backWrapper)
			screenGroup:insert(gameLogo)
			screenGroup:insert(timePic)
			screenGroup:insert(checkPic)
			screenGroup:insert(failPic)
			screenGroup:insert(textRestrict)
			screenGroup:insert(textTimeLimit)
			screenGroup:insert(textCorrect)
			screenGroup:insert(textWrong)
end

function scene:enterScene()
	if enableMusic == true then
		if myData.backMusicHandler == nil then
			print ("--------------------PLAY BACKGROUND MUSIC")
			local backMusicHandler
	    	backMusicHandler = audio.play(backMusic, {loops=-1} )
	    	myData.backMusicHandler = backMusicHandler
	    	print ("--------------------BACKGROUND MUSIC CHANNEL: " .. backMusicHandler)
		end	
	end
local nextButton = widget.newButton
{
	left = 170,
	top = 410,
	width = 130,
	height = 40,
	defaultFile = "images/next.png",
	overFile = "images/nextpress.png",
	id = "next_Button",
	onEvent = goToPlay,
} 

local backButton = widget.newButton
{
	left = 30,
	top = 410,
	width = 130,
	height = 40,
	defaultFile = "images/back.png",
	overFile = "images/backpress.png",
	id = "back_Button",
	onEvent = backToMenu,
}

button:insert(nextButton)
button:insert(backButton)

end

function scene:exitScene()
	screenGroup:removeSelf()
	screenGroup = nil
	button:removeSelf()
	button = nil
end

function scene:didExitScene()
	storyboard.removeScene("gameRestrictions")
end

scene:addEventListener ( "createScene", scene )
scene:addEventListener ( "enterScene", scene )
scene:addEventListener ( "exitScene", scene )
scene:addEventListener ( "didExitScene", scene )

return scene		