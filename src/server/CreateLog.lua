-- CreateLog.lua
local TweenService = game:GetService("TweenService")

local CreateLog = {}

-- Creates a moving log to ride
-- Moves up, sideways, then down
function CreateLog.createMovingPart()
    -- Create the part
    local part = Instance.new("Part")
    part.Size = Vector3.new(4, 1, 4)
    part.Position = Vector3.new(0, 0.5, 0)
    part.Anchored = true
    part.Parent = workspace

    -- Movement parameters
    local yTargetUp = 20
    local xTarget = 20
    local yTargetDown = 0
    local moveTime = 2  -- Time in seconds for each movement

    -- Define the tween info
    local tweenInfo = TweenInfo.new(
        moveTime,               -- Time
        Enum.EasingStyle.Linear -- EasingStyle
    )

    -- Function to create and play a tween
    local function movePart(targetPosition)
        local tween = TweenService:Create(part, tweenInfo, {Position = targetPosition})
        tween:Play()
        tween.Completed:Wait() -- Wait until the tween is complete
    end

    -- Move the part up on the y axis
    movePart(Vector3.new(part.Position.X, yTargetUp, part.Position.Z))

    -- Move the part along the x axis
    movePart(Vector3.new(xTarget, part.Position.Y, part.Position.Z))

    -- Move the part down on the y axis
    movePart(Vector3.new(part.Position.X, yTargetDown, part.Position.Z))

    -- Destroy the part
    part:Destroy()
end

return CreateLog

