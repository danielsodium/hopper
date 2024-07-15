local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
local Water = require(game.ServerScriptService.Server.Water)
local LogGen = require(game.ServerScriptService.Server.LogGen)

local Level = {}
Level.__index = Level

function Level.new(x, y, z, lognum)
    local self = setmetatable({}, Level)

    self.y = y;
	self.x = x;
	self.z = z;
	self.lognum = lognum or 8;

    self:createTerrain()

	for i=0,self.lognum-1 do
		LogGen.new(3, self.x, self.y + 6, self.z + 55+10*i);
	end

    return self
end

function Level:createTerrain()

    -- Create the starting land platform
    local startPlatform = Instance.new("Part")
    startPlatform.Size = Vector3.new(100, 20, 100)
    startPlatform.Position = Vector3.new(self.x, self.y, self.z)
    startPlatform.Anchored = true
    startPlatform.Parent = workspace
    
    -- Create the ending land platform
    local endPlatform = Instance.new("Part")
    endPlatform.Size = Vector3.new(100, 20, 100)
    endPlatform.Position = Vector3.new(self.x, self.y, self.z + 50 + 10*self.lognum + 50)
    endPlatform.Anchored = true
    endPlatform.Parent = workspace

	-- Create Death Water
	local water = Water.new(self.x, self.y - 2, self.z + 50, 100, 15, 10*self.lognum);

end

return Level
