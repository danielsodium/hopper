local Level = require(game.ServerScriptService.Server.Level)

local LevelGen = {}
LevelGen.__index = LevelGen
local Timer = require(game.ServerScriptService.Server.Timer)


function LevelGen.new(startX, startY, startZ, levels)
    local self = setmetatable({}, LevelGen)
    
    self.startX = startX or 0
    self.startY = startY or 0
    self.startZ = startZ or 0
    self.levels = levels or 20

    self.levelInstances = {}
    
    self:generateLevels()
    
    return self
end

-- Method to generate levels
function LevelGen:generateLevels()
	local z = self.startZ;
    for i = 0, self.levels - 1 do
        local level = Level.new(self.startX, self.startY, z, i+2)
        table.insert(self.levelInstances, level)
		z += 10*i + 50 +20;
    end
end

return LevelGen
