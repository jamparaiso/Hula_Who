
local sqlite = require ( "sqlite3" )
local sql
local tblName ="player_Data"
local colName = "save_Status"
local param =[["1"]]
local totalRows

local function countActiveSaveFile(dbName)

	local path = system.pathForFile (dbName,system.DocumentsDirectory)
	local db = sqlite.open(path)

	sql = "SELECT * FROM " .. tblName .. " WHERE " .. colName .. " = " .. param

	local totalRows = 0
	
		for row in db:nrows(sql) do
			totalRows = totalRows  + 1
		end				db:close()

	return totalRows
	
end

totalRows = countActiveSaveFile("playerDB.sqlite")

local M = {}

local totalRows = totalRows
M.totalRows = totalRows

return M