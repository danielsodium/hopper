local TweenService = game:GetService("TweenService")
local ServerStorage = game:GetService("ServerStorage")
local Random = Random.new()  -- Create a Random object for randomness
local Players = game:GetService("Players")
local Coin = require(game.ServerScriptService.Server.Coin)
local Invincible = require(game.ServerScriptService.Server.Invincible)
local Superjump = require(game.ServerScriptService.Server.Superjump)

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
    
    -- Randomly generate different log (normal, with coin, invincibility, super jump)
    local num = Random:NextNumber() 
    -- Set color with 50% chance to be blue
    if num < 0.35 then
		self.coin = Coin.new(self.part.Position, speed, destroyX)
    elseif num < 0.40 then 
        self.Invincible = Invincible.new(self.part.Position, speed, destroyX)
        self.part.BrickColor = BrickColor.new("Blue")
    elseif num < 0.50 then
        self.Superjump = Superjump.new(self.part.Position, speed, destroyX)
        self.part.BrickColor = BrickColor.new("Black")
    else 
        self.part.BrickColor = BrickColor.new("Brown") 
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
    elseif self.Invincible then
        self.Invincible:destroy()
    elseif self.Superjump then
        self.Superjump:destroy()
    end
    
    if self.part then
        self.part:Destroy()
    end
end

return Log
