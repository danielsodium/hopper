local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local TweenService = game:GetService("TweenService")
local BadgeService = game:GetService("BadgeService")
local badgeId_super_jump = 877021050023259

local Superjump = {}
Superjump.__index = Superjump

function Superjump.new(position, speed, destroyX)
    local self = setmetatable({}, Superjump)
    self.position = Vector3.new(position.x, position.y + 2, position.z);
    self.speed = speed 
	self.destroyX = destroyX
    self.part = self:createCoinInstance()
    self:applyVelocity()
    self:setupTouchEvent()
    return self
end

function Superjump:createCoinInstance()
    local Superjump = Instance.new("Part")
    Superjump.Name = "Superjump"
    Superjump.Size = Vector3.new(2, 2, 2)
    Superjump.Position = self.position
    Superjump.Anchored = true 
    Superjump.CanCollide = false
    Superjump.BrickColor = BrickColor.new("Bright Blue")
    Superjump.Parent = Workspace
    return Superjump
end

function Superjump:applyVelocity()
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



function Superjump:setupTouchEvent()
    self.part.Touched:Connect(function(hit)
        local character = hit.Parent
        if character and character:FindFirstChild("Humanoid") then
            self:destroy()
            local player = Players:GetPlayerFromCharacter(character)
            if player then
                self:giveInvincibility(character)
                -- award badge to super jump
                BadgeService:AwardBadge(player.UserId, badgeId_super_jump)
            end
        end
    end)
end

function Superjump:giveInvincibility(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        local origJumpPower = humanoid.JumpPower
        humanoid.JumpPower = 200
        
        task.delay(3, function()
            humanoid.JumpPower = origJumpPower
        end)
    end
end


function Superjump:destroy()
    if self.part then
        self.part:Destroy()
        self.part = nil
    end
end

return Superjump
