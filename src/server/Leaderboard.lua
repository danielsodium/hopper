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
    
    -- Create a score int value
    local score = Instance.new("IntValue")
    score.Name = "Levels"
    score.Value = 0
    score.Parent = leaderstats
    
end



return Leaderboard
