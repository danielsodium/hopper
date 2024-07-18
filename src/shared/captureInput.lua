local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local module = {}

local function setupControlGui(player)
    -- Create a ScreenGui and buttons for WASD and Space controls
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ControlGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local buttons = {}
    local keys = {"W", "A", "S", "D", "Space"}
    local positions = {
        W = UDim2.new(0.14, 0, 0.68, 0),
        A = UDim2.new(0.08, 0, 0.75, 0),
        S = UDim2.new(0.14, 0, 0.75, 0),
        D = UDim2.new(0.20, 0, 0.75, 0),
        Space = UDim2.new(0.14, 0, 0.82, 0)
    }

    for _, key in ipairs(keys) do
        local button = Instance.new("TextButton")
        button.Name = key .. "Button"
        button.Size = UDim2.new(0.05, 0, 0.05, 0)
        button.Position = positions[key]
        button.BackgroundColor3 = Color3.new(1, 1, 1)
        button.Text = key
        button.TextScaled = true
        button.Parent = screenGui
        buttons[key] = button
        print("Created button for key: " .. key) -- Debug statement
    end

    return screenGui, buttons
end

local function incrementScore(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local score = leaderstats:FindFirstChild("Score")
        if score then
            score.Value = score.Value + 1
        end
    end
end

local function handleInput(player, screenGui, buttons)
    print("Handling input for: " .. player.Name)

    local pressedKeys = {W = false, A = false, S = false, D = false, Space = false}

    local function allKeysPressed()
        for _, pressed in pairs(pressedKeys) do
            if not pressed then
                return false
            end
        end
        return true
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end

        print("Input detected")

        if input.UserInputType == Enum.UserInputType.Keyboard then
            local key = input.KeyCode.Name
            print("Input Key: " .. key)

            if pressedKeys[key] ~= nil then
                print("Key is in pressedKeys")
                buttons[key].BackgroundColor3 = Color3.new(0, 1, 0)
                pressedKeys[key] = true
            end

            if allKeysPressed() then
                screenGui.Enabled = false -- Hide the UI
                print("All keys pressed. Hiding UI.")

                if key == "Space" then
                    print("Space input detected: " .. key)

                    local character = player.Character
                    local humanoid = character and character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.Jump = true
                    end

                    incrementScore(player) -- Increment score when Space is pressed
                end
            end
        end
    end)
end

function module.captureInput()
    local player = Players.LocalPlayer
    print("Testing input for: " .. player.Name)

    local screenGui, buttons = setupControlGui(player)
    if screenGui and buttons then
        print("ScreenGui and buttons setup complete") -- Debug statement
    else
        warn("Failed to setup ScreenGui or buttons") -- Debug statement
    end

    handleInput(player, screenGui, buttons)
end

return module
