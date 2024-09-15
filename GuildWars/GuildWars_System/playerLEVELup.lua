-- Debug flag (set to true to enable debug prints)
local debug = true

-- Function to print debug information if debug mode is enabled
local function DebugPrint(message)
    if debug then
        print("[LEVEL-UP] " .. message)
    end
end

-- Function to sanitize player names to prevent SQL injection
local function SanitizeString(str)
    return str:gsub("'", "''")
end

-- Function to check if the player can level up and carry over excess XP
local function CheckAndLevelUp(player)
    local guid = player:GetGUIDLow()
    local player_name = player:GetName()
    
    DebugPrint("Checking if player " .. player_name .. " (GUID: " .. guid .. ") can level up...")

    -- Query the database to get the player's experience, next_level XP, and player_level
    local query = WorldDBQuery("SELECT experience, next_level, player_level FROM acore_guildwars.player_level WHERE guid = " .. guid)

    if query ~= nil then
        local experience = query:GetUInt32(0)
        local next_level_xp = query:GetUInt32(1)
        local player_level = query:GetUInt32(2)

        DebugPrint("Player " .. player_name .. ": Experience = " .. experience .. ", Next Level XP = " .. next_level_xp)

        -- Continue leveling up as long as the player's experience is greater than or equal to the next level XP
        while experience >= next_level_xp do
            -- Calculate excess experience that will carry over to the next level
            local excess_xp = experience - next_level_xp
            DebugPrint("Player " .. player_name .. " has excess XP: " .. excess_xp)

            -- Increase player level by 1
            player_level = player_level + 1

            -- Fetch the new XP requirement for the next level
            local next_level_query = WorldDBQuery("SELECT max_xp FROM acore_guildwars.player_level_brackets WHERE level = " .. player_level)
            if next_level_query == nil then
                DebugPrint("Error: No XP data found for level " .. player_level .. " in player_level_brackets.")
                return
            end

            local new_next_level_xp = next_level_query:GetUInt32(0)
            DebugPrint("Player " .. player_name .. " leveled up to " .. player_level .. ". New next level XP = " .. new_next_level_xp)

            -- Set the player's experience to the excess XP for the new level
            experience = excess_xp
            next_level_xp = new_next_level_xp

            -- Update player level and next level XP in the database
            local update_query = string.format(
                "UPDATE acore_guildwars.player_level SET player_level = %d, experience = %d, next_level = %d WHERE guid = %d",
                player_level, experience, next_level_xp, guid
            )
            local success = WorldDBExecute(update_query)

            if success == nil then
                DebugPrint("Player " .. player_name .. "'s level has been updated to " .. player_level .. " with experience " .. experience .. ".")
                player:SendBroadcastMessage("Congratulations! You've leveled up to level " .. player_level .. "!")
            else
                DebugPrint("Error: Failed to update player level for " .. player_name .. ". Error: " .. success)
            end
        end

        DebugPrint("Player " .. player_name .. " does not have enough experience to level up further.")
    else
        DebugPrint("Error: Could not retrieve experience and next_level for player " .. player_name .. ".")
    end
end

-- Event hooks for real-time level-up check
-- Event 3 corresponds to player login
local function OnPlayerLogin(event, player)
    CheckAndLevelUp(player)
end

-- Event for creature kill (Eluna event ID 6)
local function OnCreatureKill(event, player, creature)
    CheckAndLevelUp(player)
end

-- Event for player kill (Eluna event ID 7)
local function OnPlayerKill(event, killer, victim)
    CheckAndLevelUp(killer)
end

-- Register the events
RegisterPlayerEvent(3, OnPlayerLogin)      -- Player login
RegisterPlayerEvent(6, OnCreatureKill)     -- Creature kill
RegisterPlayerEvent(7, OnPlayerKill)       -- Player kill
print("\n[LEVEL-UP] > Player leveling system loaded.")