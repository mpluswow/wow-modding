local config = require("GuildWars_Config")

-- Utility function for debug prints
local function DebugPrint(message)
    if config.debug == 1 then
        print(message)
    end
end

-- For capture: match mapId + zoneId + areaId
local function GetMatchingZoneConfigForCapture(player)
    local mapId = player:GetMapId()
    local zoneId = player:GetZoneId()
    local areaId = player:GetAreaId()

    DebugPrint(string.format("Checking capture zone: mapId=%d, zoneId=%d, areaId=%d", mapId, zoneId, areaId))

    for _, zone in ipairs(config.zones) do
        if zone.mapId == mapId and zone.zoneId == zoneId and zone.areaId == areaId then
            return zone
        end
    end

    return nil
end

-- For reward: match mapId + zoneId only
local function GetMatchingZoneConfigForReward(player)
    local mapId = player:GetMapId()
    local zoneId = player:GetZoneId()

    DebugPrint(string.format("Checking reward zone: mapId=%d, zoneId=%d", mapId, zoneId))

    for _, zone in ipairs(config.zones) do
        if zone.mapId == mapId and zone.zoneId == zoneId then
            return zone
        end
    end

    return nil
end

-- Capture GameObject Use Handler
local function OnCaptureUse(event, player, go)
    local zoneConfig = GetMatchingZoneConfigForCapture(player)
    if not zoneConfig then
        player:SendBroadcastMessage("You are not in a capturable zone.")
        return
    end

    local guild = player:GetGuild()
    if not guild then
        player:SendBroadcastMessage("You must be in a guild to capture zones.")
        return
    end

    local guildId = guild:GetId()
    local guildName = guild:GetName()
    local playerName = player:GetName()
    local now = os.time()

    local result = WorldDBQuery(string.format(
        "SELECT guild_id, UNIX_TIMESTAMP(captured_at) FROM guildwars_captured_zone WHERE zone_id = %d AND map_id = %d;",
        zoneConfig.zoneId, zoneConfig.mapId
    ))

    if result then
        local currentOwner = result:GetUInt32(0)
        local capturedAt = result:GetUInt32(1)

        if currentOwner == guildId then
            player:SendBroadcastMessage("Your guild already controls this zone.")
            return
        end

        local diff = now - capturedAt
        if diff < zoneConfig.cooldown then
            local remain = zoneConfig.cooldown - diff
            local hours = math.floor(remain / 3600)
            local minutes = math.floor((remain % 3600) / 60)
            local seconds = remain % 60

            local formattedTime = ""
            if hours > 0 then
                formattedTime = formattedTime .. string.format("%d hour%s, ", hours, hours > 1 and "s" or "")
            end
            if minutes > 0 or hours > 0 then
                formattedTime = formattedTime .. string.format("%d minute%s, ", minutes, minutes > 1 and "s" or "")
            end
            formattedTime = formattedTime .. string.format("%d second%s", seconds, seconds > 1 and "s" or "")

            player:SendBroadcastMessage("Zone is under cooldown. Try again in " .. formattedTime .. ".")
            return
        end
    end

    -- Update ownership
    WorldDBQuery(string.format([[ 
        REPLACE INTO guildwars_captured_zone (zone_id, map_id, guild_id, captured_at, last_guild_id) 
        VALUES (%d, %d, %d, NOW(), %s);
    ]], zoneConfig.zoneId, zoneConfig.mapId, guildId, result and result:GetUInt32(0) or "NULL"))

    -- Log capture
    WorldDBQuery(string.format([[ 
        INSERT INTO guildwars_capture_history (zone_id, map_id, guild_id, captured_at, player_name) 
        VALUES (%d, %d, %d, NOW(), '%s');
    ]], zoneConfig.zoneId, zoneConfig.mapId, guildId, playerName))

    -- Add reputation with faction ID 1165
    player:SetReputation(1165, 10)  -- 10 reputation points with faction 1165

    player:SendBroadcastMessage("Your guild has captured " .. zoneConfig.name .. " and gained 10 reputation with faction 1165!")
    SendWorldMessage(string.format("|cff00ff00[Guild Wars]|r %s was captured by guild: %s!", zoneConfig.name, guildName))

    DebugPrint(string.format("Captured zone: %s by guild: %s", zoneConfig.name, guildName))
end

-- XP Bonus Handler
local function OnGiveXP(event, player, amount, victim)
    local guild = player:GetGuild()
    if not guild then return amount end

    local zoneConfig = GetMatchingZoneConfigForReward(player)
    if not zoneConfig then return amount end

    local result = WorldDBQuery(string.format(
        "SELECT guild_id FROM guildwars_captured_zone WHERE zone_id = %d AND map_id = %d;", zoneConfig.zoneId, zoneConfig.mapId
    ))

    if result and result:GetUInt32(0) == guild:GetId() then
        local bonusPercent = zoneConfig.rewardedXP or 0
        local bonusAmount = amount * (bonusPercent / 100)
        local finalAmount = math.floor(amount + bonusAmount)

        player:SendBroadcastMessage(string.format(
            "XP Bonus - Base: %d, Bonus: %d%% (%.1f), Total: %d",
            amount, bonusPercent, bonusAmount, finalAmount
        ))

        DebugPrint(string.format("XP Bonus applied: %d -> %d (Bonus: %.1f)", amount, finalAmount, bonusAmount))

        return finalAmount
    end

    return amount
end

-- Gold Bonus Handler on Creature Kill
local function OnKillCreature(event, player, creature)
    local guild = player:GetGuild()
    if not guild then return end

    local zoneConfig = GetMatchingZoneConfigForReward(player)
    if not zoneConfig then return end

    local result = WorldDBQuery(string.format(
        "SELECT guild_id FROM guildwars_captured_zone WHERE zone_id = %d AND map_id = %d;", zoneConfig.zoneId, zoneConfig.mapId
    ))

    if result and result:GetUInt32(0) == guild:GetId() then
        local level = creature:GetLevel()
        local baseGold = level * 10 -- 10 copper per level
        local bonusPercent = zoneConfig.rewardedGold or 0
        local bonusGold = baseGold * (bonusPercent / 100)
        local totalGold = math.floor(baseGold + bonusGold)

        if totalGold > 0 then
            player:ModifyMoney(totalGold)
            player:SendBroadcastMessage(string.format(
                "Gold Bonus - Base: %d, Bonus: %d%% (%.1f), Total: %d copper",
                baseGold, bonusPercent, bonusGold, totalGold
            ))

            DebugPrint(string.format("Gold Bonus applied: %d -> %d (Bonus: %.1f)", baseGold, totalGold, bonusGold))
        end
    end
end

-- Register Events
RegisterGameObjectGossipEvent(config.sharedGoEntry, 1, OnCaptureUse)
RegisterPlayerEvent(12, OnGiveXP)       -- EVENT_ON_GIVE_XP
RegisterPlayerEvent(7, OnKillCreature)  -- EVENT_ON_KILL_CREATURE
