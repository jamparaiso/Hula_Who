
--this fetch the new player data and put in variables

local sqlite = require ( "sqlite3" )
local myData = require ("myData")


local M = {}

function loadPlayerData()
local loadPlayerData1 = myData.loadPlayerData
print ("myData loadpayer")
print (loadPlayerData1)


local  result = {}

if loadPlayerData1 == true then
		
	local function fetchLastData(filename)
		print ("load new player profile")
		local path = system.pathForFile (filename , system.DocumentsDirectory)
		local db = sqlite.open(path)
		local tblName = "player_Data"
		local playerID = "player_ID"
		local myTable = {}
	
		local sql ="SELECT * FROM " .. tblName .. " WHERE " .. playerID .. " = (SELECT MAX(" .. playerID .. ") FROM " .. tblName .. ")"
	
		for row in db:nrows(sql) do
			myTable = row
				return myTable
		end	
	
		db:close()
	
		return nil
		
	end

	result = fetchLastData("playerDB.sqlite")

	
	return result

elseif loadPlayerData1 == false then

	print ("load save profile")
--this is for when the user load his profile in load game
	result = myData.loadPlayerTable
	return result
else
	print ("Error on choosing what to load")
end
end
M.loadPlayerData = loadPlayerData
return M

--[[player data
local M = {}

local playerID = result.player_ID
M.playerID = playerID

local playerName=result.player_Name
M.playerName = playerName

local currentCoins = result.current_Coins
M.currentCoins = currentCoins

local acquiredCoins = result.coins_Acquired
M.acquiredCoins = acquiredCoins

local achievementPts = result.achievement_pts
M.achievementPts = achievementPts

local currentLevel = result.current_Level
M.currentLevel = currentLevel

local currentEra = result.current_Era
M.currentEra = currentEra

local answeredCorrect = result.answered_Correct
M.answeredCorrect = answeredCorrect

local answeredWrong = result.answered_Wrong
M.answeredWrong = answeredWrong

local numHintsUsed = result.num_Hints_Used
M.numHintsUsed = numHintsUsed

local gameFinished = result.game_Finished
M.gameFinished = gameFinished

local slotsLastUsed = result.slots_Last_Used
M.slotsLastUsed = slotsLastUsed

local saveStatus = result.save_Status
M.saveStatus = saveStatus

return  M]]--