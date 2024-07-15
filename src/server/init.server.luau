local TutorialLevel = require(game.ServerScriptService.Server.TutorialLevel)
local LevelGen = require(game.ServerScriptService.Server.LevelGen)

-- Shorten Respawn Time
require(game.ServerScriptService.Server.Respawn)

TutorialLevel.new(0, 0, 0)
-- Level.new(0, 0, 300)
LevelGen.new(0,0,60);