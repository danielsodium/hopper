local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
local Terrain = workspace.Terrain
local CreateLog = require(game.ServerScriptService.Server.Log)

local Level = {}
Level.__index = Level

function Level.new()
    local self = setmetatable({}, Level)

    self.y = 20;
	self.x = 100;

    self.logs = {}
    self.logInterval = 5 
    self.logYPosition = 0 
    self.logXStart = 0  
    self.logXEnd = self.x
    self.logSpeed = 20  

    self:createTerrain()

    self:startLogGeneration()
    
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
    
    -- Create the water area using Terrain
    local waterSize = Vector3.new(self.x, self.y, 100)
    local waterPosition = Vector3.new(0, -5, 100)  -- Position adjusted to fit terrain
    Terrain:FillBlock(CFrame.new(waterPosition), waterSize, Enum.Material.Water)
	
    self:createWaterDeathZone(waterPosition, waterSize)

end

function Level:createWaterDeathZone(position, size)
    local region = Region3.new(
        position - size / 2,
        position + size / 2
    )

    -- Monitor the region for players touching the water
    RunService.Heartbeat:Connect(function()
        local parts = workspace:FindPartsInRegion3(region, nil, math.huge)
        for _, part in pairs(parts) do
            local character = part.Parent
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.Health = 0
            end
        end
    end)
end

function Level:createLog()
    local log = CreateLog.new(-50, self.logYPosition, 60, 50, 10)
    table.insert(self.logs, log)
end

function Level:startLogGeneration()
    spawn(function()
        while true do
            self:createLog()
            wait(self.logInterval)
        end
    end)
end

return Level
