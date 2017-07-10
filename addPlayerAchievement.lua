
local sqlite = require ("sqlite3")

local M = {}

function addAchievement(playID,tbl)

	local path = system.pathForFile ("playerDB.sqlite" , system.DocumentsDirectory)
	local db = sqlite.open(path)
	local playID = playID
	
local sql = [[
INSERT INTO player_Achievement ("player_ID","coll_2k","coll_3k","coll_5k","lastColl","hint1","hint2","hint3",
"hint4","acientFin","middleFin","earlyFin","modernFin","gameFin","totalPoint")
VALUES ("]] .. playID ..
[[","]] .. tbl.coll2k ..
[[","]] .. tbl.coll3k ..
[[","]] .. tbl.coll5k ..
[[","]] .. tbl.coll10k ..
[[","]] .. tbl.hint1 ..	
[[","]] .. tbl.hint2 ..
[[","]] .. tbl.hint3 ..
[[","]] .. tbl.hint4 ..
[[","]] .. tbl.ancientFin  ..
[[","]] .. tbl.middleFin ..
[[","]] .. tbl.earlyFin ..
[[","]] .. tbl.modernFin ..	
[[","]] .. tbl.gameFin ..
[[","]] .. tbl.totalPoint ..	
[[");]]	
db:exec(sql)	
db:close()
print ("SUCCESSFULLY CREATED PLAYER ACHIEVEMENT DATA")
end
M.addAchievement = addAchievement

return M