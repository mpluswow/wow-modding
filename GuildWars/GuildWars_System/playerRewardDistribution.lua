--On login check if rewards are claimed if not send them by mail.
-- Debug flag (set to true to enable debug prints)
local debug = true  -- Enable debug to trace issues

-- Function to print debug information if debug mode is enabled
local function DebugPrint(message)
    if debug then
        print("[REWARD-CHECK] " .. message)
    end
end

-- Function to send rewards via in-game mail
local function SendRewardsViaMail(player, gold, items)
    local receiverGUIDLow = player:GetGUIDLow()  -- Low GUID of the receiver
    local senderGUIDLow = 3  -- Low GUID of the sender (3 in this example)
    local mail_subject = "Your Rewards"
    local mail_body = "Here are your rewards. Congratulations!"
    local stationary = 61 -- MAIL_STATIONERY_GM
    local delay = 0 -- No delay
    local cod = 0 -- No COD

    DebugPrint("Preparing to send mail to player GUID: " .. receiverGUIDLow)

    -- Send each item in separate mails along with gold if present
    local item_sent = false
    for _, item_id in ipairs(items) do
        if item_id and item_id > 0 then
            DebugPrint("Sending item ID: " .. item_id)
            -- Send the mail with each item individually
            local success = SendMail(
                mail_subject,           -- subject
                mail_body,              -- text
                receiverGUIDLow,        -- receiverGUIDLow
                senderGUIDLow,          -- senderGUIDLow
                stationary,             -- stationary
                delay,                  -- delay
                gold * 10000,           -- money (gold in copper)
                cod,                    -- cod
                item_id,                -- entry (item entry ID)
                1                       -- amount (send 1 of each item)
            )

            if success then
                DebugPrint("Mail sent successfully with item ID " .. item_id)
            else
                DebugPrint("Failed to send mail with item ID " .. item_id)
            end

            -- Set gold to 0 after first mail to avoid sending it multiple times
            gold = 0
            item_sent = true
        end
    end

    -- If no items were provided, send just the gold
    if not item_sent and gold > 0 then
        DebugPrint("Sending only gold: " .. gold)
        local success = SendMail(
            mail_subject,        -- subject
            mail_body,           -- text
            receiverGUIDLow,     -- receiverGUIDLow
            senderGUIDLow,       -- senderGUIDLow
            stationary,          -- stationary
            delay,               -- delay
            gold * 10000,        -- money (gold in copper)
            cod                  -- cod
        )

        if success then
            DebugPrint("Mail sent successfully with only gold.")
        else
            DebugPrint("Failed to send mail with only gold.")
        end
    end
end

-- Function to check if rewards have been claimed for the player's level
local function CheckAndSendRewards(player)
    local guid = player:GetGUIDLow()
    local player_name = player:GetName()

    -- Query to get the player's current level
    local level_query = WorldDBQuery("SELECT player_level FROM acore_guildwars.player_level WHERE guid = " .. guid)

    if not level_query then
        DebugPrint("Error: Player level not found for player " .. player_name)
        return
    end

    local player_level = level_query:GetUInt32(0)
    DebugPrint("Player level: " .. player_level)

    -- Query to check which rewards have been claimed for the player
    local reward_query = WorldDBQuery("SELECT lvl_1, lvl_2, lvl_3, lvl_4, lvl_5, lvl_6, lvl_7, lvl_8, lvl_9, lvl_10, lvl_11, lvl_12, lvl_13, lvl_14, lvl_15 FROM acore_guildwars.player_claimed_rewards WHERE guid = " .. guid)

    if not reward_query then
        DebugPrint("Error: No claimed rewards data found for player " .. player_name)
        return
    end

    -- Check if rewards for the player's level have already been claimed
    for level = 1, player_level do
        local claimed = reward_query:GetUInt32(level - 1)
        if claimed == 0 then
            DebugPrint("Rewards for level " .. level .. " not claimed. Sending rewards via mail.")

            -- Query the reward bracket for the current level
            local reward_bracket_query = WorldDBQuery("SELECT gold, item_id1, item_id2, item_id3, item_id4 FROM acore_guildwars.player_reward_brackets WHERE level = " .. level)

            if reward_bracket_query then
                -- Fetch gold and item IDs
                local gold = reward_bracket_query:GetUInt32(0)
                local items = {
                    reward_bracket_query:GetUInt32(1),
                    reward_bracket_query:GetUInt32(2),
                    reward_bracket_query:GetUInt32(3),
                    reward_bracket_query:GetUInt32(4)
                }

                -- Send the gold and items via mail
                SendRewardsViaMail(player, gold, items)

                -- Mark the reward as claimed in the database
                WorldDBExecute("UPDATE acore_guildwars.player_claimed_rewards SET lvl_" .. level .. " = 1 WHERE guid = " .. guid)
                DebugPrint("Marked level " .. level .. " rewards as claimed for player " .. player_name)
            else
                DebugPrint("Error: No reward bracket found for level " .. level)
            end
        else
            DebugPrint("Rewards for level " .. level .. " already claimed.")
        end
    end
end

-- Hook into the player login event
local function OnPlayerLogin(event, player)
    CheckAndSendRewards(player)
end

-- Hook into the player level-up event
local function OnPlayerLevelUp(event, player, oldLevel)
    CheckAndSendRewards(player)
end

-- Register events for login and level-up
RegisterPlayerEvent(3, OnPlayerLogin)  -- Event 3: Player login
RegisterPlayerEvent(13, OnPlayerLevelUp)  -- Event 13: Player level-up
print("\n[REWARD-CHECK] > Player Rewarding system loaded.")