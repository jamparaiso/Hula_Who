
print ("scene7 module---------------------------")

local storyboard = require ( "storyboard");
local myData = require ( "myData" )
local widget = require ("widget")
local systemConfigurations = require ( "systemConfigurations" )
local scene = storyboard.newScene();
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


local screenGroup
local button = display.newGroup ( )

local function nextScene6Event ( event )
	local phase = event.phase
		if "ended" == phase then
				print ("next pressed and released")
				if enableSound ==true then
					audio.play (tapSound)
				end
			storyboard.gotoScene ( "playerMenu",{
								effect = "slideLeft",
								time = 250,
				} )
		end			
end

function scene: createScene (event)
		screenGroup = self.view;
		
		local background = display.newImageRect ("images/background.png",  _W, _H);
		background.x=_W * 0.5 ; background.y=_H *0.5

		
		local scene6Image = display.newImageRect ("images/final7.png", 300, 400 );
		scene6Image.x = _W*0.5; scene6Image.y =210
		
screenGroup:insert(background)
screenGroup:insert(scene6Image) 
end


function scene: enterScene(event)

local nextScene6Button = widget.newButton
 
	{
			left =110,
			top =428,
			width =100,
			height = 50,
			defaultFile = "images/next.png",
			overFile = "images/nextpress.png",
			id = "Next_Scene7_Button",
			onEvent = nextScene6Event,
	} 

			button:insert(nextScene6Button)
	
end


function scene: exitScene(event)

	screenGroup:removeSelf()
	screenGroup= nil
	button:removeSelf()
	button = nil

end

function scene:didExitScene(event)

		storyboard.removeScene("scene7");
end	

scene: addEventListener ("createScene", scene);
scene: addEventListener ("enterScene", scene);
scene: addEventListener ("exitScene", scene);
scene:addEventListener("didExitScene",scene)
		
return scene		