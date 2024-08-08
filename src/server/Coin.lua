local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local TweenService = game:GetService("TweenService")

local BadgeService = game:GetService("BadgeService")
local badgeId_coin = 625806392601762

local Coin = {}
Coin.__index = Coin

function Coin.new(position, speed, destroyX)
    local self = setmetatable({}, Coin)
    self.position = Vector3.new(position.x, position.y + 2, position.z);
    self.speed = speed 
	self.destroyX = destroyX
    self.part = self:createCoinInstance()
    self:applyVelocity()
    self:setupTouchEvent()
    return self
end

function Coin:createCoinInstance()
    local coin = Instance.new("Part")
    coin.Name = "Coin"
    coin.Size = Vector3.new(2, 2, 2)
    coin.Position = self.position
    coin.Anchored = true 
    coin.CanCollide = false
    coin.BrickColor = BrickColor.new("Bright yellow")
    coin.Parent = Workspace
    return coin
end

function Coin:applyVelocity()
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



function Coin:setupTouchEvent()
    self.part.Touched:Connect(function(hit)
        local character = hit.Parent
        if character and character:FindFirstChild("Humanoid") then
			local player = Players:GetPlayerFromCharacter(hit.Parent)
			if player then
				local leaderstats = player:FindFirstChild("leaderstats")
				if leaderstats then
					local levels = leaderstats:FindFirstChild("Coins")
					if levels then
						levels.Value = levels.Value + 1  -- Increment the Levels stat
                        if levels.Value >= 5 then
                            -- award badge to 5 coins
                            BadgeService:AwardBadge(player.UserId, badgeId_coin)
                        end
					end
				end
			end
            self:destroy()
        end
    end)
end

function Coin:destroy()
    if self.part then
        self.part:Destroy()
        self.part = nil
    end
end

return Coin
