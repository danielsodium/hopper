local Players = game:GetService("Players")
local TutorialLevel = require(game.ServerScriptService.Server.TutorialLevel)
local LevelGen = require(game.ServerScriptService.Server.LevelGen)

-- Shorten Respawn Time
require(game.ServerScriptService.Server.Respawn)

local function onPlayerAdded(player)
    -- Wait for the player's character to load
    player.CharacterAdded:Connect(function(character)
        -- Set the player's RespawnLocation to the initial spawn location
        local spawnLocation = workspace.LevelTeleports:FindFirstChild("TutorialSpawn")
        if spawnLocation then
            player.RespawnLocation = spawnLocation
        end
    end)
end

Players.PlayerAdded:Connect(onPlayerAdded)



TutorialLevel.new(0, 0, 0)
-- Level.new(0, 0, 300)
LevelGen.new(0,0,60);