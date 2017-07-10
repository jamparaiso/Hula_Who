
local sqlite = require("sqlite3")

local M ={}


function getSaveData(dbName)

local tblName = "player_Data"
local colName = "save_Status"
local param = [["1"]]
local dataTable= {}

local path = system.pathForFile (dbName,system.DocumentsDirectory)
local db = sqlite.open(path)

local sql = "SELECT * FROM " .. tblName .. " WHERE " .. colName .. " = " .. param

local saveFileInfo = {}

	for row in db:nrows(sql) do
		print ("PLAYER ID " .. row.player_ID)
		
		saveFileInfo[#saveFileInfo+1]=
		{
			playerID = row.player_ID,
			playerName = row.player_Name,
			currentCoins = row.current_Coins,
			acquiredCoins = row.coins_Acquired,
			achievementPoints = row.achievement_pts,
			currentLevel = row.current_Level,
			currentEra = row.current_Era,
			answeredCorrect = row.answered_Correct,
			answeredWrong = row.answered_Wrong,
			numHintsUsed = row.num_Hints_Used,
			gameFinished = row.game_Finished,
			slotsLastUsed = row.slots_Last_Used,
			saveStatus = row.save_Status,
		}
	end
	
	db:close()

	return saveFileInfo

end
M.getSaveData = getSaveData
return M
