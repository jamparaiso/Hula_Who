
local sqlite = require ( "sqlite3" )

local M = {}

local function upSaveStat(playerID,gameStatus)
	
	local playerID = playerID
	local gameStatus = gameStatus
	
	local path = system.pathForFile ("playerDB.sqlite", system.DocumentsDirectory)
	local db = sqlite.open(path)
	
	local sql = "UPDATE player_Data SET game_Finished = " .. gameStatus .. " WHERE player_ID = " .. playerID
	
	db:exec(sql)
	db:close()
	print ("game  successfully updated")
end
M.upSaveStat = upSaveStat	

return M 