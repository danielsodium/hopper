local Players = game:GetService("Players")

local PlayerModule = {} -- Create a table to hold the module functions

local time = 300

PlayerModule.paused = 0

local function setupClockGui(player)
    -- Create a ScreenGui and TextLabel for displaying the time
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TimeGui"

    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "TimeLabel"
    
    -- Appearance
    textLabel.Size = UDim2.new(0.2, 0, 0.1, 0)
    textLabel.Position = UDim2.new(0.4, 0, -0.05, 0)
    textLabel.BackgroundTransparency = 0.5
    textLabel.TextScaled = true
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.Parent = screenGui

    -- Default Text
    textLabel.Text = string.format("Level Start")

    return screenGui, textLabel
end

local function startTimer(player, timeValue, screenGui, timeLabel)
    local timeLimit = timeValue.Value
    timeValue.Value = timeLimit

    local timerCoroutine = coroutine.create(function()
        
        while timeLimit > 0 do
            if PlayerModule.paused == 0 then
                task.wait(1)

                timeLimit -= 1
                timeValue.Value = timeLimit

                timeLabel.Text = string.format("%d seconds remaining", timeLimit)

                -- print(string.format("%d seconds remaining for %s", timeLimit, player.Name))
            end
        end

        if timeLimit <= 0 then

            local character = player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Parent then
                humanoid.Health = 0
                -- print("Time's up! " .. player.Name .. " has been killed.")
            end
            timeLabel.Text = "Time's up!"
            screenGui:Destroy()
        end
    end)

    coroutine.resume(timerCoroutine)

    return timerCoroutine
end

local screenGui, timeLabel
local currentTimerCoroutine
local timeValue
local humanoid

Players.PlayerAdded:Connect(function(player)
    -- print("Player added: " .. player.Name)

    -- Create a Time value for the player
    timeValue = Instance.new("NumberValue")
    timeValue.Name = "Time"
    timeValue.Value = time
    timeValue.Parent = player


    player.CharacterAdded:Connect(function(character)
        humanoid = character:WaitForChild("Humanoid")

        screenGui, timeLabel = setupClockGui(player)

        timeValue.Value = time

        if currentTimerCoroutine and coroutine.status(currentTimerCoroutine) == "suspended" then
            coroutine.close(currentTimerCoroutine)
        end
        
        currentTimerCoroutine = startTimer(player, timeValue, screenGui, timeLabel)

        humanoid.Died:Connect(function()

            screenGui:Destroy()

            if currentTimerCoroutine and coroutine.status(currentTimerCoroutine) == "running" then
                coroutine.yield(currentTimerCoroutine)
            end

        end)
    end)
end)

return PlayerModule