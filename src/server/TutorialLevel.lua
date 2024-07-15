local ServerStorage = game:GetService("ServerStorage")
local Level = require(game.ServerScriptService.Server.Level)

local TutorialLevel = setmetatable({}, Level)
TutorialLevel.__index = TutorialLevel

function TutorialLevel.new(x,y,z)
    local self = Level.new(x,y,z, 2)
    setmetatable(self, TutorialLevel)
    
	self:createTutorial();
    return self
end

function TutorialLevel:createTutorial()
	local sign = ServerStorage:FindFirstChild("TutorialSign"):Clone()
	sign.Parent = workspace;
	sign:MoveTo(Vector3.new(0,20,0))
    
end

return TutorialLevel
