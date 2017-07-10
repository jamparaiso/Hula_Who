
print ("game proper module-----------------------------------------")

local myData = require ("myData")
local widget = require ("widget")
local systemConfigurations = require ( "systemConfigurations" )
local funcGetPlayerDat = require ("funcGetPlayerDat")
local storyboard = require( "storyboard" )
local generateQuestion =require ( "generateQuestion" )
local hintUsed = require ( "hintUsed" )
local updateCorWro = require ( "updateCorWro" )
local funcGetPlayerAch = require ( "funcGetPlayerAch" )
local  updateAchHint = require ( "updateAchHint" )
local makeSysConfig = require ("makeSystemConfig")
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
local clockTick = myData.clockTick
local backMusic = myData.backMusic
local questionMusic = myData.questionMusic
local enableSound = gameSettings.soundOn
local enableMusic = gameSettings.musicOn
local alert1,alert2,alert3,alert4
local alertS1 = 0
local alertS2 = 0
local alertS3 = 0
local alertS4 = 0
local questionMusicHandler

local screenGroup
local button = display.newGroup ( )
local descButton
local nameButton
local fifButton
local aButton
local bButon
local cButton
local dButton
local invImg
local playerCoin
local textTime
local textCor
local textWro
local hintName
local hintDesc
local countTime
local timerEvent
local fifHintCost = 500
local nameHintCost = 250
local igSoundButtonOn
local igSoundButtonOff
local igMusicButtonOn
local igMusicButtonOff


math.randomseed ( os.time() )

--updates the player data in myData
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



local qTable
local sciName
local invName
local imagePath
local discDate
local briefDesc
local choice1
local choice2
local choice3
local ans
local clockSound

--gets the restrictions in myData
local levelRes = {}
levelRes = myData.levelRestriction
local timeRes = levelRes.timeRes
local corAns = levelRes.corAns
local wroAns = levelRes.wroAns
local playCor = myData.playCor
local playWro = myData.playWro
local lastQ

-------------------------------------------------------------------
--check achievement
-------------------------------------------------------------------
--player achievement data
local upPlayerAchData = {}
upPlayerAchData = funcGetPlayerAch.getPlayerAch("playerDB.sqlite", playerID)
local hint1 = upPlayerAchData.hint1
local hint2 = upPlayerAchData.hint2
local hint3 = upPlayerAchData.hint3
local hint4 = upPlayerAchData.hint4
local totalPoint = upPlayerAchData.totalPoint
--achievement condition
local useHint1 = myData.useHint1
local useHint2 = myData.useHint2
local useHint3 = myData.useHint3
local useHint4 = myData.useHint4
--achievement points
local hintUse1 = myData.hintUse1
local hintUse2 = myData.hintUse2
local hintUse3 = myData.hintUse3
local hintUse4 = myData.hintUse4
-- parammeters
local pMe1
local pMe2
local pMe3
local pMe4
local pMe5
local curHint


local function showAch()

	storyboard.hideOverlay()
	storyboard.showOverlay("checkAchievement",{
	isModal = true,				
	effect = "fromBottom",
	time =350 ,
	})
end

local function checkMe(param)
	curHint = param

--stack of coin achievement
		if tonumber(curHint) >= tonumber(useHint1) and tonumber(hint1) == 0  then
		--show overlay here


			totalPoint = totalPoint + hintUse1
			pMe1 = 1
			pMe2 = 0
			pMe3 = 0
			pMe4 = 0

			hint1 = 1 	
			updateAchHint.updateAchHint(playerID,pMe1,pMe2,pMe3,pMe4,totalPoint)
				
			myData.whatAch = "Hint user" -- used for the achievement overlay
			timer.performWithDelay ( 500, showAch )
			return true
--pile of coin achievement	
		elseif tonumber(curHint) >= tonumber(useHint2) and tonumber(hint2) == 0 then
			--show overlay here


			totalPoint = totalPoint + hintUse2
			pMe1 = 1
			pMe2 = 1
			pMe3 = 0
			pMe4 = 0

			hint2 = 1
				
			updateAchHint.updateAchHint(playerID,pMe1,pMe2,pMe3,pMe4,totalPoint)	
			
			myData.whatAch = "Hint buyer" -- used for the achievement overlay
			
			timer.performWithDelay ( 500, showAch )
			return true
--bag of coin achievement								
		elseif tonumber(curHint) >= tonumber(useHint3) and tonumber(hint3) == 0 then
			--show overlay here


				totalPoint = totalPoint + hintUse3
				pMe1 = 1
				pMe2 = 1
				pMe3 = 1
				pMe4 = 0
				
				hint3 = 1
				
				updateAchHint.updateAchHint(playerID,pMe1,pMe2,pMe3,pMe4,totalPoint)
			
				myData.whatAch = "Hint customer" -- used for the achievement overlay
			
				timer.performWithDelay ( 500, showAch )
				return true
--chest of coin achievement		
			
		elseif tonumber(curHint) >= tonumber(useHint4) and tonumber(hint4) == 0 then
			--show overlay here			
				totalPoint = totalPoint + hintUse4
				pMe1 = 1
				pMe2 = 1
				pMe3 = 1
				pMe4 = 1
				
				hint4 = 1
				
				updateAchHint.updateAchHint(playerID,pMe1,pMe2,pMe3,pMe4,totalPoint)
			
				myData.whatAch = "Hint shopper" -- used for the achievement overlay			
			
				timer.performWithDelay ( 500, showAch )
				return true
		else
				return false
		end
end
----------------------------------------------------------------------------
--end for checking achievement
----------------------------------------------------------------------------

local function shuffle(t)--if you notice the 't' in shuffle(t) this is the actual table tb it self.
    local iterations = #t --gets the length of the table

    	for i = iterations, 2, -1 do --this is a reverse looping, we start on the max length of the tb, and for every loop we minus 1 to the i, 
								 				    --this loop will stop at 2
        	j = math.random(i)
        		t[i], t[j] = t[j], t[i]
			--[[In this case, it's simply taking t[j] and putting it into t[i], while at the same time taking t[i] and putting it in t[j].
						This seems weird because you would think it would overwrite each other.  In traditional languages you would do:
						local tmp = t[i]
						t[i] = t[j]
						t[j] = tmp
			]] --
    	end
end

--shuffles the answers and position them accordingly
--*****************************************************************
local function initAns(param1,param2,param3,param4)
	local ansTable = {param1,param2,param3,param4}

	shuffle(ansTable) --shuffle the table data

	local leftPos
	local topPos
	ans = {}

		for i=1,#ansTable do --prints all the data on the table,
				if i == 1 then
						leftPos = 50
						topPos = 365
						ans[i] = display.newText( ansTable[i], 100, 100, fontStyle, _W * 0.03 )
						ans[i]:setReferencePoint ( display.CenterLeftReferencePoint )
						ans[i]:setTextColor ( 255, 255, 255 )
						ans[i].x = leftPos ; ans[i].y = topPos

						aButton.id = ansTable[i]
				
				elseif i == 2 then
						leftPos = 200
						topPos = 365
						ans[i] = display.newText( ansTable[i], 100, 100, fontStyle, _W * 0.03 )
						ans[i]:setReferencePoint ( display.CenterLeftReferencePoint )				
						ans[i]:setTextColor ( 255, 255, 255  )
						ans[i].x = leftPos ; ans[i].y = topPos		
	
						bButton.id = ansTable[i]		
				
				elseif i == 3 then
						leftPos = 50
						topPos = 430
						ans[i] = display.newText( ansTable[i], 100, 100, fontStyle, _W * 0.03 )
						ans[i]:setReferencePoint ( display.CenterLeftReferencePoint )				
						ans[i]:setTextColor ( 255, 255, 255  )
						ans[i].x = leftPos ; ans[i].y = topPos
		
						cButton.id = ansTable[i]				
				
				elseif i == 4 then
				
						leftPos = 200
						topPos = 430
						ans[i] = display.newText( ansTable[i], 100, 100, fontStyle, _W * 0.03 )
						ans[i]:setReferencePoint ( display.CenterLeftReferencePoint )				
						ans[i]:setTextColor ( 255, 255, 255  )
						ans[i].x = leftPos ; ans[i].y = topPos
			
						dButton.id = ansTable[i]				
				
				end
					button:insert(ans[i])
		end
end


--generate random question
--*************************************************
local function getQuestion()
	upCurEra = tonumber(upCurEra)
	local ran

	local curQuestion = nil
	qTable = {}
	qTable = myData.lastQ
	
--for ancient era---------------------------------------------
--------------------------------------------------------------
		if upCurEra == 1 then
			print ("GENERATING ANCIENT ERA QUESTION")
			if #qTable == 0 then
			qTable  = generateQuestion.genQuestion("ancientDB",upCurLevel)
			print ("LEVEL " .. upCurLevel .." questions: " .. #qTable)
			shuffle(qTable) --shuffles the table
			myData.lastQ = qTable --save the table in myData
			qTable = myData.lastQ
			ran = myData.qCount + 1
			myData.qCount = ran
				for i = 1, #qTable do
					local a = qTable[i].invName
					print (a)
				end
			else
			qTable = myData.lastQ
				for i = 1, #qTable do
					local a = qTable[i].invName
					print (a)
				end	
			ran = myData.qCount + 1
			myData.qCount = ran
			end


			qID = qTable[ran].qID
			sciName = qTable[ran].sciName
			invName = qTable[ran].invName
			imagePath = qTable[ran].imagePath
			discDate = qTable[ran].discDate
			briefDesc = qTable[ran].briefDesc
			choice1 = qTable[ran].choice1
			choice2 = qTable[ran].choice2
			choice3 = qTable[ran].choice3
			
			
			initAns(sciName,choice1,choice2,choice3)
			hintName.text = invName
			print ("INVENTION NAME: " ..invName)
			print ("INVENTOR: " ..sciName)
			print ("QUESTION ID: " .. qID)
			
			invImg = display.newImageRect ( imagePath  , 135, 135 )
			invImg.x = _W * 0.5 ; invImg.y = 183 
			screenGroup:insert(invImg)
			
--for middle age----------------------------------------------------
--------------------------------------------------------------------			
		elseif upCurEra == 2 then
			print ("GENERATING MIDDLE AGE QUESTION")
			if #qTable == 0 then
			qTable  = generateQuestion.genQuestion("middleDB",upCurLevel)
			print ("LEVEL " .. upCurLevel .." questions: " .. #qTable)
			shuffle(qTable) --shuffles the table
			myData.lastQ = qTable --save the table in myData
			qTable = myData.lastQ
			ran = myData.qCount + 1
			myData.qCount = ran
				for i = 1, #qTable do
					local a = qTable[i].invName
					print (a)
				end
			else
			qTable = myData.lastQ
				for i = 1, #qTable do
					local a = qTable[i].invName
					print (a)
				end	
			ran = myData.qCount + 1
			myData.qCount = ran
			end			
			
			qID = qTable[ran].qID
			sciName = qTable[ran].sciName
			invName = qTable[ran].invName
			imagePath = qTable[ran].imagePath
			discDate = qTable[ran].discDate
			briefDesc = qTable[ran].briefDesc
			choice1 = qTable[ran].choice1
			choice2 = qTable[ran].choice2
			choice3 = qTable[ran].choice3
			
			initAns(sciName,choice1,choice2,choice3)
			hintName.text = invName
			print ("INVENTION NAME: " ..invName)
			print ("INVENTOR: " ..sciName)
			print ("QUESTION ID: " .. qID)
			
			invImg = display.newImageRect ( imagePath  , 135, 135 )
			invImg.x = _W * 0.5 ; invImg.y = 183 
			screenGroup:insert(invImg)					
--for early modern------------------------------------------
------------------------------------------------------------			
		elseif upCurEra == 3 then
			print ("GENERATING EARLY MODERN AGE QUESTION")
			if #qTable == 0 then
			qTable  = generateQuestion.genQuestion("earlyDB",upCurLevel)
			print ("LEVEL " .. upCurLevel .." questions: " .. #qTable)
			shuffle(qTable) --shuffles the table
			myData.lastQ = qTable --save the table in myData
			qTable = myData.lastQ
			ran = myData.qCount + 1
			myData.qCount = ran
				for i = 1, #qTable do
					local a = qTable[i].invName
					print (a)
				end
			else
			qTable = myData.lastQ
				for i = 1, #qTable do
					local a = qTable[i].invName
					print (a)
				end	
			ran = myData.qCount + 1
			myData.qCount = ran
			end			
			
			qID = qTable[ran].qID
			sciName = qTable[ran].sciName
			invName = qTable[ran].invName
			imagePath = qTable[ran].imagePath
			discDate = qTable[ran].discDate
			briefDesc = qTable[ran].briefDesc
			choice1 = qTable[ran].choice1
			choice2 = qTable[ran].choice2
			choice3 = qTable[ran].choice3
			
			initAns(sciName,choice1,choice2,choice3)			
			hintName.text = invName
			print ("INVENTION NAME: " ..invName)
			print ("INVENTOR: " ..sciName)
			print ("QUESTION ID: " .. qID)
			
			invImg = display.newImageRect ( imagePath  , 135, 135 )
			invImg.x = _W * 0.5 ; invImg.y = 183 
			screenGroup:insert(invImg)						
--for modern age-----------------------------------------------
---------------------------------------------------------------			
		elseif upCurEra == 4 then
			print ("GENERATING MODERN AGE QUESTION")			
			if #qTable == 0 then
			qTable  = generateQuestion.genQuestion("modernDB",upCurLevel)
			print ("LEVEL " .. upCurLevel .." questions: " .. #qTable)
			shuffle(qTable) --shuffles the table
			myData.lastQ = qTable --save the table in myData
			qTable = myData.lastQ
			ran = myData.qCount + 1
			myData.qCount = ran
				for i = 1, #qTable do
					local a = qTable[i].invName
					print (a)
				end
			else
			qTable = myData.lastQ
				for i = 1, #qTable do
					local a = qTable[i].invName
					print (a)
				end	
			ran = myData.qCount + 1
			myData.qCount = ran
			end			
			
			qID = qTable[ran].qID
			sciName = qTable[ran].sciName
			invName = qTable[ran].invName
			imagePath = qTable[ran].imagePath
			discDate = qTable[ran].discDate
			briefDesc = qTable[ran].briefDesc
			choice1 = qTable[ran].choice1
			choice2 = qTable[ran].choice2
			choice3 = qTable[ran].choice3
			
			initAns(sciName,choice1,choice2,choice3)
			hintName.text = invName			
			print ("INVENTION NAME: " ..invName)
			print ("INVENTOR: " ..sciName)
			print ("QUESTION ID: " .. qID)
			
			invImg = display.newImageRect ( imagePath  , 135, 135 )
			invImg.x = _W * 0.5 ; invImg.y = 183 
			screenGroup:insert(invImg)						
			
		end
		
--makes the image big
local toMinus = 1
local bigPic = 1
local function makePicBig()	
	if toMinus ~= 2 then
			invImg.xScale = toMinus +.1
			invImg.yScale = toMinus + .1
			toMinus = toMinus + .1
	
		else
			timer.cancel ( myTimer )
	end
	bigPic = 0
end

local function makePicSmall()
	if toMinus ~= 1 then
			invImg.xScale = toMinus -.1
			invImg.yScale = toMinus - .1
			toMinus = toMinus - .1

	else
		timer.cancel ( myTimer )
	end
	bigPic = 1			
end			
		
local function makeImgBig(event)
	if bigPic == 1 then
	myTimer = timer.performWithDelay( 10, makePicBig,10 )
	elseif bigPic == 0 then
	myTimer = timer.performWithDelay( 10, makePicSmall,10 )
	end			
end			
		
invImg:addEventListener ( "tap", makeImgBig )		
		
--gets the question description and put it in the text box		
myData.questionDescription = nil	
myData.questionDescription = briefDesc	
end

local function correctAnswer()
	myData.playCor = playCor +1
	storyboard.gotoScene("ansCorrect",{
	effect = "slideLeft",
	time = 250,
})
end

local function wrongAnswer()
	myData.playWro = playWro + 1
	myData.year1 = discDate
	myData.name1 = sciName
	myData.invent1 = invName	
	storyboard.gotoScene("ansWrong",{
	effect = "slideLeft",
	time = 250,
})	
end		

--checks the answers if correct
--and updates the db at the same time
--*********************************************************
local upCor
local fName
local function checkAns1(event)
	local phase = event.phase
		if phase  == "ended" then
				if enableSound == true then
					audio.play(tapSound)
				end
			timer.cancel (timerEvent)
					if aButton.id == sciName then
						print ("corrent answer")
						upCor = nil
						fName = nil
						 upCor = upAnsCor +1
						 fName = "answered_Correct"
	myData.year1 = discDate
	myData.name1 = sciName
	myData.invent1 = invName						 
						updateCorWro.upCorWro(playerID,fName,upCor)
						correctAnswer()
					else
						print ("wrong answer")
						upCor = nil
						fName = nil
						 upCor = upAnsWro +1
						 fName = "answered_Wrong"
	myData.year1 = discDate
	myData.name1 = sciName
	myData.invent1 = invName						 
						updateCorWro.upCorWro(playerID,fName,upCor)
						wrongAnswer()
					end	
		end
end

local function checkAns2(event)
	local phase = event.phase
		if phase  == "ended" then
				if enableSound == true then
					audio.play(tapSound)
				end
			timer.cancel (timerEvent)
					if bButton.id == sciName then
						print ("corrent answer")
						upCor = nil
						fName = nil
						 upCor = upAnsCor +1
						 fName = "answered_Correct"
	myData.year1 = discDate
	myData.name1 = sciName
	myData.invent1 = invName						 
						updateCorWro.upCorWro(playerID,fName,upCor)
						correctAnswer()
					else
						print ("wrong answer")
						upCor = nil
						fName = nil
						 upCor = upAnsWro +1
						 fName = "answered_Wrong"
	myData.year1 = discDate
	myData.name1 = sciName
	myData.invent1 = invName						 
						updateCorWro.upCorWro(playerID,fName,upCor)
						wrongAnswer()
					end	
		end
end

local function checkAns3(event)
	local phase = event.phase
		if phase  == "ended" then
				if enableSound == true then
					audio.play(tapSound)
				end			
			timer.cancel (timerEvent)
					if cButton.id == sciName then
						print ("corrent answer")
						upCor = nil
						fName = nil
						 upCor = upAnsCor +1
						 fName = "answered_Correct"
	myData.year1 = discDate
	myData.name1 = sciName
	myData.invent1 = invName						 
						updateCorWro.upCorWro(playerID,fName,upCor)
						correctAnswer()
					else
						print ("wrong answer")
						upCor = nil
						fName = nil
						 upCor = upAnsWro +1
						 fName = "answered_Wrong"
	myData.year1 = discDate
	myData.name1 = sciName
	myData.invent1 = invName						 
						updateCorWro.upCorWro(playerID,fName,upCor)
						wrongAnswer()
					end	
		end
end

local function checkAns4(event)
	local phase = event.phase
		if phase  == "ended" then
				if enableSound == true then
					audio.play(tapSound)
				end
			timer.cancel (timerEvent)
					if dButton.id == sciName then
						print ("corrent answer")
						upCor = nil
						fName = nil
						 upCor = upAnsCor +1
						 fName = "answered_Correct"
	myData.year1 = discDate
	myData.name1 = sciName
	myData.invent1 = invName					 
						updateCorWro.upCorWro(playerID,fName,upCor)
						correctAnswer()
					else
						print ("wrong answer")
						upCor = nil
						fName = nil
						 upCor = upAnsWro +1
						 fName = "answered_Wrong"
	myData.year1 = discDate
	myData.name1 = sciName
	myData.invent1 = invName						 
						updateCorWro.upCorWro(playerID,fName,upCor)
						wrongAnswer()
					end	
		end
end


--displays the screen value upon loading of the module
--******************************************************************
local function displayVal()
	playerCoin.text = upCurCoins
	textTime.text = timeRes
	textCor.text = (playCor .. "/" .. corAns)
	textWro.text = (playWro .. "/" .. wroAns)
end

--native alert
--**********************************************
local function enoughComplete(event)
	if "clicked" == event.action then
		local i = event.index
			if i == 1 then
				alertS1 = 0
				native.cancelAlert ( alert1 )
			end
	elseif "cancelled" == event.action then
		alertS1 = 0			
	end	
end	

local function checkIfEnough()
	alertS1 = 1
		 alert1 = native.showAlert ( "Not enough coins", 
			"Cannot use this hint", {"Ok"},
	enoughComplete
		)
end

local function showNameComplete(event)
	if "clicked" == event.action then
		local i = event.index
			if i == 1 then
				alertS2 = 0
				upCurCoins = upCurCoins - nameHintCost
				playerCoin.text = upCurCoins
				upHintUsed = upHintUsed + 1
				print ("number of hints used: " .. upHintUsed)			
				hintName.alpha = 1
				nameButton:setEnabled(false)
				checkMe(upHintUsed)
				hintUsed.hintUse(playerID,upCurCoins,upHintUsed)				
			end
	elseif "cancelled" == event.action then
		alertS2 = 0
	end				
end	

local function valShowName()
		alertS2 = 1
	 alert2 = native.showAlert("Use hint",
		"Show the name of the invention/discovery (" .. nameHintCost .. " coins)",
		{"Ok","Cancel"},
		showNameComplete
	)
end	

--show description hint
--****************************************************
local function showDesc(event)
	local phase = event.phase
		if phase == "ended" then
			print ("descButton button is pressed and released")
				if enableSound == true then
					audio.play(tapSound)
				end
			descButton:setEnabled(false)
			timer.pause(timerEvent)
			storyboard.showOverlay("descOverlay",{
				isModal = true,				
				effect = "fade",
				time =100 ,

				})
		end	
end

--show name hint
--*****************************************************
local function showName(event)
	local phase = event.phase
		if phase == "ended" then
			print ("nameButton is pressed and released")
				if enableSound == true then
					audio.play(tapSound)
				end
					if tonumber(upCurCoins) >= nameHintCost then
						valShowName()
					else
						checkIfEnough()
					print ("not enough coins")
					end
		end	 
end

local function deleteBogus()
		--removes the other choices randomly
local butTbl = {aButton,bButton,cButton,dButton}
local f = 1
local lastRan = 0

	repeat
		local ran = math.random(1,4)
		local button = butTbl[ran]
			if ran ~= lastRan then
					if tostring(button.id) ~= tostring(sciName) then
						lastRan = ran
						button.alpha = 0
						ans[ran].text = ""
						f = f + 1
				end
			end
	until f == 3
end

local function hideBogusComplete(event)
	if "clicked" == event.action then
		local i = event.index
			if i == 1 then
				alertS3 = 0
				upCurCoins = upCurCoins - fifHintCost
				playerCoin.text = upCurCoins
				playerCoin.text = upCurCoins
				upHintUsed = upHintUsed + 1
				print ("number of hints used: " .. upHintUsed)
				fifButton:setEnabled(false)
				deleteBogus()
				hintUsed.hintUse(playerID,upCurCoins,upHintUsed)
				checkMe(upHintUsed)				
			end
	elseif "cancelled" == event.action then
			alertS3 = 0
	end				
end

local function forfeitComplete(event)
	if "clicked" == event.action then
		local i = event.index
			if i == 1 then
				alertS4 = 0
				upCor = nil
				fName = nil
				myData.playWro = wroAns
	myData.year1 = discDate
	myData.name1 = sciName
	myData.invent1 = invName				
				storyboard.gotoScene("ansWrong",{
				effect = "slideLeft",
				time = 250,
				})									
			end
	elseif "cancelled" == event.action then
			alertS4 = 0	
	end	
end		

local function valHideBogus()
		alertS3 = 1
	 alert3 = native.showAlert("Use hint",
		"Randomly remove two incorrect choices  (" .. fifHintCost .. " coins)",
		{"Ok","Cancel"},
		hideBogusComplete
	)
end

local function forfeitGame(event)
	local phase = event.phase
		if phase == "ended" then
		alertS4 = 1
	 alert4 = native.showAlert ( "Forfeit level",
		"Do you want to forfeit this level?",
		 {"Yes","No"},
		 forfeitComplete
		)
		 end
end	

--delete bogus answer
--****************************************************
local function hideBogus(event)
	local phase = event.phase
		if phase == "ended" then
			print("fifButton is pressed and released")
				if enableSound == true then
					audio.play(tapSound)
				end
				if tonumber(upCurCoins) >= fifHintCost then
					valHideBogus()
				else
					checkIfEnough()
					print ("not enough coins")
				end
		end	
end

local function turnOnMusic(event)
	local phase = event.phase
		if phase == "ended" then
			if enableSound == true then
				audio.play(tapSound)
			end
				enableMusic = true
				igMusicButtonOn.alpha = 1
				igMusicButtonOff.alpha = 0
				
					if enableMusic == true then
						if myData.questionMusicHandler == nil then
		 				local backMusicHandler
		 				print ("---------------PLAY BACKGROUND MUSIC")
	 					questionMusicHandler = audio.play(questionMusic, {loops=-1} )
	 					myData.questionMusicHandler = questionMusicHandler
	 					print ("---------------BACKGROUND MUSIC CHANNEL: " .. questionMusicHandler)
						end
					end			
		end	
end

local function turnOffMusic(event)
	local phase = event.phase
		if phase == "ended" then
			if enableSound == true then
				audio.play(tapSound)
			end
				enableMusic = false
				igMusicButtonOff.alpha = 1
				igMusicButtonOn.alpha = 0

					if enableMusic == false then

		 				local questionMusicHandler
		 				print ("---------------STOP BACKGROUND MUSIC")
	 					questionMusicHandler = myData.questionMusicHandler
	 					audio.stop(questionMusicHandler)
	 					myData.questionMusicHandler = nil
	 					print ("---------------BACKGROUND MUSIC CHANNEL: " .. questionMusicHandler)
					end				
						
		end	
end

local function turnOnSound(event)
	local phase = event.phase
		if phase == "ended" then
			if enableSound == true then
				audio.play(tapSound)
			end
				enableSound = true
				igSoundButtonOn.alpha = 1
				igSoundButtonOff.alpha = 0
				
			if enableSound == true then
				local clockSound
				clockSound = audio.play(clockTick,{loops = -1})
				myData.clockTickSoundHandler = clockSound
			end				
		end	
end

local function turnOffSound(event)
	local phase = event.phase
		if phase == "ended" then
			if enableSound == true then
				audio.play(tapSound)
			end
				enableSound = false
				igSoundButtonOff.alpha = 1
				igSoundButtonOn.alpha = 0
				
				if enableSound == false then
					local clockSound
					clockSound = myData.clockTickSoundHandler
					audio.stop(clockSound)
					myData.clockTickSoundHandler = nil
				end	
		
		end	
end				

function scene:createScene()
	screenGroup = self.view
	
	local background = display.newImageRect ( "images/background.png",  _W, _H )
	background.x = _W * 0.5 ; background.y = _H * 0.5
			  
	local topBar = display.newImageRect (  "images/topBar.png",  _W, 40 )
	topBar.x =_W * 0.5 ; topBar.y = 20

	local timePic = display.newImageRect ( "images/time.png"  , 25, 25 )
	timePic.x = 52 ; timePic.y = 20
			 
	local checkPic = display.newImageRect ( "images/check.png" ,25 ,25 )
	checkPic.x = 105 ; checkPic.y = 20
			 
	local failPic = display.newImageRect ( "images/fail.png"  , 25, 25 )
	failPic.x = 170 ; failPic.y = 20
	
	local coinsImage = display.newImageRect (  "images/coins.png" , 100, 40 )
	coinsImage.x = _W - 50 ; coinsImage.y = 20
	
	playerCoin = display.newText( "000000" ,_W-60, 12, fontStyle, _W * 0.05 )
	playerCoin:setReferencePoint ( display.CenterLeftReferencePoint )
	playerCoin:setTextColor ( 255, 255, 255  )
	
	textTime = display.newText(  "0", 75, 10, fontStyle, _W * 0.05 )
	textTime:setReferencePoint ( display.CenterLeftReferencePoint )
	textTime:setTextColor ( 255, 255, 255  )
	
	textCor = display.newText(  "0/0", 125, 10, fontStyle, _W * 0.05 )
	textCor:setReferencePoint ( display.CenterLeftReferencePoint )
	textCor:setTextColor ( 255, 255, 255  )
	
	textWro = display.newText(  "0/0", 190, 10, fontStyle, _W * 0.05 )
	textWro:setReferencePoint ( display.CenterLeftReferencePoint )
	textWro:setTextColor ( 255, 255, 255  )	
	
	local backWrap = display.newImageRect ( "images/gamewrapper.png" ,296, 290 )
	backWrap.x = _W * 0.5 ; backWrap.y = 185
	
	hintName = display.newText( "invention Name", 100, 100, fontStyle, _W * 0.05 )
	hintName:setTextColor ( 0, 0, 0 )
	hintName.x =_W * 0.5 ; hintName.y = 270
	hintName.alpha = 0

	screenGroup:insert(background)
	screenGroup:insert(topBar)
	screenGroup:insert(timePic)
	screenGroup:insert(checkPic)
	screenGroup:insert(failPic)
	screenGroup:insert(coinsImage)
	screenGroup:insert(playerCoin)
	screenGroup:insert(backWrap)
	screenGroup:insert(textTime)
	screenGroup:insert(textCor)
	screenGroup:insert(textWro)
	screenGroup:insert(hintName) 
	

	displayVal() -- display player data in scene
	
end

function scene:enterScene()
	if enableMusic == true then
		if myData.questionMusicHandler == nil then
			print ("--------------PLAY QUESTION MUSIC")
			local backMusicHandler = myData.backMusicHandler
			backMusicHandler = myData.backMusicHandler
			print ("--------------BACKGROUND MUSIC CHANNEL: ".. backMusicHandler)
			audio.stop(backMusicHandler)
			myData.backMusicHandler = nil
			
			local questionMusicHandler
			questionMusicHandler = audio.play(questionMusic,{loops = -1})
			myData.questionMusicHandler = questionMusicHandler
			print ("---------------QUESTION MUSIC CHANNEL: " .. questionMusicHandler)
		end
	end

	storyboard.hideOverlay()
descButton = widget.newButton
{
	left = 30,
	top = 285,
	width = 80,
	height = 35,
	defaultFile = "images/description.png",
	overFile = "images/descriptionpress.png",
	id = "descButton",
	onEvent = showDesc,
}

nameButton = widget.newButton
{
	left = 120,
	top = 285,
	width = 80,
	height = 35,
	defaultFile = "images/hintname.png",
	overFile = "images/hintnamepress.png",
	id = "nameButton",
	onEvent = showName,
}

fifButton = widget.newButton
{
	left = 210,
	top = 285,
	width = 80,
	height = 35,
	defaultFile = "images/5050.png",
	overFile = "images/5050press.png",
	id = "fifButton",
	onEvent = hideBogus,
}

aButton = widget.newButton
{
	left = 10,
	top = 340,
	width = 150,
	height = 50,
	defaultFile = "images/blanka.png",
	overFile = "images/blankapress.png",
	id = "aButton",
	label = "",
	onEvent = checkAns1,	
}

bButton = widget.newButton
{
	left = 160,
	top = 341,
	width = 150,
	height = 50,
	defaultFile = "images/blankb.png",
	overFile = "images/blankbpress.png",
	id = "bButton",
	onEvent = checkAns2,	
}

cButton = widget.newButton
{
	left = 10,
	top = 405,
	width = 150,
	height = 50,
	defaultFile = "images/blankc.png",
	overFile = "images/blankcpress.png",
	id = "cButton",
	onEvent = checkAns3,	
}

dButton = widget.newButton
{
	left = 160,
	top = 406,
	width = 150,
	height = 50,
	defaultFile = "images/blankd.png",
	overFile = "images/blankdpress.png",
	id = "dButton",
	onEvent = checkAns4,	
}

local forfeitButton = widget.newButton
{
	left = 5,
	top = 5,
	width = 30,
	height = 30,
	defaultFile = "images/arrowback.png",
	overFile = "images/arrowbackpress.png",
	id = "forfeitButton",
	onEvent = forfeitGame,	
}

igSoundButtonOn = widget.newButton
{
	left = 28,
	top = 218,
	width = 34,
	height = 35,
	defaultFile = "images/igsoundon.png",
	overFile = "images/igsoundonpress.png",
	id = "igSoundButtonOn",
	onEvent = turnOffSound,
}
igSoundButtonOn.alpha = 0

igSoundButtonOff = widget.newButton
{
	left = 28,
	top = 218,
	width = 34,
	height = 35,
	defaultFile = "images/igsoundoff.png",
	overFile = "images/igsoundoffpress.png",
	id = "igSoundButtonOff",
	onEvent = turnOnSound,
}
igSoundButtonOff.alpha = 0

igMusicButtonOn = widget.newButton
{
	left = 254,
	top = 218,
	width = 34,
	height = 35,
	defaultFile = "images/igmusicon.png",
	overFile = "images/igmusiconpress.png",
	id = "igMusicButtonOn",
	onEvent = turnOffMusic,	
}
igMusicButtonOn.alpha = 0

igMusicButtonOff = widget.newButton
{
	left = 254,
	top = 218,
	width = 34,
	height = 35,
	defaultFile = "images/igmusicoff.png",
	overFile = "images/igmusicoffpress.png",
	id = "igMusicButtonOff",
	onEvent = turnOnMusic,	
}
igMusicButtonOff.alpha = 0

local function initIgButtons()
	if enableSound == true then
		igSoundButtonOn.alpha = 1
		igSoundButtonOff.alpha = 0
	elseif enableSound == false then
		igSoundButtonOff.alpha = 1	
		igSoundButtonOn.alpha = 0			
	end
	
	if enableMusic == true then
		igMusicButtonOn.alpha = 1
		igMusicButtonOff.alpha = 0
	elseif enableMusic == false then
		igMusicButtonOff.alpha = 1
		igMusicButtonOn.alpha = 0				
	end		
end
		
	button:insert(descButton)
	button:insert(nameButton)
	button:insert(fifButton)
	button:insert(aButton)
	button:insert(bButton)
	button:insert(cButton)
	button:insert(dButton)
	button:insert(igSoundButtonOn)
	button:insert(igSoundButtonOff)
	button:insert(igMusicButtonOn)
	button:insert(igMusicButtonOff)
	button:insert(forfeitButton)
	
		initIgButtons()
		getQuestion()
		
		if enableSound == true then
			if myData.clockTickSoundHandler == nil then
				local clockSound
				clockSound = audio.play(clockTick,{loops = -1})
				myData.clockTickSoundHandler = clockSound
			end
		end
		local levelTime = tonumber(timeRes)
		
		countTime = function(event)
			levelTime = levelTime- 1
			textTime.text = levelTime
				if (levelTime <= 0) then
						print ("time's up!")
						timer.cancel ( timerEvent )
						storyboard.hideOverlay()
						if alertS1 == 1 then
						native.cancelAlert( alert1 )
						end
						if alertS2 == 1 then
						native.cancelAlert( alert2 )
						end
						if alertS3 == 1 then
						native.cancelAlert( alert3 )
						end
						if alertS4 == 1 then
						native.cancelAlert( alert4 )
						end
						wrongAnswer()
				end	
		end
			
		timerEvent = timer.performWithDelay ( 1000, countTime ,levelTime )

end

function scene:overlayBegan()
	print ("overlay is shown")
end

function scene:overlayEnded()
	print ("overlay is removed")
	timer.resume( timerEvent )
end		

function scene:exitScene()
				-- system default configurations
local systemConfig = {}
	systemConfig.soundOn = enableSound
	systemConfig.musicOn = enableMusic

	makeSystemConfig(systemConfig, "systemConfiguration.json")
	print ("SYSTEM CONFIGURATIONS UPDATED")	
	if alertS1 == 1 then
	native.cancelAlert( alert1 )
	end
	if alertS2 == 1 then
	native.cancelAlert( alert2 )
	end
	if alertS3 == 1 then
	native.cancelAlert( alert3 )
	end
	if alertS4 == 1 then
	native.cancelAlert( alert4 )
	end	
	storyboard.hideOverlay()
				if enableSound == true then
					local clockSound
					clockSound = myData.clockTickSoundHandler
					audio.stop(clockSound)
					myData.clockTickSoundHandler = nil
				end
	timer.cancel ( timerEvent )
	timerEvent = nil
	screenGroup:removeSelf()
	screenGroup = nil
	button:removeSelf()
	button = nil
end

function scene:didExitScene()
	storyboard.removeScene("gameProper")
end

scene:addEventListener ( "createScene", scene )
scene:addEventListener ( "enterScene", scene )
scene:addEventListener ( "overlayBegan", scene )
scene:addEventListener ( "overlayEnded", scene )
scene:addEventListener ( "exitScene", scene )
scene:addEventListener ( "didExitScene", scene )

return scene				