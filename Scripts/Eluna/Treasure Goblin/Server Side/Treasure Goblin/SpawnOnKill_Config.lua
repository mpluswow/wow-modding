--[[	
	Created by Sylian (from emudevs.gg)

	[LICENSE]
	This script is made exclusively for Emudevs.gg
	All emudevs.gg members are allowed to use this resource for their servers.
	You are NOT allowed to share this script anywhere.
	
	Edited by Dreamforge
--]]

-------------------- Settings --------------------

-- This is the ID for the creature we want to spawn.
local creatureID = 200001

-- This is the chance to spawn the creature.
-- Chance must be a number between 1 & 100 (chance / chanceMax)
local chance = 5
local chanceMin = 1
local chanceMax = 100

-- Despawn time for the spawned creature (in milliseconds)
local despawnTime = 120000 -- 2 minutes

-- Faction reputation gain
local factionID = 1163
local repAmount = 50

-- Scale factor for the spawned creature (1.0 is default size)
local scale = 1.5

-- Set to true to enable debug messages in console
local debug = true

-- Set to true to spawn the creature on every kill
local alwaysSpawn = false

-- Loot table for when the special creature is killed
local lootTable = {
    { item = 29434, loot_chance = 50 }, -- Badge of Justice
    { item = 20558, loot_chance = 25 }, -- Warsong Mark of Honor
    { item = 12345, loot_chance = 10 }  -- Rare drop (placeholder)
}

-------------------- DONT TOUCH ANYTHING BELOW HERE --------------------

-- Debug function
local function Debug(message, arg)
	if debug then
		print("[DEBUG] -> " .. message .. " : " .. arg)
	end
end

return {
	-- Variables
	creatureID = creatureID,
	chance = chance,
	chanceMin = chanceMin,
	chanceMax = chanceMax,
	despawnTime = despawnTime,
	factionID = factionID,
	repAmount = repAmount,
	scale = scale,
	lootTable = lootTable,

	-- Functions
	Debug = Debug,

	-- Booleans
	debug = debug,
	alwaysSpawn = alwaysSpawn
}
