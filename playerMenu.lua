
print ("playerMenu module-------------------------------------------")

local storyboard = require ( "storyboard" )
local myData = require ("myData")
local widget = require ("widget")
local systemConfigurations = require ( "systemConfigurations" )
local loadNewPlayerData = require ("loadNewPlayerData")
local fetchSaveData = require ( "fetchSaveData" )
local funcGetPlayerDat = require ("funcGetPlayerDat")
local funcGetPlayerAch = require ( "funcGetPlayerAch" )
local updateAchCoin = require ( "updateAchCoin" )
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

local param =myData.loadPlayerData
print ("playerMenu")
print (param)
local loadPlayer = {}


local screenGroup
local button = display.newGroup ( )
local myTimer
local slotCoolDown = 1800 -- 30 min
local eraPic

--initialize player data
loadPlayer = loadNewPlayerData.loadPlayerData()
local playerID = loadPlayer.player_ID

local playerName = loadPlayer.player_Name

myData.currentPlayerID = nil
myData.currentPlayerID = playerID
local upPlayerData = {}
upPlayerData = funcGetPlayerDat.getPlayerDat("playerDB.sqlite",playerID)
print ("updated player name: " .. upPlayerData.player_Name)

myData.playerDat = upPlayerData

--updates the player achievement data in myData
local upPlayerAchData = {}
upPlayerAchData = funcGetPlayerAch.getPlayerAch("playerDB.sqlite",playerID)

myData.playerAchievement = upPlayerAchData

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

local slotMachineButton
local slotNotMachineButton

--play button callback function
local function startGame(event)
	local phase = event.phase
		if phase == "ended" then
			print ("play button has been pressed and released")
				if enableSound ==true then
					audio.play (tapSound)
				end
				storyboard.gotoScene ( "selectLevel",{
				effect = "slideLeft",
				time = 250,
				})
		end	
end

--slot button callback function
local function slotPlay(event)
	local phase = event.phase
		if phase == "ended" then
			print ("slot button has been pressed and released")
				if enableSound == true then
					audio.play(tapSound)
				end
				storyboard.gotoScene ("slots",{
				effect ="slideLeft",
				time = 250,
				})	
		end	
end

local function lockedSlotMachine(event)
	local phase = event.phase
		if phase == "ended" then
			print ("slot machine is not available")
		end			
end

--slot machtime time count down
local curTime = os.time ()
	print ("os time: " .. curTime)
local slotLastUse = upSlotUsed
	print ("slot last used: " .. slotLastUse)
local coolTime = "Slot Ready"

local function timeCount(numSec)
	local nSeconds = numSec
		if nSeconds == 0 then

			coolTime.text = "Slot Ready";
		else
			local nHours = string.format("%02.f", math.floor(nSeconds/3600));
			local nMins = string.format("%02.f", math.floor(nSeconds/60 - (nHours*60)));
			local nSecs = string.format("%02.f", math.floor(nSeconds - nHours*3600 - nMins *60));
			
			coolTime.text =  nHours..":"..nMins..":"..nSecs
		end
end		

--checks if the slot machine available or not
local function checkSlotTime()

	local timeSince = (curTime - slotLastUse)
     if timeSince >= slotCoolDown then 
          print ("slot is ready")
          coolTime.text = "Slot Ready"
          slotMachineButton.alpha  = 1
          slotNotMachineButton.alpha = 0
      else
      	slotLastUse = slotLastUse - 1
      	print (slotLastUse)
      	timeCount(slotCoolDown-timeSince)
      	print ("slot is NOT ready")
      	 slotNotMachineButton.alpha = 1
      	 slotMachineButton.alpha  = 0
     end  
end

local function seeAchievements(event)
	local phase = event.phase
		if phase == "ended" then
		 print ("achievements button has been pressed and released")
			if enableSound == true then
				audio.play(tapSound)
			end
			--updateAchCoin.updateAchCoin(playerID,1,1,1,1,1)--check the player coins if it complete a achievement
			storyboard.gotoScene("seeAchievements",{
			effect = "slideRight",
			time = 250,	
				})	
		end	
end	

--back to menu callback function
local function backToMenu(event)
	local phase = event.phase
		if phase == "ended" then
			print ("back button has been pressed and released")
				if enableSound == true then
					audio.play(tapSound)
				end
				myData.loadPlayerData = nil
				myData.currentPlayerID = nil
				myData.loadPlayerTable = nil
				myData.playerDat = nil
				myData.playerAchievement = nil
				loadNewPlayerData.result = nil

				fetchSaveData.dataTable = nil
				upPlayerData = nil
				loadPlayer = nil
				storyboard.gotoScene("mainmenu",{
				effect="slideRight",
				time = 250,
				})	
		end	
end
			

function scene:createScene()
	screenGroup = self.view
	
	local background = display.newImageRect ( "images/background.png",   _W, _H )
	background.x=_W * 0.5 ; background.y=_H *0.5
	
	local topBar = display.newImageRect (  "images/topBar.png",  _W, 40 )
	topBar.x =_W * 0.5 ; topBar.y = 20
	
	local coinsImage = display.newImageRect (  "images/coins.png" , 100, 40 )
	coinsImage.x = _W - 50 ; coinsImage.y = 20
	
	local playerCoin = display.newText( upCurCoins ,_W-60, 12, fontStyle, _W * 0.05 )
	playerCoin:setReferencePoint ( display.CenterLeftReferencePoint )
	playerCoin:setTextColor ( 255, 255, 255  )
	
	local topRed = display.newImageRect ( "images/slotMini.png" , 100, 35 )
		topRed.x = 60 ; topRed.y = 20
	
	coolTime = display.newText("00:00:00", 40, 19, fontStyle, _W * 0.05 )
	coolTime:setReferencePoint ( display.CenterLeftReferencePoint )
	coolTime:setTextColor ( 255, 255, 255  )
	
	local helloPlayer = display.newText(  "Hello " .. upPlayerName .. " !", 0, 0, fontStyle, 25 )
		  helloPlayer.x = _W * 0.5 ; helloPlayer.y = 260 	

	local function eraImage(param)
		local param = tonumber(param)
		if param == 1 then
			print ("ancient period")
			eraPic = display.newImageRect (  "images/ancientPeriod.png" , 300, 200 )
			eraPic.x = _W * 0.5 ; eraPic.y = 150
			
		elseif param == 2 then
			print ("middle ages")
			eraPic = display.newImageRect (  "images/middleAges.png" , 300, 200 )
			eraPic.x = _W * 0.5 ; eraPic.y = 150
			
		elseif param == 3 then
			print ("early modern ages")
			eraPic = display.newImageRect (  "images/earlyModernAges.png" , 300, 200 )
			eraPic.x = _W * 0.5 ; eraPic.y = 150
			
		elseif param == 4 then
			print ("modern age")
			eraPic = display.newImageRect (  "images/modernAge.png" , 300, 200 )
			eraPic.x = _W * 0.5 ; eraPic.y = 150
		end		
	end
	eraImage(upCurEra)
		
		--checks the slot machine every seconds
	myTimer = timer.performWithDelay(1000,checkSlotTime,0)

	
	screenGroup:insert(background)
	screenGroup:insert(topBar)
	screenGroup:insert(coinsImage)
	screenGroup:insert(helloPlayer)
	screenGroup:insert(playerCoin)
	screenGroup:insert(topRed)
	screenGroup:insert(coolTime)
	screenGroup:insert(eraPic)
	
end


function scene:enterScene()
	if enableMusic == true then
		if myData.backMusicHandler == nil then
			print ("------------------PLAY BACKGROUND MUSIC")
			local backMusicHandler
	 		backMusicHandler = audio.play(backMusic, {loops=-1} )
	 		myData.backMusicHandler = backMusicHandler
	 		print ("-----------------BACKGROUND MUSIC CHANNEL: " .. backMusicHandler)
		end	
	end
		
local playButton = widget.newButton
{
	top = 280,
	left = 40,
	width = 250,
	height = 40,
	defaultFile = "images/playlong.png",
	overFile = "images/playlongpress.png",
	onEvent = startGame,
	
}

slotMachineButton = widget.newButton
{
	top = 330,
	left = 40,
	width = 250,
	height = 40,
	defaultFile = "images/slotmachine.png",
	overFile = "images/slotmachinepress.png",
	onEvent = slotPlay,
}
slotMachineButton.alpha = 0

slotNotMachineButton = widget.newButton
{
	top = 330,
	left = 40,
	width = 250,
	height = 40,
	defaultFile = "images/slotmachinelock.png",
	overFile = "images/slotmachinelock.png",
	onEvent = lockedSlotMachine,
}
slotNotMachineButton.alpha = 1

local achievementButton = widget.newButton
{
	top = 380,
	left = 40,
	width = 250,
	height = 40,
	defaultFile = "images/achievements.png",
	overFile = "images/achievementspress.png",
	onEvent = seeAchievements,
}

local backButton = widget.newButton
{
	top =430,
	left = 40,
	width = 250,
	height = 40,
	defaultFile = "images/backlong1.png",
	overFile = "images/backlongpress1.png",
	onEvent = backToMenu,
}


button:insert(playButton)
button:insert(slotMachineButton)
button:insert(slotNotMachineButton)
button:insert(achievementButton)
button:insert(backButton)

end

function scene:exitScene()
	timer.cancel (myTimer)
	myTimer = nil
	button:removeSelf()
	button = nil
	screenGroup:removeSelf()
	screenGroup = nil
	print ("playerMenu unloaded ------------------------------")
end			

function scene:didExitScene()
	storyboard.removeScene("playerMenu")
end

function scene:destroyScene()
end

scene:addEventListener ( "createScene",scene )
scene:addEventListener ( "enterScene", scene )
scene:addEventListener ( "exitScene", scene )
scene:addEventListener ( "didExitScene", scene )
scene:addEventListener ( "destroyScene", scene )

return scene		