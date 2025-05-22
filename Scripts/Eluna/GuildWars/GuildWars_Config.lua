local config = {}

config.sharedGoEntry = 600001

-- Debug option: 0 for no debug messages, 1 for debug messages
config.debug = 1  -- Set to 0 to disable debug prints

-- Capturable zones with XP and Gold reward bonuses (in percent)
config.zones = {
    {
        mapId = 0,            -- mapId for Elwynn Forest
        zoneId = 12,          -- zoneId for Elwynn Forest
        areaId = 87,          -- areaId for the specific subzone
        name = "Elwynn Forest",
        cooldown = 300,      -- Cooldown in seconds (30 minutes)
        rewardedXP = 5,       -- 5% XP bonus
        rewardedGold = 20     -- 20% Gold bonus
    },
    {
        mapId = 0,            -- mapId for Westfall
        zoneId = 40,          -- zoneId for Westfall
        areaId = 107,         -- areaId for the specific subzone
        name = "Westfall",
        cooldown = 1800,
        rewardedXP = 10,
        rewardedGold = 50
    },
    {
        mapId = 1,            -- mapId for Durotar
        zoneId = 14,          -- zoneId for Durotar
        areaId = 14,          -- areaId for the specific subzone
        name = "Durotar",
        cooldown = 1800,
        rewardedXP = 7,
        rewardedGold = 25
    },
    {
        mapId = 0,            -- mapId for Duskwood
        zoneId = 10,          -- zoneId for Duskwood
        areaId = 10,          -- areaId for the specific subzone
        name = "Duskwood",
        cooldown = 1800,
        rewardedXP = 8,
        rewardedGold = 40
    },
}

return config
