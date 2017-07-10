
--altho the name tell get last but it also add achievement to the db

print ("add player achievement db")

local sqlite = require ( "sqlite3" )
local addPlayerAchievement = require ( "addPlayerAchievement" )
local myData = require ( "myData" )		
		
local M = {}	
		
local function getLast()

	local path = system.pathForFile ("playerDB.sqlite" , system.DocumentsDirectory)
	local db = sqlite.open(path)
	local tblName = "player_Data"
	local playerID = "player_ID"
	local myTable = {}
	
	local sql ="SELECT * FROM " .. tblName .. " WHERE " .. playerID .. " = (SELECT MAX(" .. playerID .. ") FROM " .. tblName .. ")"
	
		for row in db:nrows(sql) do
			myTable = row

		end	

	
	db:close()	
	
	--add player achievement record
	local playID = myTable.player_ID
	print ("player ID for achievement" .. playID)
	local a = {}
	
		  a = {
			coll2k = myData.coll2k,
			coll3k = myData.coll3k,
			coll5k = myData.coll5k,
			coll10k = myData.coll10k,
			hint1 = myData.hint1,
			hint2 = myData.hint2,
			hint3 = myData.hint3,
			hint4 = myData.hint4,
			ancientFin = myData.ancientFin,
			middleFin = myData.middleFin,
			earlyFin = myData.earlyFin,
			modernFin = myData.modernFin,
			gameFin = myData.gameFin,
			totalPoint = myData.totalPoint,	
		  }
	addPlayerAchievement.addAchievement(playID,a)
end
M.getLast = getLast	

	
return M