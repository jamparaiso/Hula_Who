
print ("leaderBoards module----------------------------------------")

local tableView = require("tableView")
local widget = require("widget")
local myData = require ("myData")
local ui = require("ui")
local storyboard = require ( "storyboard" )
local systemConfigurations = require ( "systemConfigurations" )
local getTotalPoint = require ( "getTotalPoint" )
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

local screenOffsetW, screenOffsetH = display.contentWidth -  display.viewableContentWidth, display.contentHeight - display.viewableContentHeight
local myList, detailScreenText , detailScreenSub, detailScreenSub1,detailScreenSub2,detailScreenSub4,detailScreenSub5
local detailScreenSub6,detailScreenSub7,detailScreenSub8,detailScreenSub9,detailScreenSub10,detailScreenSub11,detailScreenSub12
local achImg,achImg1,achImg2,achImg3,achImg4,achImg5,achImg6,achImg7,achImg8,achImg9,achImg10,achImg11,achImg12

--setup the table
local data = {}  --note: the declaration of this variable was moved up higher to broaden its scope

local screenGroup
local g
local button = display.newGroup()
--setup a destination for the list items
--group for detaiScreen
local detailScreen = display.newGroup()
--position of the slide on the top
local topBoundary = display.screenOriginY + 70
local bottomBoundary = display.screenOriginY + 65

local totalAchPoint ={}
totalAchPoint = getTotalPoint.getAchPoint()

local imgTable = {
{imgPath ="images/goldtrophy.png"},
{imgPath ="images/silvertrophy.png"},
{imgPath ="images/bronzetrophy.png"},
{imgPath ="images/medal4.png"},
{imgPath ="images/medal5.png"},
{imgPath ="images/medal6.png"},
{imgPath ="images/medal7.png"},
{imgPath ="images/medal8.png"},
{imgPath ="images/medal9.png"},
{imgPath ="images/medal10.png"},	
}

--dynamic list view
--shows all the top 10 player
for i = 1, #totalAchPoint do
	data[i] = {}
	data[i].title = (totalAchPoint[i].playerName) 
	data[i].subtitle = ("Total Achievement Points :".. totalAchPoint[i].totalPoint)
	data[i].image = imgTable[i].imgPath
	data[i].col2 = totalAchPoint[i].coll2k
	data[i].col3 = totalAchPoint[i].coll3k
	data[i].col5 = totalAchPoint[i].coll5k
	data[i].col10 = totalAchPoint[i].coll10k
	data[i].hint1 = totalAchPoint[i].hint1
	data[i].hint2 = totalAchPoint[i].hint2
	data[i].hint3 = totalAchPoint[i].hint3
	data[i].hint4 = totalAchPoint[i].hint4
	data[i].ancientFin = totalAchPoint[i].ancientFin
	data[i].middleFin = totalAchPoint[i].middleFin
	data[i].earlyFin = totalAchPoint[i].earlyFin
	data[i].modernFin = totalAchPoint[i].modernFin
	data[i].gameFin = totalAchPoint[i].gameFin
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

local function swipeEvent(event)
	local phase = event.phase
	local xPos
	local yPos
		if phase =="began" then
			 xPos = event.x --store the location of the touch event
			 yPos = event.y --store the localtion of the touch event
		elseif phase == "moved" then
			if event.x > event.xStart then
				backBtnRelease()
			end		
		end	
end	

--this the event handler when a selection is tapped
--setup functions to execute on touch of the list view items
local function listButtonRelease( event )
	self = event.target
	local id = self.id

	
	detailScreenText.text = "Achievements" --added this line to make the right side of the screen more interesting
	
	if tonumber(data[id].col2) == 1 then
		detailScreenSub.alpha = 1
		achImg.alpha = 1
	else
		detailScreenSub.alpha = .4
		achImg.alpha = .4	
	end
			
	if tonumber(data[id].col3) == 1 then
		detailScreenSub1.alpha = 1
		achImg1.alpha = 1
	else
		detailScreenSub1.alpha = .4
		achImg1.alpha = .4	
	end
		
	if tonumber(data[id].col5) == 1 then
		detailScreenSub2.alpha = 1
		achImg2.alpha = 1
	else
		detailScreenSub2.alpha = .4
		achImg2.alpha = .4	
	end
		
	if tonumber(data[id].col10) == 1 then
		detailScreenSub3.alpha = 1
		achImg3.alpha = 1
	else
		detailScreenSub3.alpha = .4
		achImg3.alpha = .4	
	end
		
	if tonumber(data[id].hint1) == 1 then
		detailScreenSub4.alpha = 1
		achImg4.alpha = 1
	else
		detailScreenSub4.alpha = .4
		achImg4.alpha = .4	
	end
		
	if tonumber(data[id].hint2) == 1 then
		detailScreenSub5.alpha = 1
		achImg5.alpha = 1
	else
		detailScreenSub5.alpha = .4
		achImg5.alpha = .4	
	end
		
	if tonumber(data[id].hint3) == 1 then
		detailScreenSub6.alpha = 1
		achImg6.alpha = 1
	else
		detailScreenSub6.alpha = .4
		achImg6.alpha = .4	
	end
		
	if tonumber(data[id].hint4) == 1 then
		detailScreenSub7.alpha = 1
		achImg7.alpha = 1
	else
		detailScreenSub7.alpha = .4
		achImg7.alpha = .4	
	end
		
	if tonumber(data[id].ancientFin) == 1 then
		detailScreenSub8.alpha = 1
		achImg8.alpha = 1
	else
		detailScreenSub8.alpha = .4
		achImg8.alpha = .4	
	end
		
	if tonumber(data[id].middleFin) == 1 then
		detailScreenSub9.alpha = 1
		achImg9.alpha = 1
	else
		detailScreenSub9.alpha = .4
		achImg9.alpha = .4	
	end
		
	if tonumber(data[id].earlyFin) == 1 then
		detailScreenSub10.alpha = 1
		achImg10.alpha = 1
	else
		detailScreenSub10.alpha = .4
		achImg10.alpha = .4	
	end
		
	if tonumber(data[id].modernFin) == 1 then
		detailScreenSub11.alpha = 1
		achImg11.alpha = 1
	else
		detailScreenSub11.alpha = .4
		achImg11.alpha = .4	
	end
		
	if tonumber(data[id].gameFin) == 1 then
		detailScreenSub12.alpha = 1
		achImg12.alpha = 1
	else
		detailScreenSub12.alpha = .4
		achImg12.alpha = .4																															
	end
	
		transition.to(myList, {time=400, x=display.contentWidth*-1, transition=easing.outExpo })
		transition.to(detailScreen, {time=400, x=0, transition=easing.outExpo })

		delta, velocity = 0, 0
		
		Runtime:addEventListener ( "touch", swipeEvent )	
end

--back button is pressed
function backBtnRelease()

	transition.to(myList, {time=400, x=0, transition=easing.outExpo })
	transition.to(detailScreen, {time=400, x=display.contentWidth, transition=easing.outExpo })

	delta, velocity = 0, 0
	Runtime:removeEventListener ( "touch", swipeEvent )
end

local function backMenu(event)
	local phase = event.phase
		if phase == "ended" then

				if enableSound == true then
					audio.play(tapSound)
				end
				Runtime:removeEventListener ( "touch", swipeEvent )
				storyboard.gotoScene("mainmenu",{
					effect = "slideRight",
					time = 250,
					})
		end	
end

--callback function if the navtop is tapped
local function scrollToTop()
	myList:scrollTo(topBoundary-1)
end


function scene:createScene()
	screenGroup = self.view
	
	local background = display.newImage("images/background.png")
		  background.x = _W * 0.5 ; background.y = _H * 0.5
		  
		screenGroup:insert(background)

--achievement text		
detailScreenText = display.newText("You tapped item", 0, 0,fontStyle, _W * 0.08)
detailScreenText:setTextColor(255, 255, 255)

detailScreenText.x = math.floor(display.contentWidth/2)
detailScreenText.y = math.floor(display.contentHeight-435)
detailScreen:insert(detailScreenText)
 	

--achievement list
achImg = display.newImageRect ( unCompAch[1].unImgPath, 40, 40 )
achImg.x = math.floor(display.contentWidth-250)
achImg.y = math.floor (display.contentHeight-405 )
detailScreen:insert(achImg)
achImg.alpha = 0.4
detailScreenSub = display.newText("Stack of coins", 0, 0,fontStyle, _W * 0.05)
detailScreenSub:setTextColor(255, 255, 255)

detailScreenSub.x = math.floor(display.contentWidth-166)
detailScreenSub.y = math.floor(display.contentHeight-405)
detailScreenSub:setReferencePoint ( display.CenterLeftReferencePoint )
detailScreen:insert(detailScreenSub)

detailScreenSub.alpha = 0.4


achImg1 = display.newImageRect ( unCompAch[2].unImgPath, 40, 40 )
achImg1.x = math.floor(display.contentWidth-250)
achImg1.y = math.floor (display.contentHeight-375 )
detailScreen:insert(achImg1)
achImg1.alpha = 0.4
detailScreenSub1 = display.newText("Pile of coins", 0, 0,fontStyle, _W * 0.05)
detailScreenSub1:setTextColor(255, 255, 255)
detailScreenSub1.x = math.floor(display.contentWidth-173)
detailScreenSub1.y = math.floor(display.contentHeight-375)
detailScreenSub1:setReferencePoint ( display.CenterLeftReferencePoint )
detailScreen:insert(detailScreenSub1)
detailScreenSub1.alpha = 0.4

achImg2 = display.newImageRect (unCompAch[3].unImgPath, 40, 40)
achImg2.x = math.floor(display.contentWidth-250)
achImg2.y = math.floor (display.contentHeight-345 )
detailScreen:insert(achImg2)
achImg2.alpha = 0.4
detailScreenSub2 = display.newText("Bag of coins", 0, 0,fontStyle, _W * 0.05)
detailScreenSub2:setTextColor(255, 255, 255)
detailScreenSub2.x = math.floor(display.contentWidth-170)
detailScreenSub2.y = math.floor(display.contentHeight-345)
detailScreenSub2:setReferencePoint ( display.CenterLeftReferencePoint )
detailScreen:insert(detailScreenSub2)
detailScreenSub2.alpha = 0.4 

achImg3 = display.newImageRect (unCompAch[4].unImgPath, 40, 40)
achImg3.x = math.floor(display.contentWidth-250)
achImg3.y = math.floor (display.contentHeight-315 )
detailScreen:insert(achImg3)
achImg3.alpha = 0.4
detailScreenSub3 = display.newText("Chest of coins", 0, 0,fontStyle, _W * 0.05)
detailScreenSub3:setTextColor(255, 255, 255)
detailScreenSub3.x = math.floor(display.contentWidth-164)
detailScreenSub3.y = math.floor(display.contentHeight-315)
detailScreenSub3:setReferencePoint ( display.CenterLeftReferencePoint )
detailScreen:insert(detailScreenSub3)
detailScreenSub3.alpha = 0.4 

achImg4 = display.newImageRect (unCompAch[5].unImgPath, 40, 40)
achImg4.x = math.floor(display.contentWidth-250)
achImg4.y = math.floor (display.contentHeight-285 )
detailScreen:insert(achImg4)
achImg4.alpha = 0.4
detailScreenSub4 = display.newText("Hint user", 0, 0,fontStyle, _W * 0.05)
detailScreenSub4:setTextColor(255, 255, 255)
detailScreenSub4.x = math.floor(display.contentWidth-181)
detailScreenSub4.y = math.floor(display.contentHeight-285)
detailScreenSub4:setReferencePoint ( display.CenterLeftReferencePoint )
detailScreen:insert(detailScreenSub4)
detailScreenSub4.alpha = 0.4 

achImg5 = display.newImageRect (unCompAch[6].unImgPath, 35, 35)
achImg5.x = math.floor(display.contentWidth-250)
achImg5.y = math.floor (display.contentHeight-255 )
detailScreen:insert(achImg5)
achImg5.alpha = 0.4
detailScreenSub5 = display.newText("Hint buyer", 0, 0,fontStyle, _W * 0.05)
detailScreenSub5:setTextColor(255, 255, 255)
detailScreenSub5.x = math.floor(display.contentWidth-177)
detailScreenSub5.y = math.floor(display.contentHeight-255)
detailScreenSub5:setReferencePoint ( display.CenterLeftReferencePoint )
detailScreen:insert(detailScreenSub5)
detailScreenSub5.alpha = 0.4 

achImg6 = display.newImageRect (unCompAch[7].unImgPath, 40, 40)
achImg6.x = math.floor(display.contentWidth-250)
achImg6.y = math.floor (display.contentHeight-225 )
detailScreen:insert(achImg6)
achImg6.alpha = 0.4
detailScreenSub6 = display.newText("Hint customer", 0, 0,fontStyle, _W * 0.05)
detailScreenSub6:setTextColor(255, 255, 255)
detailScreenSub6.x = math.floor(display.contentWidth-165)
detailScreenSub6.y = math.floor(display.contentHeight-225)
detailScreenSub6:setReferencePoint ( display.CenterLeftReferencePoint )
detailScreen:insert(detailScreenSub6)
detailScreenSub6.alpha = 0.4 

achImg7 = display.newImageRect (unCompAch[8].unImgPath, 40, 40)
achImg7.x = math.floor(display.contentWidth-250)
achImg7.y = math.floor (display.contentHeight-195 )
detailScreen:insert(achImg7)
achImg7.alpha = 0.4
detailScreenSub7 = display.newText("Hint shopper", 0, 0,fontStyle, _W * 0.05)
detailScreenSub7:setTextColor(255, 255, 255)
detailScreenSub7.x = math.floor(display.contentWidth-167)
detailScreenSub7.y = math.floor(display.contentHeight-195)
detailScreenSub7:setReferencePoint ( display.CenterLeftReferencePoint )
detailScreen:insert(detailScreenSub7)
detailScreenSub7.alpha = 0.4 

achImg8 = display.newImageRect (unCompAch[9].unImgPath,40, 40)
achImg8.x = math.floor(display.contentWidth-250)
achImg8.y = math.floor (display.contentHeight-165 )
detailScreen:insert(achImg8)
achImg8.alpha = 0.4
detailScreenSub8 = display.newText("Ancient Master", 0, 0,fontStyle, _W * 0.05)
detailScreenSub8:setTextColor(255, 255, 255)
detailScreenSub8.x = math.floor(display.contentWidth-159)
detailScreenSub8.y = math.floor(display.contentHeight-165)
detailScreenSub8:setReferencePoint ( display.CenterLeftReferencePoint )
detailScreen:insert(detailScreenSub8)
detailScreenSub8.alpha = 0.4 

achImg9 = display.newImageRect (unCompAch[10].unImgPath, 40, 40)
achImg9.x = math.floor(display.contentWidth-250)
achImg9.y = math.floor (display.contentHeight-135 )
detailScreen:insert(achImg9)
achImg9.alpha = 0.4
detailScreenSub9 = display.newText("Middle Age Commoner", 0, 0,fontStyle, _W * 0.05)
detailScreenSub9:setTextColor(255, 255, 255)
detailScreenSub9.x = math.floor(display.contentWidth-130)
detailScreenSub9.y = math.floor(display.contentHeight-135)
detailScreenSub9:setReferencePoint ( display.CenterLeftReferencePoint )
detailScreen:insert(detailScreenSub9)
detailScreenSub9.alpha = 0.4 

achImg10 = display.newImageRect (unCompAch[11].unImgPath, 40, 40)
achImg10.x = math.floor(display.contentWidth-250)
achImg10.y = math.floor (display.contentHeight-105 )
detailScreen:insert(achImg10)
achImg10.alpha = 0.4
detailScreenSub10 = display.newText("Early Modern Ranger", 0, 0,fontStyle, _W * 0.05)
detailScreenSub10:setTextColor(255, 255, 255)
detailScreenSub10.x = math.floor(display.contentWidth-135)
detailScreenSub10.y = math.floor(display.contentHeight-105)
detailScreenSub10:setReferencePoint ( display.CenterLeftReferencePoint )
detailScreen:insert(detailScreenSub10) 
detailScreenSub10.alpha = 0.4

achImg11 = display.newImageRect (unCompAch[12].unImgPath, 40, 40)
achImg11.x = math.floor(display.contentWidth-250)
achImg11.y = math.floor (display.contentHeight-75 )
detailScreen:insert(achImg11)
achImg11.alpha = 0.4
detailScreenSub11 = display.newText("Modern Age Genius", 0, 0,fontStyle, _W * 0.05)
detailScreenSub11:setTextColor(255, 255, 255)
detailScreenSub11.x = math.floor(display.contentWidth-140)
detailScreenSub11.y = math.floor(display.contentHeight-75)
detailScreenSub11:setReferencePoint ( display.CenterLeftReferencePoint )
detailScreen:insert(detailScreenSub11) 
detailScreenSub11.alpha = 0.4

achImg12 = display.newImageRect (unCompAch[13].unImgPath, 40, 40)
achImg12.x = math.floor(display.contentWidth-250)
achImg12.y = math.floor (display.contentHeight-45 )
detailScreen:insert(achImg12)
achImg12.alpha = 0.4
detailScreenSub12 = display.newText("Game Master", 0, 0,fontStyle, _W * 0.05)
detailScreenSub12:setTextColor(255, 255, 255)
detailScreenSub12.x = math.floor(display.contentWidth-160)
detailScreenSub12.y = math.floor(display.contentHeight-45)
detailScreenSub12:setReferencePoint ( display.CenterLeftReferencePoint )
detailScreen:insert(detailScreenSub12)  	
detailScreenSub12.alpha = 0.4

detailScreen.x = display.contentWidth			  	  
	
end
local function youTappedMe()
	print ("okay you tapped me")
end
	
function scene:enterScene()

-- create the list of items
myList = tableView.newList{
	data=data, 
	--default="images/listItemBg.png",
	--over="images/listItemBg_over.png",
	onRelease = youTappedMe,
	onRelease=listButtonRelease,
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
                         local subtitle =  display.newText( row.subtitle, 0, 0, fontStyle, 12 )
                         subtitle:setTextColor(80,80,80)
                         --subtitle:setTextColor(180,180,180)
                         g:insert(subtitle)
                         subtitle.x = subtitle.width*0.5 + img.width + 6
                         subtitle.y = title.y + title.height + 6

                         return g   
                  end 
}

--Setup the nav bar
--top bar 
local navBar = ui.newButton{
	default = "images/leaderNavBar.png",
	onRelease = scrollToTop
}
navBar.x = display.contentWidth*.5
navBar.y = math.floor(display.screenOriginY + navBar.height*0.5)


local bottomWrap = display.newImageRect ( "images/achievementsBottom.png",  320, 60 )
	bottomWrap.x = _W /2 ; bottomWrap.y = 483	
	
local backToMenu = widget.newButton
{
	left = 40,
	top = 455,
	width = 250,
	height = 45,
	defaultFile = "images/backlong1.png",
	overFile = "images/backlongpress1.png",
	id = "gotomenu",
	onEvent = backMenu,
}
	button:insert(myList)
	button:insert(navBar)
	button:insert(bottomWrap)	
	button:insert(backToMenu)
	
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
	storyboard.removeScene("leaderBoards")
end

scene:addEventListener ( "createScene", scene )
scene:addEventListener ( "enterScene", scene )
scene:addEventListener ( "exitScene", scene )
scene:addEventListener ( "didExitScene", scene )

return scene				