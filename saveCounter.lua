local json = require ( "json" )

local function createSaveCounter (tbl, filename)
	local path = system.pathForFile (filename, system.DocumentsDirectory ) --path of the json file
	local file = io.open (path, "w") --what to do, in this case write
	
		if file then --if the file does not exist
			local config = json.encode( tbl ) --encodes the data
			file:write(config) --writes the data into the json file
			io.close ( file )--closes the file
			print ("save counter has been created")
		end	

end

local M = {}

function makeSaveCounter(fname, path)
	local results = false

    local filePath = system.pathForFile( fname, path )
    --filePath will be 'nil' if file doesn't exist and the path is 'system.ResourceDirectory'
    if ( filePath ) then
        filePath = io.open( filePath, "r" )
    end
    if ( filePath ) then
        print( "File found: " .. fname )
        --clean up file handles
        filePath:close()
        results = true
    else
        print( "File does not exist: " .. fname )
      
       -- if makeSysConfig == true then
			-- system default configurations
			print ("making save file counter")
			local totalSaveFile = {}
			totalSaveFile.savedFile = 0

			createSaveCounter (totalSaveFile, "saveCounter.json")
       -- end	     
    end

    return results
	
end
M.makeSaveCounter = makeSaveCounter	

return M