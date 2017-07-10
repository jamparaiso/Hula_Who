
print ("seeaAchievements module-----------------------------")

local tableView = require("tableView")
local widget = require("widget")
local myData = require ("myData")
local ui = require("ui")
local storyboard = require ( "storyboard" )
local systemConfigurations = require ( "systemConfigurations" )
local funcGetPlayerDat = require ("funcGetPlayerDat")
local funcGetPlayerAch = require ( "funcGetPlayerAch" )
local scene = storyboard.newScene()
local json = require ("json")
local gameSettings = { }

local function loadSysConfig()

	local function loadSystemConfig (filename)
		local path = system.pathForFile (filename,system.DocumentsDirectory )
		local contents = ""
		local myTable = { }
		local file = io.open ( path ,"r" )
	
			if file then
				local contents = file:read ("*a")
				myTable = json.decode( contents )
				io.close (file)
				return myTable	
			end
				return nil
	end

 gameSettings = loadSystemConfig ("systemConfiguration.json")

 end
--gets the currents system settings 
loadSysConfig()
local _H = myData._H
local _W = myData._W
local _HH = myData._HH
local _HW = myData._HW
local fontStyle = myData.fontStyle
local tapSound = myData.tapSound
local backMusic = myData.backMusic
local enableSound = gameSettings.soundOn
local enableMusic = gameSettings.musicOn

--updates the player data in myData
local playerID
playerID = myData.currentPlayerID
print ("current player ID: ".. playerID)
local upPlayerData = {}
upPlayerData = funcGetPlayerDat.getPlayerDat("playerDB.sqlite" , playerID)
print ("updated player name: " .. upPlayerData.player_Name)
myData.playerDat = upPlayerData

--updates the player achievement data in myData
local upPlayerAchData = {}
upPlayerAchData = funcGetPlayerAch.getPlayerAch("playerDB.sqlite", playerID)
print ("total Achievement points: " .. upPlayerAchData.totalPoint)
myData.playerAchievement = upPlayerAchData

local screenOffsetW, screenOffsetH = display.contentWidth -  display.viewableContentWidth, display.contentHeight - display.viewableContentHeight

local myList, backBtn, detailScreenText , detailScreenSub

--setup the table
local data = {}  --note: the declaration of this variable was moved up higher to broaden its scope

local screenGroup
local g
local button = display.newGroup ( )

--setup a destination for the list items
--group for detaiScreen
local detailScreen = display.newGroup()

--position of the slide on the top
local topBoundary = display.screenOriginY + 60
local bottomBoundary = display.screenOriginY + 65


--player achievements data
local coll2k = upPlayerAchData.coll_2k
local coll3k = upPlayerAchData.coll_3k
local coll5k = upPlayerAchData.coll_5k
local coll10k = upPlayerAchData.lastColl
local hint1 = upPlayerAchData.hint1
local hint2 = upPlayerAchData.hint2
local hint3 = upPlayerAchData.hint3
local hint4 = upPlayerAchData.hint4
local ancientFin = upPlayerAchData.acientFin
local middleFin = upPlayerAchData.middleFin
local earlyFin = upPlayerAchData.earlyFin
local modernFin = upPlayerAchData.modernFin
local gameFin = upPlayerAchData.gameFin
local totalPoint = upPlayerAchData.totalPoint

--dynamic data img path
local dtaImgPath1
local dtaImgPath2
local dtaImgPath3
local dtaImgPath4
local dtaImgPath5
local dtaImgPath6
local dtaImgPath7
local dtaImgPath8
local dtaImgPath9
local dtaImgPath10
local dtaImgPath11
local dtaImgPath12
local dtaImgPath13


--this the event handler when a selection is tapped
--setup functions to execute on touch of the list view items
local function listButtonRelease( event )
	self = event.target
	local id = self.id
	print(self.id)
	
	detailScreenText.text =  data[id].title --added this line to make the right side of the screen more interesting

	detailScreenSub.text = "Here Jam kung weron na"
	
		transition.to(myList, {time=400, x=display.contentWidth*-1, transition=easing.outExpo })
		transition.to(detailScreen, {time=400, x=0, transition=easing.outExpo })
		transition.to(detailScreenSub, {time=400, x=_W/2, transition=easing.outExpo })
		transition.to(backBtn, {time=400, x=_W/2, transition=easing.outExpo }) --position of back button when a selection is tapped
		transition.to(backBtn, {time=400, alpha=1 })
		delta, velocity = 0, 0
end

--back button is pressed
function backBtnRelease( event )
	print("back button released")
	transition.to(myList, {time=400, x=0, transition=easing.outExpo })
	transition.to(detailScreen, {time=400, x=display.contentWidth, transition=easing.outExpo })
	transition.to(detailScreenSub, {time=400, x=display.contentWidth, transition=easing.outExpo })
	transition.to(backBtn, {time=400, x=math.floor(backBtn.width/2)+backBtn.width, transition=easing.outExpo })
	transition.to(backBtn, {time=400, alpha=0 })

	delta, velocity = 0, 0
end

--callback function if the navtop is tapped
local function scrollToTop()
	myList:scrollTo(topBoundary-1)
end

local function backMenu(event)
	local phase = event.phase
		if phase == "ended" then
			print ("back to menu is press and released")
				if enableSound == true then
					audio.play(tapSound)
				end
				storyboard.gotoScene("playerMenu",{
					effect = "slideRight",
					time = 250,
					})
		end	
end


--uncompleted achievement image path
local unCompAch = 
{
{unImgPath = "images/stackofcoin.png"},
{unImgPath = "images/pileofcoin.png"},
{unImgPath = "images/bagofcoin.png"},
{unImgPath = "images/chestofcoin.png"},
{unImgPath = "images/hint.png"},
{unImgPath = "images/hint2.png"},
{unImgPath = "images/hint3.png"},
{unImgPath = "images/hint4.png"},
{unImgPath = "images/ancientsmall.png"},
{unImgPath = "images/middlesmall.png"},
{unImgPath = "images/earlysmall.png"},
{unImgPath = "images/modernsmall.png"},
{unImgPath = "images/gamefinish.png"},	
}

--completed achievement image path
local compAch = 
{
{imgPath = "images/stackofcoinfinnish.png"},
{imgPath = "images/pileofcoinfinnish.png"},
{imgPath = "images/bagofcoinfinnish.png"},
{imgPath = "images/chestofcoinfinnish.png"},
{imgPath = "images/hintfinnish.png"},
{imgPath = "images/hint2finnish.png"},
{imgPath = "images/hint3finnish.png"},
{imgPath = "images/hint4finnish.png"},
{imgPath = "images/ancientfinnish.png"},
{imgPath = "images/middlefinnish.png"},
{imgPath = "images/earlyfinnish.png"},
{imgPath = "images/modernfinish.png"},
{imgPath = "images/gamefinishfinnish.png"},	
}

--set what image to show
local function whatShow()
--for 2k coins	
	if tonumber(coll2k) == 0 then
		dtaImgPath1 = unCompAch[1].unImgPath
	elseif tonumber(coll2k) == 1 then
		dtaImgPath1 = compAch[1].imgPath	
	end
--for 3k coins	
	if tonumber(coll3k) == 0 then
		dtaImgPath2 = unCompAch[2].unImgPath
	elseif tonumber(coll3k) == 1 then
		dtaImgPath2 = compAch[2].imgPath	
	end
--for 5k coins	
	if tonumber(coll5k) == 0 then
		dtaImgPath3 = unCompAch[3].unImgPath
	elseif tonumber(coll5k) == 1 then
		dtaImgPath3 = compAch[3].imgPath	
	end
--for 10k coins
	if tonumber(coll10k) == 0 then
		dtaImgPath4 = unCompAch[4].unImgPath
	elseif tonumber(coll10k) == 1 then
		dtaImgPath4 = compAch[4].imgPath	
	end
--for hint 1
	if tonumber(hint1) == 0 then
		dtaImgPath5 = unCompAch[5].unImgPath
	elseif tonumber(hint1) == 1 then
		dtaImgPath5 = compAch[5].imgPath	
	end
--for hint 2
	if tonumber(hint2) == 0 then
		dtaImgPath6 = unCompAch[6].unImgPath
	elseif tonumber(hint2) == 1 then
		dtaImgPath6 = compAch[6].imgPath	
	end
--for hint 3
	if tonumber(hint3) == 0 then
		dtaImgPath7 = unCompAch[7].unImgPath
	elseif tonumber(hint3) == 1 then
		dtaImgPath7 = compAch[7].imgPath	
	end
--for hint 4
	if tonumber(hint4) == 0 then
		dtaImgPath8 = unCompAch[8].unImgPath
	elseif tonumber(hint4) == 1 then
		dtaImgPath8 = compAch[8].imgPath	
	end
--for ancient
	if tonumber(ancientFin) == 0 then
		dtaImgPath9 = unCompAch[9].unImgPath
	elseif tonumber(ancientFin) == 1 then
		dtaImgPath9 = compAch[9].imgPath	
	end
--for middle
	if tonumber(middleFin) == 0 then
		dtaImgPath10 = unCompAch[10].unImgPath
	elseif tonumber(middleFin) == 1 then
		dtaImgPath10 = compAch[10].imgPath	
	end
--for early
	if tonumber(earlyFin) == 0 then
		dtaImgPath11 = unCompAch[11].unImgPath
	elseif tonumber(earlyFin) == 1 then
		dtaImgPath11 = compAch[11].imgPath	
	end
--for modern
	if tonumber(modernFin) == 0 then
		dtaImgPath12 = unCompAch[12].unImgPath
	elseif tonumber(modernFin) == 1 then
		dtaImgPath12 = compAch[12].imgPath	
	end
--for game finish
	if tonumber(gameFin) == 0 then
		dtaImgPath13 = unCompAch[13].unImgPath
	else
		dtaImgPath13 = compAch[13].imgPath	
	end		
	

--static data table
--******************************************************************
--setup each row as a new table, then add title, subtitle, and image
data[1] = {}
data[1].title = "Stack of coins"
data[1].subtitle = "Collect 2000 coins"
data[1].achtitle = ("Achievement Points: " .. myData.coin1)
data[1].image = dtaImgPath1

data[2] = {}
data[2].title = "Pile of coins"
data[2].subtitle = "Collect 3000 coins"
data[2].achtitle = ("Achievement Points: " .. myData.coin2)
data[2].image = dtaImgPath2

data[3] = {}
data[3].title = "Bag of coins"
data[3].subtitle = "Collect 5000 coins"
data[3].achtitle = ("Achievement Points: " .. myData.coin3)
data[3].image = dtaImgPath3

data[4] = {}
data[4].title = "Chest of coins"
data[4].subtitle = "Collect 10,000 coins"
data[4].achtitle = ("Achievement Points: " .. myData.coin4)
data[4].image = dtaImgPath4

data[5] = {}
data[5].title = "Hint user"
data[5].subtitle = "Use hint 20 times"
data[5].achtitle = ("Achievement Points: " .. myData.hintUse1)
data[5].image = dtaImgPath5

data[6] = {}
data[6].title = "Hint buyer"
data[6].subtitle = "Use hint 30 times"
data[6].achtitle = ("Achievement Points: " .. myData.hintUse2)
data[6].image = dtaImgPath6

data[7] = {}
data[7].title = "Hint customer"
data[7].subtitle = "Use hint 40 times"
data[7].achtitle = ("Achievement Points: " .. myData.hintUse3)
data[7].image = dtaImgPath7

data[8] = {}
data[8].title = "Hint shopper"
data[8].subtitle = "Use hint 50 times"
data[8].achtitle = ("Achievement Points: " .. myData.hintUse4)
data[8].image = dtaImgPath8

data[9] = {}
data[9].title = "Ancient Master"
data[9].subtitle = "Finish Ancient period for the first time"
data[9].achtitle = ("Achievement Points: " .. myData.era1Fin)
data[9].image = dtaImgPath9

data[10] = {}
data[10].title = "Middle Age Commoner"
data[10].subtitle = "Finish Middle Age for the first time"
data[10].achtitle = ("Achievement Points: " .. myData.era2Fin)
data[10].image = dtaImgPath10

data[11] = {}
data[11].title = "Early Modern Ranger"
data[11].subtitle = "Finish Early Modern Age for the first time"
data[11].achtitle = ("Achievement Points: " .. myData.era3Fin)
data[11].image = dtaImgPath11

data[12] = {}
data[12].title = "Modern Age Genius"
data[12].subtitle = "Finish Modern Age for the first time"
data[12].achtitle = ("Achievement Points: " .. myData.era4Fin)
data[12].image = dtaImgPath12

data[13] = {}
data[13].title = "Game Master"
data[13].subtitle = "Finish the game for the first time"
data[13].achtitle = ("Achievement Points: " .. myData.finGame)
data[13].image = dtaImgPath13

end

function scene:createScene()
	screenGroup = self.view

	whatShow()
	
	local background = display.newImage("images/background.png")
		  background.x = _W * 0.5 ; background.y = _H * 0.5
		  
		screenGroup:insert(background)

--detail screen text		
detailScreenText = display.newText("You tapped item", 0, 0,fontStyle, _W * 0.08)
detailScreenText:setTextColor(255, 255, 255)
detailScreen:insert(detailScreenText)
detailScreenText.x = math.floor(display.contentWidth/2)
detailScreenText.y = math.floor(display.contentHeight-380) 	
detailScreen.x = display.contentWidth


detailScreenSub = display.newText("You tapped item", 0, 0,fontStyle, _W * 0.06)
detailScreenSub:setTextColor(255, 255, 255)
detailScreen:insert(detailScreenSub)
detailScreenSub.x = math.floor(display.contentWidth/2)
detailScreenSub.y = math.floor(display.contentHeight-250) 	
detailScreenSub.x = display.contentWidth

		  
end

local function youTapMe()
	print ("okay you tapped me")
end	

function scene:enterScene()

-- create the list of items
myList = tableView.newList{
	data=data, 
	--default="images/listItemBg.png",
	--over="images/listItemBg_over.png",
	--onRelease=listButtonRelease,
	onRelease = youTapMe,
	top=topBoundary,
	bottom=bottomBoundary,
    callback = function( row )
                          g = display.newGroup()

                         local img = display.newImage(row.image)
                         g:insert(img)
                         img.x = math.floor(img.width*0.5 + 6)
                         img.y = math.floor(img.height*0.5)
						 img.yScale = 1
						 img.xScale = 1
						--inserts the title of the img
                         local title =  display.newText( row.title, 0, 0, fontStyle, 14 )
                         title:setTextColor(0, 0, 0)
                         --title:setTextColor(255, 255, 255)
                         g:insert(title)
                         title.x = title.width*0.5 + img.width + 6
                         title.y = 30
						 
						--inserts the subtitle of the img
                         local subtitle =  display.newText( row.subtitle, 0, 0, fontStyle, 11 )
                         subtitle:setTextColor(80,80,80)
                         --subtitle:setTextColor(180,180,180)
                         g:insert(subtitle)
                         subtitle.x = subtitle.width*0.5 + img.width + 6
                         subtitle.y = title.y + title.height + 6
                         
                         						--inserts the subtitle of the img
                         local achievement =  display.newText( row.achtitle, 0, 0, fontStyle, 11 )
                         achievement:setTextColor(80,80,80)
                         --subtitle:setTextColor(180,180,180)
                         g:insert(achievement)
                         achievement.x = achievement.width*0.5 + img.width + 6
                         achievement.y = subtitle.y + subtitle.height + 6

                         return g   
                  end 
}	
	
--Setup the nav bar
--top bar 
local navBar = ui.newButton{
	default = "images/navBar.png",
	onRelease = scrollToTop
}
navBar.x = display.contentWidth*.5
navBar.y = math.floor(display.screenOriginY + navBar.height*0.5)


--Setup the back button
backBtn = ui.newButton{ 
	default = "images/back.png", 
	over = "images/backpress.png", 
	onRelease = backBtnRelease
}
backBtn.x = math.floor(backBtn.width/2) + backBtn.width + screenOffsetW
backBtn.y = 460
backBtn.xScale = .7
backBtn.yScale = .7
backBtn.alpha = 0

local pointText = display.newText(  "Total points:" .. totalPoint,110, 20, fontStyle, 15 )

local bottomWrap = display.newImageRect ( "images/achievementsBottom.png",  320, 60 )
	bottomWrap.x = _W /2 ; bottomWrap.y = 483	
	
local backToMenu = widget.newButton
{
	left = 40,
	top = 455,
	width = 250,
	height = 45,
	defaultFile = "images/backlong.png",
	overFile = "images/backlongpress.png",
	id = "gotomenu",
	onEvent = backMenu,
}
	button:insert(myList)
	button:insert(navBar)
	button:insert(pointText)
	button:insert(bottomWrap)
	button:insert(backToMenu)
	button:insert(backBtn)
end



function scene:exitScene()
	screenGroup:removeSelf()
	screenGroup = nil
	detailScreen:removeSelf()
	detailScreen = nil
	if g ~= nil then
	g:removeSelf()
	g = nil
	end
	button:removeSelf()
	button = nil
	data = nil
end

function scene:didExitScene()
	storyboard.removeScene("seeAchievements")
end

scene:addEventListener ( "createScene", scene )
scene:addEventListener ( "enterScene", scene )
scene:addEventListener ( "overlayBegan", scene )
scene:addEventListener ( "overlayEnded", scene )
scene:addEventListener ( "exitScene", scene )
scene:addEventListener ( "didExitScene", scene )

return scene				