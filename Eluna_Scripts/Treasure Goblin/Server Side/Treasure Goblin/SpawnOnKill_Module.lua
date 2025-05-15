-- Requires the "Config" file.
local config = require("SpawnOnKill_Config")

-- Events
local PLAYER_EVENT_ON_KILL_CREATURE = 7

-- Calculates whether the creature should spawn based on chance
local function ShouldSpawn()
	local roll = math.random(config.chanceMin, config.chanceMax)
	config.Debug("Spawn roll", roll)
	return roll <= config.chance
end

-- Spawns the configured creature at the kill location and sets despawn timer
local function SpawnSpecialCreature(killer, killed)
	local x, y, z, o = killed:GetX(), killed:GetY(), killed:GetZ(), killed:GetO()

	local spawned = killer:SpawnCreature(
		config.creatureID,
		x, y, z, o,
		1,
		config.despawnTime
	)

	if spawned then
		config.Debug("Creature spawned with despawn in " .. (config.despawnTime / 1000) .. " seconds", spawned:GetGUIDLow())

		local level = killer:GetLevel()
		local hp = level * 200

		spawned:SetLevel(level)
		spawned:SetMaxHealth(hp)
		spawned:SetHealth(hp)
		spawned:SetScale(config.scale)

		config.Debug("Custom level set", level)
		config.Debug("Custom HP set", hp)
		config.Debug("Custom scale set", config.scale)
	else
		config.Debug("Failed to spawn creature", "")
	end
end

-- Grants loot to the killer based on configured lootTable
local function GrantLoot(killer)
	for _, loot in ipairs(config.lootTable) do
		if math.random(1, 100) <= loot.loot_chance then
			killer:AddItem(loot.item, 1)
			killer:SendBroadcastMessage("You looted item ID: " .. loot.item)
			config.Debug("Loot granted", loot.item)
		end
	end
end

-- Called when a player kills a creature
local function OnCreatureKill(event, killer, killed)
	if not killer or not killed then return end

	local killedEntry = killed:GetEntry()

	-- Grant reputation and loot if the player killed the special creature
	if killedEntry == config.creatureID then
		local currentRep = killer:GetReputation(config.factionID)
		local newRep = currentRep + config.repAmount

		killer:SetReputation(config.factionID, newRep)
		killer:SendBroadcastMessage("You gained " .. config.repAmount .. " reputation with faction ID " .. config.factionID .. ".")
		config.Debug("Reputation granted for killing special creature", newRep)

		-- Grant loot
		GrantLoot(killer)
		return -- prevent recursive spawns
	end

	-- Otherwise, handle random or forced spawn
	if not config.alwaysSpawn then
		if ShouldSpawn() then
			SpawnSpecialCreature(killer, killed)
		end
	else
		config.Debug("AlwaysSpawn is enabled, forcing spawn.", "")
		SpawnSpecialCreature(killer, killed)
	end
end

-- Register the kill event
RegisterPlayerEvent(PLAYER_EVENT_ON_KILL_CREATURE, OnCreatureKill)
