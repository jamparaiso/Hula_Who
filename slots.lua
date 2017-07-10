
print ("slot machine module----------------------------------")

local myData = require ("myData")
local widget = require ("widget")
local checkAchCoin = require ( "checkAchCoin" )
local updateAchCoin = require ( "updateAchCoin" )
local systemConfigurations = require ( "systemConfigurations" )
local updateGameCoin = require ( "updateGameCoin" )
local funcGetPlayerAch = require ( "funcGetPlayerAch" )
local storyboard = require( "storyboard" )
local sqlite = require ( "sqlite3" )
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

math.randomseed ( os.time())

local _H = myData._H
local _W = myData._W
local _HH = myData._HH
local _HW = myData._HW
local fontStyle = myData.fontStyle
local tapSound = myData.tapSound
local slotSound = myData.slotSound
local kaChingSound = myData.kaChingSound
local backMusic = myData.backMusic
local enableSound = gameSettings.soundOn
local enableMusic = gameSettings.musicOn

--player DATA
local playerData = {}
playerData = myData.playerDat

local playerID = playerData.player_ID
print ("player ID: ".. playerID)
local playerCoins = playerData.current_Coins
print ("current coins: " .. playerCoins)
local playerAcqCoins = playerData.coins_Acquired
print ("player acquired coins: " .. playerAcqCoins)
local playerLastSlotTime = playerData.slots_Last_Used

local totalspin = 6 -- total chance to Spin

local canSpin = true
local totalcoins = playerCoins -- Starting money
local bet = 1 -- Cost per play
local slotButton
local backButton
local group
local curTime

local winnings = 0

local w,h = display.contentWidth, display.contentHeight

local slideSheet, slideSet, slide, slide2, slide3, shade, shade2, shade3, moneyTxt, winTxt

local slotCongrats
local slotNoSpin
local slotTapStart
local slotTryAgain
local showWin
local slotSpinSound

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

local function checkMe()
	curCoin = totalcoins

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
local function onComplete(event)
	if "clicked" == event.action then
		local i = event.index
			if i == 1 then
				storyboard.gotoScene("playerMenu",{
				effect ="slideRight",
				time = 250,
				})		
			end	
	end	 
end	

local function backToMenu(event)
	local phase = event.phase
		if phase == "ended" then
			if enableSound == true then
				audio.play(tapSound)
			end
		if totalspin ~= 0 then
		local alert = native.showAlert ( "Game alert",
		"Are you sure that you want to go back? Once you spin the slot machine, You have to wait for another 30 minutes in order to spin again.",
		 {"Yes","No"},
		 onComplete )
		else
		 	storyboard.gotoScene("playerMenu",{
			 effect ="slideRight",
			 time = 250,
				})	
		end	
		end	
end	

--indicates how many the player won
local function textFadeIn(params)
	winTxt.text = ("+ $"..params)

	-- Fade in win text
	transition.to( winTxt, { time=500, alpha=1, x=(_W/2), y=(_H/2) } )

	-- Fade back out win text
	transition.to( winTxt, { time=500, delay=1500, alpha=0, x=380, y=10 } )
end

--checks if there is a match
local function endRoll()
	-- Set default winnings for spin
	 winnings = 0
	 if enableSound == true then
	 audio.pause ( slotSpinSound )
	 end
	canSpin = false
	-- Stop slides from moving
	slide:pause()
	slide2:pause()
	slide3:pause()
	
	-- Check for matches
	if (slide.currentFrame == 7 and slide2.currentFrame == 7 and slide3.currentFrame == 7) then -- All three are 7's
		winnings = 500
		print ("you get " .. winnings)
	elseif (slide.currentFrame == 2 and slide2.currentFrame == 2 and slide3.currentFrame == 2) then -- All three are Bar's
		winnings = 200
		print ("you get " .. winnings)
	elseif (slide.currentFrame == 3 and slide2.currentFrame == 3 and slide3.currentFrame == 3) then -- All three are Bell's
		winnings =  100
		print ("you get " .. winnings)
	elseif (slide.currentFrame == 6 and slide2.currentFrame == 6 and slide3.currentFrame == 6) then -- All three are Watermelon's
		winnings =  50
		print ("you get " .. winnings)
	elseif ( (slide.currentFrame == 1 or slide.currentFrame == 4 or slide.currentFrame == 5) and (slide2.currentFrame == 1 or slide2.currentFrame == 4 or slide2.currentFrame == 5) and (slide3.currentFrame == 1 or slide3.currentFrame == 4 or slide3.currentFrame == 5) ) then -- All three are Cherry's
		winnings =  25
		print ("you get " .. winnings)
	end
		
		--if the player has won
		if winnings > 0 then
			slotCongrats.alpha = 1
			showWin.text = winnings
			showWin.alpha = 1

			slotTapStart.alpha = 0
			slotTryAgain.alpha = 0
			slotNoSpin.alpha = 0
			if enableSound == true then
				audio.play(kaChingSound)
			end
			--textFadeIn(winnings)
		elseif winnings == 0 then
			slotCongrats.alpha = 0
			showWin.alpha = 0

			slotTapStart.alpha = 0
			slotTryAgain.alpha = 1
			slotNoSpin.alpha = 0
		end
	
	-- Set and display new total
	totalcoins = totalcoins  + winnings
	if tonumber(totalcoins) >= 999999 then
		totalcoins = 999999
	end
	
	checkMe()
	
	curTime =os.time()
	updateGameCoin.upGameCoin(playerID,"playerDB.sqlite",totalcoins, playerAcqCoins,curTime)
		
	playerAcqCoins = playerAcqCoins + winnings
	print ("player acquired coins: " .. playerAcqCoins)
	moneyTxt.text = totalcoins
	lifeTxt.text = "Spins left: ".. totalspin
	

	
	if totalspin == 0 then
		slotCongrats.alpha = 0
		showWin.alpha = 0

		slotTapStart.alpha = 0
		slotTryAgain.alpha = 0
		slotNoSpin.alpha = 1

	end	
	
	-- Let user spin again
	canSpin = true

end

local function rollslide()
			
	if totalspin ~= 0 then
		if canSpin == true  then
			if enableSound == true then
				slotSpinSound = audio.play(slotSound)
			end	 
			totalspin = totalspin - bet
		-- Start spinning all three slides
			slide:play()
			slide2:play()
			slide3:play()

		-- Random spin time
			randomTime = math.random(1500, 3500)
			timer.performWithDelay(randomTime, endRoll, 1)
	
		else
			canSpin = false 
		end
	end

end


function scene:createScene( event )
	 group = self.view
	
	local background=display.newImageRect (  "images/background.png" , _W,_H )
			 background.x=_W * 0.5 ; background.y=_H *0.5
			 group:insert(background)
		
	local topBar = display.newImageRect (  "images/topBar.png",  _W, 40 )
			 topBar.x =_W * 0.5 ; topBar.y = 20
			 group:insert(topBar)
	
	local coinsImage = display.newImageRect (  "images/coins.png" , 100, 40 )
			 coinsImage.x = _W - 50 ; coinsImage.y = 20
			 group:insert(coinsImage)	
		
	--local slotBack = display.newRect(  60, 100, 200, 250 )
		--	 slotBack:setFillColor ( 0, 0, 0 )
			-- group:insert(slotBack)	
		
--	local slotimg = display.newImageRect ( "images/slotmachine_img.png", 280,330  )
	--		 slotimg.x = 170 ; slotimg.y = 230	
	--group:insert(slotimg)
	
	slideSheet = sprite.newSpriteSheet( "images/slide.png", 77, 226)
	slideSet = sprite.newSpriteSet( slideSheet, 1, 7 )
	sprite.add( slideSet, "slide", 1, 7, 160, 0)
	sprite.add( slideSet, "slide2", 1, 7, 100, 0)
	sprite.add( slideSet, "slide3", 1, 7, 230, 0)

	slide = sprite.newSprite( slideSet )
	slide.x = 83
	slide.y = 270
	slide:prepare("slide")
	group:insert(slide)
	
	shade = display.newImage("images/shade.png", true)
	shade.x = 83
	shade.y = 270
	group:insert(shade)

	slide2 = sprite.newSprite( slideSet )
	slide2.x = 163
	slide2.y = 270
	slide2:prepare("slide2")
	group:insert(slide2)
	
	shade2 = display.newImage("images/shade.png", true)
	shade2.x = 163
	shade2.y = 270
	group:insert(shade2)
	
	slide3 = sprite.newSprite( slideSet )
	slide3.x = 243
	slide3.y = 270
	slide3:prepare("slide3")
	group:insert(slide3)

	shade3 = display.newImage("images/shade.png", true)
	shade3.x = 243
	shade3.y = 270
	group:insert(shade3)

local slotWrap = display.newImageRect("images/slotwrapper.png",313,365)
	 slotWrap.x = w/2 slotWrap.y = 230
group:insert(slotWrap)

local jackPotPrize = 500
local barPrize = 200
local bellPrize = 100
local melonPrize = 50
local cherryPrize = 25

local jackText = display.newText (jackPotPrize,150,102,fontStyle,11)
local barText = display.newText (barPrize,103,87,fontStyle,12)
local bellText = display.newText (bellPrize,260,87,fontStyle,12)
local melonText = display.newText(melonPrize,103,105,fontStyle,12)
local cherryText = display.newText(cherryPrize,260,105,fontStyle,12)
		
	slotCongrats = display.newImageRect("images/slotcongrats.png",135,25)
	slotCongrats.x = 155 ; slotCongrats.y = 145
	slotCongrats.alpha = 0
		
	showWin = display.newText("500",200,137,fontStyle,15)
	showWin:setReferencePoint(display.CenterReferencePoint)
	showWin:setTextColor(0,0,0)
	showWin.alpha = 0
	  
	slotNoSpin = display.newImageRect("images/slotnospin.png",150,25)
	slotNoSpin.x = 160 ; slotNoSpin.y = 145
	slotNoSpin.alpha = 0
	
	slotTapStart = display.newImageRect("images/slottapstart.png",135,22)
	slotTapStart.x = 160 ; slotTapStart.y = 146
	slotTapStart.alpha = 1
	  
    slotTryAgain = display.newImageRect("images/slottryagain.png",135,22)
	slotTryAgain.x = 160 ; slotTryAgain.y = 145
	slotTryAgain.alpha = 0
		
		group:insert(jackText)
		group:insert(barText)
		group:insert(bellText)
		group:insert(melonText)
		group:insert(cherryText)
		group:insert(slotCongrats)
		group:insert(showWin)
		group:insert(slotNoSpin)
		group:insert(slotTapStart)
		group:insert(slotTryAgain)			
end

function scene:enterScene( event )
	 group = self.view
 
	 
	moneyTxt = display.newText(totalcoins,_W-60, 12, fontStyle, _W * 0.05)

	moneyTxt:setReferencePoint( display.CenterLeftReferencePoint )

	group:insert(moneyTxt)
	
	lifeTxt = display.newText("Spins Left: ".. totalspin ,5, 10, fontStyle, _W * 0.07)
	lifeTxt:setReferencePoint( display.CenterLeftReferencePoint )
	lifeTxt.x =10 ; lifeTxt.y=20
	group:insert(lifeTxt)
	
	winTxt = display.newText("+2", 380, 10, fontStyle, 55)
	winTxt:setTextColor(50, 100, 250)
	winTxt:setReferencePoint( display.CenterReferencePoint )
	winTxt.alpha = 0
	group:insert(winTxt)
	
local function spinSlides(event)
	local phase = event.phase
		if phase == "ended" then

					if enableSound == true then
						audio.play(tapSound)
					end
					
		slotCongrats.alpha = 0
		showWin.alpha = 0
		slotTapStart.alpha = 0
		slotTryAgain.alpha = 0
			
		rollslide()
		canSpin = false	
	 
			end	
end
	
slotButton = widget.newButton
	{
		top = 420,
		left = 170,
		width = 100,
		height = 40,
		defaultFile = "images/spin.png",
		overFile = "images/spinpress.png",
		id = "spinButton",
		onEvent = spinSlides,
	}
	group:insert(slotButton)

backButton = widget.newButton
{
		left = 50,
		top = 420,
		width = 100,
		height = 40,
		defaultFile = "images/back.png",
		overFile = "images/backpress.png",
		id ="back_Button",
		onEvent = backToMenu,
}

	group:insert(backButton)	

end

function scene:overlayBegan()
	print ("overlay is shown")
end

function scene:overlayEnded()
	print ("overlay is removed")

end

function scene:exitScene( event )
group:removeSelf()
group = nil

end


function scene:didExitScene( event )
	storyboard.removeScene("slots")
end

	scene:addEventListener( "createScene", scene )
	scene:addEventListener( "enterScene", scene )
	scene:addEventListener ( "overlayBegan", scene )
	scene:addEventListener ( "overlayEnded", scene )
	scene:addEventListener( "exitScene", scene )
	scene:addEventListener( "didExitScene", scene )

return scene