-- Get references to ServerStorage and ReplicatedStorage services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Required modules
local Level = require(game.ServerScriptService.Server.Level)

local TutorialLevel = setmetatable({}, Level)
TutorialLevel.__index = TutorialLevel

local firstClear = true;
-- Ensure the RemoteEvent exists
local activateTutorialInputEvent = ReplicatedStorage:FindFirstChild("ActivateTutorialInput")

-- Initialize tutorial level
function TutorialLevel.new(x, y, z)
    -- Create a new Level instance and set its metatable to TutorialLevel
    local self = Level.new(x, y, z, 1)
    setmetatable(self, TutorialLevel)
    
    self:createTutorial()

    return self
end

-- Method to create the tutorial elements in the level
function TutorialLevel:createTutorial()
    local sign = ServerStorage:FindFirstChild("TutorialSign"):Clone()
    sign.Parent = workspace
    sign:MoveTo(Vector3.new(-25, 12, 28))
end

return TutorialLevel