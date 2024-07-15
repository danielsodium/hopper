local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
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
	self.start_platform_size = 30
	self.end_platform_size = 20


    self:createTerrain()

	for i=0,self.lognum-1 do
		LogGen.new(3, self.x, self.y + 6, self.z + self.start_platform_size + 5+ 10*i);
	end

    return self
end

function Level:createTerrain()

    -- Create the starting land platform
    local startPlatform = Instance.new("Part")
    startPlatform.Size = Vector3.new(100, 20, self.start_platform_size)
    startPlatform.Position = Vector3.new(self.x, self.y, self.z + self.start_platform_size/2)
    startPlatform.Anchored = true
    startPlatform.Parent = workspace
    
    -- Create the ending land platform
    local endPlatform = Instance.new("Part")
    endPlatform.Size = Vector3.new(100, 20, self.end_platform_size)
    endPlatform.Position = Vector3.new(self.x, self.y, self.z + self.start_platform_size + 10*self.lognum + self.end_platform_size/2)
    endPlatform.Anchored = true
    endPlatform.Parent = workspace

	-- Create the level teleporter
	local teleporter = Instance.new("Part");
	teleporter.Position = Vector3.new(self.x, self.y+20, self.z + self.start_platform_size/2 + 5)
	teleporter.Parent = Workspace.LevelTeleports
	teleporter.Anchored = true
	teleporter.CanCollide = false
	teleporter.CanTouch = false
	teleporter.Transparency = 1;
	teleporter.Name = "Level" .. tostring(self.lognum - 1);

	-- Create Death Water
	local water = Water.new(self.x, self.y - 2, self.z + self.start_platform_size, 100, 15, 10*self.lognum);

end

return Level
