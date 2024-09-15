-- Debug flag (set to true to enable debug prints)
local debug = true

-- Function to print debug information if debug mode is enabled
local function DebugPrint(message)
    if debug then
        print("[REGISTRATION] " .. message)
    end
end

-- Function to sanitize player names to prevent SQL injection
local function SanitizeString(str)
    return str:gsub("'", "''")
end

-- Function to check if player exists in the player_level table
local function CheckAndRegisterPlayer(player)
    local guid = player:GetGUIDLow()
    local player_name = player:GetName()
    local sanitized_name = SanitizeString(player_name)

    DebugPrint("Checking if player " .. player_name .. " (GUID: " .. guid .. ") exists in the database...")

    -- Query the database to check if the player exists in player_level
    local query = WorldDBQuery("SELECT guid FROM acore_guildwars.player_level WHERE guid = " .. guid)

    if query == nil then
        -- Player is not registered, so let's add them
        DebugPrint("Player not found in player_level table. Registering player...")

        -- Default starting level and experience
        local player_level = 1
        local experience = 0

        -- Fetch the next level XP requirement from the player_level_brackets table
        local next_level_query = WorldDBQuery("SELECT max_xp FROM acore_guildwars.player_level_brackets WHERE level = " .. player_level)

        if next_level_query == nil then
            DebugPrint("Error: No XP data found for level " .. player_level .. " in player_level_brackets.")
            return
        end

        local next_level = next_level_query:GetUInt32(0)
        DebugPrint("Next level XP for level " .. player_level .. ": " .. next_level)

        -- Set the current timestamp for last_reset and calculate next_reset (30 days later)
        local last_reset = os.time()
        local next_reset = last_reset + (30 * 24 * 60 * 60) -- 30 days in seconds

        -- Insert the new player into the player_level table
        local insert_player_level_query = string.format(
            "INSERT INTO acore_guildwars.player_level (guid, player_name, player_level, experience, next_level, last_reset, next_reset) " ..
            "VALUES (%d, '%s', %d, %d, %d, FROM_UNIXTIME(%d), FROM_UNIXTIME(%d))",
            guid, sanitized_name, player_level, experience, next_level, last_reset, next_reset
        )
        local success_level = WorldDBExecute(insert_player_level_query)

        if success_level == nil then
            DebugPrint("Player " .. player_name .. " successfully registered in player_level.")
        else
            DebugPrint("Error: Failed to register player " .. player_name .. " in player_level. Error: " .. success_level)
        end

        -- Now, insert the player into the player_claimed_rewards table with lvl_1 to lvl_15 set to 0
        DebugPrint("Registering player " .. player_name .. " in player_claimed_rewards table...")

        local insert_claimed_rewards_query = string.format(
            "INSERT INTO acore_guildwars.player_claimed_rewards (guid, player_name, " ..
            "lvl_1, lvl_2, lvl_3, lvl_4, lvl_5, lvl_6, lvl_7, lvl_8, lvl_9, lvl_10, lvl_11, lvl_12, lvl_13, lvl_14, lvl_15) " ..
            "VALUES (%d, '%s', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)",
            guid, sanitized_name
        )
        local success_rewards = WorldDBExecute(insert_claimed_rewards_query)

        if success_rewards == nil then
            DebugPrint("Player " .. player_name .. " successfully registered in player_claimed_rewards.")
        else
            DebugPrint("Error: Failed to register player " .. player_name .. " in player_claimed_rewards. Error: " .. success_rewards)
        end

    else
        -- Player is already registered
        DebugPrint("Player " .. player_name .. " already exists in the player_level table.")
    end
end

-- Function to check if it's time to reset the player's level and experience
local function CheckAndResetPlayer(player)
    local guid = player:GetGUIDLow()
    local player_name = player:GetName()

    DebugPrint("Checking if player " .. player_name .. " needs a reset...")

    -- Query the database to get the next_reset timestamp as Unix timestamp
    local query = WorldDBQuery("SELECT UNIX_TIMESTAMP(next_reset) FROM acore_guildwars.player_level WHERE guid = " .. guid)

    if query ~= nil then
        local next_reset = query:GetUInt32(0)
        local current_time = os.time()

        DebugPrint("Next reset time: " .. os.date("%Y-%m-%d %H:%M:%S", next_reset))
        DebugPrint("Current time: " .. os.date("%Y-%m-%d %H:%M:%S", current_time))

        if current_time >= next_reset then
            DebugPrint("It's time to reset the player.")

            local player_level = 1
            local experience = 0

            -- Fetch the next level XP requirement from the player_level_brackets table
            local next_level_query = WorldDBQuery("SELECT max_xp FROM acore_guildwars.player_level_brackets WHERE level = " .. player_level)

            if next_level_query == nil then
                DebugPrint("Error: No XP data found for level " .. player_level .. " in player_level_brackets.")
                return
            end

            local next_level = next_level_query:GetUInt32(0)
            DebugPrint("Next level XP for level " .. player_level .. ": " .. next_level)

            -- Update the last_reset and next_reset timestamps
            local last_reset = current_time
            local new_next_reset = last_reset + (30 * 24 * 60 * 60) -- 30 days in seconds

            -- Reset the player's data in player_level table
            local update_player_level_query = string.format(
                "UPDATE acore_guildwars.player_level SET player_level = %d, experience = %d, next_level = %d, " ..
                "last_reset = FROM_UNIXTIME(%d), next_reset = FROM_UNIXTIME(%d) WHERE guid = %d",
                player_level, experience, next_level, last_reset, new_next_reset, guid
            )
            local success_level = WorldDBExecute(update_player_level_query)

            if success_level == nil then
                DebugPrint("Player " .. player_name .. "'s level and experience have been reset.")
            else
                DebugPrint("Error: Failed to reset player " .. player_name .. "'s level and experience. Error: " .. success_level)
            end

            -- Reset the claimed rewards in player_claimed_rewards table
            DebugPrint("Resetting claimed rewards for player " .. player_name .. "...")
            
            local reset_rewards_query = string.format(
                "UPDATE acore_guildwars.player_claimed_rewards SET " ..
                "lvl_1 = 0, lvl_2 = 0, lvl_3 = 0, lvl_4 = 0, lvl_5 = 0, lvl_6 = 0, lvl_7 = 0, " ..
                "lvl_8 = 0, lvl_9 = 0, lvl_10 = 0, lvl_11 = 0, lvl_12 = 0, lvl_13 = 0, lvl_14 = 0, lvl_15 = 0 " ..
                "WHERE guid = " .. guid
            )
            local success_rewards = WorldDBExecute(reset_rewards_query)

            if success_rewards == nil then
                DebugPrint("Player " .. player_name .. "'s claimed rewards have been reset.")
            else
                DebugPrint("Error: Failed to reset claimed rewards for player " .. player_name .. ". Error: " .. success_rewards)
            end

        else
            DebugPrint("No reset needed for player " .. player_name .. ".")
        end
    else
        DebugPrint("Error: Could not retrieve next_reset for player " .. player_name .. ".")
    end
end

-- Event that triggers on player login
local function OnPlayerLogin(event, player)
    -- Check if the player exists and register them if not
    CheckAndRegisterPlayer(player)

    -- Check if the player's data needs to be reset
    CheckAndResetPlayer(player)
end

-- Register the player login event (Event 3 corresponds to player login)
RegisterPlayerEvent(3, OnPlayerLogin)
print("\n[REGISTRATION] > Player Registration system loaded.")