-- Debug flag (set to true to enable debug prints)
local debug = false

-- Function to print debug information if debug mode is enabled
local function DebugPrint(message)
    if debug then
        print("[PLAYER-KILL-COUNTER] " .. message)
    end
end

-- Function to handle player kills (TypeID 4)
local function OnPlayerKill(event, killer, victim)
    local typeId = victim:GetTypeId()

    if typeId == 4 then  -- TypeID 4 corresponds to players
        local guid = killer:GetGUIDLow()
        DebugPrint("Player " .. killer:GetName() .. " killed another player.")

        -- Query to get current player_kills and experience from the database
        local query = CharDBQuery("SELECT player_kills, experience FROM acore_guildwars.player_level WHERE guid = " .. guid)
        
        if query then
            local player_kills = query:GetUInt32(0)
            local experience = query:GetUInt32(1)

            -- Increment player kills by 1 and experience by 50
            local new_player_kills = player_kills + 1
            local new_experience = experience + 50

            -- Update the database with new values
            local update_query = string.format(
                "UPDATE acore_guildwars.player_level SET player_kills = %d, experience = %d WHERE guid = %d",
                new_player_kills, new_experience, guid
            )
            local success = CharDBExecute(update_query)

            if success == nil then
                DebugPrint("Player " .. killer:GetName() .. "'s player kills and experience updated.")
            else
                DebugPrint("Error: Failed to update player kills and experience for player " .. killer:GetName() .. ". Error: " .. success)
            end
        else
            DebugPrint("Error: No data found for player " .. killer:GetName() .. " in player_level.")
        end
    else
        DebugPrint("Target is not a player (TypeID: " .. typeId .. ")")
    end
end

-- Register the event for player kills
RegisterPlayerEvent(6, OnPlayerKill)  -- Event 6: Player kills
