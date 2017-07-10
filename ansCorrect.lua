
print ("answer correct module----------------------")

local myData = require ( "myData" )
local systemConfigurations = require ( "systemConfigurations" )
local storyboard = require ( "storyboard" )
local widget = require ("widget")
local updateGameCoin = require ( "updateGameCoin" )
local funcGetPlayerDat = require ( "funcGetPlayerDat" )
local updateLevel = require ( "updateLevel" )
local funcGetPlayerAch = require ( "funcGetPlayerAch" )
local updateAchCoin = require ( "updateAchCoin" )
local scene = storyboard.newScene()
local physics = require("physics")
physics.start()
physics.setGravity( 0, 4 )

math.randomseed ( os.time() )

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
local correctSound = myData.correctSound
local correctSound2 = myData.correctSound2
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

local neo1,neo2,timerEvent,timerEvent1,timerEvent2

local button = display.newGroup ()
local neoDance = display.newGroup()
local conDrop = display.newGroup()
local screenGroup

local resTbl = {}
resTbl = myData.levelRestriction
local corAns = resTbl.corAns
local wroAns = resTbl.wroAns

local playCor = myData.playCor
local playWro = myData.playWro
local correctPic
local completePic
local nextButton
local textReward
local rewardPic
local nextLevelButton
local backButton
local textLevel
local myTimer
local neo
local fail
local raySpin

--rotates the ray on the back
local h = 0
local function rotRay()
	h = h + 1
	raySpin.rotation = h % 360
end

-- x animation
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
	curCoin = param --change this accroding to module coins variable handler

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


--give the player a random amount of  coin reward everytime he finish a level
--*********************************************************************
local coinReward
local function giveReward()

		print (upCurLevel)
		print (upCurEra)
		local upCurLevel = tonumber(upCurLevel)
		local upCurEra = tonumber(upCurEra)
		--for era 1
		if upCurEra == 1 and upCurLevel == 1 then
			coinReward = 30
			
		elseif upCurEra == 1 and upCurLevel == 2 then
			coinReward = 60
			
		elseif upCurEra == 1 and upCurLevel == 3 then
			coinReward = 90
			
		elseif upCurEra == 1 and upCurLevel == 4 then
			coinReward = 120
			
		elseif upCurEra == 1 and upCurLevel == 5 then
			coinReward = 150
			
		elseif upCurEra == 1 and upCurLevel == 6 then
			coinReward = 180
			
		elseif upCurEra == 1 and upCurLevel == 7 then
			coinReward = 210

		elseif upCurEra == 1 and upCurLevel == 8 then
			coinReward = 240
		
		elseif upCurEra == 1 and upCurLevel == 9 then
			coinReward = 270
			
		elseif upCurEra == 1 and upCurLevel == 10 then
			coinReward = 300
--era 2			
			
		elseif upCurEra == 2 and upCurLevel == 1 then
			coinReward = 30
			
		elseif upCurEra == 2 and upCurLevel == 2 then
			coinReward = 60
			
		elseif upCurEra == 2 and upCurLevel == 3 then
			coinReward = 90
			
		elseif upCurEra == 2 and upCurLevel == 4 then
			coinReward = 120
			
		elseif upCurEra == 2 and upCurLevel == 5 then
			coinReward = 150
			
		elseif upCurEra == 2 and upCurLevel == 6 then
			coinReward = 180
			
		elseif upCurEra == 2 and upCurLevel == 7 then
			coinReward = 210

		elseif upCurEra == 2 and upCurLevel == 8 then
			coinReward = 240
		
		elseif upCurEra == 2 and upCurLevel == 9 then
			coinReward = 270
			
		elseif upCurEra == 2 and upCurLevel == 10 then
			coinReward = 300
									
--for era 3
	
		elseif upCurEra == 3 and upCurLevel == 1 then
			coinReward = 30
			
		elseif upCurEra == 3 and upCurLevel == 2 then
			coinReward = 60
			
		elseif upCurEra == 3 and upCurLevel == 3 then
			coinReward = 90
			
		elseif upCurEra == 3 and upCurLevel == 4 then
			coinReward = 120
			
		elseif upCurEra == 3 and upCurLevel == 5 then
			coinReward = 150
			
		elseif upCurEra == 3 and upCurLevel == 6 then
			coinReward = 180
			
		elseif upCurEra == 3 and upCurLevel == 7 then
			coinReward = 210

		elseif upCurEra == 3 and upCurLevel == 8 then
			coinReward = 240
		
		elseif upCurEra == 3 and upCurLevel == 9 then
			coinReward = 270
			
		elseif upCurEra == 3 and upCurLevel == 10 then
			coinReward = 300
			
		elseif upCurEra == 3 and upCurLevel == 11 then
			coinReward = 330
			
		elseif upCurEra == 3 and upCurLevel == 12 then
			coinReward = 360
			
		elseif upCurEra == 3 and upCurLevel == 13 then
			coinReward = 390
			
		elseif upCurEra == 3 and upCurLevel == 14 then
			coinReward = 420
			
		elseif upCurEra == 3 and upCurLevel == 15 then
			coinReward =450															

--era 4
		elseif upCurEra == 4 and upCurLevel == 1 then
			coinReward = 30
			
		elseif upCurEra == 4 and upCurLevel == 2 then
			coinReward = 60
			
		elseif upCurEra == 4 and upCurLevel == 3 then
			coinReward = 90
			
		elseif upCurEra == 4 and upCurLevel == 4 then
			coinReward = 120
			
		elseif upCurEra == 4 and upCurLevel == 5 then
			coinReward = 150
			
		elseif upCurEra == 4 and upCurLevel == 6 then
			coinReward = 180
			
		elseif upCurEra == 4 and upCurLevel == 7 then
			coinReward = 210

		elseif upCurEra == 4 and upCurLevel == 8 then
			coinReward = 240
		
		elseif upCurEra == 4 and upCurLevel == 9 then
			coinReward = 270
			
		elseif upCurEra == 4 and upCurLevel == 10 then
			coinReward = 300
			
		elseif upCurEra == 4 and upCurLevel == 11 then
			coinReward = 330
			
		elseif upCurEra == 4 and upCurLevel == 12 then
			coinReward = 360
			
		elseif upCurEra == 4 and upCurLevel == 13 then
			coinReward = 390
			
		elseif upCurEra == 4 and upCurLevel == 14 then
			coinReward = 420
			
		elseif upCurEra == 4 and upCurLevel == 15 then
			coinReward = 450																															
		end

		print ("total Reward: " .. coinReward)
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

local function checkUpLevel()
	local upCurEra = tonumber(upCurEra)
	local upCurLevel = tonumber(upCurLevel)
	local ancientLevel = myData.ancientLevel
	local middleLevel = myData.middleLevel
	local earlyLevel = myData.earlyLevel
	local modernLevel = myData.modernLevel
	local newLevel


--ancient era----------------------------------------------
--*********************************************************	
	if upCurEra == 1 then --ancient era
		
		if upCurLevel ~= 10 then --player is not in era's last level
			newLevel = upCurLevel + 1 -- add 1 level
			updateLevel.upLevel(playerID,newLevel,upCurEra)
			print ("player is in new level")
				myData.lastQ = nil
				myData.lastQ = {}
				myData.qCount = 0
				storyboard.gotoScene("gameRestrictions",{ --go to the next level
				effect = "slideLeft",
				time = 250,
				})
		elseif upCurLevel == ancientLevel and upCurEra == 1 then --player is in last level, unlocked next era
			print ("player unlocked new era")
				storyboard.gotoScene("congratsOverlay",{ --go to the next level
				effect = "slideLeft",
				time = 250,
				})			
		end
--middle ages----------------------------------------------
--*********************************************************	
	elseif upCurEra == 2 then -- middle ages
	
		if upCurLevel ~= 10 then --player is not in era's last level
			newLevel = upCurLevel + 1 -- add 1 level
			updateLevel.upLevel(playerID,newLevel,upCurEra)
			print ("player is in new level")
				myData.lastQ = nil
				myData.lastQ = {}
				myData.qCount = 0
				storyboard.gotoScene("gameRestrictions",{ --go to the next level
				effect = "slideLeft",
				time = 250,
				})	
		elseif upCurLevel == middleLevel and upCurEra == 2 then --player is in last level, unlocked next era
			print ("player unlocked new era")	
				storyboard.gotoScene("congratsOverlay",{ --go to the next level
				effect = "slideLeft",
				time = 250,
				})	
		end
--early modern age------------------------------------------
--**********************************************************
	elseif upCurEra == 3 then --early age
	
		if upCurLevel ~= 15 then --player is not in era's last level
			newLevel = upCurLevel + 1 -- add 1 level
			updateLevel.upLevel(playerID,newLevel,upCurEra)
			print ("player is in new level")
				myData.lastQ = nil
				myData.lastQ = {}
				myData.qCount = 0
				storyboard.gotoScene("gameRestrictions",{ --go to the next level
				effect = "slideLeft",
				time = 250,
				})	
		elseif upCurLevel == earlyLevel and upCurEra == 3 then --player is in last level, unlocked next era
			print ("player unlocked new era")
				storyboard.gotoScene("congratsOverlay",{ --go to the next level
				effect = "slideLeft",
				time = 250,
				})		
		end
--modern age-------------------------------------------------
--***********************************************************	
	elseif upCurEra == 4 then --modern age
	
		if upCurLevel ~= 15 then --player is not in era's last level
			newLevel = upCurLevel + 1 -- add 1 level
			updateLevel.upLevel(playerID,newLevel,upCurEra)
			print ("player is in new level")
				myData.lastQ = nil
				myData.lastQ = {}
				myData.qCount = 0
				storyboard.gotoScene("gameRestrictions",{ --go to the next level
				effect = "slideLeft",
				time = 250,
				})	
		elseif upCurLevel == modernLevel and upCurEra == 4 then --player is in last level, unlocked next era
			print ("player unlocked new era")
				storyboard.gotoScene("gameFinishScene1",{ --go to the next level
				effect = "slideLeft",
				time = 250,
				})		
		end
--nothing found-------------------------------------------------
--**************************************************************	
	else
	 print ("Invalid Era")	
	end
end	

--check if the player finish the level or not
--************************************************
local function checkIfFinish(playCor,corAns,playWro,wroAns)
	local playCor = tonumber(playCor)
	local corAns = tonumber(corAns)
	local playWro = tonumber(playWro)
	local wroAns = tonumber(wroAns)
	local upCurEra = tonumber(upCurEra)
	local upCurLevel = tonumber(upCurLevel)
	local ancientLevel = myData.ancientLevel
	local middleLevel = myData.middleLevel
	local earlyLevel = myData.earlyLevel
	local modernLevel = myData.modernLevel
	
-- level is not yet complete	
	if playCor ~= corAns then
		print ("correct answer")
		nextButton.alpha = 1
		correctPic.alpha = 0
		completePic.alpha = 0
		
neo1 = display.newImageRect("images/neohappy21.png",140,185 )
neo1.x = _W * 0.5 ; neo1.y = 300
neo1.alpha = 0
neoDance:insert(neo1)

neo2 = display.newImageRect("images/neohappy22.png",140,185 )
neo2.x = _W * 0.5 ; neo2.y = 300
neo2.alpha = 0
neoDance:insert(neo2)

--local function showAnswer()


--end

	    fail = display.newImageRect("images/checkbig.png",100,100)
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
	choice = math.random(1,6)
	local confetti
	
	if choice == 1 then
		confetti = display.newImage( "images/bluetri.png" )
		confetti.width = 9
		confetti.height = 9
		confetti.x = 2 + math.random( 0,310 ); confetti.y = 5
		physics.addBody( confetti, { density=0.6, friction=0.6, bounce=.6, radius=5 } )
		confetti.angularVelocity = math.random(800) - 400
		confetti.isSleepingAllowed = false
		conDrop:insert(confetti)
	
	elseif choice == 2 then
		confetti = display.newImage( "images/green.png" )
				confetti.width = 9
		confetti.height = 9
		confetti.x = 2 + math.random( 0,310 ); confetti.y = 5
		physics.addBody( confetti, { density=0.6, friction=0.6, bounce=.6, radius=5 } )
		confetti.angularVelocity = math.random(600) - 300
		confetti.isSleepingAllowed = false
		conDrop:insert(confetti)
		
	elseif choice == 3 then
		confetti = display.newImage( "images/greentri.png" )
				confetti.width = 9
		confetti.height = 9
		confetti.x = 2 + math.random( 0,310 ); confetti.y = 5
		physics.addBody( confetti, { density=0.6, friction=0.6, bounce=.6, radius=5 } )
		confetti.angularVelocity = math.random(600) - 300
		confetti.isSleepingAllowed = false
		conDrop:insert(confetti)

	elseif choice == 4 then
		confetti = display.newImage( "images/purpletri.png" )
				confetti.width = 9
		confetti.height = 9
		confetti.x = 2 + math.random( 0,310 ); confetti.y = 5
		physics.addBody( confetti, { density=0.6, friction=0.6, bounce=.6, radius=5 } )
		confetti.angularVelocity = math.random(600) - 300
		confetti.isSleepingAllowed = false
		conDrop:insert(confetti)

	elseif choice == 5 then
		confetti = display.newImage( "images/red.png" )
				confetti.width = 9
		confetti.height = 9
		confetti.x = 2 + math.random( 0,310 ); confetti.y = 5
		physics.addBody( confetti, { density=0.6, friction=0.6, bounce=.6, radius=5 } )
		confetti.angularVelocity = math.random(600) - 300
		confetti.isSleepingAllowed = false
		conDrop:insert(confetti)

	elseif choice == 6 then
		confetti = display.newImage( "images/yellow.png" )
				confetti.width = 9
		confetti.height = 9
		confetti.x = 2 + math.random( 0,310 ); confetti.y = 5
		physics.addBody( confetti, { density=0.6, friction=0.6, bounce=.6, radius=5 } )
		confetti.angularVelocity = math.random(600) - 300
		confetti.isSleepingAllowed = false
		conDrop:insert(confetti)		
	
	end
	
	conTbl[#conTbl + 1] = confetti	
end
	    --button:insert(neo)

	    timerEvent = timer.performWithDelay (200,danceNeo,-1)
		myTimer = timer.performWithDelay( 10, makeFailSmall,10 )
		--showAnswer()
		timerEvent2 = timer.performWithDelay(200,ranConfetti,-1)
		button:insert(fail)
			if enableSound == true then
				local ran = math.random(1,2)
					if ran == 1 then
						audio.play(correctSound)
					elseif ran == 2 then
						audio.play(correctSound2)
					end	
			end			
--level complete
	elseif playCor == corAns then
	
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
	 	
		print("level complete")
		giveReward()
		correctPic.alpha = 0	
		nextButton.alpha = 0
		nextLevelButton.alpha = 1
		backButton.alpha =1

		textReward.alpha = 1
		rewardPic.alpha = 1

		completePic.alpha = 1
		textLevel.text = upCurLevel
		textLevel.alpha = 1
		raySpin.alpha = 1
		if enableSound == true then
		audio.play(successSound)	
		end
	end
	
--hides the back button if the player reached the last level of an era	
	if upCurLevel == ancientLevel and upCurEra == 1 then
		backButton.alpha = 0
	elseif upCurLevel == middleLevel and upCurEra == 2 then
		backButton.alpha = 0
	elseif upCurLevel == earlyLevel and upCurEra == 3 then
		backButton.alpha = 0
	elseif upCurLevel == modernLevel and upCurEra == 4 then
		backButton.alpha = 0				
	end		

end	

--callback function for next button
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


--callback function for nextlevel button
local function nextLevel(event)
	local phase = event.phase
		if phase == "ended" then
			print ("nextlevel is press and released")
				if enableSound == true then
					audio.play(tapSound)
				end
				myData.playCor = 0
				myData.playWro = 0
				myData.lastQ = nil
				myData.lastQ = {}
				checkUpLevel()	
		end	
end

--callback function for back to menubutton
local function backToMenu(event)
	local phase = event.phase
		if phase == "ended" then
				print ("back to menu is pressed and released")
				if enableSound == true then
					audio.play(tapSound)
				end
				myData.playCor = 0
				myData.playWro = 0
				myData.lastQ = nil
				myData.lastQ = {}
				myData.qCount = 0
				checkUpLevel()
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
			  
	 		correctPic = display.newImageRect (  "images/correct.png" , 250, 40 )
			 correctPic.x = _W * 0.5 ; correctPic.y = 80
			 correctPic.alpha = 0
			 
	 		completePic = display.newImageRect (  "images/levelcompletetext.png" , 320, 165 )
			 completePic .x = _W * 0.5 ; completePic.y = 120
			 completePic.alpha = 0
			 
			 rewardPic = display.newImageRect ( "images/rewardText.png" , 240, 110 )
			 rewardPic.x = _W * 0.5 ;rewardPic.y = 290
			 rewardPic.alpha = 0
			 
			raySpin = display.newImageRect ("images/rayrotate.png",480, 480 )
			raySpin.x = _W * 0.5 ; raySpin.y = _H * 0.5
			raySpin.alpha = .7
			raySpin.alpha = 0			 
			 
			 textReward = display.newText(  "00", _W * 0.5, 290, fontStyle, _W*0.1 )
			 textReward:setTextColor ( 255, 255, 255 )
			 textReward.alpha = 0
			 
			 textLevel = display.newText(  "00", _W * 0.44, 150, fontStyle, _W *0.09 )
			 textLevel:setTextColor ( 255, 255, 255 )
			 textLevel.alpha = 0
			  
	screenGroup:insert(background)
	screenGroup:insert(raySpin)
	screenGroup:insert(correctPic)
	screenGroup:insert(completePic)
	screenGroup:insert(rewardPic)
	screenGroup:insert(textReward)
	screenGroup:insert(textLevel)		  
	
end


function scene:enterScene()

nextButton = widget.newButton
{
	left = 100,
	top = 400,
	width = 100,
	height = 50,
	defaultFile = "images/next.png",
	overFile = "images/nextpress.png",
	id = "nextButton",
	onEvent = reloadGameProper,
}

nextLevelButton = widget.newButton
{
	left = 40,
	top = 350,
	width = 250,
	height = 50,
	defaultFile = "images/nextlevel.png",
	overFile = "images/nextlevelpress.png",
	id = "nextLevel",
	onEvent = nextLevel,
}
nextLevelButton.alpha = 0

backButton = widget.newButton
{
	left = 40,
	top = 400,
	width = 250,
	height = 50,
	defaultFile = "images/backlong.png",
	overFile = "images/backlongpress.png",
	id = "nextLevel",
	onEvent = backToMenu,
}
backButton.alpha = 0
	
button:insert(nextButton)
button:insert(nextLevelButton)
button:insert(backButton)
checkIfFinish(playCor,corAns,playWro,wroAns)
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
	storyboard.removeScene("ansCorrect")
end

scene:addEventListener ( "createScene", scene )
scene:addEventListener ( "enterScene", scene )
scene:addEventListener ( "overlayBegan", scene )
scene:addEventListener ( "overlayEnded", scene )
scene:addEventListener ( "exitScene", scene )
scene:addEventListener ( "didExitScene", scene )

return scene				