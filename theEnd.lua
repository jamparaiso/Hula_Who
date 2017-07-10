
local myData = require ( "myData" )
local systemConfigurations = require ( "systemConfigurations" )
local storyboard = require ( "storyboard" )
local widget = require ("widget")
local funcGetPlayerDat = require ( "funcGetPlayerDat" )
local updateLevel = require ( "updateLevel" )
local updateSaveStatus = require ( "updateSaveStatus" )

local updateAchFinish = require ( "updateAchFinish" )
local funcGetPlayerAch = require ( "funcGetPlayerAch" )
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
print ("current player ID: ".. playerID)
local upPlayerData = {}
upPlayerData = funcGetPlayerDat.getPlayerDat("playerDB.sqlite" , playerID)
print ("updated player name: " .. upPlayerData.player_Name)
myData.playerDat = upPlayerData

--updates the player achievement data in myData
local upPlayerAchData = {}
upPlayerAchData = funcGetPlayerAch.getPlayerAch("playerDB.sqlite", playerID)
print ("total Achievement points: " .. upPlayerAchData.totalPoint)

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

local totalPoint = upPlayerAchData.totalPoint
local gameFinAch = upPlayerAchData.gameFin
local gameFinPoint = myData.finGame

--updates the player era
local function upMe()
	local newLevel = 1
	local newEra =  1
	local gameFinish = upGameFin + 1
	updateSaveStatus.upSaveStat(playerID,gameFinish)
	updateLevel.upLevel(playerID,newLevel,newEra)	
end

local function showAch()

	storyboard.hideOverlay()
	storyboard.showOverlay("checkAchievement",{
	isModal = true,				
	effect = "fromBottom",
	time =350 ,
	})
end

local function achFinish()
	print ("number of game finished:" .. upGameFin)
	if tonumber(upGameFin) == 0 and tonumber(gameFinAch) == 0 then
		totalPoint = totalPoint + gameFinPoint
		local finStatus = 1
		updateAchFinish.updateAchFinish(playerID,finStatus,totalPoint)
		myData.whatAch = "Game Master"
		showAch()
	else
		return false
	end	
end	

local function backMenu(event)
	local phase = event.phase
	local upGameFin = tonumber(upGameFin)
		if phase == "ended" then
			if upGameFin == 0 then
				storyboard.gotoScene("finishReward",{
					effect = "slideRight",
					time = 250,
					})
			else
				storyboard.gotoScene("playerMenu",{
					effect = "slideLeft",
					time = 250,
					})		
			end	
		end	
end	


function scene:createScene()
	screenGroup = self.view
	
local background = display.newImageRect  ("images/background.png", _W ,_H)
	background.x = _W * 0.5 ; background.y = _H * 0.5
	
local theEndtext = display.newImageRect("images/theend.png",300, 60)
	theEndtext.x = _W * 0.5 ; theEndtext.y = _H * 0.5	
	
	screenGroup:insert(background)
	screenGroup:insert(theEndtext)
	
end

function scene:enterScene()

local backToMenu = widget.newButton

{
	left = 40,
	top = 400,
	width = 250,
	height = 50,
	defaultFile = "images/backlong.png",
	overFile = "images/backlongpress.png",
	id = "gotomenu",
	onEvent = backMenu,
}	

button:insert(backToMenu)
achFinish()
upMe() --resets the level and era

end

function scene:overlayBegan()
	print ("overlay is shown")
end

function scene:overlayEnded()
	print ("overlay is removed")

end

function scene:exitScene()
	screenGroup:removeSelf()
	screenGroup = nil
	button:removeSelf()
	button = nil
end

function scene:didExitScene()
	storyboard.removeScene("theEnd")
end

scene:addEventListener ( "createScene", scene )
scene:addEventListener ( "enterScene", scene )
scene:addEventListener ( "overlayBegan", scene )
scene:addEventListener ( "overlayEnded", scene )
scene:addEventListener ( "exitScene", scene )
scene:addEventListener ( "didExitScene", scene )

return scene				