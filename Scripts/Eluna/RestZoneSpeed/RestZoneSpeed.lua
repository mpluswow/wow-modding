-- Define a table with zone IDs for common resting zones
local RESTING_ZONES = {
    [1519] = true,  -- Stormwind City
    [1637] = true,  -- Orgrimmar
    [1657] = true,  -- Darnassus
    [1497] = true,  -- Undercity
    [3703] = true,  -- Shattrath City
    [4395] = true,  -- Dalaran
    [1537] = true,  -- Ironforge
    [1] = true,     -- Dun Morogh (example for other zones)
    -- Add other resting zone IDs as needed
}

local function ModifyPlayerSpeed(event, player, newZone)
    if RESTING_ZONES[newZone] then
        if not player:IsInCombat() then  -- Ensure they are not in combat when increasing speed
            player:SetSpeed(1, 1.1)  -- Increase normal run speed by 10%
            player:SendBroadcastMessage("You are in a resting zone. Speed increased by 10%.")
        end
    else
        player:SetSpeed(1, 1.0)  -- Reset speed to normal when leaving the resting zone
        
    end
end

-- Register events to check when a player enters or leaves a resting zone
RegisterPlayerEvent(27, ModifyPlayerSpeed)  -- Zone change event
RegisterPlayerEvent(3, function(event, player)
    local zoneId = player:GetZoneId()
    ModifyPlayerSpeed(event, player, zoneId)
end)

print(" ")
print("> Script RestZone PlayerSpeed loaded successfully")
