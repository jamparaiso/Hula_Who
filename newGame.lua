print ("newGame module----------------------------------------------------------")

local storyboard = require ( "storyboard" )
local myData = require ("myData")
local widget = require ("widget")
local systemConfigurations = require ( "systemConfigurations" )
local countSaveFile = require ("countSaveFile")
local addPlayerData = require ("addPlayerData")
local updateSaveCounter = require ("updateSaveCounter")
local getLastPlayer = require ( "getLastPlayer" )
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

local numProfiles ={} 
numProfiles = countSaveFile.numSavedFile("saveCounter.json")
local totalSave = numProfiles.savedFile
print ("Total Save Profile: ".. totalSave)


local playerTextField = pTextField
local screenGroup
local button = display.newGroup ( )
local backToMenu
local checkForSaveSlot
local focusTextField
local checkIfBlank
local background
local profileText
local newGameText
local nameLimitText
local alertDisplay
local pName
local t = {}


function scene:createScene()
	screenGroup = self.view

			background=display.newImageRect (  "images/background.png" , _W,_H )
			background.x=_W * 0.5 ; background.y=_H *0.5
			
			newGameText = display.newImageRect ( "images/newgametxt.png",300, 25 )
			newGameText.x = _W*0.5 ; newGameText.y = 60
			
			profileText = display.newText(  "Player Name",_HW-60, 100, fontStyle, 20 )
			nameLimitText = display.newText(  "*maximum of 10 letters", _HW-75, 180, fontStyle, 15 )	
			nameLimitText:setTextColor ( 199, 25, 0 )
			nameLimitText:setReferencePoint(display.CenterReferencePoint)
		local nameRestrict = display.newText(  "", _HW-115, 200, fontStyle,15 )
				nameRestrict:setTextColor ( 199, 25, 0 )
				nameRestrict:setReferencePoint(display.CenterReferencePoint)
			
			screenGroup:insert(background)
			screenGroup:insert(newGameText)
			screenGroup:insert(profileText)
			screenGroup:insert(nameLimitText)
			screenGroup:insert(nameRestrict)
			
--hides the keyboard when the background is tapped
function background:tap (event)
	native.setKeyboardFocus ( nil ) --dismissess the keyboard
	print ("background has been tapped")
end

--checks and set the focus on the text field when the text field is blank
function focusTextField(event)
		if(event.action == "clicked") then

			if (event.index == 1 ) then  --choose ok
				native.setKeyboardFocus (pTextField)
				print ("ok has been tapped")
			end
	
		elseif (event.action == "cancelled") then
			print ("cancel has been tapped")

		end
					
end

--native alert callback function
local function onAlertInteract(event)
	if (event.action == "clicked") then
		if (event.index == 1 ) then
			print ("delete profile")

			storyboard.gotoScene("deleteSave",{
			effect = "slideLeft",
			time = 250,
			})
		elseif (event.index == 2 ) then
			print ("cancel delete profile")	
		end
	elseif (event.action =="cancelled") then
		print ("alert cancelled")	
	end
end

local function onAlertInvalidName(event)
	if (event.action == "clicked") then
		if (event.index == 1) then
			pTextField.text = ""
		end	
	end
end	
--native alert
function checkIfBlank()
		print ("emptyField")
		local alert = native.showAlert ( "Invalid Input", 
			"Please type your name", {"Ok"},
			focusTextField
		)
end

function alertDisplay()
	local invalidNameAlert = native.showAlert ( 
		"Invalid name", 
		"This name contains special character or numbers",
			{"Ok"},
			onAlertInvalidName
			)
end

--go to the next scene
function checkForSaveSlot(event)
	local phase = event.phase
		if "ended" == phase then
			print ("next press and released")
				if enableSound == true then
					audio.play(tapSound)
				end
						if pTextField.text == "" or pTextField.text == "Enter your nickname" then
								--remove the comments when testing on device---------------------
								checkIfBlank() -- uncomment this when building on device
							else --there is text on the textfield / uncomment this when building on device
								pName = pTextField.text --uncomment this when building on device
								--pName = "newPlayer" --comment this when testing on device	
									if (pName:match('%"')) then
										print ("Invalid")
										alertDisplay()
									elseif (pName:match('%+')) then
										print ("Invalid")
										alertDisplay()
									elseif (pName:match('%-')) then
										print ("Invalid")
										alertDisplay()
									elseif (pName:match('%/')) then
										print ("Invalid")
										alertDisplay()
									elseif (pName:match('%*')) then
										print ("Invalid")
										alertDisplay()																
									elseif (pName:match("%A+%A")) then --checks if there are special characters and numbers
										print ("Invalid player name")
										alertDisplay()
									else --valid  name		

										myData.playerName = pName -- pass the value this is used for delete player
										print ("player name: " .. pName)
										if totalSave <= 2 then --go to the player main menu if there are save slot
											t = {
												player_Name = pName,

												default_coins = myData.default_coins,

												acquired_coins = myData.acquired_coins,

												achieve_points = myData.achieve_points,

												default_level = myData.default_level,

												default_era = myData.default_era,

												answered_correct = myData.answered_correct,

												answered_wrong = myData.answered_wrong,

												num_hints_used = myData.num_hints_used,

												game_finished = myData.game_finished,

												slots_last_used = myData.slots_last_used,

												level_Tries = myData.level_Tries,

												last_LevelTry = myData.last_LevelTry,

												save_status = myData.save_status,

											}
	
										addPlayerData.addPlayer(t) --add new player in db
										getLastPlayer.getLast() --add new player achievements data
										updateSaveCounter.upSaveCounter() --updates the save counter
										myData.loadPlayerData = true-- tells loadNewPlayerData module to load the newly created save game
									
										storyboard.gotoScene ( "scene1",{
										effect = "slideLeft",
										time = 250,
										} )
										else --go to delete save player profile
							
									local alert = native.showAlert ( 
										"Maximum save space reached.", 
										"In order to create a new profile, please delete other save profile." ,
			 							{"Yes", "No"},
			 							onAlertInteract  -- callback function
										)							

										end
									end				
						end	
				native.setKeyboardFocus ( nil ) --dismissess the keyboard	
		end	
end	

--return to menu
function backToMenu(event)
		local phase = event.phase
			if "ended" == phase then
				native.setKeyboardFocus ( nil ) --dismissess the keyboard
				print (" back pressed and released")
					if enableSound ==true then
						audio.play (tapSound)
					end
				storyboard.gotoScene ( "mainmenu",{
				effect = "slideRight",
					time = 250,
					} )
			end	
end

background:addEventListener ( "tap", backgroundEvent ) --every time the backround is tapped the keyboard will dismiss

end	

function scene:enterScene()
	
--creates textfield
pTextField = native.newTextField ( _HW, _HH, _W * 0.8 ,_H * 0.1  )
pTextField.inputType = "default"
pTextField.font = native.newFont ( fontStyle , _H * 0.05 )
pTextField:setTextColor ( 0, 0, 0)
pTextField.align = "center"
pTextField.x = _W * 0.5 ; pTextField.y = 150
local fieldText = "Enter your nickname"
pTextField.text = fieldText

--next button
local nextButton = widget.newButton
{
		left = 20,
		top = 250,
		width = 130,
		height = 40,
		defaultFile = "images/create.png",
		overFile = "images/createpress.png",
		id = "next_Button",
		onEvent = checkForSaveSlot,	
}

--back button
local backMenu = widget.newButton
{
		left = 170,
		top = 250,
		width = 130,
		height = 40,
		defaultFile = "images/cancel.png",
		overFile = "images/cancelpress.png",
		id ="back_Button",
		onEvent = backToMenu,
}


--check the textfield contents
function pTextField:userInput(event)
	if (event.phase == "began") then
		pTextField.text=""
		print ("began")
	elseif (event.phase == "editing") then

	        -- This section happens when the user types
        	-- Lets set up a max length, compare it and if too long, replace it
        	local myNum = 10-- max characters 	
        	if string.len(event.text) > myNum then
               	-- Text too long, replace textField text with old text
               	pTextField.text = event.oldText
               	print ("max length reached")
        	end
        
	elseif (event.phase == "ended") then
		print ("ended")
	elseif (event.phase == "submitted") then
		if pTextField.text == "" then
		checkIfBlank()
		else
			pName = pTextField.text
			print (pName)
		end
	print ("submitted")
	end	
end
	
pTextField:addEventListener ( "userInput", pTextField )

button:insert(pTextField)
button:insert(nextButton)
button:insert(backMenu)

end

function scene:exitScene()

	pTextField:removeEventListener("userInput",pTextField)
	background:removeEventListener("tap",backgroundEvent)
	screenGroup:removeSelf()
	screenGroup=nil
	button:removeSelf()
	button = nil
end

function scene:didExitScene()

	storyboard.removeScene("newGame")
end


scene:addEventListener ( "createScene", scene )
scene:addEventListener ( "enterScene", scene )
scene:addEventListener ( "exitScene", scene )
scene:addEventListener ("didExitScene", scene )

			
return scene		