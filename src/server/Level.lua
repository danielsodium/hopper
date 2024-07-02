local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
local Water = require(game.ServerScriptService.Server.Water)
local LogGen = require(game.ServerScriptService.Server.LogGen)

local Level = {}
Level.__index = Level

function Level.new()
    local self = setmetatable({}, Level)

    self.y = 20;
	self.x = 100;

    self.logs = {}
    self.logInterval = 3 
    self.logYPosition = 0 
    self.logXStart =  -self.x/2 
    self.logXEnd = self.x
    self.logSpeed = 20  

	self.logZPositions = {60, 70, 80, 90, 100}

    self:createTerrain()

	local logspawn = LogGen.new(0, 20, 150);

    return self
end

function Level:createTerrain()

    -- Create the starting land platform
    local startPlatform = Instance.new("Part")
    startPlatform.Size = Vector3.new(self.x, self.y, 100)
    startPlatform.Position = Vector3.new(0, 0, 0)
    startPlatform.Anchored = true
    startPlatform.Parent = workspace
    
    -- Create the ending land platform
    local endPlatform = Instance.new("Part")
    endPlatform.Size = Vector3.new(self.x, self.y, 100)
    endPlatform.Position = Vector3.new(0, 0, 200)
    endPlatform.Anchored = true
    endPlatform.Parent = workspace

	-- Create Death Water
	-- local water = Water.new(0, -2, 100, 100, 15, 100);


end

return Level
