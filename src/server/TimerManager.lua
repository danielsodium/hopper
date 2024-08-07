local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PauseEvent = ReplicatedStorage:WaitForChild("PauseEvent")
local Timer = require(game.ServerScriptService.Server.Timer)

local TimerManager = {}
TimerManager.__index = TimerManager

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
end

PauseEvent.OnServerEvent:Connect(function(player, action)
    local playerTimer = Timers[player.UserId]
    if not playerTimer then return end

    if action == "Pause" then
        playerTimer:pause()
    elseif action == "Unpause" then
        playerTimer:unpause()
    elseif action == "Start" then
        playerTimer:start()
    elseif action == "Reset" then
		playerTimer:reset()
    end
end)


local function onPlayerRemoved(player)
    Timers[player.UserId] = nil
	local updateEvent = ReplicatedStorage:FindFirstChild("UpdateTimerEvent_" .. player.UserId)
    if updateEvent then
        updateEvent:Destroy()
    end
end

function TimerManager.resetTimer(player)
	Timers[player.userId]:reset()
end

function TimerManager.new()
	Players.PlayerAdded:Connect(onPlayerAdded)
	Players.PlayerRemoving:Connect(onPlayerRemoved)
end

return TimerManager