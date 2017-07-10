
print ("gameFinishScene1----------------------------------------")

local storyboard = require ( "storyboard")
local myData = require ( "myData" )
local widget = require ("widget")
local systemConfigurations = require ( "systemConfigurations" )
local funcGetPlayerDat = require ( "funcGetPlayerDat" )
local funcGetPlayerAch = require ( "funcGetPlayerAch" )
local updateAchEra = require ( "updateAchEra" )
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

--fetch the updatedupdates the player data in myData
local playerID
playerID = myData.currentPlayerID
print ("PLAYER ID: ".. playerID)
local upPlayerData = {}
upPlayerData = funcGetPlayerDat.getPlayerDat("playerDB.sqlite" , playerID)
print ("PLAYER NAME: " .. upPlayerData.player_Name)
myData.playerDat = upPlayerData

--updates the player achievement data in myData
local upPlayerAchData = {}
upPlayerAchData = funcGetPlayerAch.getPlayerAch("playerDB.sqlite", playerID)
print ("ACHIEVEMENT POINTS: " .. upPlayerAchData.totalPoint)

--player achievement status
local ancientFin = upPlayerAchData.acientFin
local middleFin = upPlayerAchData.middleFin
local earlyFin = upPlayerAchData.earlyFin
local modernFin = upPlayerAchData.modernFin
local totalPoint = upPlayerAchData.totalPoint
--achievement points
local era1Fin = myData.era1Fin
local era2Fin = myData.era2Fin
local era3Fin = myData.era3Fin
local era4Fin = myData.era4Fin

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

local screenGroup
local button = display.newGroup ( )

local function showAch()

	storyboard.hideOverlay()
	storyboard.showOverlay("checkAchievement",{
	isModal = true,				
	effect = "fromBottom",
	time =350 ,
	})
end

local function checkAchEra()
	
local colName --column to update

	if tonumber(upCurEra) == 1 and  tonumber(ancientFin) == 0 then
		totalPoint = totalPoint + era1Fin
		colName = "acientFin"
		updateAchEra.updateAchEra(playerID,colName,totalPoint)
		myData.whatAch = "Ancient Master"
		showAch()
	elseif tonumber(upCurEra) == 2 and tonumber(middleFin) == 0 then
		totalPoint = totalPoint + era2Fin
		colName = "middleFin"
		updateAchEra.updateAchEra(playerID,colName,totalPoint)
		myData.whatAch = "Middle Age Commoner"
		showAch()
	elseif tonumber(upCurEra) == 3 and tonumber(earlyFin) == 0 then
		totalPoint = totalPoint + era3Fin
		colName = "earlyFin"
		updateAchEra.updateAchEra(playerID,colName,totalPoint)
		myData.whatAch = "Early Modern Ranger"
		showAch()
	elseif tonumber(upCurEra) == 4 and tonumber(modernFin) == 0 then
		totalPoint = totalPoint + era4Fin
		colName = "modernFin"
		updateAchEra.updateAchEra(playerID,colName,totalPoint)
		myData.whatAch = "Modern Genius"
		showAch()
	end	


end

local function nextSceneEvent(event)
	local phase = event.phase
		if phase == "ended" then

				if enableSound == true then
					audio.play(tapSound)
				end
				storyboard.gotoScene("gameFinishScene2",{
					effect = "slideLeft",
					time = 250,
					})	
		end	
end	

function scene:createScene()
	screenGroup = self.view
		
		local background = display.newImageRect ("images/background.png",  _W, _H)
		background.x=_W * 0.5 ; background.y=_H *0.5

		
		local scene1Image = display.newImageRect ( "images/ending1.png", 300, 400 );
		scene1Image.x = _W*0.5; scene1Image.y =210
		
	screenGroup:insert(background)
	screenGroup:insert(scene1Image) 		if enableMusic == true then
		if myData.backMusicHandler == nil then
		 	local backMusicHandler
		 	print ("---------------PLAY BACKGROUND MUSIC")
	 		backMusicHandler = audio.play(backMusic, {loops=-1} )
	 		myData.backMusicHandler = backMusicHandler
	 		print ("---------------BACKGROUND MUSIC CHANNEL: " .. backMusicHandler)
		end	  
	end

end

function scene:enterScene()
	
local nextButton = widget.newButton

{
			left = 100,
			top =428,
			width =100,
			height = 50,
			defaultFile = "images/next.png",
			overFile = "images/nextpress.png",
			id = "Next_Scene1_Button",
			onEvent = nextSceneEvent,
} 	

button:insert(nextButton)
	checkAchEra()
end

function scene:overlayBegan()
	print ("overlay is shown")
end

function scene:overlayEnded()
	print ("overlay is removed")

end	

function scene:exitScene()
	screenGroup:removeSelf()
	screenGroup= nil
	button:removeSelf()
	button = nil
end

function scene:didExitScene()
	storyboard.removeScene("gameFinishScene1")
end

scene:addEventListener ( "createScene", scene )
scene:addEventListener ( "enterScene", scene )
scene:addEventListener ( "overlayBegan", scene )
scene:addEventListener ( "overlayEnded", scene )
scene:addEventListener ( "exitScene", scene )
scene:addEventListener ( "didExitScene", scene )

return scene				