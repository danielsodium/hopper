local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
local Terrain = workspace.Terrain

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TimerManager = require(game.ServerScriptService.Server.TimerManager)
local BadgeService = game:GetService("BadgeService")
local BADGE_killed_by_water = 3241773550132668
local Water = {}
Water.__index = Water

-- Constructor for water part, create a water part
function Water.new(x, y, z, w, h, d)
    local self = setmetatable({}, Water)

    -- Setting dimension for water part
    self.y = x
	self.x = y
	self.z = z
	self.width = w
	self.height = h
	self.depth = d

    -- Create the water area using Terrain
    local waterSize = Vector3.new(w, h, d)
    local waterPosition = Vector3.new(x, y, z+d/2)
    Terrain:FillBlock(CFrame.new(waterPosition), waterSize, Enum.Material.Water)
	
    self:createWaterDeathZone(waterPosition, waterSize)

    return self
end

-- Setting death region to water part
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
                local humanoid = character.Humanoid
                -- Kill player if player does not have invincible
                if not humanoid:GetAttribute("Invincible") then

					local player = Players:GetPlayerFromCharacter(character)
					TimerManager.resetTimer(player)

                    humanoid.Health = 0

                    -- award Badge the Water is Poisonous
                    BadgeService:AwardBadge(player.UserId, BADGE_killed_by_water)
                end
            end
        end
    end)
end

return Water
