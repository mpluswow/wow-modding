local function ZoneCommand(event, player, command)
    
    local cmd, rest = command:match("^(%S+)%s*(.*)")
    if not cmd or cmd ~= "zone" then
        return
    end

    local name, xpStr, goldStr = rest:match("^(%S+)%s+(%S+)%s+(%S+)")
    if not name then
        player:SendBroadcastMessage("Usage: .zone <name> <bonus_xp> <bonus_gold>")
        return false
    end

    local bonus_xp = tonumber(xpStr)
    local bonus_gold = tonumber(goldStr)
    if not bonus_xp or not bonus_gold then
        player:SendBroadcastMessage("XP and Gold must be numbers.")
        return false
    end

    local map = player:GetMapId()
    local zone = player:GetZoneId()
    local area = player:GetAreaId()

   
    local safe_name = name:gsub("'", "''")

    
    local sql = string.format(
        "INSERT INTO gw_pillars (name, map, zone, area, bonus_xp, bonus_gold) " ..
        "VALUES ('%s', %d, %d, %d, %d, %d) " ..
        "ON DUPLICATE KEY UPDATE name = VALUES(name), bonus_xp = VALUES(bonus_xp), bonus_gold = VALUES(bonus_gold);",
        safe_name, map, zone, area, bonus_xp, bonus_gold
    )

    
    print("[Eluna] Executing SQL: " .. sql)

    -- execute
    local ok = WorldDBExecute(sql)

    if ok then
        player:SendBroadcastMessage("Zone saved/updated: " .. name)
    end
end

RegisterPlayerEvent(42, ZoneCommand)


