-- Define a global DEBUG_MODE variable
local DEBUG_MODE = false  -- Set to false to disable debug messages

-- Function to log debug messages only if DEBUG_MODE is true
local function debugLog(message)
    if DEBUG_MODE then
        print(message)
    end
end

local RESET_INTERVAL = 30 * 24 * 60 * 60  -- 30 days in seconds

-- Function to convert Unix timestamp to MySQL DATETIME format
local function guildSoloTracker_UnixToDateTime(unix_time)
    return os.date('%Y-%m-%d %H:%M:%S', unix_time)
end

-- Function to get XP needed for the next level from player_level_brackets
local function guildSoloTracker_GetXPRequiredForNextLevel(level)
    local query = string.format("SELECT xp_required FROM acore_guildwars.player_level_brackets WHERE level_id = %d", level)
    local result = WorldDBQuery(query)
    
    if result then
        return result:GetInt32(0)  -- Returns the xp_required value
    else
        debugLog("[No XP Requirement] No XP requirement found for level [" .. level .. "]")
        return nil
    end
end

-- Function to reset player kills, level, and XP when the next reset date is reached
local function guildSoloTracker_ResetKillsAndLevelIfNeeded(player)
    local guid = player:GetGUIDLow()
    local current_time = os.time()

    debugLog("[Reset Check] Checking for reset eligibility for player GUID: [" .. guid .. "]")

    -- Query to fetch last_reset and next_reset for the player
    local query = string.format("SELECT last_reset, next_reset FROM acore_guildwars.player_solo_ranking WHERE guid = %d", guid)
    local result = WorldDBQuery(query)
    
    if result then
        local next_reset = result:GetString(1)  -- Get the next reset time (column 2)

        -- Convert next_reset to Unix timestamp
        local next_reset_unix = os.time({
            year = tonumber(string.sub(next_reset, 1, 4)),
            month = tonumber(string.sub(next_reset, 6, 7)),
            day = tonumber(string.sub(next_reset, 9, 10)),
            hour = tonumber(string.sub(next_reset, 12, 13)),
            min = tonumber(string.sub(next_reset, 15, 16)),
            sec = tonumber(string.sub(next_reset, 18, 19))
        })

        -- Check if it's time to reset kills and level
        if current_time >= next_reset_unix then
            debugLog("[Reset] Resetting kills and level for player GUID: [" .. guid .. "]")

            -- Reset player_kills, creature_kills, level, and current XP
            local current_datetime = guildSoloTracker_UnixToDateTime(current_time)
            local new_next_reset = current_time + RESET_INTERVAL
            local new_next_reset_datetime = guildSoloTracker_UnixToDateTime(new_next_reset)

            -- Update player_solo_ranking and player_level tables
            local reset_kills_query = string.format("UPDATE acore_guildwars.player_solo_ranking SET player_kills = 0, creature_kills = 0, last_reset = '%s', next_reset = '%s' WHERE guid = %d", current_datetime, new_next_reset_datetime, guid)
            WorldDBExecute(reset_kills_query)

            -- Reset level to 1 and fetch the new XP required for the next level
            local xp_needed = guildSoloTracker_GetXPRequiredForNextLevel(1)
            if xp_needed then
                local reset_level_query = string.format("UPDATE acore_guildwars.player_level SET current_level = 1, current_xp = 0, xp_needed_for_next_level = %d WHERE player_guid = %d", xp_needed, guid)
                WorldDBExecute(reset_level_query)
                player:SendBroadcastMessage("Your kills, level, and XP have been reset.")
            else
                debugLog("[Error] Error fetching XP required for the next level during reset.")
            end
        else
            debugLog("[Reset] No reset needed for player GUID: [" .. guid .. "]")
        end
    else
        debugLog("[No Record] No record found for player GUID: [" .. guid .. "] in player_solo_ranking.")
    end
end

-- Function to register or update player details in the player_solo_ranking table
local function guildSoloTracker_RegisterOrUpdatePlayerIfNeeded(player)
    local guid = player:GetGUIDLow()  -- Player GUID
    local player_name = player:GetName()
    local guild_id = player:GetGuildId()
    local guild_name = player:GetGuildName()

    debugLog("[Player Update] Registering or updating player GUID: [" .. guid .. "]")

    -- Check if player exists in player_solo_ranking table
    local query = string.format("SELECT * FROM acore_guildwars.player_solo_ranking WHERE guid = %d", guid)
    local result = WorldDBQuery(query)

    if not result then
        -- Register player with player_name, guild_id, and guild_name
        local current_time = os.time()
        local current_datetime = guildSoloTracker_UnixToDateTime(current_time)
        local next_reset_datetime = guildSoloTracker_UnixToDateTime(current_time + RESET_INTERVAL)

        -- Insert the player data into player_solo_ranking table
        local insert_query = string.format(
            "INSERT INTO acore_guildwars.player_solo_ranking (guid, player_name, guild_id, guild_name, player_kills, creature_kills, last_reset, next_reset) VALUES (%d, '%s', %d, '%s', 0, 0, '%s', '%s')",
            guid, player_name, guild_id, guild_name, current_datetime, next_reset_datetime
        )
        WorldDBExecute(insert_query)

        -- Register player in player_level with initial level and XP
        local xp_needed = guildSoloTracker_GetXPRequiredForNextLevel(1)
        if xp_needed then
            local insert_level_query = string.format(
                "INSERT INTO acore_guildwars.player_level (player_guid, current_level, current_xp, xp_needed_for_next_level) VALUES (%d, 1, 0, %d)", guid, xp_needed
            )
            WorldDBExecute(insert_level_query)
            player:SendBroadcastMessage("You have been registered in the solo ranking and level tables.")
        else
            debugLog("[Error] Error fetching XP required for level 1 during registration.")
        end
    else
        -- Update player details if they exist
        local update_query = string.format(
            "UPDATE acore_guildwars.player_solo_ranking SET player_name = '%s', guild_id = %d, guild_name = '%s' WHERE guid = %d",
            player_name, guild_id, guild_name, guid
        )
        WorldDBExecute(update_query)

        -- Check if the player needs a kill and level reset
        guildSoloTracker_ResetKillsAndLevelIfNeeded(player)
        player:SendBroadcastMessage("Your details in the solo ranking table have been updated.")
    end
end

-- Function to register a guild in the guild_level table if not already present
local function guildSoloTracker_RegisterGuildIfNeeded(guild_id)
    if guild_id == 0 then
        -- Skip guild registration if player is not in a guild
        return
    end
    
    local query = string.format("SELECT * FROM acore_guildwars.guild_level WHERE guild_id = %d", guild_id)
    local result = WorldDBQuery(query)
    
    if not result then
        -- Register guild in guild_level
        local insert_query = string.format("INSERT INTO acore_guildwars.guild_level (guild_id, current_level, current_xp, xp_needed_for_next_level) VALUES (%d, 1, 0, 5000)", guild_id)
        WorldDBExecute(insert_query)
    end
end

-- Event registration for player login
local function OnPlayerLogin(event, player)
    guildSoloTracker_RegisterOrUpdatePlayerIfNeeded(player)
    local guild_id = player:GetGuildId()
    guildSoloTracker_RegisterGuildIfNeeded(guild_id)
end

RegisterPlayerEvent(3, OnPlayerLogin)
debugLog("[Registration] Registration Handler Loaded")
