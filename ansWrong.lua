
print ("answer wrong module")

local myData = require ( "myData" )
local systemConfigurations = require ( "systemConfigurations" )
local storyboard = require ( "storyboard" )
local widget = require ("widget")
local funcGetPlayerDat = require ( "funcGetPlayerDat" )
local scene = storyboard.newScene()
local physics = require("physics")
physics.start()
physics.setGravity( 0, 4 )
math.randomseed(os.time())

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
local failSound = myData.failSound
local wrongSound = myData.wrongSound
local wrongSound2 = myData.wrongSound2
local enableSound = gameSettings.soundOn
local enableMusic = gameSettings.musicOn


--fetch the updated player data in myData
local playerID
playerID = myData.currentPlayerID
print ("current player ID: ".. playerID)
local upPlayerData = {}
upPlayerData = funcGetPlayerDat.getPlayerDat("playerDB.sqlite" , playerID)
print ("updated player name: " .. upPlayerData.player_Name)
myData.playerDat = upPlayerData

--player data
local upPlayerName = upPlayerData.player_Name
local upCurCoins = upPlayerData.current_Coins
local upAcqCoins = upPlayerData.coins_Acquired
local upAchievePts = upPlayerData.achievement_pts
local upCurEra = upPlayerData.current_Era
local upCurLevel = upPlayerData.current_Level
local upAnsCor = upPlayerData.answered_Correct
local upAnsWro = upPlayerData.answered_Wrong
local upHintUsed = upPlayerData.num_Hints_Used
local upGameFin = upPlayerData.game_Finished
local upSlotUsed = upPlayerData.slots_Last_Used
local upSaveStat = upPlayerData.save_Status

local resTbl = {}
resTbl = myData.levelRestriction
local corAns = resTbl.corAns
local wroAns = resTbl.wroAns

local playCor = myData.playCor
local playWro = myData.playWro
local nextButton
local failPic
local correctPic
local retryButton
local menuButton
local textLevel

local neo1,neo2,neo2,timerEvent,timerEvent1,timerEvent2
local screenGroup
local button = display.newGroup ( )
local neoDance = display.newGroup()
local conDrop = display.newGroup()
local myTimer
local neo
local fail

local toMinus = 3
local function makeFailSmall()
		if toMinus ~= 1 then
		fail.xScale = toMinus -.2
		fail.yScale = toMinus - .2
		toMinus = toMinus - .2

		else
		timer.cancel(myTimer)
		end

end

local function checkIfFinish(playCor,corAns,playWro,wroAns)
	local playCor = tonumber(playCor)
	local corAns = tonumber(corAns)
	local playWro = tonumber(playWro)
	local wroAns = tonumber(wroAns)
	
	if playWro ~= wroAns then
		print ("answer wrong")
		nextButton.alpha = 1
		menuButton.alpha =0
		retryButton.alpha= 0
		correctPic.alpha = 0
		
neo1 = display.newImageRect("images/neocry1.png",120,185 )
neo1.x = _W * 0.5 ; neo1.y = 300
neo1.alpha = 0
neoDance:insert(neo1)

neo2 = display.newImageRect("images/neocry2.png",120,185 )
neo2.x = _W * 0.5 ; neo2.y = 300
neo2.alpha = 0
neoDance:insert(neo2)


--local function showAnswer()

--end	    
	    fail = display.newImageRect("images/failbig.png",90,90)
	    fail.x = _W * 0.5 ; fail.y = _H * 0.12
	    fail.xScale = 3
	    fail.yScale = 3
	    
physics.addBody(neo1,"static",{friction = 0.3,density=.3})
physics.addBody(neo2,"static",{friction = 0.3,density=.3})
local fCount = 1
local function danceNeo()
	
local year1 = myData.year1
local name1 = myData.name1
local invent1 = myData.invent1
local sitation = "Just the Facts: Inventions and Discoveries"

local chatBubble=display.newImageRect("images/chatBubble.png",250,120)
chatBubble.x = _W * 0.5 ; chatBubble.y = _H *.35
neoDance:insert(chatBubble)

local text1 = display.newText("In the year " .. year1 .. ",", 50, 115,fontStyle, 16)
text1:setTextColor(0,0,0)
neoDance:insert(text1)

local text2 = display.newText(name1, 50, 130,fontStyle, 16)
text2:setTextColor(0,0,0)
neoDance:insert(text2)

local text3 = display.newText("invented/discovered the", 50, 145,fontStyle, 16)
text3:setTextColor(0,0,0)
neoDance:insert(text3)

local text4 = display.newText(invent1, 50, 160,fontStyle, 16)
text4:setTextColor(0,0,0)
neoDance:insert(text4)

local text5 = display.newText("Source: " .. sitation,50,180,fontStyle,10)
text5:setTextColor(0,0,0)
neoDance:insert(text5)
	
	if fCount ~=0 then
		if fCount == 1 then
			neo1.alpha = 1
			neo2.alpha = 0

			fCount = fCount + 1
		elseif fCount == 2 then
			neo1.alpha = 0
			neo2.alpha = 1
			fCount = 1
		end
	end
end

local conTbl={}
local choice
local ranConfetti = function()
	choice = math.random(1,2)
	local confetti
	
	if choice == 1 then
		confetti = display.newImage( "images/tearL.png" )
		confetti.width = 9
		confetti.height = 9
		confetti.x = 110; confetti.y = 270
		physics.addBody( confetti, { density=0.6, friction=0.6, bounce=0.6, radius=5 } )
		confetti.isSleepingAllowed = false
		conDrop:insert(confetti)
	
	elseif choice == 2 then
		confetti = display.newImage( "images/tearR.png" )
		confetti.width = 9
		confetti.height = 9
		confetti.x = 210; confetti.y = 270
		physics.addBody( confetti, { density=0.6, friction=0.6, bounce=0.6, radius=5 } )
		conDrop:insert(confetti)
	end

	conTbl[#conTbl + 1] = confetti	
end
		failPic.alpha = 0

	    		
		timerEvent = timer.performWithDelay (200,danceNeo,-1)
		myTimer = timer.performWithDelay( 10, makeFailSmall,10 )

		timerEvent2 = timer.performWithDelay(500,ranConfetti,-1)
		button:insert(fail)
		if enableSound == true then
			local ran = math.random(1,2)
				if ran == 1 then
					audio.play(wrongSound)
				elseif ran == 2 then
					audio.play(wrongSound2)
				end		
		end
	elseif playWro == wroAns then
		print("level failed")
		
	 	if enableMusic == true then
	 		if myData.questionMusicHandler >= 0 then
	 			print ("STOP QUESTION MUSIC")
 				local questionMusicHandler
 				questionMusicHandler = myData.questionMusicHandler
 				print ("QUESTION MUSIC CHANNEL: " .. questionMusicHandler)	
			 	audio.stop (questionMusicHandler)
			 	myData.questionMusicHandler = nil
	 		end
	 	end		
		
		failPic.alpha = 1
		menuButton.alpha =1
		retryButton.alpha = 1
		textLevel.text = upCurLevel
		textLevel.alpha = 1
		correctPic.alpha = 0
		nextButton.alpha = 0
		if enableSound == true then
		audio.play(failSound)	
		end
	end	
	
end	

local function reloadGameProper(event)
	local phase = event.phase
		if phase == "ended" then
			print ("next button is presses and released")
				if enableSound == true then
					audio.play(tapSound)
				end
					timer.cancel ( timerEvent )
					timer.cancel ( timerEvent2 )
				storyboard.gotoScene("gameProper",{
					effect = "slideRight",
					time = 250,
					})	
		end
end	

local function retryLevel(event)
	local phase = event.phase
		if phase == "ended" then
			print("retrybutton is pressed and released")
				if enableSound == true then
					audio.play(tapSound)
				end
				myData.playCor = 0
				myData.playWro = 0
				myData.lastQ = nil
				myData.lastQ = {}
				myData.qCount = 0
				storyboard.gotoScene("gameRestrictions",{
					effect = "slideRight",
					time = 250,
					})
		end
end	

local function gotoMenu(event)
	local phase = event.phase
		if phase == "ended" then
			print ("go to menu is pressed and released")
				if enableSound == true then
					audio.play(tapSound)
				end
				myData.playCor = 0
				myData.playWro = 0
				myData.lastQ = nil
				myData.lastQ = {}
				myData.qCount = 0
				storyboard.gotoScene("playerMenu",{
					effect = "slideRight",
					time = 250,
					})	
		end	
end	

function scene:createScene()
	screenGroup = self.view
	
	local background = display.newImageRect ( "images/background.png",  _W, _H )
			  background.x = _W * 0.5 ; background.y = _H * 0.5
			  
			 correctPic = display.newImageRect (  "images/wrong.png" , 250, 40 )
			 correctPic.x = _W * 0.5 ; correctPic.y = 80
			 correctPic.alpha = 0
			 
			 failPic = display.newImageRect ( "images/levelfailedtext.png"  , 245, 175 )
			 failPic .x = _W * 0.5 ; failPic.y = 170
			 failPic.alpha = 0
			 
			 textLevel = display.newText( "00", _W * 0.45, 205, fontStyle, _W *0.09 )
			 textLevel:setTextColor ( 255, 255, 255 )
			 textLevel.alpha = 0		 		  
			  
	screenGroup:insert(background)
	screenGroup:insert(correctPic)
	screenGroup:insert(failPic)
	screenGroup:insert(textLevel)		  
	
end

function scene:enterScene()

nextButton = widget.newButton
{
	left = 100,
	top = 400,
	width = 130,
	height = 50,
	defaultFile = "images/next.png",
	overFile = "images/nextpress.png",
	id = "nextButton",
	onEvent = reloadGameProper,
}

retryButton = widget.newButton
{
	left = 40,
	top = 350,
	width = 250,
	height = 50,
	defaultFile = "images/retrylevel.png",
	overFile = "images/retrylevelpress.png",
	onEvent = retryLevel,
}
retryButton.alpha = 0

menuButton = widget.newButton
{
	left = 40,
	top = 400,
	width = 250,
	height = 50,
	defaultFile = "images/backlong.png",
	overFile = "images/backlongpress.png",
	onEvent = gotoMenu,
}
menuButton.alpha = 0

	
button:insert(nextButton)
button:insert(retryButton)
button:insert(menuButton)
checkIfFinish(playCor,corAns,playWro,wroAns)
	
end

function scene:overlayBegan()
	print ("overlay is shown")
end

function scene:overlayEnded()
	print ("overlay is removed")

end

function scene:exitScene()
	myData.year1 = nil
	myData.name1 = nil
	myData.invent1 = nil
	neoDance:removeSelf()
	neoDance = nil
	conDrop:removeSelf()
	conDrop = nil	
	screenGroup:removeSelf()
	screenGroup = nil
	button:removeSelf()
	button = nil
end

function scene:didExitScene()
	storyboard.removeScene("ansWrong")
end

scene:addEventListener ( "createScene", scene )
scene:addEventListener ( "enterScene", scene )
scene:addEventListener ( "overlayBegan", scene )
scene:addEventListener ( "overlayEnded", scene )
scene:addEventListener ( "exitScene", scene )
scene:addEventListener ( "didExitScene", scene )

return scene			