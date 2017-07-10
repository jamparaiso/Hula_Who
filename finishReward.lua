
print ("finishReward module-----------------------------")

local myData = require ( "myData" )
local systemConfigurations = require ( "systemConfigurations" )
local storyboard = require ( "storyboard" )
local widget = require ("widget")
local funcGetPlayerDat = require ( "funcGetPlayerDat" )
local updateGameCoin = require ( "updateGameCoin" )
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
local raySpin
local coinReward = 1000
local textReward

--rotates the ray on the back
local h = 0
local function rotRay()
	h = h + 1
	raySpin.rotation = h % 360
end

-------------------------------------------------------------------
--check achievement
-------------------------------------------------------------------

--coin achievement condition
local upPlayerAchData = {}
upPlayerAchData = funcGetPlayerAch.getPlayerAch("playerDB.sqlite", playerID)
local coll2k = upPlayerAchData.coll_2k
local coll3k = upPlayerAchData.coll_3k
local coll5k = upPlayerAchData.coll_5k
local lastColl = upPlayerAchData.lastColl
local totalPoint = upPlayerAchData.totalPoint
local collectCoin1 = myData.collectCoin1
local collectCoin2 = myData.collectCoin2
local collectCoin3 = myData.collectCoin3
local collectCoin4 = myData.collectCoin4
--achievement points
local coll1Point = myData.coin1
local coll2Point = myData.coin2
local coll3Point = myData.coin3
local coll4Point = myData.coin4
-- parammeters
local pMe1
local pMe2
local pMe3
local pMe4
local pMe5
local curCoin

local function showAch()

	storyboard.hideOverlay()
	storyboard.showOverlay("checkAchievement",{			
	effect = "fromBottom",
	time =350 ,
	})
end

local function checkMe(param)
	curCoin = param --players new coin

--stack of coin achievement	
		if tonumber(curCoin) >= tonumber(collectCoin1) and tonumber(coll2k) == 0  then
		--show overlay here
			print ("coin achievement 1 complete")

			totalPoint = tonumber(totalPoint + coll1Point)
			pMe1 = 1
			pMe2 = 0
			pMe3 = 0
			pMe4 = 0

			coll2k = 1	
			updateAchCoin.updateAchCoin(playerID,pMe1,pMe2,pMe3,pMe4,totalPoint)
				
			myData.whatAch = "Stack of coins" -- used for the achievement overlay
			timer.performWithDelay ( 500, showAch )
			return true
--pile of coin achievement	
		elseif curCoin >= collectCoin2 and tonumber(coll3k) == 0 then
			--show overlay here
			print ("coin achievement 2 complete")
			

			totalPoint = totalPoint + coll2Point
			pMe1 = 1
			pMe2 = 1
			pMe3 = 0
			pMe4 = 0

			coll3k = 1	
			updateAchCoin.updateAchCoin(playerID,pMe1,pMe2,pMe3,pMe4,totalPoint)	
			
			myData.whatAch = "Pile of coins" -- used for the achievement overlay
			
			timer.performWithDelay ( 500, showAch )
			return true
--bag of coin achievement								
		elseif curCoin >= collectCoin3 and tonumber(coll5k) == 0 then
			--show overlay here
			print ("coin achievement 3 complete")
			
				print ("player current point: " .. totalPoint)
				totalPoint = totalPoint + coll3Point
				pMe1 = 1
				pMe2 = 1
				pMe3 = 1
				pMe4 = 0
				coll5k = 1
				updateAchCoin.updateAchCoin(playerID,pMe1,pMe2,pMe3,pMe4,totalPoint)	
			
				myData.whatAch = "Bag of coins" -- used for the achievement overlay
			
				timer.performWithDelay ( 500, showAch )
				return true
--chest of coin achievement					
		elseif curCoin >= collectCoin4 and tonumber(lastColl) == 0 then
			--show overlay here			
			print ("coin achievement 4 complete")

				totalPoint = totalPoint + coll4Point
				pMe1 = 1
				pMe2 = 1
				pMe3 = 1
				pMe4 = 1
				lastColl = 1
				updateAchCoin.updateAchCoin(playerID,pMe1,pMe2,pMe3,pMe4,totalPoint)
			
				myData.whatAch = "Chest of coins" -- used for the achievement overlay			
			
				timer.performWithDelay ( 500, showAch )
				return true
		else
				return false
		end
end
----------------------------------------------------------------------------
--end for checking achievement
----------------------------------------------------------------------------

local function giveReward()

		print ("TOTAL REWARD: " .. coinReward)
		upCurCoins = upCurCoins + coinReward
		upAcqCoins = upAcqCoins + coinReward
		local curTime = upSlotUsed
		if tonumber(upCurCoins) >= 999999 then
			upCurCoins = 999999
		end	 
		updateGameCoin.upGameCoin(playerID,"playerDB.sqlite",upCurCoins, upAcqCoins,curTime)
		textReward.text = coinReward
		checkMe(upCurCoins)
end

local function backMenu(event)
	local phase = event.phase
		if phase == "ended" then

				if enableSound == true then
					audio.play(tapSound)
				end
				storyboard.gotoScene("playerMenu",{
					effect = "slideLeft",
					time = 250,
					})	
		end	
end	

function scene:createScene()
	screenGroup = self.view
	
local background = display.newImageRect  ("images/background.png", _W ,_H)
	background.x = _W * 0.5 ; background.y = _H * 0.5	
	
	raySpin = display.newImageRect ("images/rayrotate.png",480, 480 )
	raySpin.x = _W * 0.5 ; raySpin.y = _H * 0.5
	raySpin.alpha = .7
	
local neo = display.newImageRect ("images/neohappy.png" ,140 , 185)
		neo.x = _W * 0.5 ; neo.y = 300		
		
local rewardTxt = display.newImageRect ("images/gameFinishedReward.png",295,110)
	rewardTxt.x = _W * 0.5 ; rewardTxt.y = 140
	
local congratsImg = display.newImageRect ("images/eracongrats.png" ,317, 340 )
	  congratsImg.x = _W * 0.5 ; congratsImg.y = 200
	  
 textReward = display.newText ("000", _W * 0.5, 160,"Arial",_W*0.1 )
	textReward:setTextColor(255,255,255)
	
screenGroup:insert(background)
screenGroup:insert(raySpin)
screenGroup:insert(rewardTxt)
screenGroup:insert(congratsImg)
screenGroup:insert(neo)
screenGroup:insert(textReward)

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
giveReward()

audio.play(successSound)	
Runtime:addEventListener ("enterFrame", rotRay )	
end

function scene:exitScene()

	Runtime:removeEventListener ( "enterFrame", rotRay )
	screenGroup:removeSelf()
	screenGroup = nil
	button:removeSelf()
	button = nil
end

function scene:didExitScene()
	storyboard.removeScene("finishReward")
end

scene:addEventListener ( "createScene", scene )
scene:addEventListener ( "enterScene", scene )
scene:addEventListener ( "exitScene", scene )
scene:addEventListener ( "didExitScene", scene )

return scene				