local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local Function
local lastPlatformCFrame

local function onCharacterDied()
    if Function then
        Function:Disconnect()
    end
end

local function onHeartbeat()
    local character = player.Character
    local rootPart = character:WaitForChild("HumanoidRootPart")

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local raycastResult = workspace:Raycast(rootPart.Position, Vector3.new(0, -50, 0), raycastParams)
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
