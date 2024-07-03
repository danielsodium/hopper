local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local Function

local lastPlatformCFrame

local function onCharacterDied()
	Function:Disconnect()
end

local function onHeartbeat()
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
local humanoid = character:FindFirstChild("Humanoid") or character:WaitForChild("Humanoid");
humanoid.Died:Connect(onCharacterDied)
Function = RunService.Heartbeat:Connect(onHeartbeat)