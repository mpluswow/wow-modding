local AIO = AIO or require("AIO")

-- Registering server-side AIO handlers
local guildBar_Handlers = AIO.AddHandlers("guildBar_", {})

-- Function to send a text message to trigger the spell bar
local function SendGuildBarMessage(player)
    player:SendBroadcastMessage("TriggerGuildBar")  -- This message will be detected by the client
end

-- Function to trigger the spell bar on player login
local function OnPlayerLogin(event, player)
    SendGuildBarMessage(player)  -- Send the text message on login to display the bar
end

-- Register the player login event
RegisterPlayerEvent(3, OnPlayerLogin)
