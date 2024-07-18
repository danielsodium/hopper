local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local Function
local lastPlatformCFrame

local function onCharacterDied()
    if Function then
        Function:Disconnect()
    end
end

-- Make the player move with the Logs
local function onHeartbeat()
    local character = player.Character
    local rootPart = character:WaitForChild("HumanoidRootPart")

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local raycastResult = workspace:Raycast(rootPart.Position, Vector3.new(0, -5, 0), raycastParams)
    if raycastResult and raycastResult.Instance.Name == "Log" then
        local platformCFrame = raycastResult.Instance.CFrame

        if lastPlatformCFrame then
            local rel = platformCFrame * lastPlatformCFrame:inverse()
            rootPart.CFrame = rel * rootPart.CFrame
        end

        lastPlatformCFrame = platformCFrame
    else
        lastPlatformCFrame = nil
    end
end


local function setupCharacter(character)
    local humanoid = character:FindFirstChild("Humanoid") or character:WaitForChild("Humanoid")
    humanoid.Died:Connect(onCharacterDied)
    Function = RunService.Heartbeat:Connect(onHeartbeat)
end

player.CharacterAdded:Connect(function(character)
    setupCharacter(character)
end)

if player.Character then
    setupCharacter(player.Character)
end

-- When the player enter the game

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local captureInputModule = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("captureInput"))

local function onCharacterAdded(character)
    captureInputModule.captureInput()
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)

-- For testing when the player is already in the game
if Players.LocalPlayer then
    onPlayerAdded(Players.LocalPlayer)
end

