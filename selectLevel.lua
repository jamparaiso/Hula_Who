
print ("selectLevel module --------------------------------------------------")

local storyboard = require ( "storyboard" )
local widget = require ("widget")
local systemConfigurations = require ( "systemConfigurations" )
local myData = require ( "myData" )
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
local eraMax

local screenGroup
local button = display.newGroup ( )

local playerDat = {}
playerDat = myData.playerDat
local playerID = playerDat.player_ID
	print ("player ID: " .. playerDat.player_ID)
	print ("player name: " .. playerDat.player_Name)
	
local upPlayerData = {}
upPlayerData = funcGetPlayerDat.getPlayerDat("playerDB.sqlite" , playerID)
local playerLevel = upPlayerData.current_Level
local playerEra = upPlayerData.current_Era

--image table for completed levels
local imageTblComp = {
	{img="images/ancientLevelComplete.png"},
	{img="images/modernAgeLevelComplete.png"},
	{img="images/earlyModernAgesLevelComplete.png"},
	{img="images/modernAgeLevelComplete.png"},
	}
	
--image table for locked levels
local imageTblLock = {
	{img="nothing"},
	{img="images/middleLevelLocked.png"},
	{img="images/earlyModernAgesLevelLocked.png"},
	{img="images/modernAgeLevelLocked.png"},
	}
	
local function completedEra()
	print("this era is completed" )
end	
	
local function playProper(event)
	local phase = event.phase
		if phase == "ended" then

				if enableSound == true then
					audio.play(tapSound)
				end
				storyboard.gotoScene("gameRestrictions",{
					effect ="slideLeft",
					time = 250,
					})
		end	

end

local function lockEraEvent()
		print ("this era is locked")			
end

local function backToMenu(event)
	local phase = event.phase
		if phase == "ended" then

					if enableSound == true then
							audio.play(tapSound)
					end
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
				 
		local selectEraText = display.newImageRect ( "images/selectera.png",280, 25 )
		selectEraText.x = _W*0.5 ; selectEraText.y = 50	 
				 	 
	screenGroup:insert(background)
	screenGroup:insert(selectEraText)
end

function scene:enterScene()
	if enableMusic == true then
		if myData.backMusicHandler == nil then
			print ("---------------------PLAY BACKGROUND MUSIC")
			local backMusicHandler
	    	backMusicHandler = audio.play(backMusic, {loops=-1} )
	    	myData.backMusicHandler = backMusicHandler
	    	print ("---------------------BACKGROUND MUSIC CHANNEL: " .. backMusicHandler)
		end	
	end
local eraToPlay
local complete
local locked
local imgPath

	--level indicator
local function levelBar(emptyBarY,fullBarY,levelTextY,eLevel)
	local pLevel = playerLevel
	local eLevel = eLevel
	local toDiv = 141 / eLevel --141 is the width of the fullbar to make it dynamic just divide it to the level in a era
	local barWidth = toDiv  * pLevel
	
	local emptyBar = display.newImageRect("images/levelBarEmpty.png", 150 , 20 )
		  emptyBar.x = 200 ; emptyBar.y = emptyBarY
		  
	local fullBar = display.newRoundedRect (129,fullBarY,barWidth,17,7)
		  fullBar:setFillColor(77, 171, 186 )
		  
	local levelText = display.newText ("10/10",100,100,fontStyle, _H * 0.03)
		  levelText:setReferencePoint (display.CenterLeftReferencePoint)
		  levelText.x = 180 ; levelText.y = levelTextY
		  levelText.text = (pLevel .. "/"..eLevel)
		  levelText:setTextColor(0,0,0)

	button:insert(emptyBar)
	button:insert(fullBar)
	button:insert(levelText)	
end

--for ancient period-------------------------------------------------
---------------------------------------------------------------------
if tonumber(playerEra) == 1 then
	print ("ancient period")
	
	eraToPlay = widget.newButton
	{
		left = 15,
		top = 90,
		width = 300,
		height = 70,
		defaultFile = "images/ancientLevel.png",
		overFile = "images/ancientLevelpress.png",
		id = "ancientEraPlay",
		onEvent = playProper,
	}
	
--locked era buttons
	local t = 3
	local topPos = 170

	for i = 1 , t do
		locked = ("lockedEra" .. i)
		local a = i + 1
		imgPath = imageTblLock[a].img
	
		locked =widget.newButton
		{
			left = 15,
			top = topPos,
			width =  300,
			height = 70,
			defaultFile = imgPath,
			overFile = imgPath,
			id = ("lockedEra"..i),
			onEvent = lockEraEvent,
		}

	button:insert(eraToPlay)
	eraMax = myData.ancientLevel
	levelBar(140,131,140,eraMax)
	button:insert(locked)
	topPos = topPos + 80 
	end

--for middle ages-------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------	

elseif tonumber(playerEra) == 2 then
	print ("middle ages")
	
		local t =1
		
		for i = 1 ,t do
			complete = ("completed" .. i)
			imgPath = imageTblComp[i].img
			complete = widget.newButton
			{
				left = 15,
				top =90,
				width = 300,
				height = 70,
				defaultFile = imgPath,
				overFile = imgPath,
				id = ("completeEra"  .. i ),
				onEvent = completedEra,
			} 
	

		end
		
		eraToPlay = widget.newButton
		{
			left = 15,
			top = 170,
			width = 300,
			height = 70,
			defaultFile = "images/middleLevel.png",
			overFile = "images/middleLevelpress.png",
			id = "middleLevelPlay",
			onEvent = playProper,
		} 

--locked era		
		local lockedEarlyAge = widget.newButton
		{
			left = 15,
			top = 250,
			width = 300,
			height = 70,
			defaultFile = "images/earlyModernAgesLevelLocked.png",
			overFile = "images/earlyModernAgesLevelLocked.png",
			id = "lockedEarlyAge",
			onEvent = lockEraEvent,
		}
		
		local lockedModernAge = widget.newButton
		{
			left = 15,
			top = 330,
			width = 300,
			height = 70,
			defaultFile = "images/modernAgeLevelLocked.png",
			overFile = "images/modernAgeLevelLocked.png",
			id = "lockedModernAge",
			onEvent = lockEraEvent,
		}
		
		button:insert(complete)
		button:insert(eraToPlay)
		eraMax = myData.middleLevel
		levelBar(220,211,220,eraMax)
		button:insert(lockedEarlyAge)
		button:insert(lockedModernAge)

--early modern era-------------------------------------------------------
-------------------------------------------------------------------------
elseif tonumber(playerEra) == 3 then
	print ("early modern age")
	
	eraToPlay = widget.newButton
	{
		left = 15,
		top = 250,
		width = 300,
		height = 70,
		defaultFile = "images/earlyModernAgesLevel.png",
		overFile = "images/earlyModernAgesLevelpress.png",
		id ="earlyModernPlay",
		onEvent = playProper,
	}
	
	local completeEra1 = widget.newButton
	{
		left = 15,
		top = 90,
		width = 300,
		height = 70,
		defaultFile = imageTblComp[1].img,
		overFile = imageTblComp[1].img,
		id = "compEra1",
		onEvent = completedEra,
	}
	
	local completeEra2 = widget.newButton
	{
		left = 15,
		top = 170,
		width = 300,
		height = 70,
		defaultFile = imageTblComp[2].img,
		overFile = imageTblComp[2].img,
		id = "compEra2",
		onEvent = completedEra,
	}
	
		local lockedEra = widget.newButton
	{
		left = 15,
		top = 330,
		width = 300,
		height = 70,
		defaultFile = imageTblLock[4].img,
		overFile = imageTblLock[4].img,
		id = "lockedEra",
		onEvent = lockEraEvent,
	}
	
	button:insert(eraToPlay)
	eraMax = myData.earlyLevel
	levelBar(300,291,300,eraMax)
	button:insert(completeEra1)
	button:insert(completeEra2)
	button:insert(lockedEra)

--for modern age---------------------------------------------------------
-------------------------------------------------------------------------	
elseif tonumber(playerEra) == 4 then
	print ("modern age")
	
	local comp
	local topPos = 90
	
	for i = 1 , 3 do
		comp = ("completeEra" .. i)
			comp = widget.newButton
	{
		left = 15,
		top = topPos,
		width = 300,
		height = 70,
		defaultFile = imageTblComp[i].img,
		overFile = imageTblComp[i].img,
		id = ("compID" .. i),
		onEvent =completedEra,	
	}
	
	topPos = topPos + 80
	button:insert(comp)
	end	
	
	eraToPlay = widget.newButton
	{
		left = 15,
		top = 330,
		width = 300,
		height = 70,
		defaultFile = "images/modernAgeLevel.png",
		overFile = "images/modernAgeLevelpress.png",
		id = "eraToPlay",
		onEvent = playProper,	
	}
	
	button:insert(eraToPlay)
	eraMax = myData.modernLevel
	levelBar(380,372,380,eraMax)			
end
	
local backButton = widget.newButton
{
		left = _HW-65,
		top = 430,
		width = 130,
		height = 40,
		defaultFile = "images/back.png",
		overFile = "images/backpress.png",
		id ="back_Button",
		onEvent = backToMenu,
}
	
button:insert(backButton)	
	
end

function scene:exitScene()
	playerDat = nil
	upPlayerData = nil
	screenGroup:removeSelf()
	screenGroup = nil
	button:removeSelf()
	button = nil
end

function scene:didExitScene()
	storyboard.removeScene("selectLevel")
end

scene:addEventListener ( "createScene", scene )
scene:addEventListener ( "enterScene", scene )
scene:addEventListener ( "exitScene", scene )
scene:addEventListener ( "didExitScene", scnene )

return scene