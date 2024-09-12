-- Define guild names and commands at the top of the script
local guild1_name = "Dream Forgers"
local guild2_name = "Nightmare Forgers"

local command_for_guild1 = "joindream"   -- Command for joining Dream Forgers
local command_for_guild2 = "joinnightmare"   -- Command for joining Nightmare Forgers

-- Define cooldown time in seconds (3600 seconds = 1 hour)
local command_cooldown = 3600
-- Table to store the last command usage for each player
local player_command_timers = {}

-- Function to remove the player from their current guild, if they are in one
local function RemoveFromCurrentGuild(player)
    if player:IsInGuild() then -- Check if the player is in a guild
        local guild = player:GetGuild() -- Get the player's current guild object
        if guild then
            guild:DeleteMember(player, false) -- Remove the player from the guild
            player:SendBroadcastMessage("You have been removed from your current guild.")
        else
            player:SendBroadcastMessage("Error: Unable to find your current guild.")
        end
    else
        player:SendBroadcastMessage("You are not currently in a guild.")
    end
end

-- Function to check cooldown for a player
local function IsOnCooldown(player)
    local playerGUID = player:GetGUIDLow() -- Get a unique identifier for the player
    local last_used = player_command_timers[playerGUID]

    if last_used then
        local current_time = os.time()
        if current_time - last_used < command_cooldown then
            return true, command_cooldown - (current_time - last_used) -- Return remaining cooldown time
        end
    end
    return false, 0
end

-- Command to add a player to Guild1 (Dream Forgers)
local function AddToGuild1(event, player, command)
    if command == command_for_guild1 then -- Command for Dream Forgers
        -- Check cooldown
        local onCooldown, remainingTime = IsOnCooldown(player)
        if onCooldown then
            player:SendBroadcastMessage("You can use this command again in " .. math.ceil(remainingTime / 60) .. " minutes.")
            return false
        end

        RemoveFromCurrentGuild(player) -- Remove the player from the current guild

        local guild = GetGuildByName(guild1_name)

        if guild then
            guild:AddMember(player, player:GetGuildRank()) -- Add the player to Dream Forgers
            player:SendBroadcastMessage("You have been added to " .. guild1_name .. "!")
            player_command_timers[player:GetGUIDLow()] = os.time() -- Record the time of command usage
        else
            player:SendBroadcastMessage(guild1_name .. " does not exist.")
        end

        return false -- Prevent command from showing in chat
    end
end

-- Command to add a player to Guild2 (Nightmare Forgers)
local function AddToGuild2(event, player, command)
    if command == command_for_guild2 then -- Command for Nightmare Forgers
        -- Check cooldown
        local onCooldown, remainingTime = IsOnCooldown(player)
        if onCooldown then
            player:SendBroadcastMessage("You can use this command again in " .. math.ceil(remainingTime / 60) .. " minutes.")
            return false
        end

        RemoveFromCurrentGuild(player) -- Remove the player from the current guild

        local guild = GetGuildByName(guild2_name)

        if guild then
            guild:AddMember(player, player:GetGuildRank()) -- Add the player to Nightmare Forgers
            player:SendBroadcastMessage("You have been added to " .. guild2_name .. "!")
            player_command_timers[player:GetGUIDLow()] = os.time() -- Record the time of command usage
        else
            player:SendBroadcastMessage(guild2_name .. " does not exist.")
        end

        return false -- Prevent command from showing in chat
    end
end

-- Register the commands to invite players to guilds
RegisterPlayerEvent(42, AddToGuild1)
RegisterPlayerEvent(42, AddToGuild2)
