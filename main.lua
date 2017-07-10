print ("MAIN MODULE---------------------------------------")

--require controller module
local storyboard=require ( "storyboard" )

local json = require ("json")

local myData = require ("myData")

local makeSysConfig = require ("makeSystemConfig")

local checkSysConfigExist = require ( "checkSysConfigExist" )

local saveCounter = require ("saveCounter")

local createPlayerProfile = require ("createPlayerProfile")
local createAncientDB = require ( "createAncientDB" )
local createMiddleDB = require ( "createMiddleDB" )
local createEarlyDB =require ( "createEarlyDB" )
local createModernDB = require ( "createModernDB" )
local addGameQuestion = require ( "addGameQuestion" )
local createAchievementsDB = require ( "createAchievementsDB" )

--checks if system configurations exist, if not, it will create
local results = checkSysConfigExist.doesFileExist( "systemConfiguration.json", system.DocumentsDirectory )
print ("SYSTEM CONFIGURATIONS IS LOADED")
local saveExist = saveCounter.makeSaveCounter("saveCounter.json",system.DocumentsDirectory)
print ("SAVE FILE COUNTER IS LOADED")

--creates system database
--creates player Databases
createPlayerProfile.createProfile()
print ("PLAYER DATABASE LOADED")

--creates achievement database
createAchievementsDB.createAchievement()
print ("ACHIEVEMENTS DATABASE LOADED")

--creates ancient era database
createAncientDB.createAncientDB()
print("ANCIENT ERA DATABASE LOADED")

--creates middle age database
createMiddleDB.createMiddleDB()
print("MIDDLE AGE DATABASE LOADED")

--creates early period database
createEarlyDB.createEarlyDB()
print("EARLY AGE DATABASE LOADED")

--creats modern age database
createModernDB.createModernDB()
print("MODERN AGE DATABASE LOADED")

--adds questions in the system
addGameQuestion.addAncientQuestion()
print("ANCIENT ERA QUESTION SAVED AND LOADED")
addGameQuestion.addMiddleQuestion()
print("MIDDLE AGE QUESTION SAVED AND LOADED")
addGameQuestion.addEarlyQuestion()
print("EARLY PERRIOD QUESTION SAVED AND LOADED")
addGameQuestion.addModernQuestion()
print("MODERN ERA QUESTION SAVED AND LOADED")

local krabbyText = display.newText( "My new text in 'Krabby Patty' font", 25, 100, "Krabby Patty", 40 )
krabbyText.text = ""
krabbyText = nil
sprite = require("sprite")

--native alert callback function
--[[local function onAlertInteract(event)
	if (event.action == "clicked") then
		if (event.index == 1 ) then
			native.requestExit()
		elseif (event.index == 2 ) then
			return false
		end
	elseif (event.action =="cancelled") then
		print ("alert cancelled")	
	end
end

local function onKeyEvent( event )

   local phase = event.phase
   local keyName = event.keyName
   print (event.phase, event.keyName)

   	if ("back" == keyName and phase == "down") then
				local alert = native.showAlert ( 
					"Exit game", 
					"Are you sure that you want to exit the game?." ,
					{"Yes", "No"},
						onAlertInteract  -- callback function
					)
   	end
   				
		if (keyName == "volumeUp"  and phase == "down") then
			local masterVolume = audio.getVolume()
      	 print( "volume:", masterVolume )
      		if ( masterVolume < 1.000 ) then
         		masterVolume = masterVolume + 0.1
         		audio.setVolume( masterVolume )
      		end
   	elseif ( keyName == "volumeDown" and phase == "down" ) then
      	local masterVolume = audio.getVolume()
      	print( "volume:", masterVolume )
      		if ( masterVolume > 0.000 ) then
         	 masterVolume = masterVolume - 0.1
         	 audio.setVolume( masterVolume )
      		end      			
		end
		
	return true
end
Runtime:addEventListener( "key", onKeyEvent )]]--


--load first screen
storyboard.gotoScene("splashScreen")
