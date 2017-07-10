
print ("congratsOverlay module-------------")

local myData = require ( "myData" )
local systemConfigurations = require ( "systemConfigurations" )
local storyboard = require ( "storyboard" )
local widget = require ("widget")
local funcGetPlayerDat = require ( "funcGetPlayerDat" )
local updateLevel = require ( "updateLevel" )
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
local successSound = myData.successSound
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
local button = display.newGroup()
local background
local raySpin
local neoPic = tonumber(upCurEra)

local unlockPic = neoPic + 1


--rotates the ray on the back
local h = 0
local function rotRay()
	h = h + 1
	raySpin.rotation = h % 360
end

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

--callback function for nextEraButton
local function goToNextEra(event)
	local phase = event.phase
		if phase == "ended" then

			if enableSound == true then
				audio.play(tapSound)
			end
				myData.lastQ = nil
				myData.lastQ = {}
				myData.qCount = 0
			storyboard.gotoScene("selectLevel",{
			effect = "slideRight",
			time = 250,	
				})	
		end
end

--updates the player era
local function upMe()
	local newLevel = 1
	local newEra = upCurEra + 1
	updateLevel.upLevel(playerID,newLevel,newEra)	
end	

--imageTables
local neoImg = {
{neoPath = "images/neoaccomplish.png"},
{neoPath = "images/neoaccomplish.png"},
{neoPath = "images/neoaccomplish.png"},
{neoPath = "images/neoaccomplish.png"},
}
local unlockText = {
{unlockPath = "images/unlockmiddletext.png"},--dummy
{unlockPath = "images/unlockmiddletext.png"},
{unlockPath = "images/unlockearlytext.png"},
{unlockPath = "images/unlockmoderntext.png"}, 		
}

function scene:createScene()
	screenGroup = self.view
		
local whatNeo = neoImg[neoPic].neoPath

local whatUnlock = unlockText[unlockPic].unlockPath

	background = display.newImageRect ( "images/background.png",  _W, _H )
	background.x = _W * 0.5 ; background.y = _H * 0.5
	
	raySpin = display.newImageRect ("images/rayrotate.png",480, 480 )
	raySpin.x = _W * 0.5 ; raySpin.y = _H * 0.5
	raySpin.alpha = .7
	
local congratsImg = display.newImageRect ("images/eracongrats.png" ,317, 340 )
	  congratsImg.x = _W * 0.5 ; congratsImg.y = 200
	  
local unlock = display.newImageRect(whatUnlock,300,55)
	 unlock.x = _W * 0.5 ; unlock.y = 110
	  
local neo = display.newImageRect (whatNeo,235,240)
	  neo.x = _W * 0.6 ; neo.y = 270
	  	  
	
	screenGroup:insert(background)
	screenGroup:insert(raySpin)
	screenGroup:insert(congratsImg)
	screenGroup:insert(unlock)
	screenGroup:insert(neo)
end


function scene:enterScene()
	
local nextEraButton = widget.newButton
{
	left = 45,
	top = 400,
	width = 240,
	height = 50,
	defaultFile = "images/nextera.png",
	overFile = "images/nexterapress.png",
	id = "nextEraButton",
	onEvent = goToNextEra,
}

button:insert(nextEraButton)
checkAchEra()
upMe()

if enableSound == true then
audio.play(successSound)
end
Runtime:addEventListener ("enterFrame", rotRay )
end

function scene:overlayBegan()
	print ("overlay is shown")
end

function scene:overlayEnded()
	print ("overlay is removed")

end	

function scene:exitScene()

	Runtime:removeEventListener ( "enterFrame", rotRay )
	screenGroup:removeSelf()
	screenGroup = nil
	button:removeSelf()
	button= nil
end

function scene:didExitScene()
	storyboard.removeScene("congratsOverlay")
end

scene:addEventListener ( "createScene", scene )
scene:addEventListener ( "enterScene", scene )
scene:addEventListener ( "overlayBegan", scene )
scene:addEventListener ( "overlayEnded", scene )
scene:addEventListener ( "exitScene", scene )
scene:addEventListener ( "didExitScene", scene )

return scene				