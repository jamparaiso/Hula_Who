
--gets the`player achievement data

local sqlite = require ("sqlite3")
local myData = require ("myData")


local M = {}

function getPlayerAch(filename , player_ID)
	local path = system.pathForFile (filename, system.DocumentsDirectory)
	local db = sqlite.open(path)
	local tblName = "player_Achievement"
	local colName = "player_ID"
	local playerID = player_ID--myData.currentPlayerID
	local upPlayerAch = {}
	local myTable = {}
	
		local sql ="SELECT * FROM " .. tblName .. " WHERE " .. colName .. " = " .. playerID
	
		for row in db:nrows(sql) do
			myTable = row
				return myTable
		end
			
	db:close()

	upPlayerAch = myTable

	
	return upPlayerAch	
		
end
M.getPlayerAch = getPlayerAch
return M