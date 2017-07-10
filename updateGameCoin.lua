
local sqlite= require("sqlite3")

local M = {}

function upGameCoin(playerID, fileName,coins, acqCoins,curTime)
	local sql
	local coins = coins
	local acqCoins = acqCoins
	local tblName = "player_Data"
	local colCoin = "current_Coins"
	local acqCoin = "coins_Acquired"
	local slotLast = "slots_Last_Used"
	local curTime = curTime
	
	--if tonumber(coins) >= 999999 then
		--coins = 999999
	--end	
	
	local path = system.pathForFile (fileName,system.DocumentsDirectory)
	local db = sqlite.open(path)
	
	sql = "UPDATE " .. tblName .. " SET " .. colCoin .. " = " .. coins .. "," .. acqCoin .. " = " .. acqCoins .. ",".. slotLast .. " = " .. curTime .. " WHERE player_ID = " .. playerID
	
	print (sql)
	db:exec(sql)
	db:close()
	print ("successfully updated")
end
M.upGameCoin = upGameCoin

return M
