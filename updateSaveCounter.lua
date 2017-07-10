--this will update the save counter it just increments by 1 since you can't directly delete a player profile

local json = require ("json")
local countSaveFile = require ("countSaveFile")

local M = {}

function upSaveCounter()	
	local numProfiles ={} 
	numProfiles = countSaveFile.numSavedFile("saveCounter.json")	
	local totalSave = numProfiles.savedFile
	local filename = "saveCounter.json"
	local saveCount = totalSave + 1
	print ("updated save count: ".. saveCount)
	local tbl = {savedFile = saveCount}

	
	local path = system.pathForFile (filename, system.DocumentsDirectory ) --path of the json file
	local file = io.open (path, "w") --what to do, in this case write
	
		if file then --if the file does not exist
			local config = json.encode( tbl ) --encodes the data
			file:write(config) --writes the data into the json file
			io.close ( file )--closes the file
			print ("save counter has been updated")
		end	
	
end
M.upSaveCounter = upSaveCounter	

return M