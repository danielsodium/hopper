local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

-- Creates a log to jump on
-- Goes up, sideways, then right
local Log = {}
Log.__index = Log 

-- Constructor
function Log.new(x, y, z, xtarget, ytarget)
    local self = setmetatable({}, Log)
    
    self.part = ServerStorage:FindFirstChild("Log"):Clone()

    self.part.Position = Vector3.new(x, y, z)
    self.part.Anchored = false 
    self.part.Parent = workspace
    
    -- Initialize movement state
    self.state = "up"
    self.yTargetUp = ytarget 
    self.xTarget = xtarget
    self.yTargetDown = y 
    self.moveSpeed = 20
    
    self.connection = RunService.Heartbeat:Connect(function(dt)
        self:updatePosition(dt)
    end)
    
    return self
end

-- Update the part's position
-- Goes Up, then right, then down
function Log:updatePosition(dt)
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

return Log 