local json = require ("json")
--make config file, if it does not exist, it will create
local M = {}
function makeSystemConfig(tbl, filename)
	local path = system.pathForFile (filename, system.DocumentsDirectory ) --path of the json file
	local file = io.open (path, "w") --open the file
	
		if file then --if the file does not exist
			local config = json.encode( tbl ) --encodes the data
			file:write(config) --writes the data into the json file
			io.close ( file )--closes the file
			print ("System configurations successfully created")
			return true
		else
			print ("System configurations already exist")
			return false --file exist
		end	
end
M.makeSystemConfig = makeSystemConfig

return M