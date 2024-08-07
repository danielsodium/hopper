local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TutorialLevel = require(game.ServerScriptService.Server.TutorialLevel)
local LevelGen = require(game.ServerScriptService.Server.LevelGen)
local Leaderboard = require(game.ServerScriptService.Server.Leaderboard)
local TimerManager = require(game.ServerScriptService.Server.TimerManager)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LevelTeleportEvent = ReplicatedStorage:WaitForChild("LevelTeleportEvent")
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
			local ltp = "Level" .. levelNum
			spawnLocation = workspace.LevelTeleports:FindFirstChild(ltp)
		end
        if spawnLocation then
            player.RespawnLocation = spawnLocation
        end
    end)
end

Players.PlayerAdded:Connect(onPlayerAdded)

LevelTeleportEvent.OnServerEvent:Connect(function(player, level)
	local tpLocation = workspace.LevelTeleports:FindFirstChild("Level" .. level)
	local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = tpLocation.CFrame * CFrame.Angles(math.rad(180), math.rad(180), 0)
    end
end)

TutorialLevel.new(0, 0, 0)
-- Level.new(0, 0, 300)
LevelGen.new(0,0,60);

TimerManager.new();