
local sqlite = require ( "sqlite3" )

local M = {}

local function deletePlayer(playerID)
	local path = system.pathForFile ("playerDB.sqlite",system.DocumentsDirectory )
	local db = sqlite.open(path)
	local playerID = playerID
	
	local sql = "UPDATE player_Data SET save_Status = 0 WHERE player_ID = " .. playerID 
	db:exec(sql)
	db:close()
	print ( playerID .. "HAS BEEN DELETED")
end
M.deletePlayer = deletePlayer	

return M