
local sqlite = require ( "sqlite3" )

local M = {}

local function createModernDB()
local path = system.pathForFile ("playerDB.sqlite" , system.DocumentsDirectory)
local db = sqlite.open(path)

local sql = [[
	CREATE TABLE IF NOT EXISTS modernDB (
	question_ID INTEGER PRIMARY KEY,
	Sci_Name,
	inv_Name,
	img_Path,
	disc_Date,
	inv_Desc,
	choice1,
	choice2,
	choice3,	level INTEGER
	);
	]]
print ("SUCCESSFULLY CREATED MODERN AGE DATABASE")	
db:exec(sql)
db:close()	
end
M.createModernDB = createModernDB

return M