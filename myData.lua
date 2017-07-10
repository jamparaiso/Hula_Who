-- define a local table to store all references to functions/variables
--this will serve as Global Variable since its not good to use Global variables directly bcos of memory leaks and will make the system slower

local M = {}

local _W = display.viewableContentWidth --dynamic screen width getter
M._W = _W

local _H = display.viewableContentHeight --dynamic screen height getter
M._H = _H

local _HW = _W/2 --half of screen width
M._HW = _HW

local _HH = _H/2 -- half of screen height
M._HH = _HH


local fontStyle = "Krabby Patty"
M.fontStyle = fontStyle

local tapSound =  audio.loadSound ( "sounds/tap.wav") --global tapsound
M.tapSound = tapSound

local clockTick = audio.loadSound("sounds/ticking.wav" ) --global clock tick sound
M.clockTick = clockTick

local wrongSound = audio.loadSound ( "sounds/wrong.wav") --global wrong sound
M.wrongSound = wrongSound

local wrongSound2 = audio.loadSound ( "sounds/wrong2.wav") --global wrong sound
M.wrongSound2 = wrongSound2

local correctSound = audio.loadSound ( "sounds/right.wav" ) -- global correct sound
M.correctSound = correctSound

local correctSound2 = audio.loadSound ( "sounds/right2.wav" ) -- global correct sound
M.correctSound2 = correctSound2

local failSound = audio.loadSound ( "sounds/fail.wav") -- global level fail sound
M.failSound = failSound

local successSound = audio.loadSound ( "sounds/levelsuccess.wav" ) --global success sound
M.successSound = successSound

local slotSound = audio.loadSound("sounds/slotsound.wav")
M.slotSound = slotSound

local kaChingSound = audio.loadSound ("sounds/kaching.wav")
M.kaChingSound = kaChingSound


local backMusic = audio.loadStream ( "sounds/music_loop.wav" ) -- game music
M.backMusic = backMusic

local questionMusic = audio.loadStream ( "sounds/questionsound.wav" )
M.questionMusic = questionMusic

local backMusicHandler = nil
M.backMusicHandler = backMusicHandler

local questionMusicHandler = nil
M.questionMusicHandler = questionMusicHandlerlocal clockTickSoundHandler = nilM.clockTickSoundHandler = clockTickSoundHandler

--used for delete save profile to track the playerName
local playerName = nil
M.playerName = playerName

--determines what to load: new player profile or a saved player profile
local loadPlayerData = nil
M.loadPlayerData = loadPlayerData

local currentPlayerID = nil
M.currentPlayerID = currentPlayerID

local loadPlayerTable = {}
M.loadPlayerTable = loadPlayerTable

--prevents question from appearing concecutive
local lastQ = {}
M.lastQ = lastQ

--it detemines what question will be question
local qCount = 0
M.qCount = qCount

local year1 = nil
M.year1 = year1

local name1 = nil
M.name1 = name1

local invent1 = nil
M.invent1 = invent1

--in this table , the fectched player data will be put here
local playerDat = {}
M.playerDat = playerDat

--in this table, the fetched player achievement data will be here
local playerAchievement = {}
M.playerAchievement = playerAchievement

--dynamic level restrictions
local levelRestriction = {}
M.levelRestriction = levelRestriction

--answer counter in game proper
local playCor = 0
M.playCor = playCor

local playWro = 0
M.playWro = playWro

--description will be put here,, for hint
local questionDescription = nil
M.questionDescription = questionDescription

--era levels
local ancientLevel = 10
M.ancientLevel = ancientLevel

local middleLevel = 10
M.middleLevel = middleLevel

local earlyLevel = 15
M.earlyLevel = earlyLevel

local modernLevel = 15
M.modernLevel = modernLevel

--new player default data
local default_coins = 1000
M.default_coins = default_coins

local acquired_coins = 1000
M.acquired_coins = acquired_coins

local achieve_points = 0
M.achieve_points = achieve_points

local default_level = 1
M.default_level = default_level

local default_era = 1
M.default_era = default_era

local answered_correct = 0
M.answered_correct = answered_correct

local answered_wrong = 0
M.answered_wrong = answered_wrong

local num_hints_used = 0
M.num_hints_used =num_hints_used

local game_finished = 0
M.game_finished = game_finished

local slots_last_used = 0
M.slots_last_used = slots_last_used

local level_Tries = 0
M.level_Tries = level_Tries

local last_LevelTry = 0
M.last_LevelTry = last_LevelTry

local save_status = 1
M.save_status = save_status

--achievement default values
local coll2k = 0
M.coll2k = coll2k

local coll3k = 0
M.coll3k = coll3k

local coll5k = 0
M.coll5k = coll5k

local coll10k = 0
M.coll10k = coll10k

local hint1 = 0
M.hint1 = hint1

local hint2 = 0
M.hint2 = hint2

local hint3 = 0
M.hint3 = hint3

local hint4 = 0
M.hint4 = hint4

local ancientFin = 0
M.ancientFin = ancientFin

local middleFin = 0
M.middleFin = middleFin

local earlyFin = 0
M.earlyFin = earlyFin

local modernFin = 0
M.modernFin = modernFin

local gameFin = 0
M.gameFin = gameFin

local totalPoint = 0
M.totalPoint =totalPoint

--achievements conditions
local collectCoin1 = 2000
M.collectCoin1 = collectCoin1

local collectCoin2 = 3000
M.collectCoin2 = collectCoin2

local collectCoin3 = 5000
M.collectCoin3 = collectCoin3

local collectCoin4 = 10000
M.collectCoin4 = collectCoin4

local useHint1 = 10
M.useHint1 = useHint1

local useHint2 = 20
M.useHint2 = useHint2

local useHint3 = 30
M.useHint3 = useHint3

local useHint4 = 50
M.useHint4 = useHint4

--achievement points
local coin1 = 50
M.coin1 = coin1

local coin2 = 100
M.coin2 = coin2

local coin3 = 200
M.coin3 = coin3

local coin4 = 500
M.coin4 = coin4

local hintUse1 = 50
M.hintUse1 = hintUse1

local hintUse2 = 100
M.hintUse2 = hintUse2

local hintUse3 = 200
M.hintUse3 = hintUse3

local hintUse4 = 400
M.hintUse4 = hintUse4

local era1Fin = 100
M.era1Fin = era1Fin

local era2Fin = 200
M.era2Fin = era2Fin

local era3Fin = 300
M.era3Fin = era3Fin

local era4Fin = 400
M.era4Fin = era4Fin

local finGame = 500
M.finGame = finGame

--what achievement is completed
local whatAch = nil
M.whatAch = whatAch

-- Finally, return the table to be used locally elsewhere
return M



--[[ functions are now local:
local testFunction1 = function()
    print( "Test 1" )
end
-- assign a reference to the above local function
M.testFunction1 = testFunction1
 
local testFunction2 = function()
    print( "Test 2" )
end
M.testFunction2 = testFunction2
 
local testFunction3 = function()
    print( "Test 3" )
end
M.testFunction3 = testFunction3
]]--
 