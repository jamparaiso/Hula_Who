print ("OPTIONS MODULE--------------------------------------------------------")

local storyboard = require ("storyboard")
local widget = require ("widget")
local myData =require ("myData")
local json = require ("json")
local makeSysConfig = require ("makeSystemConfig")
local systemConfigurations = require ( "systemConfigurations" )

local scene = storyboard.newScene()

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
local tapSound = myData.tapSound
local backMusic = myData.backMusic
local enableSound = gameSettings.soundOn
local enableMusic = gameSettings.musicOn
print (enableSound)print (enableMusic)

local button = display.newGroup ( )
local screenGroup
local soundButtonOn
local soundButtonOff
local musicButtonOn
local musicButtonOff
local howToPlayButton
local mainMenuButton
local optionText
local background

--button events--------------------------------------------------------------
local function soundOnEvent ( event )
		local phase = event.phase
		if "ended" == phase then
				if enableSound == true then
					audio.play (tapSound)
				end
					enableSound = true
					soundButtonOn.alpha = 0
					soundButtonOff.alpha =1
		end			
	end
	
local function soundOffEvent (event)
		local phase = event.phase
			if "ended" == phase then

				if enableSound == true then
					audio.play (tapSound)
				end
					enableSound = false
					soundButtonOff.alpha = 0
					soundButtonOn.alpha =1
			end
	end
	
local function musicOnEvent (event)
		local phase = event.phase
			if "ended" == phase then

				if enableSound == true then
					audio.play (tapSound)
				end
					enableMusic = true
					musicButtonOn.alpha = 0
					musicButtonOff.alpha = 1										if enableMusic == true then						if myData.backMusicHandler == nil then
		 				local backMusicHandler
		 				print ("---------------PLAY BACKGROUND MUSIC")
	 					backMusicHandler = audio.play(backMusic, {loops=-1} )
	 					myData.backMusicHandler = backMusicHandler
	 					print ("---------------BACKGROUND MUSIC CHANNEL: " .. backMusicHandler)						end
					end	  
			end	
	end
	
local function musicOffEvent (event)
		local phase = event.phase
			if "ended" == phase then

				if enableSound == true then
					audio.play (tapSound)
				end
					enableMusic = false
					musicButtonOff.alpha = 0
					musicButtonOn.alpha = 1					if enableMusic == false then
		 				local backMusicHandler
		 				print ("---------------STOP BACKGROUND MUSIC")
	 					backMusicHandler = myData.backMusicHandler	 					audio.stop(backMusicHandler)
	 					myData.backMusicHandler = nil
	 					print ("---------------BACKGROUND MUSIC CHANNEL: " .. backMusicHandler)
					end
			end	
	end
	
local function howToPlayEvent (event)
		local phase = event.phase
			if "ended" == phase then

				if enableSound == true then
				audio.play (tapSound)
				end
				storyboard.gotoScene("howToPlay",{
					effect = "slideRight",
					time = 250,
					})
			end	
	end
	
local function backMainMenuEvent(event)
		local phase = event.phase
			if "ended" == phase then

				if enableSound == true then
				audio.play (tapSound)
				end				-- system default configurations
local systemConfig = {}
	systemConfig.soundOn = enableSound
	systemConfig.musicOn = enableMusic
	makeSystemConfig(systemConfig, "systemConfiguration.json")
	print ("SYSTEM CONFIGURATIONS UPDATED")
				storyboard.gotoScene("mainmenu",{
					effect="slideRight",
					time = 250,
					})
			end	
	end 

--end of button events------------------------------------------------------------------


function scene:createScene()
	screenGroup = self.view
	
	background = display.newImageRect (  "images/background.png" , _W, _H )
	background.x = _W * 0.5 ; background.y = _H * 0.5
		
	optionText = display.newImageRect ( "images/optiontext.png",250, 25 )
	optionText.x = _W*0.5 ; optionText.y = 60	

	screenGroup:insert(background)
	screenGroup:insert(optionText)		

end

function scene:enterScene()

--buttons initialization------------------------------------------------------------------
		soundButtonOn = widget.newButton 
		{
			left = 40,
			top = 150,
			width =250,
			height = 40,
			defaultFile = "images/soundOff.png",
			overFile = "images/soundOffpress.png",
			id = "Sound_On",
			onEvent = soundOnEvent,	
		}
		soundButtonOn.alpha=1


		soundButtonOff = widget.newButton 
		{
			left = 40,
			top = 150,
			width =250,
			height = 40,
			defaultFile = "images/soundOn.png",
			overFile = "images/soundOnpress.png",
			id = "Sound_Off",
			onEvent = soundOffEvent,		
		}
		soundButtonOff.alpha=1

		musicButtonOn = widget.newButton
		{
			left = 40,
			top = 200,
			width = 250,
			height = 40,
			defaultFile = "images/musicOff.png",
			overFile ="images/musicOffpress.png",
			id = "Music_On",
			onEvent = musicOnEvent,
		}
		musicButtonOn.alpha=1


		musicButtonOff = widget.newButton
		{
			left = 40,
			top = 200,
			width = 250,
			height = 40,
			defaultFile = "images/musicOn.png",
			overFile = "images/musiconpress.png",
			id = "Music_Off",
			onEvent = musicOffEvent,
		}
		musicButtonOff.alpha=1

	howToPlayButton = widget.newButton
	{
		left = 40,
		top = 250,
		width = 250,
		height = 40,
		defaultFile = "images/howToPlay.png",
		overFile = "images/howToPlayPress.png",
		id = "How_To_Play",
		onEvent = howToPlayEvent, 
	}
	howToPlayButton.alpha=1


	mainMenuButton = widget.newButton
	{
		left = 40,
		top = 300,
		width = 250,
		height = 40,
		defaultFile = "images/backlong1.png",
		overFile = "images/backlongpress1.png",
		id = "Main_Menu",
		onEvent = backMainMenuEvent,
	}
	mainMenuButton.alpha=1

--end of buttons initialization----------------------------------------


--checks if what button will be shown-----------------------------------
local function initializeButton()
	if enableSound == true then

		soundButtonOn.alpha = 0
		soundButtonOff.alpha = 1
		howToPlayButton.alpha =1
		mainMenuButton.alpha = 1
	elseif enableSound == false then

		soundButtonOn.alpha = 1
		soundButtonOff.alpha = 0
		howToPlayButton.alpha =1
		mainMenuButton.alpha = 1	
	end

	if enableMusic == true then

		musicButtonOn.alpha = 0
		musicButtonOff.alpha =1
		howToPlayButton.alpha =1
		mainMenuButton.alpha = 1
	elseif enableMusic == false then

		musicButtonOn.alpha = 1
		musicButtonOff.alpha =0
		howToPlayButton.alpha =1
		mainMenuButton.alpha = 1
	end
			print ("button initialization complete")
end
		
initializeButton()


button:insert(howToPlayButton)
button:insert(mainMenuButton)
button:insert(soundButtonOn)
button:insert(soundButtonOff)
button:insert(musicButtonOn)
button:insert(musicButtonOff)

end

function scene:exitScene()
	
	gameSettings = nil
	contents= nil
	path = nil
	myTable = nil
	systemConfig =nil
	button:removeSelf()
	button = nil
	screenGroup:removeSelf()
	screenGroup=nil
end

function scene:didExitScene()

	storyboard.removeScene("options")
end

function scene:destroyScene()

end

scene:addEventListener ( "createScene", scene )
scene:addEventListener ( "enterScene", scene )
scene:addEventListener ( "exitScene", scene )
scene:addEventListener ( "didExitScene", scene )
scene:addEventListener ( "destroyScene", scene )				

return scene		
