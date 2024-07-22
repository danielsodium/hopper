local TweenService = game:GetService("TweenService")
local ServerStorage = game:GetService("ServerStorage")
local Random = Random.new()  -- Create a Random object for randomness
local Players = game:GetService("Players")
local Coin = require(game.ServerScriptService.Server.Coin)

local Log = {}
Log.__index = Log

-- Constructor
function Log.new(x, y, z, speed, destroyX)
    local self = setmetatable({}, Log)
    
    -- Create the log part
    self.part = ServerStorage:FindFirstChild("Log"):Clone()
    self.part.Position = Vector3.new(x, y, z)
    self.part.Anchored = true
    self.part.Parent = workspace
    
    -- Set color with 50% chance to be blue
    if Random:NextNumber() < 0.5 then
		self.coin = Coin.new(self.part.Position, speed, destroyX);
    else
        self.part.BrickColor = BrickColor.new("Brown")  -- Use a different color or keep it as the default
    end
    
    -- Store parameters
    self.speed = speed
    self.destroyX = destroyX
    
    -- Start moving the log
    self:startMoving()
    
    return self
end

-- Method to start moving the log using TweenService
function Log:startMoving()
    local goal = { Position = Vector3.new(self.destroyX, self.part.Position.Y, self.part.Position.Z) }
    local distance = math.abs(self.destroyX - self.part.Position.X)
    local time = distance / self.speed
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    
    local tween = TweenService:Create(self.part, tweenInfo, goal)
    tween:Play()
    
    tween.Completed:Connect(function()
        self:destroy()
    end)
end

-- Method to destroy the log and clean up
function Log:destroy()
	if self.coin then
		self.coin:destroy()
	end
    if self.part then
        self.part:Destroy()
    end
end

return Log
