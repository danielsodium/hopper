local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

-- Creates a log to jump on
-- Goes up, sideways, then right
local Log = {}
Log.__index = Log 

-- Constructor
function Log.new(x, y, z, xtarget, ytarget)

	print("LOG")
	local self = setmetatable({}, Log);

	self.part = ServerStorage:FindFirstChild("Log"):Clone()
	self.part.Position = Vector3.new(x, y, z)
		-- Platform movement parameters
	self.dir = Vector3.new(10, 0, 0)
	self.spd = 10;
	self.startPos = self.part.Position


	self.bodyPosition = Instance.new("BodyPosition")
	self.bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

	-- Smoothhhhh
	self.bodyPosition.P = 1000 
	self.bodyPosition.D = 100 

	self.bodyPosition.Position = self.part.Position
	self.bodyPosition.Parent = self.part

	self.bodyGyro = Instance.new("BodyGyro")
	self.bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	self.bodyGyro.CFrame = self.part.CFrame
	self.bodyGyro.Parent = self.part

	-- Player platform attachment
	self:onPlayerTouch()

	-- Start the platform movement
	self:movePlatform()

end

-- Movement function
function Log:movePlatform()
	local direction = 1
	while true do
		local targetPosition = self.startPos+ (self.dir * direction)
		self.bodyPosition.Position = targetPosition
		
		-- Wait until the platform is close enough to the target position
		while (self.part.Position - targetPosition).magnitude > 0.1 do
			RunService.Heartbeat:Wait()
		end

		-- Pause before changing direction
		wait(1)
		direction = direction * -1
	end
end

function Log:onPlayerTouch()
	self.part.Touched:Connect(function(otherPart)
		local character = otherPart.Parent
		if character and Players:GetPlayerFromCharacter(character) then
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart then
				-- Weld the player's HumanoidRootPart to the platform
				local weld = Instance.new("WeldConstraint")
				weld.Part0 = self.part 
				weld.Part1 = humanoidRootPart
				weld.Parent = self.part

				-- Clean up weld when player leaves the platform
				local function onPlayerLeave()
					if weld.Parent then
						weld:Destroy()
					end
					humanoidRootPart.AncestryChanged:Disconnect(onPlayerLeave)
				end

				humanoidRootPart.AncestryChanged:Connect(onPlayerLeave)
			end
		end
	end)
end

return Log 