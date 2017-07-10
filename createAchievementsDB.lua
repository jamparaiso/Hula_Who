local sqlite = require ("sqlite3")

local M = {}

function createAchievement()
	local path = system.pathForFile ("playerDB.sqlite" , system.DocumentsDirectory)
	local db = sqlite.open(path)
	
	local sql =[[
		CREATE TABLE IF NOT EXISTS player_Achievement (
		id_Num INTEGER PRIMARY KEY,
		player_ID INTEGER, --foreign key
		coll_2k INTEGER,
		coll_3k INTEGER,
		coll_5k INTEGER,
		lastColl INTEGER,
		hint1 INTEGER,
		hint2 INTEGER,
		hint3 INTEGER,
		hint4 INTEGER,
		acientFin INTEGER,
		middleFin INTEGER,
		earlyFin INTEGER,
		modernFin INTEGER,
		gameFin INTEGER,
		totalPoint INTEGER
		);
		]]
print ("SUCCESSFULLY CREATED ACHIEVEMENTS DATABASE")	
db:exec(sql)
db:close()
end
M.createAchievement = createAchievement


return M	