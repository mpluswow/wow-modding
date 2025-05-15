local TELEPORT_MAP = 571       -- Northrend
local TELEPORT_X = 5940.51
local TELEPORT_Y = 623.757
local TELEPORT_Z = 650.654
local TELEPORT_O = 2.73016     -- orientation
local TARGET_LEVEL = 70
local REWARD_GOLD = 250000     -- 2500 gold in copper

function OnLogin(event, player)
    if player:GetTotalPlayedTime() < 60 then
        local guid = player:GetGUIDLow()
        
        player:SetLevel(TARGET_LEVEL)
        player:SendBroadcastMessage("Welcome! You have been leveled to " .. TARGET_LEVEL .. ". Teleporting in 5 seconds...")

        -- Wait 5 seconds, then teleport
        CreateLuaEvent(function()
            local p = GetPlayerByGUID(guid)
            if p and p:IsInWorld() then
                p:Teleport(TELEPORT_MAP, TELEPORT_X, TELEPORT_Y, TELEPORT_Z, TELEPORT_O)
                p:SendBroadcastMessage("Teleported! You'll receive your gold in 5 seconds...")

                -- Wait another 5 seconds, then reward gold
                CreateLuaEvent(function()
                    local p2 = GetPlayerByGUID(guid)
                    if p2 and p2:IsInWorld() then
                        p2:ModifyMoney(REWARD_GOLD)
                        p2:SendBroadcastMessage("You've received 2500 gold. Enjoy your adventure!")
                    end
                end, 5000, 1)
            end
        end, 5000, 1)
    end
end

RegisterPlayerEvent(3, OnLogin)
