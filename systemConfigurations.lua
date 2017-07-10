
--this will load the system configurations

print ("systemConfigurations has been loaded")

local json = require ("json")

local gameSettings = { }

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


 local A = {}
 
 local gameSound = gameSettings.soundOn
 A.gameSound = gameSound
 
 local gameMusic = gameSettings.musicOn
 A.gameMusic = gameMusic
 
 return A	