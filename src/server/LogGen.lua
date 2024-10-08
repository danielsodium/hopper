-- LogGen.lua
local Log = require(game.ServerScriptService.Server.Log)
local RunService = game:GetService("RunService")

-- Store log generation class with its methods
local LogGen = {}
LogGen.__index = LogGen

-- Constructor
function LogGen.new(interval, x, y, z)
    local self = setmetatable({}, LogGen)
    

	self.speed = math.random(10, 20)
    self.interval = math.floor(50/ self.speed) 
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
    self.logs = {}
    self.lastLogTime = 0
    
    -- Connect to the RunService Heartbeat event
    self.heartbeatConnection = RunService.Heartbeat:Connect(function(deltaTime)
        self:onHeartbeat(deltaTime)
    end)
    
    return self
end

-- Method to create a log
function LogGen:createLog()
    local log = Log.new(self.x- 50, self.y, self.z, self.speed, self.x + 50)
    table.insert(self.logs, log)
end

-- Heartbeat event handler
function LogGen:onHeartbeat(deltaTime)
    self.lastLogTime = self.lastLogTime + deltaTime
    if self.lastLogTime >= self.interval then
        self:createLog()
        self.lastLogTime = self.lastLogTime - self.interval
    end
end

-- Method to stop generating logs
function LogGen:stopGeneratingLogs()
    if self.heartbeatConnection then
        self.heartbeatConnection:Disconnect()
        self.heartbeatConnection = nil
    end
end

return LogGen
