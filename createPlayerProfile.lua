local sqlite = require ("sqlite3")

local M = {}

function createProfile()
	local path = system.pathForFile ("playerDB.sqlite" , system.DocumentsDirectory)
	local db = sqlite.open(path)
	
	local sql =[[
		CREATE TABLE IF NOT EXISTS player_Data (
		player_ID INTEGER PRIMARY KEY,
		player_Name,
		current_Coins,
		coins_Acquired,
		achievement_pts,
		current_Level,
		current_Era,
		answered_Correct,
		answered_Wrong,
		num_Hints_Used,
		game_Finished,
		slots_Last_Used,
		level_Tries,
		last_LevelTry,
		save_Status
		);
		]]
print ("SUCCESSFULLY CREATED PLAYER DATABASE")
db:exec(sql)
db:close()
end
M.createProfile = createProfile

return M	