local CreateLog = require(game.ServerScriptService.Server.CreateLog)

local logs = {}
local interval = 5 
local xStart = 0
local yStart = 11

while true do

    local log = CreateLog.new(xStart, yStart)

	-- Keeping track of each log just in case
    table.insert(logs, log)

    wait(interval)
end
