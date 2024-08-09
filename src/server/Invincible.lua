local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local TweenService = game:GetService("TweenService")

local Invincible = {}
Invincible.__index = Invincible

local BadgeService = game:GetService("BadgeService")
local badgeId_invincibility = 2853818019097464

local invincibleTime = 10

-- Constructor for new invincible 
function Invincible.new(position, speed, destroyX)
    local self = setmetatable({}, Invincible)
    self.position = Vector3.new(position.x, position.y + 2, position.z);
    self.speed = speed 
	self.destroyX = destroyX
    self.part = self:createInvincibleInstance()
    self:applyVelocity()
    self:setupTouchEvent()
    return self
end

-- Create new invincinble instance
function Invincible:createInvincibleInstance()
    local Invincible = Instance.new("Part")
    Invincible.Name = "Invincible"
    Invincible.Size = Vector3.new(2, 2, 2)
    Invincible.Position = self.position
    Invincible.Anchored = true 
    Invincible.CanCollide = false
    Invincible.BrickColor = BrickColor.new("Bright Green")
    Invincible.Parent = Workspace
    return Invincible
end

-- Apply velocity to invincible part
function Invincible:applyVelocity()
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

-- Settingup touch event
function Invincible:setupTouchEvent()
    self.part.Touched:Connect(function(hit)
        local character = hit.Parent
        if character and character:FindFirstChild("Humanoid") then
            self:destroy()
            local player = Players:GetPlayerFromCharacter(character)
            if player then
                -- give invincibility to player
                self:giveInvincibility(character)
                -- award badge to invincibility
                BadgeService:AwardBadge(player.UserId, badgeId_invincibility)
                print("userId: ", player.UserId)
            end
        end
    end)
end

-- Provide invincibility to player
function Invincible:giveInvincibility(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid:SetAttribute("Invincible", true)
        
        task.delay(invincibleTime, function()
            humanoid:SetAttribute("Invincible", false)
        end)
    end
end

-- Destructor for invincibility part
function Invincible:destroy()
    if self.part then
        self.part:Destroy()
        self.part = nil
    end
end

return Invincible
