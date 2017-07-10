
local storyboard = require ("storyboard")
local myData = require ( "myData" )
local systemConfigurations = require ( "systemConfigurations" )
local widget = require ( "widget" )
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
local tapSound = myData.tapSound
local backMusic = myData.backMusic
local enableSound = gameSettings.soundOn
local enableMusic = gameSettings.musicOn

local tapCount = 1
local screenGroup
local profPic
local sc1,sc2,sc3,sc5,sc5,sc6,sc7

local function onComplete(event)
	if "clicked" == event.action then
		local i = event.index
			if i == 1 then
				tapCount = 1
				sc1.alpha = 1
				sc2.alpha = 0
				sc3.alpha = 0
				sc4.alpha = 0
				sc5.alpha = 0
				sc6.alpha = 0
				sc7.alpha = 0
			else
				storyboard.gotoScene("options" ,{
				effect = "slideLeft",
				time = 250	
				})	
			end	
	end	
end	

local function nextHow(event)
	if tapCount == 1 then
		sc1.alpha = 0
		sc2.alpha = 1
		sc3.alpha = 0
		sc4.alpha = 0
		sc5.alpha = 0
		sc6.alpha = 0
		sc7.alpha = 0
		tapCount = tapCount + 1
	elseif tapCount == 2 then
		sc1.alpha = 0
		sc2.alpha = 0
		sc3.alpha = 1
		sc4.alpha = 0
		sc5.alpha = 0
		sc6.alpha = 0
		sc7.alpha = 0
		tapCount = tapCount + 1
	elseif tapCount == 3 then
		sc1.alpha = 0
		sc2.alpha = 0
		sc3.alpha = 0
		sc4.alpha = 1
		sc5.alpha = 0
		sc6.alpha = 0
		sc7.alpha = 0
		tapCount = tapCount + 1
	elseif tapCount == 4 then
		sc1.alpha = 0
		sc2.alpha = 0
		sc3.alpha = 0
		sc4.alpha = 0
		sc5.alpha = 1
		sc6.alpha = 0
		sc7.alpha = 0
		tapCount = tapCount + 1
	elseif tapCount == 5 then
		sc1.alpha = 0
		sc2.alpha = 0
		sc3.alpha = 0
		sc4.alpha = 0
		sc5.alpha = 0
		sc6.alpha = 1
		sc7.alpha = 0
		tapCount = tapCount + 1
	elseif tapCount == 6 then		
		sc1.alpha = 0
		sc2.alpha = 0
		sc3.alpha = 0
		sc4.alpha = 0
		sc5.alpha = 0
		sc6.alpha = 0
		sc7.alpha = 1	
		tapCount = tapCount + 1
	elseif tapCount == 7 then
	local alert = native.showAlert ( "How to play",
	"Do you want to read the game insructions again?",
	{"Yes","No"},
		onComplete
	 )											
	end
		
end	

function scene:createScene()
	screenGroup = self.view
	
local background = display.newImageRect("images/htpback.png",_W,_H)
	 background.x = _W * .5 ; background.y = _H * .5
	 
local backWrap = display.newRect( 0,0, _W, _H )
	  backWrap:setFillColor ( 0, 0, 0 )
	  backWrap.alpha = .2	 
	
	screenGroup:insert(background)
	screenGroup:insert(backWrap)
end

function scene:enterScene()
screenGroup = self.view
	
	profPic = display.newImageRect ( "images/htpprof.png",110, 140 )
	profPic.x = 60 ; profPic.y = 410
	
	sc1 = display.newImageRect("images/htps1.png",300,170)
	sc1.x = _W * .5 ; sc1.y = 290
	sc1.alpha = 1
	
	sc2 = display.newImageRect("images/htps2.png",300,170)
	sc2.x = _W * .5 ; sc2.y = 290
	sc2.alpha = 0
	
	sc3 = display.newImageRect("images/htps3.png",300,200)
	sc3.x = 155 ; sc3.y = 95
	sc3.alpha = 0
	
	sc4 = display.newImageRect("images/htps4.png",310,144)
	sc4.x = 165	; sc4.y = 67
	sc4.alpha = 0
	
	sc5 = display.newImageRect("images/htps5.png",310,144)
	sc5.x = 153 ; sc5.y = 67
	sc5.alpha = 0

	sc6 = display.newImageRect("images/htps6.png",300,220)
	sc6.x = _W * .5 ; sc6.y = 225
	sc6.alpha = 0
	
	sc7 = display.newImageRect ( "images/htps7.png" ,  300, 170 )
	sc7.x = _W * .5 ; sc7.y = 290
	sc7.alpha = 0		
	
screenGroup:insert(profPic)
screenGroup:insert(sc1)
screenGroup:insert(sc2)
screenGroup:insert(sc3)
screenGroup:insert(sc4)
screenGroup:insert(sc5)
screenGroup:insert(sc6)
screenGroup:insert(sc7)

profPic:addEventListener ( "tap", nextHow )

local function backOption(event)
	local phase = event.phase
		if phase == "ended" then
			if enableSound == true then
				audio.play(tapSound)
			end
			storyboard.gotoScene("options" ,{
			effect = "slideLeft",
			time = 250	
				})
		end
end	

local backButton = widget.newButton
{
	left = 110,
	top = 430,
	width = 100,
	height = 50,
	defaultFile = "images/back.png",
	overFile = "images/backpress.png",
	id = "backbutton",
	onEvent = backOption
} 		

screenGroup:insert(backButton)	
	
end

function scene:exitScene()
profPic:removeEventListener ( "tap", nextHow )
screenGroup:removeSelf()
screenGroup = nil	
end

function scene:didExitScene()
	storyboard.removeScene("howToPlay")
end

scene:addEventListener ( "createScene", scene )
scene:addEventListener ( "enterScene", scene )
scene:addEventListener ( "exitScene", scene )
scene:addEventListener ( "didExitScene", scene )

return scene				