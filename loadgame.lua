print ("loadgame module--------------------------------------")

local storyboard = require ( "storyboard" )
local myData = require ("myData")
local widget = require ("widget")
local systemConfigurations = require ( "systemConfigurations" )
local countSavePlayerData = require ("countSavePlayerData")
local countSaveFile = require ( "countSaveFile" )
local fetchSaveData=require ( "fetchSaveData" )
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
print ("Total Saved Profile: ".. totalSave)


--gets the length of the table which is the total active save profile
local dataTblLength = {}

dataTblLength = fetchSaveData.getSaveData("playerDB.sqlite")


local screenGroup
local button = display.newGroup ( )
local loadGameText
local loadSaveGame  = {}
local playerData = {}

--back button call back function
local function backToMenu(event)
	local phase = event.phase
		if "ended" == phase then
			native.setKeyboardFocus ( nil ) --dismissess the keyboard
			
				if enableSound == true then
					audio.play (tapSound)
				end					
				storyboard.gotoScene ( "mainmenu",{
				effect = "slideRight",
				time = 250,
				} )
		end	
end

--dynamic functions where corresponds to the total active profile

for i = 1, #dataTblLength do
	playerData[i] = 
	{
			player_ID = dataTblLength[i].playerID,
			player_Name = dataTblLength[i].playerName,
			current_Coins = dataTblLength[i].currentCoins,
			coins_Acquired = dataTblLength[i].acquiredCoins,
			achievement_pts = dataTblLength[i].achievementPoints,
			current_Level = dataTblLength[i].currentLevel,
			current_Era = dataTblLength[i].currentEra,
			answered_Correct = dataTblLength[i].answeredCorrect,
			answered_Wrong = dataTblLength[i].answeredWrong,
			num_Hints_Used = dataTblLength[i].numHintsUsed,
			game_Finished = dataTblLength[i].gameFinished,
			slots_Last_Used = dataTblLength[i].slotsLastUsed,
			save_Status = dataTblLength[i].saveStatus,
	}
--creates save slot call back function
--this is all dynamic	
	loadSaveGame[i] = function(event)
		local phase = event.phase
			if phase == "ended" then
				print ("load slot " .. i)
					if enableSound == true then
						audio.play(tapSound)
					end	
				myData.loadPlayerData = false-- tells loadNewPlayerData module to load  old save profile
				myData.loadPlayerTable = playerData[i] -- pass the player data in myData

					storyboard.gotoScene ( "playerMenu",{
					effect = "slideLeft",
					time = 250,
					} )
	
			end		
	end

end

function scene:createScene()
	screenGroup = self.view
	
		background=display.newImageRect (  "images/background.png" , _W,_H )
		background.x=_W * 0.5 ; background.y=_H *0.5
		
		loadGameText = display.newImageRect ( "images/loadgametxt.png",280, 25 )
		loadGameText.x = _W*0.5 ; loadGameText.y = 60
		
	screenGroup:insert(background)
	screenGroup:insert(loadGameText)
	
end

function scene:enterScene()
--dynamic slot buttons,  creates buttons which corresponds to the number of active save profile	
local t = totalSave
local topPos = 100
if t >= 3 then
	t= 3
end	
	for i = 1 , t  do
			local slotName = ("saveSlot" .. i)
				slotName = widget.newButton
				{
					left = 50,
					top =topPos ,
					width = 230,
					height = 100,
					defaultFile = "images/loadslot.png",
					overFile = "images/loadslotpress.png",
					id = ("load_slot" .. i),
					onEvent = loadSaveGame[i],
				}
	button:insert(slotName)
	topPos = topPos + 110
		end
		
local txtPlayerName = {}
local txtPlayerEra = {}
local txtPlayerLevel = {}
local txtPlayerCoins = {}
local txtPos = 0
local curEra

		for i = 1, #dataTblLength do			
				    txtPlayerName[i] = display.newText (playerData[i].player_Name, 100, 100, fontStyle,  _H * 0.04 )
				    txtPlayerName[i]:setReferencePoint (display.CenterLeftReferencePoint)
					txtPlayerName[i].x = 140 ; txtPlayerName[i].y = 112 + txtPos
					txtPlayerName[i]:setTextColor ( 255, 180, 25)

					if tonumber(playerData[i].current_Era) == 1 then
						curEra ="Ancient Period"
					elseif tonumber(playerData[i].current_Era) == 2 then
						curEra = "Middle Ages"
					elseif tonumber(playerData[i].current_Era) == 3 then
						curEra = "Early Modern Ages"
					elseif tonumber(playerData[i].current_Era) == 4 then
						curEra = "Modern Age"			
					end	
					
					txtPlayerEra[i] = display.newText(curEra, 100, 100, fontStyle, _H * 0.03 )
					txtPlayerEra[i]:setReferencePoint (display.CenterLeftReferencePoint)
					txtPlayerEra[i].x = 140 ; txtPlayerEra[i].y = 135 + txtPos
					txtPlayerEra[i]:setTextColor (255, 180, 25)
					
					txtPlayerLevel[i] =display.newText( playerData[i].current_Level, 100,100,fontStyle,_H * 0.04)
					txtPlayerLevel[i]:setReferencePoint ( display.CenterLeftReferencePoint)
					txtPlayerLevel[i].x= 140 ; txtPlayerLevel[i].y= 155 + txtPos
					txtPlayerLevel[i]:setTextColor(255,180,25)
					
					txtPlayerCoins[i] = display.newText( playerData[i].current_Coins,100, 100, fontStyle, _H * 0.04 )
					txtPlayerCoins[i]:setReferencePoint (display.CenterLeftReferencePoint )
					txtPlayerCoins[i].x = 140 ; txtPlayerCoins[i].y = 180 + txtPos
					txtPlayerCoins[i]:setTextColor ( 255, 180, 25 )
					
					txtPos= txtPos + 112
					
					button:insert(txtPlayerName[i])
					button:insert(txtPlayerEra[i])
					button:insert(txtPlayerLevel[i])
					button:insert(txtPlayerCoins[i])
		end	
	
local backMenu = widget.newButton
{
		left = _HW-65,
		top = 430,
		width = 130,
		height = 40,
		defaultFile = "images/cancel.png",
		overFile = "images/cancelpress.png",
		id ="back_Button",
		onEvent = backToMenu,
}	

	button:insert(backMenu)

end

function scene:exitScene()
	loadSaveGame  = nil
	playerData = nil
	txtPlayerName = nil
	txtPlayerEra = nil
	txtPlayerLevel = nil
	txtPlayerCoins = nil
	txtPos = nil
	curEra = nil
	screenGroup:removeSelf()
	screenGroup = nil
	button:removeSelf()
	button = nil
end

function scene:didExitScene()
		storyboard.removeScene("loadgame")
end

function scene:destroyScene()
end

scene:addEventListener ( "createScene", scene )
scene:addEventListener ( "enterScene", scene )
scene:addEventListener ( "exitScene", scene )
scene:addEventListener ( "didExitScene", scene )
scene:addEventListener ( "destroyScene", scene )

return scene						