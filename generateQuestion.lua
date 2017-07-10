
--this module will generate the question for the player, according to its era
local sqlite = require ( "sqlite3" )

local M = {}

local function genQuestion(dbName,pLevel)
	local path = system.pathForFile ("playerDB.sqlite",system.DocumentsDirectory)
	local db = sqlite.open(path)
	local sql
	local dataBase = dbName	local level = pLevel
	local eraQuestion = {}
	sql = ("SELECT * FROM " .. dataBase .. " WHERE level = " .. level .. [[ ORDER BY RANDOM() LIMIT 15]])

	for row in db:nrows(sql) do
		eraQuestion[#eraQuestion + 1] = 
{
		qID = row.question_ID,
		sciName = row.Sci_Name,
		invName = row.inv_Name,
		imagePath = row.img_Path,
		discDate = row.disc_Date,
		briefDesc = row.inv_Desc,
		choice1 = row.choice1,
		choice2 = row.choice2,
		choice3 = row.choice3,
}
	end
	db:close()
	return eraQuestion
end	
M.genQuestion = genQuestion
return M
