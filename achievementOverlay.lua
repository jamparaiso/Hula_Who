--this module is not in use
local storyboard = require ( "storyboard" )
local scene = storyboard.newScene()

function scene:createScene()

end

function scene:enterScene()
	
end

function scene:exitScene()
	
end

function scene:didExitScene()
	
end

scene:addEventListener ( "createScene", scene )
scene:addEventListener ( "enterScene", scene )
scene:addEventListener ( "exitScene", scene )
scene:addEventListener ( "didExitScene", scene )

return scene				