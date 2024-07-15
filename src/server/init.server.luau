local Players = game:GetService("Players")
local TutorialLevel = require(game.ServerScriptService.Server.TutorialLevel)
local LevelGen = require(game.ServerScriptService.Server.LevelGen)
local timer = require(game.ServerScriptService.Server.Player)

local Leaderboard = require(game.ServerScriptService.Server.Leaderboard)

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

TutorialLevel.new(0, 0, 0)
-- Level.new(0, 0, 300)
LevelGen.new(0,0,60);