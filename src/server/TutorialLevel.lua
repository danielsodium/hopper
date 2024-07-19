local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Level = require(game.ServerScriptService.Server.Level)

local Timer = require(game.ServerScriptService.Server.Timer)

local TutorialLevel = setmetatable({}, Level)
TutorialLevel.__index = TutorialLevel

local firstClear = true;
-- Ensure the RemoteEvent exists
local activateTutorialInputEvent = ReplicatedStorage:FindFirstChild("ActivateTutorialInput")

function TutorialLevel.new(x, y, z)
    local self = Level.new(x, y, z, 1)
    setmetatable(self, TutorialLevel)
    
    self:createTutorial()
    self:activateCaptureInput()

    return self
end

function TutorialLevel:createTutorial()
    local sign = ServerStorage:FindFirstChild("TutorialSign"):Clone()
    sign.Parent = workspace
    sign:MoveTo(Vector3.new(-25, 12, 28))
end

function TutorialLevel:activateCaptureInput()
    if firstClear then
        if activateTutorialInputEvent then
            activateTutorialInputEvent:FireAllClients()
        else
            warn("ActivateTutorialInput RemoteEvent not found in ReplicatedStorage")
        end
        firstClear = false
    end
end


return TutorialLevel