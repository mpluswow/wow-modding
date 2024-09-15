-- Debug flag (set to true to enable debug prints)
local debug = true

-- Function to print debug information if debug mode is enabled
local function DebugPrint(message)
    if debug then
        print("[CREATURE-KILL-COUNTER] " .. message)
    end
end

-- Function to handle creature kills (TypeID 3)
local function OnCreatureKill(event, player, creature)
    local typeId = creature:GetTypeId()

    if typeId == 3 then  -- TypeID 3 corresponds to creatures
        local guid = player:GetGUIDLow()
        DebugPrint("Player " .. player:GetName() .. " killed a creature.")

        -- Query to get current creature_kills and experience from the database
        local query = CharDBQuery("SELECT creature_kills, experience FROM acore_guildwars.player_level WHERE guid = " .. guid)
        
        if query then
            local creature_kills = query:GetUInt32(0)
            local experience = query:GetUInt32(1)

            -- Increment creature kills by 1 and experience by 13
            local new_creature_kills = creature_kills + 1
            local new_experience = experience + 13

            -- Update the database with new values
            local update_query = string.format(
                "UPDATE acore_guildwars.player_level SET creature_kills = %d, experience = %d WHERE guid = %d",
                new_creature_kills, new_experience, guid
            )
            local success = CharDBExecute(update_query)

            if success == nil then
                DebugPrint("Player " .. player:GetName() .. "'s creature kills and experience updated.")
            else
                DebugPrint("Error: Failed to update creature kills and experience for player " .. player:GetName() .. ". Error: " .. success)
            end
        else
            DebugPrint("Error: No data found for player " .. player:GetName() .. " in player_level.")
        end
    else
        DebugPrint("Target is not a creature (TypeID: " .. typeId .. ")")
    end
end

-- Register the event for creature kills
RegisterPlayerEvent(7, OnCreatureKill)  -- Event 6: Creature kills
print("\n[CREATURE-KILL-COUNTER] > Creature Kill counter loaded.")