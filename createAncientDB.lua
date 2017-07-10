
local sqlite = require ( "sqlite3" )

local M = {}

local function createAncientDB()
local path = system.pathForFile ("playerDB.sqlite" , system.DocumentsDirectory)
local db = sqlite.open(path)

local sql = [[
	CREATE TABLE IF NOT EXISTS ancientDB (
	question_ID INTEGER PRIMARY KEY,
	Sci_Name,
	inv_Name,
	img_Path,
	disc_Date,
	inv_Desc,
	choice1,
	choice2,
	choice3,
	level INTEGER
	);
	]]
print ("SUCCESSFULLY CREATED ANCIENT ERA DATABASE")	
db:exec(sql)
db:close()	
end
M.createAncientDB = createAncientDB

return M