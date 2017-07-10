
--checks the user coins if it meet the conditions in achievements--this module is not is use

local myData = require ( "myData" )
local funcGetPlayerAch = require ( "funcGetPlayerAch" )
local storyboard = require ( "storyboard" )
local sqlite = require ( "sqlite3" )
local updateAchCoin = require ( "updateAchCoin" )

--player DATA
local playerData = {}
playerData = myData.playerDat
local playerID = playerData.player_ID

--coin achievement condition
local collectCoin1 = myData.collectCoin1
local collectCoin2 = myData.collectCoin2
local collectCoin3 = myData.collectCoin3
	
local collectCoin4 = myData.collectCoin4

--player coin achievement data
local coll2k
local coll3k
local coll5k
local lastColl
local totalPoint
--achievement points
local coll1Point = myData.coin1
local coll2Point = myData.coin2
local coll3Point = myData.coin3
local coll4Point = myData.coin4
-- parammeters
local pMe1
local pMe2
local pMe3
local pMe4
local pMe5

local M = {}

local function checkAchCoin(curCoin)
	

	local curCoin = curCoin

	local upPlayerAchData = {}
	upPlayerAchData = funcGetPlayerAch.getPlayerAch("playerDB.sqlite", playerID)

--player coin achievement data
 coll2k = upPlayerAchData.coll_2k
 coll3k = upPlayerAchData.coll_3k
 coll5k = upPlayerAchData.coll_5k
 lastColl = upPlayerAchData.lastColl
 totalPoint = upPlayerAchData.totalPoint
	

------------------------------------------------------------	
	local function upAchCoin()
			local path = system.pathForFile ("playerDB.sqlite",system.DocumentsDirectory)
			local db = sqlite.open(path)
	
	local sql ="UPDATE player_Achievement SET coll_2k = " .. pMe1 .. ", coll_3k = " .. pMe2 .. ", coll_5k = ".. pMe3 .. " , lastColl = ".. pMe4 .. ", totalPoint = ".. totalPoint .. " WHERE player_ID = ".. playerID

			db:exec(sql)
			print ("SUCCESSFULLY UPDATED PLAYER ACHIEVEMENT DATA")
			db:close()
	end
--------------------------------------------------------------
		

		if tonumber(curCoin) >= tonumber(collectCoin1) and tonumber(coll2k) == 0  then
			--show overlay here


				totalPoint = tonumber(totalPoint + coll1Point)
				pMe1 = 1
				pMe2 = 0
				pMe3 = 0
				pMe4 = 0
				updateAchCoin.updateAchCoin(playerID,pMe1,pMe2,pMe3,pMe4,totalPoint)
				
				myData.whatAch = "Stack of coins" -- used for the achievement overlay
				--timer.performWithDelay ( 1500, showAch )
				return true

		elseif curCoin >= collectCoin2 and tonumber(coll3k) == 0 then
			--show overlay here
			print ("coin achievement 2 complete")
			
				print ("player current point: " .. totalPoint)
				totalPoint = totalPoint + coll1Point
				param1 = 1
				param2 = 1
				param3 = 0
				param4 = 0
				
				print ("player new point :" .. totalPoint)	
				
				--upAchCoin()		
			
				myData.whatAch = "Pile of coins" -- used for the achievement overlay
			
				timer.performWithDelay ( 1500, showAch )
				return true
							
		elseif curCoin >= collectCoin3 and tonumber(coll5k) == 0 then
			--show overlay here
			print ("coin achievement 3 complete")
			
				print ("player current point: " .. totalPoint)
				totalPoint = totalPoint + coll1Point
				param1 = 1
				param2 = 1
				param3 = 1
				param4 = 0
				
				print ("player new point :" .. totalPoint)
				
				--upAchCoin()			
			
				myData.whatAch = "Bag of coins" -- used for the achievement overlay
			
				timer.performWithDelay ( 1500, showAch )
				return true
				
		elseif curCoin >= collectCoin4 and tonumber(lastColl) == 0 then
			--show overlay here			
			print ("coin achievement 4 complete")
			
				print ("player current point: " .. totalPoint)
				totalPoint = totalPoint + coll1Point
				param1 = 1
				param2 = 1
				param3 = 1
				param4 = 1
				
				print ("player new point :" .. totalPoint)	
				
				--upAchCoin()		
			
				myData.whatAch = "Chest of coins" -- used for the achievement overlay			
			
				timer.performWithDelay ( 1500, showAch )
				return true
		else
				return false
		end
end
M.checkAchCoin = checkAchCoin

return M 