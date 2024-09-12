-- Define a global DEBUG_MODE variable
local DEBUG_MODE = false -- Set to false to disable debug messages

-- Function to log debug messages only if DEBUG_MODE is true
local function debugLog(message)
    if DEBUG_MODE then
        print(message)
    end
end

-- Define XP values for killing players
local PLAYER_KILL_XP = 50
local GUILD_PLAYER_KILL_XP = 5

-- Function to get XP required for the next level (for both player and guild)
local function gwxp_GetXPRequiredForNextLevel(level, isGuild)
    local table_name = isGuild and "acore_guildwars.guild_level_brackets" or "acore_guildwars.player_level_brackets"
    local query = string.format("SELECT xp_required FROM %s WHERE level_id = %d", table_name, level)
    local result = WorldDBQuery(query)

    if result then
        return result:GetInt32(0)  -- Return the XP required for the next level
    else
        debugLog("[LevelUp] Error fetching XP required for level: " .. level)
        return nil
    end
end

-- Function to handle leveling up for players and guilds
local function gwxp_LevelUp(guid, isGuild)
    local table_name = isGuild and "acore_guildwars.guild_level" or "acore_guildwars.player_level"
    local guid_field = isGuild and "guild_id" or "player_guid"

    -- Fetch current level, XP, and XP required for the next level
    local query = string.format("SELECT current_level, current_xp, xp_needed_for_next_level FROM %s WHERE %s = %d", table_name, guid_field, guid)
    local result = WorldDBQuery(query)

    if result then
        local current_level = result:GetInt32(0)
        local current_xp = result:GetInt32(1)
        local xp_needed_for_next_level = result:GetInt32(2)

        -- Check if the current XP exceeds or meets the XP needed for the next level
        if current_xp >= xp_needed_for_next_level then
            -- Level up
            local new_level = current_level + 1
            local excess_xp = current_xp - xp_needed_for_next_level  -- Carry over any extra XP

            -- Fetch XP required for the next level
            local xp_for_next_level = gwxp_GetXPRequiredForNextLevel(new_level, isGuild)

            if xp_for_next_level then
                -- Update the player's or guild's level and XP in the database
                local update_query = string.format("UPDATE %s SET current_level = %d, current_xp = %d, xp_needed_for_next_level = %d WHERE %s = %d",
                                                    table_name, new_level, excess_xp, xp_for_next_level, guid_field, guid)
                WorldDBExecute(update_query)

                -- Debug: Print level up details
                debugLog("[LevelUp] " .. (isGuild and "Guild" or "Player") .. " leveled up! New level: " .. new_level .. " Excess XP: " .. excess_xp)
            else
                debugLog("[LevelUp] Error fetching XP for next level.")
            end
        else
            debugLog("[LevelUp] No level up needed. Current XP: " .. current_xp .. " XP required: " .. xp_needed_for_next_level)
        end
    else
        debugLog("[LevelUp] Error fetching current level and XP for GUID: " .. guid)
    end
end

-- Function to update XP for players and guilds with debugging and level-up check
local function gwxp_UpdateXP(guid, xpToAdd, isGuild)
    local table_name = isGuild and "acore_guildwars.guild_level" or "acore_guildwars.player_level"
    local guid_field = isGuild and "guild_id" or "player_guid"
    
    -- Debug: Print the XP update initiation
    debugLog("[PlayerKills] XP Update initiated. GUID: " .. guid .. " XP to add: " .. xpToAdd .. " IsGuild: " .. tostring(isGuild))

    -- Fetch the current XP for player/guild
    local query = string.format("SELECT current_xp FROM %s WHERE %s = %d", table_name, guid_field, guid)
    local result = WorldDBQuery(query)

    if result then
        local current_xp = result:GetInt32(0)
        local new_xp = current_xp + xpToAdd

        -- Debug: Print current and new XP
        debugLog("[PlayerKills] Current XP: " .. current_xp .. " New XP: " .. new_xp)

        -- Update the XP in the database
        local update_query = string.format("UPDATE %s SET current_xp = %d WHERE %s = %d", table_name, new_xp, guid_field, guid)
        WorldDBExecute(update_query)

        -- Debug: Print successful XP update
        debugLog("[PlayerKills] XP Updated for " .. (isGuild and "Guild" or "Player") .. " GUID: " .. guid .. " New XP: " .. new_xp)

        -- If updating player or guild XP, check for level-up
        gwxp_LevelUp(guid, isGuild)
    else
        -- Debug: Print error fetching current XP
        debugLog("[PlayerKills] Error fetching current XP for GUID: " .. guid)
    end
end

-- Function to handle player kills with level-up check for player and guild
local function gwxp_HandlePlayerKill(event, killer, victim)
    debugLog("[PlayerKills] Player kill event detected.")

    -- Check if the victim is a player
    local victim_type_id = victim:GetTypeId()
    debugLog("[PlayerKills] Victim TypeID: " .. victim_type_id)

    -- Make sure the killer is a player and the victim is a player
    if killer:IsPlayer() and victim_type_id == 4 then  -- 4 is the TypeID for players
        local killer_guid = killer:GetGUIDLow()
        local killer_guild_id = killer:GetGuildId()

        debugLog("[PlayerKills] Player killed by player. Proceeding to update kill count...")

        -- Increment player kills for the killer
        local update_player_kills_query = string.format("UPDATE acore_guildwars.player_solo_ranking SET player_kills = player_kills + 1 WHERE guid = %d", killer_guid)
        WorldDBExecute(update_player_kills_query)

        debugLog("[PlayerKills] Player kills incremented for player GUID: " .. killer_guid)

        -- Award XP for the player and guild, and check for player and guild level-up
        gwxp_UpdateXP(killer_guid, PLAYER_KILL_XP, false)  -- +50 XP to player
        gwxp_UpdateXP(killer_guild_id, GUILD_PLAYER_KILL_XP, true)  -- +5 XP to guild
    else
        debugLog("[PlayerKills] Either the killer or victim is not a player. TypeID: " .. victim_type_id)
    end
end

-- Register event handler for player kills
RegisterPlayerEvent(6, gwxp_HandlePlayerKill)  -- Event ID 6 is used for player kills

debugLog("\n[PlayerKills] Player Kill and XP Handler with Level-Up System Loaded")
