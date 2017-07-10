
local sqlite = require ( "sqlite3" )

local M = {}

local function createMiddleDB()
local path = system.pathForFile ("playerDB.sqlite" , system.DocumentsDirectory)
local db = sqlite.open(path)

local sql = [[
	CREATE TABLE IF NOT EXISTS middleDB (
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
print ("SUCCESSFULLY CREATED MIDDLE AGE DATABASE")	
db:exec(sql)
db:close()	
end
M.createMiddleDB = createMiddleDB

return M