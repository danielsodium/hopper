-- Get references to required services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local Function
local lastPlatformCFrame

local function onCharacterDied()
	player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui"):WaitForChild("ImageLabel").Visible = false;

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

local loaded = false 
player.CharacterAdded:Connect(function(character)
	if (loaded) then
		player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui"):WaitForChild("ImageLabel").Visible = true;
	else 
		loaded = true
	end
	
    setupCharacter(character)
end)

if player.Character then
    setupCharacter(player.Character)
end

-- When the player enter the game
-- Import the captureInput module from ReplicatedStorage
local captureInputModule = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("captureInput"))

-- Function to handle character addition for a player
-- Capture input if the tutorial is incomplete
local function onCharacterAdded(character)
    if captureInputModule.getTutorialCompleted() == false then
        captureInputModule.captureInput()
    end
end

-- Function to handle player addition
-- Check if the player already has a character loaded
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(onCharacterAdded)
    
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

-- Connect the onPlayerAdded function to the PlayerAdded event
Players.PlayerAdded:Connect(onPlayerAdded)

-- Check if there is a local player already present (usually happens if the script runs on the client)
if Players.LocalPlayer then
    -- Call onPlayerAdded directly for the LocalPlayer
    onPlayerAdded(Players.LocalPlayer)
end
