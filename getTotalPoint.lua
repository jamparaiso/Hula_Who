
--get the total achievement point of player and sort is in descending order

local sqlite = require ( "sqlite3" )

local M = {}

local function getAchPoint()

		local path = system.pathForFile ("playerDB.sqlite" , system.DocumentsDirectory)
		local db = sqlite.open(path)

		local myTable = {}
		local result = {}
	
	local sql =[[SELECT player_Achievement.player_ID, player_Data.player_Name, 
		player_Achievement.coll_2k,player_Achievement.coll_3k,player_Achievement.coll_5k,
		player_Achievement.lastColl,player_Achievement.hint1,player_Achievement.hint2,
		player_Achievement.hint3,player_Achievement.hint4,player_Achievement.acientFin,
		player_Achievement.middleFin,player_Achievement.earlyFin,
		player_Achievement.modernFin,player_Achievement.gameFin,player_Achievement.totalPoint  
	FROM player_Data INNER JOIN player_Achievement ON player_Data.player_ID = player_Achievement.player_ID 	WHERE totalPoint <> 0 ORDER BY totalPoint DESC LIMIT 10]]
	
		for row in db:nrows(sql) do
			myTable[#myTable+1] =
			{
				playerID = row.player_ID,
				playerName = row.player_Name,
				coll2k = row.coll_2k,
				coll3k = row.coll_3k,
				coll5k = row.coll_5k,
				coll10k = row.lastColl,
				hint1 = row.hint1,
				hint2 = row.hint2,
				hint3 = row.hint3,
				hint4 = row.hint4,
				ancientFin = row.acientFin,
				middleFin = row.middleFin,
				earlyFin = row.earlyFin,
				modernFin = row.modernFin,				gameFin = row.gameFin,
				totalPoint = row.totalPoint,
			}
		end	
	
		db:close()

	
	result = myTable

	return result
	
	
end	
M.getAchPoint =getAchPoint

return M