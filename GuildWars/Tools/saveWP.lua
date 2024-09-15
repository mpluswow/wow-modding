-- Server-side script to log the player's current coordinates to a file

-- Define the log file path
local logFilePath = "waypoints_log.txt"

-- Function to append a line to the log file
local function AppendToFile(path, text)
    -- Open the file in append mode
    local file = assert(io.open(path, "a"))
    if file then
        -- Write the text followed by a new line
        file:write(text .. "\n")
        -- Close the file to ensure changes are saved
        file:close()
    else
        print("Error: Unable to open file for writing: " .. path)
    end
end

-- Command handler to log the player's current coordinates
local function LogCurrentCoordinates(event, player)
    -- Get the player's current position
    local mapId = player:GetMapId()
    local x, y, z = player:GetX(), player:GetY(), player:GetZ()

    -- Format the output line (you can customize this format as needed)
    local line = string.format("{%d, %.2f, %.2f, %.2f},", mapId, x, y, z)

    -- Append the line to the log file
    AppendToFile(logFilePath, line)

    -- Notify the player
    player:SendBroadcastMessage("Your current coordinates have been logged: " .. line)
end

-- Register the command to log the player's coordinates
-- Here, the command is ".logwaypoint"
local function OnChatCommand(event, player, command)
    if command == "swp" then
        LogCurrentCoordinates(event, player)
        return false  -- Prevent the command from being processed further
    end
end

-- Register the command event (42 = PLAYER_EVENT_ON_COMMAND)
RegisterPlayerEvent(42, OnChatCommand)
print("\n[SAVE-WP]")