local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TutorialLevel = require(game.ServerScriptService.Server.TutorialLevel)
local LevelGen = require(game.ServerScriptService.Server.LevelGen)
local Leaderboard = require(game.ServerScriptService.Server.Leaderboard)
local TimerManager = require(game.ServerScriptService.Server.TimerManager)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LevelTeleportEvent = ReplicatedStorage:WaitForChild("LevelTeleportEvent")
local CheckPlayerLevel = ReplicatedStorage:WaitForChild("CheckPlayerLevel")
local TimerManager = require(game.ServerScriptService.Server.TimerManager)

-- Create a new leaderboard instance
local leaderboard = Leaderboard.new()
-- Shorten Respawn Time
require(game.ServerScriptService.Server.Respawn)


local function onPlayerAdded(player)
	    -- Wait for the player's character to load
    player.CharacterAdded:Connect(function(character)
        -- Set the player's RespawnLocation to the initial spawn location
		local levelNum = player:FindFirstChild("leaderstats"):FindFirstChild("Levels").Value
        local spawnLocation = workspace.LevelTeleports:FindFirstChild("TutorialSpawn")
		if (levelNum ~= 0) then
			local ltp = "Level" .. (levelNum-1)
			spawnLocation = workspace.LevelTeleports:FindFirstChild(ltp)
		end
        if spawnLocation then
            player.RespawnLocation = spawnLocation
        end
    end)
end

Players.PlayerAdded:Connect(onPlayerAdded)

LevelTeleportEvent.OnServerEvent:Connect(function(player, level)
	local tpLocation = workspace.LevelTeleports:FindFirstChild("Level" .. (level-1))
	local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = tpLocation.CFrame * CFrame.Angles(math.rad(180), math.rad(180), 0)
    end
end)

CheckPlayerLevel.OnServerEvent:Connect(function(player, targetLevel)
	local playerLevel = Leaderboard:getPlayerLevel(player)
	local canTeleport = playerLevel >= targetLevel
	
	if canTeleport then
		local tpLocation = workspace.LevelTeleports:FindFirstChild("Level" .. (targetLevel-1))
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			character.HumanoidRootPart.CFrame = tpLocation.CFrame * CFrame.Angles(math.rad(180), math.rad(180), 0)
			TimerManager.resetTimer(player)

		end
	else
		-- Player's level is not sufficient, notify the player or handle accordingly
		print("You need to reach level " .. targetLevel .. " to teleport to this level.") -- Replace with your notification system
	end

end)


TutorialLevel.new(0, 0, 0)
-- Level.new(0, 0, 300)
LevelGen.new(0,0,60);

TimerManager.new();