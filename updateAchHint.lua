
local sqlite = require ( "sqlite3" )

local M = {}

local function updateAchHint(playerID,params1,params2,params3,params4,params5)

	
	local path = system.pathForFile ("playerDB.sqlite", system.DocumentsDirectory)
	local db = sqlite.open(path)
	
	local sql = "UPDATE player_Achievement SET hint1 = " .. params1 .. ", hint2 = " .. params2 .. ", hint3 = " .. params3 .. " , hint4 = " .. params4 .. " , totalPoint = " .. params5 .. " WHERE player_ID = " .. playerID
	print (sql)
	db:exec(sql)
	print ("successfully updated player achievement DB")
	db:close()
return true
end
M.updateAchHint = updateAchHint

return M