-- Global variable to store the path ID
local customPathId = nil

-- Function to log messages for debugging
local function LogDebugMessage(message)
    print("[TaxiPath Debug] " .. message)
end

-- Execute on server startup to add the custom taxi path
local function AddCustomTaxiPath()
    -- Define waypoints for the taxi path {mapid, x, y, z}
    local pathTable = {
        {1, 16242.28, 16265.39, 14.90},
{1, 16237.51, 16263.14, 18.92},
{1, 16232.95, 16260.97, 23.84},
{1, 16220.63, 16252.75, 29.19},
{1, 16210.52, 16237.17, 34.97},
{1, 16211.13, 16226.34, 46.62},
{1, 16228.22, 16190.72, 46.33},
{1, 16256.37, 16170.46, 46.14},
{1, 16283.73, 16160.20, 45.98},
{1, 16308.23, 16159.94, 45.86},
{1, 16340.13, 16168.44, 45.68},
{1, 16353.66, 16192.30, 45.53},
{1, 16347.81, 16205.27, 43.13},
{1, 16340.67, 16212.63, 40.87},
{1, 16331.14, 16222.44, 37.85},
{1, 16324.00, 16229.79, 35.59},
{1, 16316.86, 16237.15, 33.32},
{1, 16307.33, 16246.95, 30.31},
{1, 16299.10, 16253.72, 28.02},
{1, 16293.35, 16256.26, 26.77},
{1, 16286.25, 16257.91, 25.31},
{1, 16266.52, 16259.21, 20.32},
    }

    -- Add the taxi path
    -- 308 = Alliance Gryphon, 307 = Horde Wind Rider
    local pathId = AddTaxiPath(pathTable, 26466, 26466, 0)  -- 0 is the price

    -- Ensure pathId is valid
    if pathId then
        LogDebugMessage("Custom taxi path added successfully with ID: " .. pathId)
        customPathId = pathId  -- Store the pathId globally
    else
        LogDebugMessage("Error: Failed to add taxi path. pathId is nil.")
    end
end

-- Execute when the server starts up
local function OnServerStartup(event)
    AddCustomTaxiPath()
end

-- Register server startup event
RegisterServerEvent(14, OnServerStartup) -- 14 is the event ID for WORLD_EVENT_ON_STARTUP

-- Function to make a player fly along the custom path
local function StartCustomFlight(player)
    if customPathId then
        player:SendBroadcastMessage("Starting custom taxi path...")
        LogDebugMessage("Starting taxi path with ID: " .. customPathId)
        player:StartTaxi(customPathId)
    else
        player:SendBroadcastMessage("Error: Taxi path ID is invalid.")
        LogDebugMessage("Error: Taxi path ID is invalid. customPathId is nil or invalid.")
    end
end

-- Command to trigger the flight for testing purposes
local function OnChatCommand(event, player, command)
    if command == "testtaxi" then
        StartCustomFlight(player)
        return false  -- Prevent the command from being processed further
    end
end

-- Register the command event (42 = PLAYER_EVENT_ON_COMMAND)
RegisterPlayerEvent(42, OnChatCommand)

print("\n[testTAXI]")