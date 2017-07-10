
--this will get the player data everytime this module was called, in short it is updating for every changes done to the database

local sqlite = require ("sqlite3")
local myData = require ("myData")
local loadNewPlayerData = require ("loadNewPlayerData")

local M = {}

function getPlayerDat(filename , player_ID)
	local path = system.pathForFile (filename, system.DocumentsDirectory)
	local db = sqlite.open(path)
	local tblName = "player_Data"
	local colName = "player_ID"
	local playerID = player_ID--myData.currentPlayerID
	local upPlayerDat = {}
	local myTable = {}
	
		local sql ="SELECT * FROM " .. tblName .. " WHERE " .. colName .. " = " .. playerID
	
		for row in db:nrows(sql) do
			myTable = row
				return myTable
		end	
	db:close()

	upPlayerDat = myTable

	
	return upPlayerDat	
		
end
M.getPlayerDat = getPlayerDat
return M