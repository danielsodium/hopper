-- Get references to required services
local Level = require(game.ServerScriptService.Server.Level)

-- Store level gen class and its methods
local LevelGen = {}
LevelGen.__index = LevelGen

-- Constructor for level generation class
-- Generate new level
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
    -- Initalize z coordinate for level generation
	local z = self.startZ;
    for i = 1, self.levels - 1 do
        -- Create new level instance with incremental coordinate, and index
        local level = Level.new(self.startX, self.startY, z, i+1)
        -- Put new level instance into level instance table
        table.insert(self.levelInstances, level)
        -- Increment z coordinate for next level
		z += 10*i + 50 + 10;
    end
end

return LevelGen
