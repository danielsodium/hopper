local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TutorialLevel = require(game.ServerScriptService.Server.TutorialLevel)
local LevelGen = require(game.ServerScriptService.Server.LevelGen)
local Leaderboard = require(game.ServerScriptService.Server.Leaderboard)
local Timer = require(game.ServerScriptService.Server.Timer)
local PauseEvent = ReplicatedStorage:WaitForChild("PauseEvent")

-- Create a new leaderboard instance
local leaderboard = Leaderboard.new()
-- Shorten Respawn Time
require(game.ServerScriptService.Server.Respawn)

-- Timer stuff
local Timers = {}

local function onPlayerAdded(player)
	Timers[player.UserId] = Timer.new(player, 30)

	local updateEvent = Instance.new("RemoteEvent")
    updateEvent.Name = "UpdateTimerEvent_" .. player.UserId
    updateEvent.Parent = ReplicatedStorage

    -- Connect the timer's update event to the RemoteEvent
    Timers[player.UserId].updateEvent.Event:Connect(function(remainingTime)
        updateEvent:FireClient(player, remainingTime)
    end)

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

PauseEvent.OnServerEvent:Connect(function(player, action)
    local playerTimer = Timers[player.UserId]
    if not playerTimer then return end

    if action == "Pause" then
        playerTimer:pause()
        print(player.Name .. " has paused their timer.")
    elseif action == "Unpause" then
        playerTimer:unpause()
        print(player.Name .. " has unpaused their timer.")
    elseif action == "Start" then
        playerTimer:start()
        print(player.Name .. " has started their timer.")
    end
end)


local function onPlayerRemoved(player)
    Timers[player.UserId] = nil
	local updateEvent = ReplicatedStorage:FindFirstChild("UpdateTimerEvent_" .. player.UserId)
    if updateEvent then
        updateEvent:Destroy()
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoved)


TutorialLevel.new(0, 0, 0)
-- Level.new(0, 0, 300)
LevelGen.new(0,0,60);