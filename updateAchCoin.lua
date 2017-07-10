
local sqlite = require ( "sqlite3" )

local M = {}

local function updateAchCoin(playerID,params1,params2,params3,params4,params5)

	
	local path = system.pathForFile ("playerDB.sqlite", system.DocumentsDirectory)
	local db = sqlite.open(path)
	
	local sql = "UPDATE player_Achievement SET coll_2k = " .. params1 .. ", coll_3k = " .. params2 .. ", coll_5k = " .. params3 .. " , lastColl = " .. params4 .. " , totalPoint = " .. params5 .. " WHERE player_ID = " .. playerID
	print (sql)
	db:exec(sql)
	print ("successfully updated player achievement DB")
	db:close()
return true
end
M.updateAchCoin = updateAchCoin

return M