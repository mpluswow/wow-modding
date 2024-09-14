local AIO = AIO or require("AIO")

-- Register the AIO handlers
local StatBoostHandlers = AIO.AddHandlers("StatBoost", {})

-- Function to get the player's level from the database
local function GetPlayerLevelFromDB(player)
    local query = string.format("SELECT player_level FROM acore_guildwars.player_level WHERE guid = %i", player:GetGUIDLow())
    local result = CharDBQuery(query)

    if result then
        return result:GetInt32(0)
    else
        return 1 -- Default to level 1 if not found
    end
end

-- Function to apply stat boost based on player's level and send it to the client
local function ApplyStatBoostOnLogin(player)
    local level = GetPlayerLevelFromDB(player) -- Fetch the player's level from DB
    local statBonus = level -- Stat bonus is equal to the player's level

    -- Apply stat bonuses to all 5 stats
    player:HandleStatModifier(0, 0, statBonus, true) -- Strength
    player:HandleStatModifier(1, 0, statBonus, true) -- Agility
    player:HandleStatModifier(2, 0, statBonus, true) -- Stamina
    player:HandleStatModifier(3, 0, statBonus, true) -- Intellect
    player:HandleStatModifier(4, 0, statBonus, true) -- Spirit

    -- Send feedback message to the player
    player:SendBroadcastMessage("You have received a +" .. statBonus .. " boost to all stats for your level " .. level .. "!")

    -- Send the stat bonus to the client
    AIO.Msg():Add("StatBoost", "ShowStatBonus", statBonus):Send(player)
end

-- Hook into the player login event to apply stat boost automatically
local function OnPlayerLogin(event, player)
    ApplyStatBoostOnLogin(player)
end

-- Register the player login handler
RegisterPlayerEvent(3, OnPlayerLogin)  -- 3 is the Eluna event ID for player login
