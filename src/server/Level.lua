-- Get references to required services
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Required modules
local Water = require(game.ServerScriptService.Server.Water)
local LogGen = require(game.ServerScriptService.Server.LogGen)
local TimerManager = require(game.ServerScriptService.Server.TimerManager)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AddLevel = ReplicatedStorage:WaitForChild("AddLevel")

local Level = {}
Level.__index = Level

-- Constructor for new level
function Level.new(x, y, z, lognum)
    local self = setmetatable({}, Level)

    self.y = y;
	self.x = x;
	self.z = z;

	self.lognum = lognum or 8;
	self.start_platform_size = 30
	self.end_platform_size = 20

    self:createTerrain()

	-- Generating logs for this level
	for i=0,self.lognum-1 do
		LogGen.new(3, self.x, self.y + 6, self.z + self.start_platform_size + 5+ 10*i);
	end

    return self
end

-- Create terrain for each level
-- Create start platform, endplatform, spawnlocation
function Level:createTerrain()

    -- Create the starting land platform
    local startPlatform = Instance.new("Part")
    startPlatform.Size = Vector3.new(100, 20, self.start_platform_size)
    startPlatform.Position = Vector3.new(self.x, self.y, self.z + self.start_platform_size/2)
    startPlatform.Anchored = true
    startPlatform.Parent = workspace
	startPlatform.Color  = Color3.fromRGB(math.random(1,255),math.random(1,255),math.random(1,255))
	startPlatform.Material = Enum.Material.Grass
	startPlatform.TopSurface = Enum.SurfaceType.Smooth
	startPlatform.BottomSurface = Enum.SurfaceType.Smooth
	startPlatform.LeftSurface = Enum.SurfaceType.Smooth
	startPlatform.RightSurface = Enum.SurfaceType.Smooth
	startPlatform.FrontSurface = Enum.SurfaceType.Smooth
	startPlatform.BackSurface = Enum.SurfaceType.Smooth
    
    -- Create the ending land platform
    local endPlatform = Instance.new("Part")
    endPlatform.Size = Vector3.new(100, 20, self.end_platform_size)
    endPlatform.Position = Vector3.new(self.x, self.y, self.z + self.start_platform_size + 10*self.lognum + self.end_platform_size/2)
    endPlatform.Anchored = true
    endPlatform.Parent = workspace
	endPlatform.BrickColor = BrickColor.new("Sea green")
	endPlatform.Material = Enum.Material.Grass
	endPlatform.TopSurface = Enum.SurfaceType.Smooth
	endPlatform.BottomSurface = Enum.SurfaceType.Smooth
	endPlatform.LeftSurface = Enum.SurfaceType.Smooth
	endPlatform.RightSurface = Enum.SurfaceType.Smooth
	endPlatform.FrontSurface = Enum.SurfaceType.Smooth
	endPlatform.BackSurface = Enum.SurfaceType.Smooth


	-- Create the level teleporter
	local teleporter = Instance.new("SpawnLocation");
	teleporter.Position = Vector3.new(self.x, self.y+20, self.z + self.start_platform_size + 10*self.lognum + self.end_platform_size/2)
	teleporter.Parent = Workspace.LevelTeleports
	teleporter.Anchored = true
	teleporter.CanCollide = false
	teleporter.CanTouch = false
	teleporter.Transparency = 1;
	teleporter.Orientation = Vector3.new(180,0,0)
	teleporter.Name = "Level" .. tostring(self.lognum - 1);
	-- When the ending land platform touched, update respawn point
	local function onTouch(otherPart)
		local character = otherPart.Parent
		local player = Players:GetPlayerFromCharacter(character)
	
		if player then
			local score = player:FindFirstChild("leaderstats"):FindFirstChild("Levels")

			if (score.Value < self.lognum) then
				TimerManager.resetTimer(player.UserId)
				score.Value = self.lognum


				AddLevel:FireClient(player, self.lognum);

			end
			-- Set the respawn location to this part's position
			player.RespawnLocation = teleporter;

			-- Optionally, give some feedback to the player
			if character:FindFirstChild("Humanoid") then
				character.Humanoid:TakeDamage(0)  -- Just to trigger any feedback, if needed
			end
		end
	end
	
	-- Connect the touch event
	endPlatform.Touched:Connect(onTouch)

	-- Create Death Water
	local water = Water.new(self.x, self.y - 2, self.z + self.start_platform_size, 100, 15, 10*self.lognum);

end

return Level