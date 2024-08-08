local Timer = {}
Timer.__index = Timer

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

function Timer:changeDuration(duration)
	self.duration = duration
end

function Timer:start()
    if not self.isRunning then
        self.isRunning = true
        self.isPaused = true
        coroutine.wrap(function() self:_run() end)()
    end
end

function Timer:pause()
    self.isPaused = true
end

function Timer:unpause()
    self.isPaused = false
end

function Timer:reset()
	self.remainingTime = self.duration
end

function Timer:_run()
    while self.isRunning and self.remainingTime > 0 do
        if not self.isPaused then
            self.remainingTime = self.remainingTime - 1
			self.updateEvent:Fire(self.remainingTime)
            wait(1)
        else
            wait(0.1)
        end
    end
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
