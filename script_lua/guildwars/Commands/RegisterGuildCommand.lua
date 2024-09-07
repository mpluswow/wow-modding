-- RegisterGuildCommand.lua
-- This script registers a guild into a guild leveling system when players use a specific chat command.

-- Function to handle the actual guild registration (inserting data into the database)
local function TryRegisterGuild(guildId)
    -- Prepare an SQL query to insert the guild's ID, initial level, and XP into the guild leveling table
    local registerQuery = string.format("INSERT INTO dreamforge.guildwars_level (guild_id, guild_level, current_xp) VALUES (%d, 1, 0)", guildId)
    
    -- Execute the query to insert the guild information into the database
    CharDBExecute(registerQuery) 
    
    -- Print a message to the console for debugging purposes
    print("Registration query executed.") 
end

-- Function to check if the guild has been successfully registered after the insert
local function CheckIfGuildRegistered(eventId, delay, repeats, playerGuid, guildId)
    -- Retrieve the player object again by using the player's unique identifier (GUID)
    local player = GetPlayerByGUID(playerGuid)
    
    -- If the player doesn't exist anymore (e.g., they logged out), stop the process
    if not player then
        print("Player no longer exists or has logged out.") -- Debugging message
        return
    end

    -- Check if the guild was successfully registered by querying the database for the guild ID
    local checkSuccessQuery = CharDBQuery(string.format("SELECT guild_id FROM dreamforge.guildwars_level WHERE guild_id = %d", guildId))
    
    -- Print the query result to the console for debugging
    print("Checking if guild was successfully registered, query result:", checkSuccessQuery)

    -- If the query returned a result, the guild was successfully registered
    if checkSuccessQuery then
        -- Inform the player that their guild was successfully registered
        player:SendBroadcastMessage("Your guild has been successfully registered in the guild leveling system!")
    else
        -- If the guild isn't found in the database, something went wrong
        player:SendBroadcastMessage("An error occurred during guild registration.")
        print("Guild registration failed.") -- Debugging message
    end
end

-- Function to handle the overall guild registration process, starting from checking if the guild is already registered
local function RegisterGuild(player)
    -- Get the guild the player belongs to
    local guild = player:GetGuild()
    
    -- If the player isn't in a guild, notify them and stop the process
    if not guild then
        player:SendBroadcastMessage("You are not in a guild.")
        return
    end

    -- Get the guild's unique ID and the player's unique identifier (GUID)
    local guildId = guild:GetId()
    local playerGuid = player:GetGUIDLow() -- Store the player's GUID for later use in delayed events

    -- Check if the guild is already registered in the guild leveling system by querying the database
    local checkGuildQuery = CharDBQuery(string.format("SELECT guild_id FROM dreamforge.guildwars_level WHERE guild_id = %d", guildId))
    
    -- Print the query result to the console for debugging
    print("Checking if guild is already registered, query result:", checkGuildQuery)

    -- If the query returned a result, the guild is already registered
    if checkGuildQuery then
        -- Inform the player that their guild is already registered
        player:SendBroadcastMessage("Your guild is already registered in the guild leveling system.")
    else
        -- If the guild isn't registered, attempt to register it by calling the TryRegisterGuild function
        TryRegisterGuild(guildId)

        -- Wait 500 milliseconds (0.5 seconds) before checking if the guild is now registered
        -- Pass the player's GUID and the guild ID to the delayed function for re-checking registration
        CreateLuaEvent(function() CheckIfGuildRegistered(nil, nil, nil, playerGuid, guildId) end, 500, 1)
    end
end

-- Function to handle chat commands issued by players
local function RegisterGuildCommand(event, player, command)
    -- If the player types ".registerguild" in chat, proceed with guild registration
    if string.lower(command) == "registerguild" then
        -- Call the RegisterGuild function to handle the registration process
        RegisterGuild(player)
        return false -- Returning false allows other chat commands to be processed as normal
    end
end

-- Register the RegisterGuildCommand function to respond to chat commands (Event 42 handles chat input)
RegisterPlayerEvent(42, RegisterGuildCommand)

-- Print a message to the server console to indicate that the command is loaded and ready
print(" ")
print("> GuildWars .registerguild command loaded.")
