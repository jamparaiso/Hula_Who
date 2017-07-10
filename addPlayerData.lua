
local sqlite = require ("sqlite3")

local M = {}

function addPlayer(tbl)

	local path = system.pathForFile ("playerDB.sqlite" , system.DocumentsDirectory)
	local db = sqlite.open(path)
	
local sql = [[
INSERT INTO player_Data ("player_Name","current_Coins","coins_Acquired","achievement_pts","current_Level","current_Era","answered_Correct","answered_Wrong",
"num_Hints_Used","game_Finished","slots_Last_Used","level_Tries","last_LevelTry","save_Status")
VALUES ("]] .. tbl.player_Name ..
[[","]] .. tbl.default_coins ..
[[","]] .. tbl.acquired_coins ..
[[","]] .. tbl.achieve_points ..
[[","]] .. tbl.default_level ..
[[","]] .. tbl.default_era ..	
[[","]] .. tbl.answered_correct ..
[[","]] .. tbl.answered_wrong ..
[[","]] .. tbl.num_hints_used ..
[[","]] .. tbl.game_finished  ..
[[","]] .. tbl.slots_last_used ..
[[","]] .. tbl.level_Tries ..
[[","]] .. tbl.last_LevelTry ..	
[[","]] .. tbl.save_status ..
[[");]]	
db:exec(sql)	
db:close()
print ("SUCCESSFULLY CREATED PLAYER DATA")
end
M.addPlayer = addPlayer

return M