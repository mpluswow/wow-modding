local AIO = AIO or require("AIO")

-- Registering server-side AIO handlers
local gw_fetchDATA_Handlers = AIO.AddHandlers("gw_fetchDATA", {})

-- Function to fetch all necessary data in one query
local function gw_fetchDATA_AllData(guid)
    -- Fetch all data in one query
    local query = CharDBQuery("SELECT guild_name, player_kills, creature_kills, next_reset FROM acore_guildwars.player_solo_ranking WHERE guid = " .. guid)
    
    if query then
        -- Extract the results from the query
        local guildName = query:GetString(0)
        local playerKills = query:GetUInt32(1)
        local creatureKills = query:GetUInt32(2)
        local nextReset = query:GetString(3)
        
        -- Print debug logs to confirm fetched data
        print("[Server] Fetched Data:")
        print("  Guild Name: " .. guildName)
        print("  Player Kills: " .. playerKills)
        print("  Creature Kills: " .. creatureKills)
        print("  Next Reset: " .. nextReset)

        -- Return the data fetched
        return guildName, playerKills, creatureKills, nextReset
    else
        -- Log error if no data is found
        print("[Server] Error: No data found for GUID: " .. guid)
        return nil
    end
end

-- Function to trigger when the "tg" command is used
local function gw_fetchDATA_OnCommand_tg(event, player, command)
    if command == "tg" then
        -- Get the player's GUID
        local guid = player:GetGUIDLow()
        print("[Server] /tg command triggered by player GUID:", guid)

        -- Fetch all data for the player using their GUID
        local gw_guildName, gw_playerKills, gw_creatureKills, gw_nextReset = gw_fetchDATA_AllData(guid)

        -- Check if the data exists before sending to client
        if gw_guildName and gw_playerKills and gw_creatureKills and gw_nextReset then
            -- Send data to the client using AIO
            AIO.Msg():Add("gw_fetchDATA", "gw_fetchDATA_ShowWindow", gw_guildName, tostring(gw_playerKills), tostring(gw_creatureKills), gw_nextReset):Send(player)
            print("[Server] Data successfully sent to client.")
        else
            -- Send error message to the player if any data is missing
            print("[Server] Error: Missing data for player GUID:", guid)
            player:SendBroadcastMessage("Error: Missing data for your character in the player_solo_ranking table.")
        end

        return false  -- Prevent the command from showing in the chat
    end
end

-- Registering the event for the "tg" command (Event 42 is the command handler)
RegisterPlayerEvent(42, gw_fetchDATA_OnCommand_tg)
