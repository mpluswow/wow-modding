local TELEPORT_MAP = 571       -- Northrend
local TELEPORT_X = 5940.51
local TELEPORT_Y = 623.757
local TELEPORT_Z = 650.654
local TELEPORT_O = 2.73016     -- orientation
local TARGET_LEVEL = 70        -- desired level

-- Hook into OnLogin
function OnLogin(event, player)
    if player:GetLevel() == 1 and player:GetTotalPlayedTime() < 60 then
        player:SendBroadcastMessage("Welcome! Teleporting in 5 seconds...")

        local guid = player:GetGUIDLow()

        -- Delay 5 seconds for teleport
        CreateLuaEvent(function()
            local p = GetPlayerByGUID(guid)
            if p and p:IsInWorld() then
                p:Teleport(TELEPORT_MAP, TELEPORT_X, TELEPORT_Y, TELEPORT_Z, TELEPORT_O)
                p:SendBroadcastMessage("Teleported! Leveling up in 5 seconds...")

                -- Delay another 5 seconds for level-up
                CreateLuaEvent(function()
                    local p2 = GetPlayerByGUID(guid)
                    if p2 and p2:IsInWorld() then
                        p2:SetLevel(TARGET_LEVEL)
                        p2:SendBroadcastMessage("Leveled up to " .. TARGET_LEVEL .. "!")
                    end
                end, 5000, 1)
            end
        end, 5000, 1)
    end
end

RegisterPlayerEvent(3, OnLogin)
