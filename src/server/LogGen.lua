
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

local Log = require(game.ServerScriptService.Server.Log)

local LogGen = {}
LogGen.__index = LogGen 

-- Constructor
function LogGen.new(x, y, z, interval)
    local self = setmetatable({}, LogGen)
    
    self.interval = interval or 5 -- Time in seconds between log creation
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
    self.logs = {}
    
    -- Start generating logs
    self:startGeneratingLogs()
    
    return self
end

-- Method to create a log
function LogGen:createLog()
    local log = Log.new(self.x, self.y, self.z)
    table.insert(self.logs, log)
end

-- Method to start generating logs at intervals
function LogGen:startGeneratingLogs()
    spawn(function()
        while true do
			print("LOGGGG")
            self:createLog()
            wait(self.interval)
        end
    end)
end


return LogGen