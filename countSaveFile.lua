
--this will load and count how many saved profiles on the system
local json = require ("json")

local M = {}

function numSavedFile(filename)
	local numSavedFile = { }
	local path = system.pathForFile (filename , system.DocumentsDirectory )
	local contents = ""
	local myTable = { }
	local file = io.open ( path ,"r" )
	
		if file then
			local contents = file:read ("*a")
			myTable = json.decode( contents )
			io.close (file)
			return myTable	
		end
			--return nil
			numSavedFile= myTable
			
			return numSavedFile
end


M.numSavedFile = numSavedFile

return M
