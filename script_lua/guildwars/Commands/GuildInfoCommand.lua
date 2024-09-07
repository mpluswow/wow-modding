-- GuildInfoCommand.lua
-- Function to show the guild info in a gossip menu
local function ShowGuildInfoGossip(player)
    local guild = player:GetGuild()  -- Get the player's guild, returns nil if the player isn't in a guild

    if guild then  -- Check if the player is in a guild
        local guildId = guild:GetId()  -- Get the unique ID of the guild

        -- Query the guild level and current XP from the 'dreamforge.guildwars_level' table
        local guildLevelQuery = CharDBQuery(string.format("SELECT guild_level, current_xp FROM dreamforge.guildwars_level WHERE guild_id = %d", guildId))

        if guildLevelQuery then  -- If the query returns a result (the guild is registered in the system)
            local currentLevel = guildLevelQuery:GetInt32(0)  -- Get the guild's current level from the first column of the result
            local currentXP = guildLevelQuery:GetInt32(1)  -- Get the guild's current XP from the second column

            -- Query the XP required for the next level from 'dreamforge.guildwars_level_bracket' table
            local nextLevelQuery = CharDBQuery(string.format("SELECT xp_required FROM dreamforge.guildwars_level_bracket WHERE level = %d", currentLevel + 1))

            local xpRequired = nil  -- Initialize the XP required for the next level
            if nextLevelQuery then  -- If the query returns a result (there is a next level)
                xpRequired = nextLevelQuery:GetInt32(0)  -- Get the required XP for the next level from the first column
            end

            -- Start creating the gossip menu for the player
            player:GossipClearMenu()  -- Clear any previous gossip menu
            player:GossipMenuAddItem(0, "Guild Information", 0, 1)  -- Add a title or header for the menu

            -- Add a line to display the current guild level in green
            player:GossipMenuAddItem(1, string.format("Guild Level: |cff00ff00%d|r", currentLevel), 0, 0)

            -- Add a line to display the current XP and XP required for the next level, if there is a next level
            if xpRequired then
                player:GossipMenuAddItem(4, string.format("Guild XP: |cff00ff00%d|r / |cff00ff00%d|r", currentXP, xpRequired), 0, 0)
            else
                -- If there's no next level, display a message saying the guild is at max level
                player:GossipMenuAddItem(3, "Your guild is at the maximum level.", 0, 0)
            end

            -- Send the finished gossip menu to the player to be displayed
            player:GossipSendMenu(1, player, 100)  -- 1 = menu ID, 100 = gossip ID for handling later
        else
            -- If the guild is not registered in the guild leveling system, show an error message
            player:SendBroadcastMessage("Error: Your guild is not registered in the guild leveling system.")
        end
    else
        -- If the player isn't in a guild, send a message notifying them
        player:SendBroadcastMessage("You are not in a guild.")
    end
end

-- Command handler function for the "/guildinfo" command
local function OnCommand(event, player, command)
    if command == "guildinfo" then  -- Check if the player entered the "/guildinfo" command
        ShowGuildInfoGossip(player)  -- Show the gossip menu with guild info
        return false  -- Block further processing of the command (to prevent default behavior)
    end
end

-- Gossip event handler to close the gossip menu when a player selects an option
local function OnGossipSelect(event, player, object, sender, intid, code)
    player:GossipComplete()  -- Closes the gossip menu
end

-- Register the "/guildinfo" command to the player command event
RegisterPlayerEvent(42, OnCommand)  -- Event 42 is triggered for player commands

-- Register the gossip select event to handle closing the gossip menu
RegisterPlayerGossipEvent(100, 2, OnGossipSelect)  -- 100 = gossip ID, 2 = gossip select event type
