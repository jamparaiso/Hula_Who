
local sqlite = require ( "sqlite3" )

local M = {}

local function updateAchFinish(playerID,params1,params2)

	local path = system.pathForFile ("playerDB.sqlite", system.DocumentsDirectory)
	local db = sqlite.open(path)
	
	local sql = "UPDATE player_Achievement SET gameFin = " .. params1 .. " , totalPoint = " .. params2 .. " WHERE player_ID = " .. playerID
	print (sql)
	db:exec(sql)
	print ("successfully updated player achievement DB")
	db:close()
return true
end
M.updateAchFinish = updateAchFinish

return M