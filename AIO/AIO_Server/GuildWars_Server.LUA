local AIO = AIO or require("AIO")

-- Function to show the frames to the player
local function ShowFrames(player)
    -- Send a command to the client to display the GuildWars frames
    AIO.Handle(player, "GuildWars", "UpdateXP", 0, 1000)  -- Placeholder XP for display, adjust later as needed
end

-- Utility function to escape strings for SQL queries
local function EscapeString(str)
    if str == nil then
        return ""  -- Return empty string if input is nil
    end
    return string.gsub(str, "'", "''")  -- Escape single quotes by doubling them
end

-- Function to register a player into the 'player_solo_ranking' database
local function RegisterPlayerToDatabase(player)
    local playerName = EscapeString(player:GetName())  -- Escape player name for SQL
    local playerGUID = player:GetGUIDLow()
    local guildId = player:GetGuildId()
    local guildName = EscapeString(player:GetGuildName())  -- Escape guild name for SQL

    -- Check if the player already exists in the database
    local query = WorldDBQuery("SELECT guid FROM acore_guildwars.player_solo_ranking WHERE player_name = '" .. playerName .. "'")

    if not query then
        -- Player doesn't exist, insert new record
        local insertQuery = [[
            INSERT INTO acore_guildwars.player_solo_ranking (guid, player_name, guild_id, guild_name, player_kills, creature_kills, last_reset, next_reset)
            VALUES (%d, '%s', %d, '%s', 0, 0, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY))
        ]]
        WorldDBExecute(string.format(insertQuery, playerGUID, playerName, guildId, guildName))

        player:SendBroadcastMessage("You have been registered into the Guild Wars ranking system.")
    else
        player:SendBroadcastMessage("You are already registered in the Guild Wars ranking system.")
    end
end

-- Register a handler for GuildWars
local GuildWarsHandlers = AIO.AddHandlers("GuildWars", {})

-- Function to fetch and send both guild name and creature kills to the client using player GUID
local function SendGuildAndCreatureInfoToClient(player)
    local playerGUID = player:GetGUIDLow()  -- Use player GUID
    
    -- Query to fetch both guild name and creature kills
    local query = WorldDBQuery("SELECT guild_name, creature_kills FROM acore_guildwars.player_solo_ranking WHERE guid = " .. playerGUID)

    if query then
        local guildName = query:GetString(0)  -- Fetch guild_name from query result
        local creatureKills = query:GetInt32(1)  -- Fetch creature_kills from query result
        
        -- Send guild name to the client
        AIO.Handle(player, "GuildWars", "UpdateGuildName", guildGWName)  -- Send guild name to the client
        
        -- Send creature kills to the client
        AIO.Handle(player, "GuildWars", "UpdateCreatureKills", creatureGWKills)  -- Send creature kills to the client
    else
        -- If no record is found, send default values
        AIO.Handle(player, "GuildWars", "UpdateGuildName", "No Guild")  -- Send default guild name
        AIO.Handle(player, "GuildWars", "UpdateCreatureKills", 0)  -- Send default creature kills
    end
end
-- Function to increment player kills in the database
local function UpdatePlayerKills(player)
    local playerName = EscapeString(player:GetName())  -- Escape player name for SQL

    -- Increment the player_kills counter for the player
    local updateQuery = [[
        UPDATE acore_guildwars.player_solo_ranking 
        SET player_kills = player_kills + 1 
        WHERE player_name = '%s'
    ]]
    WorldDBExecute(string.format(updateQuery, playerName))

    player:SendBroadcastMessage("You have killed another player! Player kills have been updated.")
end

-- Function to increment creature kills in the database
local function UpdateCreatureKills(player)
    local playerName = EscapeString(player:GetName())  -- Escape player name for SQL

    -- Increment the creature_kills counter for the player
    local updateQuery = [[
        UPDATE acore_guildwars.player_solo_ranking 
        SET creature_kills = creature_kills + 1 
        WHERE player_name = '%s'
    ]]
    WorldDBExecute(string.format(updateQuery, playerName))

    player:SendBroadcastMessage("You have killed a creature! Creature kills have been updated.")
end

-- Event handler for when a player kills a creature
local function OnCreatureKill(event, killer, killed)
    if killer:IsPlayer() then
        UpdateCreatureKills(killer)
    end
end

-- Event handler for when a player kills another player
local function OnPlayerKill(event, killer, killed)
    if killer:IsPlayer() and killed:IsPlayer() then
        UpdatePlayerKills(killer)
    end
end

-- Event handler for when a player logs in
local function OnPlayerLogin(event, player)
    RegisterPlayerToDatabase(player)
end

-- Command to trigger frame display for debugging/testing
local function OnCommand(event, player, command)
    if command == "gwar" then
        SendGuildAndCreatureInfoToClient(player)
        ShowFrames(player)
        return false  -- Prevent the command from being processed further
    end
end

-- Register the player event for login (3 is the event for player login)
RegisterPlayerEvent(3, OnPlayerLogin)

-- Register the creature kill event (7 is the event for killing a creature)
RegisterPlayerEvent(7, OnCreatureKill)

-- Register the player kill event (6 is the event for killing a player)
RegisterPlayerEvent(6, OnPlayerKill)

-- Register the command to be handled (42 is the player event for chat commands)
RegisterPlayerEvent(42, OnCommand)
