--testServer.LUA

local AIO = AIO or require("AIO")

-- Register server-side handlers
local ResetInfoHandlers = AIO.AddHandlers("ResetInfo", {})

-- Function to fetch guild name, last reset, and next reset from the DB
local function FetchResetInfoFromDB(player)
    local guid = player:GetGUIDLow()

    -- Error handling: Ensure the player GUID is valid
    if not guid or guid <= 0 then
        print("Error: Invalid GUID received from player.")
        return
    end

    print("Debug: Starting FetchResetInfoFromDB for GUID: " .. guid) -- DEBUG

    -- SQL query to fetch player_name, last_reset, next_reset based on GUID
    local query = string.format("SELECT player_name, last_reset, next_reset FROM acore_guildwars.player_solo_ranking WHERE guid = %d", guid)
    local result = WorldDBQuery(query)

    -- Error handling: Check if query succeeded
    if not result then
        print("Error: Query failed or no result returned for GUID: " .. guid)
        return
    end

    -- Error handling: Check if the result has valid rows
    if result:GetRowCount() == 0 then
        print("Error: No data found for GUID: " .. guid)
        return
    end

    -- Fetch the data
    local gwname = result:GetString(0)  -- Fetch 'player_name' as a string
    local last_reset = result:GetString(1)  -- Fetch 'last_reset' as a string (timestamp)
    local next_reset = result:GetString(2)  -- Fetch 'next_reset' as a string (timestamp)

    -- Error handling: Ensure valid data has been fetched
    if not gwname or gwname == "" then
        print("Error: Invalid player_name fetched for GUID: " .. guid)
        return
    end

    if not last_reset or last_reset == "" then
        print("Error: Invalid last_reset fetched for GUID: " .. guid)
        return
    end

    if not next_reset or next_reset == "" then
        print("Error: Invalid next_reset fetched for GUID: " .. guid)
        return
    end

    -- Debugging: Log what we have fetched
    print("Debug: Fetched player_name: " .. tostring(gwname))
    print("Debug: Fetched last_reset: " .. tostring(last_reset))
    print("Debug: Fetched next_reset: " .. tostring(next_reset))

    -- Send the data to the client using AIO
    local success, err = pcall(function()
        AIO.Handle(player, "ResetInfo", "ShowAllResetInfo", gwname, last_reset, next_reset)
    end)

    -- Error handling: Check if AIO.Handle succeeded
    if not success then
        print("Error: Failed to send data to client via AIO. Error: " .. tostring(err))
        return
    end

    print("Debug: Data sent successfully to the client.")
end

-- Command handler for command input
RegisterPlayerEvent(42, function(event, player, command)
    if command == "11" then  -- Check if the player typed '/11'
        print("Debug: Command '11' received from player: " .. player:GetName())  -- DEBUG
        local success, err = pcall(function() FetchResetInfoFromDB(player) end)
        -- Error handling: Ensure the function execution succeeded
        if not success then
            print("Error: Failed to fetch reset info. Error: " .. tostring(err))
        end
        return false -- Prevent further command processing
    end
end)
