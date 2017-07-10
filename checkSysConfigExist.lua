
local json = require ("json")
local myData = require ("myData")
local makeSysConfig = require ("makeSystemConfig")

local M = {}
--checks if the system configurations exist
function doesFileExist( fname, path )

    local results = false
    local filePath = system.pathForFile( fname, path )
    --filePath will be 'nil' if file doesn't exist and the path is 'system.ResourceDirectory'
    if ( filePath ) then
        filePath = io.open( filePath, "r" )
    end
    if ( filePath ) then
        print( "SYSTEM CONFIGURATIONS FILE FOUND: " .. fname )
        --clean up file handles
        filePath:close()
        results = true
    else
        print( "SYSTEM CONFIGURATIONS FILE DOES NOT EXIST: " .. fname )
			-- system default configurations
			print ("CREATING SYSTEM CONFIGURATIONS...")
			local systemConfig = {}
			systemConfig.soundOn = true
			systemConfig.musicOn = true
			makeSysConfig.makeSystemConfig(systemConfig, "systemConfiguration.json")
    end
    return results
end
M.doesFileExist =doesFileExist

return M