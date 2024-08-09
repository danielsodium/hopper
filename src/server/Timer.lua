local Timer = {}
Timer.__index = Timer

-- Constructors that create a new timer for player
function Timer.new(player, duration)
    local self = setmetatable({}, Timer)
    self.duration = duration
	self.player = player
    self.remainingTime = duration
    self.isPaused = true
    self.isRunning = false
	self.updateEvent = Instance.new("BindableEvent")
    return self
end

-- Update the duration of the time 
function Timer:changeDuration(duration)
	self.duration = duration
end

-- Start Timer
function Timer:start()
    if not self.isRunning then
        self.isRunning = true
        self.isPaused = true
        coroutine.wrap(function() self:_run() end)()
    end
end

-- Pause Timer
function Timer:pause()
    self.isPaused = true
end

-- Unpause Timer
function Timer:unpause()
    self.isPaused = false
end

-- Reset the time for timer
function Timer:reset()
	self.remainingTime = self.duration
end

-- When timer is running
function Timer:_run()
    while self.isRunning and self.remainingTime > 0 do
        -- Count down mechanism
        -- Check if the timer is paused
        if not self.isPaused then
            self.remainingTime = self.remainingTime - 1
			self.updateEvent:Fire(self.remainingTime)
            wait(1)
        else
            wait(0.1)
        end
    end
    -- Kill player when Timer ran out of time
    if self.remainingTime <= 0 then
		local character = self.player.Character
		local humanoid = character and character:FindFirstChild("Humanoid")
		if humanoid and humanoid.Parent then
			humanoid.Health = 0
		end
		self.remainingTime = self.duration
        self.isRunning = false
    end
end

return Timer
