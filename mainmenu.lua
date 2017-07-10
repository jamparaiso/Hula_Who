print ("MAIN MENU MODULE----------------------------------------------")

local storyboard = require ( "storyboard" )
local myData = require ("myData")
local widget = require ("widget")
local systemConfigurations = require ( "systemConfigurations" )
local countSaveFile = require ("countSaveFile")
local updateAchCoin = require ( "updateAchCoin" )
local scene = storyboard.newScene()
local json = require ("json")local gameSettings = { }

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

local numProfiles ={} 
numProfiles = countSaveFile.numSavedFile("saveCounter.json")
local totalSave = numProfiles.savedFile
print ("TOTAL SAVE PROFILE: ".. totalSave)
print ("SOUND ENABLED:")
print (enableSound)
print ("MUSIC ENABLED:")
print (enableMusic)

local loadPlayerData = myData.loadPlayerData

 --button group
local button = display.newGroup ( )
local screenGroup
local background
local gameLogo

-- button events----------------------------------------------------------------------------------
local function newGameEvent ( event )
	local phase = event.phase
		if "ended" == phase then

				if enableSound == true then
					audio.play (tapSound)
				end			
				storyboard.gotoScene ( "newGame",{
					effect = "slideLeft",
					time = 250,
					} )
		end			
end

local function loadGameEvent ( event )
	local phase = event.phase
		if "ended" == phase then
	
				if enableSound == true then
					audio.play (tapSound)
				end
				storyboard.gotoScene ( "loadgame",{
					effect = "slideLeft",
					time = 250,
					} )
		end			
end
	
local function leaderBoardEvent ( event )
	local phase = event.phase
		if "ended" == phase then

				if enableSound == true then
					audio.play (tapSound)
				end

				storyboard.gotoScene ( "leaderBoards",{
				effect = "slideLeft",
				time = 250,
				} )

		end			
end
	
local function optionsEvent ( event )
	local phase = event.phase
		if "ended" == phase then

				if enableSound == true then
					audio.play (tapSound)
				end
				storyboard.gotoScene ( "options",{
				effect = "slideLeft",
					time = 250,
					} )
		end			
end			

--end of button events-------------------------------------------------------------	

function scene:createScene()
	screenGroup = self.view
	
		background=display.newImageRect (  "images/background.png" , _W,_H )
		background.x=_W * 0.5 ; background.y=_H *0.5


	    gameLogo = display.newImageRect ( "images/logosmall.png"  ,200 ,200 )
		gameLogo:setReferencePoint ( display.CenterReferencePoint )
		gameLogo.x =160  ; gameLogo.y = 130

		screenGroup:insert(background)

		screenGroup:insert(gameLogo)		
		
end


function scene:enterScene()

	if enableMusic == true then
		if myData.backMusicHandler == nil then
		 	local backMusicHandler
		 	print ("---------------PLAY BACKGROUND MUSIC")
	 		backMusicHandler = audio.play(backMusic, {loops=-1} )
	 		myData.backMusicHandler = backMusicHandler
	 		print ("---------------BACKGROUND MUSIC CHANNEL: " .. backMusicHandler)
		end	  
	end

--button initialization------------------------------------------------------------	
	local newGameButton = widget.newButton 
	{
			left = 50,
			top = 250,
			width =230,
			height = 40,
			defaultFile = "images/newgame.png",
			overFile = "images/newgamepress.png",
			id = "New_Game_Button",
			onEvent = newGameEvent,
	} 
	
	local loadGameButton = widget.newButton 
	{
			left = 50,
			top = 300,
			width =230,
			height = 40,
			defaultFile = "images/loadgame.png",
			overFile = "images/loadgamepress.png",
			id = "Load_Game_Button",
			onEvent = loadGameEvent,
	} 
	
	local leaderBoardButton = widget.newButton 
	{
			left = 50,
			top = 350,
			width =230,
			height = 40,
			defaultFile = "images/leaderboard.png",
			overFile = "images/leaderboardpress.png",
			id = "Load_Game_Button",
			onEvent = leaderBoardEvent,
	} 
	
	local optionsButton = widget.newButton 
	{
			left = 50,
			top = 400,
			width =230,
			height = 40,
			defaultFile = "images/optionbutton.png",
			overFile = "images/optionbuttonpress.png",
			id = "Options_Button",
			onEvent = optionsEvent,
	} 		
	
--end of button initialization--------------------------------------------------------		

--group		
		button:insert(newGameButton)
		button:insert(loadGameButton)
		button:insert(leaderBoardButton)
		button:insert(optionsButton)
--end of group------------------------------------------------------------------------


   local platFormUse = system.getInfo("platformName")
   print ("PLATFORM USED: " .. platFormUse)

end

function scene:overlayBegan()
	print ("overlay is shown")
end

function scene:overlayEnded()
	print ("overlay is removed")

end

function scene:exitScene()
	button:removeSelf()
	button=nil
	screenGroup:removeSelf()
	screenGroup=nil
	print ("MAINMENU MODULE UNLOADED----------------------------------------------")	
end

function scene:didExitScene()
	storyboard.removeScene("mainmenu")	
end

		
		
scene:addEventListener ( "createScene", scene )
scene:addEventListener ( "enterScene", scene )
scene:addEventListener ( "overlayBegan", scene )
scene:addEventListener ( "overlayEnded", scene )
scene:addEventListener ( "exitScene", scene )
scene:addEventListener ( "didExitScene", scene )

return scene	