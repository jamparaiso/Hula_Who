
--dont touch any code on this module, this was optimized everytime there is changes on questionTable

local sqlite =require ( "sqlite3" )
local questionTable = require ( "questionTable" )

local M = {}

--add ancient period question
--*************************************
local function addAncientQuestion()
	local path = system.pathForFile ( "playerDB.sqlite",system.DocumentsDirectory)
	local db = sqlite.open(path)
	local sql
	local ancientTable = {}
	ancientTable = questionTable.ancientQuestion
	print ("TOTAL ANCIENT QUESTION: "..#ancientTable)
	
	local totalRows = 0
		for row in db:nrows("SELECT * FROM ancientDB") do
			totalRows = totalRows + 1
		end
		
		if (totalRows == 0) then
			for z= 1, #ancientTable do
			sql = [[
				INSERT INTO ancientDB ("Sci_Name" ,"inv_Name" ,"img_Path", "disc_Date" , "inv_Desc", "choice1", "choice2" , "choice3","level")
			VALUES ("]] .. ancientTable[z].sciName ..
			[[","]] .. ancientTable[z].invName ..
			[[","]] .. ancientTable[z].imagePath ..
			[[","]] .. ancientTable[z].discDate ..
			[[","]] .. ancientTable[z].briefDesc ..
			[[","]] .. ancientTable[z].choice1 ..
			[[","]] .. ancientTable[z].choice2 ..
			[[","]] .. ancientTable[z].choice3 ..
			[[","]] .. ancientTable[z].level ..	
			[[");]]
			db:exec(sql)
				end
		end	
db:close()		
end	
M.addAncientQuestion = addAncientQuestion


--add middle age questios
--***************************************
local function addMiddleQuestion()
	local path = system.pathForFile ( "playerDB.sqlite",system.DocumentsDirectory)
	local db = sqlite.open(path)
	local sql
	local middleTable = {}
	middleTable = questionTable.middleQuestion
	print ("TOTAL MIDDLE AGE QUESTION: ".. #middleTable)
	
	local totalRows = 0
		for row in db:nrows("SELECT * FROM middleDB") do
			totalRows = totalRows + 1
		end
		
		if (totalRows == 0) then
			for z= 1, #middleTable do
			sql = [[
				INSERT INTO middleDB ("Sci_Name" ,"inv_Name", "img_Path", "disc_Date" , "inv_Desc", "choice1", "choice2" , "choice3","level")
			VALUES ("]] .. middleTable[z].sciName ..
			[[","]] .. middleTable[z].invName ..
			[[","]] .. middleTable[z].imagePath ..
			[[","]] .. middleTable[z].discDate ..
			[[","]] .. middleTable[z].briefDesc ..
			[[","]] .. middleTable[z].choice1 ..
			[[","]] .. middleTable[z].choice2 ..
			[[","]] .. middleTable[z].choice3 ..			[[","]] .. middleTable[z].level ..	
			[[");]]
			db:exec(sql)
				end
		end	
db:close()
end
M.addMiddleQuestion = addMiddleQuestion	


--add early modern age questios
--*********************************************
local function addEarlyQuestion()
	local path = system.pathForFile ( "playerDB.sqlite",system.DocumentsDirectory)
	local db = sqlite.open(path)
	local sql
	local earlyTable = {}
	earlyTable = questionTable.earlyQuestion
	print ("TOTAL EARLY MODERN AGE QUESTION: ".. #earlyTable)
	
	local totalRows = 0
		for row in db:nrows("SELECT * FROM earlyDB") do
			totalRows = totalRows + 1
		end
		
		if (totalRows == 0) then
			for z= 1, #earlyTable do
			sql = [[
				INSERT INTO earlyDB ("Sci_Name" ,"inv_Name", "img_Path", "disc_Date" , "inv_Desc", "choice1", "choice2" , "choice3","level")
			VALUES ("]] .. earlyTable[z].sciName ..
			[[","]] .. earlyTable[z].invName ..
			[[","]] .. earlyTable[z].imagePath ..
			[[","]] .. earlyTable[z].discDate ..
			[[","]] .. earlyTable[z].briefDesc ..
			[[","]] .. earlyTable[z].choice1 ..
			[[","]] .. earlyTable[z].choice2 ..
			[[","]] .. earlyTable[z].choice3 ..			[[","]] .. earlyTable[z].level ..	
			[[");]]
			db:exec(sql)
				end
		end	
db:close()
end
M.addEarlyQuestion = addEarlyQuestion


--add modern age question
--******************************************
local function addModernQuestion()
	local path = system.pathForFile ( "playerDB.sqlite",system.DocumentsDirectory)
	local db = sqlite.open(path)
	local sql
	local modernTable = {}
	modernTable = questionTable.modernQuestion
	print ("TOTAL MODERN AGE QUESTIONS ".. #modernTable)
	
	local totalRows = 0
		for row in db:nrows("SELECT * FROM modernDB") do
			totalRows = totalRows + 1
		end
		
		if (totalRows == 0) then
			for z= 1, #modernTable do
			sql = [[
				INSERT INTO modernDB ("Sci_Name" ,"inv_Name", "img_Path", "disc_Date" , "inv_Desc", "choice1", "choice2" , "choice3","level")
			VALUES ("]] .. modernTable[z].sciName ..
			[[","]] .. modernTable[z].invName ..
			[[","]] .. modernTable[z].imagePath ..
			[[","]] .. modernTable[z].discDate ..
			[[","]] .. modernTable[z].briefDesc ..
			[[","]] .. modernTable[z].choice1 ..
			[[","]] .. modernTable[z].choice2 ..
			[[","]] .. modernTable[z].choice3 ..			[[","]] .. modernTable[z].level ..	
			[[");]]
			db:exec(sql)
				end
		end	
db:close()
end
M.addModernQuestion = addModernQuestion

return M