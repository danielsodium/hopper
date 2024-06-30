local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

-- Creates a log to jump on
-- Goes up, sideways, then right
local CreateLog = {}
CreateLog.__index = CreateLog

-- Constructor
function CreateLog.new(x, y)
    local self = setmetatable({}, CreateLog)
    
    self.part = ServerStorage:FindFirstChild("Log"):Clone()

    self.part.Position = Vector3.new(x, y, 0)
    self.part.Anchored = false
    self.part.Parent = workspace
    
    -- Initialize movement state
    self.state = "up"
    self.yTargetUp = 20
    self.xTarget = 20
    self.yTargetDown = 10
    self.moveSpeed = 20
    
    self.connection = RunService.Heartbeat:Connect(function(dt)
        self:updatePosition(dt)
    end)
    
    return self
end

-- Update the part's position
-- Goes Up, then right, then down
function CreateLog:updatePosition(dt)
    if self.state == "up" then
        self.part.Velocity = Vector3.new(0, self.moveSpeed, 0)
        if self.part.Position.Y >= self.yTargetUp then
            self.state = "right"
        end
    elseif self.state == "right" then
        self.part.Velocity = Vector3.new(self.moveSpeed, 0, 0)
        if self.part.Position.X >= self.xTarget then
            self.state = "down"
        end
    elseif self.state == "down" then
        self.part.Velocity = Vector3.new(0, -self.moveSpeed, 0)
        if self.part.Position.Y <= self.yTargetDown then
            self.state = "destroy"
        end
    elseif self.state == "destroy" then
        self.part:Destroy()
        self.connection:Disconnect()
    end
end

return CreateLog