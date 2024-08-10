-- Get references to required services
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local TweenService = game:GetService("TweenService")
local BadgeService = game:GetService("BadgeService")
local badgeId_super_jump = 3926353098697598

-- Superjump class with its methods
local Superjump = {}
Superjump.__index = Superjump

-- Constructor of super jump object
function Superjump.new(position, speed, destroyX)
    local self = setmetatable({}, Superjump)
    self.position = Vector3.new(position.x, position.y + 2, position.z);
    self.speed = speed 
	self.destroyX = destroyX
    self.part = self:createPowerUpInstance()
    self:applyVelocity()
    self:setupTouchEvent()
    return self
end

-- Constructor of super jump instance
function Superjump:createPowerUpInstance()
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

-- Apply movement to the part
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


-- Touch Event when player touched super jump
function Superjump:setupTouchEvent()
    self.part.Touched:Connect(function(hit)
        local character = hit.Parent
        if character and character:FindFirstChild("Humanoid") then
            -- Destroy the super jump object from the game
            self:destroy()
            local player = Players:GetPlayerFromCharacter(character)
            if player then
                -- Activate super jump
                self:giveSuperJump(character)
                -- award badge to super jump
                BadgeService:AwardBadge(player.UserId, badgeId_super_jump)
            end
        end
    end)
end

-- Give player character to super jump
function Superjump:giveSuperJump(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        local origJumpPower = humanoid.JumpPower
        humanoid.JumpPower = 200
        
        task.delay(3, function()
            humanoid.JumpPower = origJumpPower
        end)
    end
end

-- Destroyer
function Superjump:destroy()
    if self.part then
        self.part:Destroy()
        self.part = nil
    end
end

return Superjump
