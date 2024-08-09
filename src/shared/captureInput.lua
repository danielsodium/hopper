local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local module = {}

local tutorialCompleted = false
local NotInitiated = true

-- Create a ScreenGui and buttons for WASD and Space controls for selected player
local function setupControlGui(player)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ControlGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    local buttons = {}
    local keys = {"W", "A", "S", "D", "Space"}
    local positions = {
        W = UDim2.new(0.11, 0, 0.68, 0),
        A = UDim2.new(0.02, 0, 0.78, 0),
        S = UDim2.new(0.11, 0, 0.78, 0),
        D = UDim2.new(0.20, 0, 0.78, 0),
        Space = UDim2.new(0.11, 0, 0.88, 0)
    }

    for _, key in ipairs(keys) do
        local button = Instance.new("TextButton")
        button.Name = key .. "Button"
        button.Size = UDim2.new(0.07, 0, 0.07, 0)
        button.Position = positions[key]
        button.Text = key
        button.TextScaled = true
        button.Parent = screenGui
        button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  
		button.BackgroundTransparency = 0.5               
		button.BorderColor3 = Color3.fromRGB(0, 0, 0)      
		button.BorderSizePixel = 0.5
		button.TextColor3 = Color3.fromRGB(255, 255, 255) 
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0.3, 0)
        uiCorner.Parent = button


        buttons[key] = button
    end

    return screenGui, buttons
end

-- Update tutorial movement base on player input
local function handleInput(player, screenGui, buttons)

    local pressedKeys = {W = false, A = false, S = false, D = false, Space = false}

    local function allKeysPressed()
        for _, pressed in pairs(pressedKeys) do
            if not pressed then
                return false
            end
        end
        return true
    end

    -- Connect input to UI
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end

        if input.UserInputType == Enum.UserInputType.Keyboard then
            local key = input.KeyCode.Name

            if pressedKeys[key] ~= nil then
                buttons[key].TextColor3 = Color3.fromRGB(255, 255, 255) 
                buttons[key].BackgroundColor3 = Color3.new(0, 1, 0)
                pressedKeys[key] = true
            end
            
            -- If all keys for tutorial movement are pressed, hide it
            if allKeysPressed() then
                screenGui.Enabled = false -- Hide the UI
                tutorialCompleted = true
                if key == "Space" then

                    local character = player.Character
                    local humanoid = character and character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.Jump = true
                    end

                end
            end
        end
    end)
end

-- Method to begin input Capture
function module.captureInput()
    if (NotInitiated) then
        local player = Players.LocalPlayer

        local screenGui, buttons = setupControlGui(player)
    
        handleInput(player, screenGui, buttons)
        NotInitiated = false
    end
end

-- Check if movement tutorial is completed or not
function module.getTutorialCompleted()
    return tutorialCompleted
end

return module
