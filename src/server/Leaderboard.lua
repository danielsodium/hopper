-- Leaderboard.lua
local Players = game:GetService("Players")

local Leaderboard = {}
Leaderboard.__index = Leaderboard

-- Constructor
function Leaderboard.new()
    local self = setmetatable({}, Leaderboard)
    
    -- Initialize the leaderboard
    self:initializeLeaderboard()
    
    -- Connect to the PlayerAdded event
    Players.PlayerAdded:Connect(function(player)
        self:onPlayerAdded(player)
    end)
    
    return self
end

-- Function to initialize the leaderboard
function Leaderboard:initializeLeaderboard()
    for _, player in pairs(Players:GetPlayers()) do
        self:onPlayerAdded(player)
    end
end

-- Function to handle player added
function Leaderboard:onPlayerAdded(player)
    -- Create a leaderstats folder
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    -- Create a levels int value
    local levels = Instance.new("IntValue")
    levels.Name = "Levels"
    levels.Value = 0
    levels.Parent = leaderstats

    -- Create a coins int value
    local coins = Instance.new("IntValue")
    coins.Name = "Coins"
    coins.Value = 0
    coins.Parent = leaderstats
    
end

function Leaderboard:getPlayerLevel(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local levels = leaderstats:FindFirstChild("Levels")
        if levels then
            return levels.Value
        end
    end
    return 0
end


return Leaderboard
