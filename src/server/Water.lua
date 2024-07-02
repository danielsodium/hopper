local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
local Terrain = workspace.Terrain

local Water = {}
Water.__index = Water

function Water.new(x, y, z, w, h, d)
    local self = setmetatable({}, Water)

    self.y = x
	self.x = y
	self.z = z
	self.width = w
	self.height = h
	self.depth = d

    -- Create the water area using Terrain
    local waterSize = Vector3.new(w, h, d)
    local waterPosition = Vector3.new(x, y, z)
    Terrain:FillBlock(CFrame.new(waterPosition), waterSize, Enum.Material.Water)
	
    self:createWaterDeathZone(waterPosition, waterSize)

    return self
end

function Water:createWaterDeathZone(position, size)
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

return Water
