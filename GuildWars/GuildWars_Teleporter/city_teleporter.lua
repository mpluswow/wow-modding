local NPC_ID = 600000  -- NPC entry ID
local debug = true  -- Set this to true or false to enable/disable debug messages

-- Function to display the gossip menu
function OnGossipHello(event, player, creature)
    if debug then
        print("[TELEPORTER] OnGossipHello called for player: " .. player:GetName())
    end

    player:GossipClearMenu()  -- Clear any existing menu
    
    if player:IsAlliance() then
        if debug then
            print("[TELEPORTER] Player is Alliance")
        end
        player:GossipMenuAddItem(2, "|TInterface\\Icons\\inv_misc_rune_01:30|t Teleport to Stormwind", 1, 1)  -- Icon for Stormwind
        player:GossipMenuAddItem(2, "|TInterface\\Icons\\inv_misc_rune_02:30|t Teleport to Ironforge", 1, 2)  -- Icon for Ironforge
        player:GossipMenuAddItem(2, "|TInterface\\Icons\\inv_misc_rune_03:30|t Teleport to Darnassus", 1, 3)  -- Icon for Darnassus
        player:GossipMenuAddItem(2, "|TInterface\\Icons\\inv_misc_rune_04:30|t Teleport to The Exodar", 1, 4)  -- Icon for Exodar
    elseif player:IsHorde() then
        if debug then
            print("[TELEPORTER] Player is Horde")
        end
        player:GossipMenuAddItem(2, "|TInterface\\Icons\\inv_misc_rune_05:30|t Teleport to Orgrimmar", 1, 5)  -- Icon for Orgrimmar
        player:GossipMenuAddItem(2, "|TInterface\\Icons\\inv_misc_rune_06:30|t Teleport to Thunder Bluff", 1, 6)  -- Icon for Thunder Bluff
        player:GossipMenuAddItem(2, "|TInterface\\Icons\\inv_misc_rune_07:30|t Teleport to Undercity", 1, 7)  -- Icon for Undercity
        player:GossipMenuAddItem(2, "|TInterface\\Icons\\inv_misc_rune_08:30|t Teleport to Silvermoon City", 1, 8)  -- Icon for Silvermoon
    end
    
    -- Add GM Island teleport for Game Masters only
    if player:IsGM() then
        if debug then
            print("[TELEPORTER] Player is GM")
        end
        player:GossipMenuAddItem(4, "|TInterface\\Icons\\inv_misc_rune_09:30|t Teleport to GM Island", 1, 9)  -- Icon for GM Island
    end
    
    player:GossipSendMenu(1, creature, 1)
end

-- Function to handle player selection
function OnGossipSelect(event, player, creature, sender, intid, code)
    if debug then
        print("[TELEPORTER] OnGossipSelect called with intid: " .. intid)
    end

    player:GossipClearMenu()
    
    if intid == 1 then  -- Stormwind
        player:Teleport(0, -8833.38, 628.62, 94.00, 3.61)
        if debug then
            print("[TELEPORTER] Teleporting player to Stormwind")
        end
    elseif intid == 2 then  -- Ironforge
        player:Teleport(0, -4981.25, -881.542, 502.66, 5.41)
        if debug then
            print("[TELEPORTER] Teleporting player to Ironforge")
        end
    elseif intid == 3 then  -- Darnassus
        player:Teleport(1, 9951.52, 2280.32, 1341.39, 1.59)
        if debug then
            print("[TELEPORTER] Teleporting player to Darnassus")
        end
    elseif intid == 4 then  -- The Exodar
        player:Teleport(530, -3987.29, -11846.6, -2.01903, 0.63)
        if debug then
            print("[TELEPORTER] Teleporting player to The Exodar")
        end
    elseif intid == 5 then  -- Orgrimmar
        player:Teleport(1, 1676.21, -4315.29, 61.52, 2.83)
        if debug then
            print("[TELEPORTER] Teleporting player to Orgrimmar")
        end
    elseif intid == 6 then  -- Thunder Bluff
        player:Teleport(1, -1274.45, 71.8601, 128.16, 2.90)
        if debug then
            print("[TELEPORTER] Teleporting player to Thunder Bluff")
        end
    elseif intid == 7 then  -- Undercity
        player:Teleport(0, 1586.48, 239.562, -52.149, 0.05)
        if debug then
            print("[TELEPORTER] Teleporting player to Undercity")
        end
    elseif intid == 8 then  -- Silvermoon City
        player:Teleport(530, 9473.03, -7279.67, 14.29, 6.26)
        if debug then
            print("[TELEPORTER] Teleporting player to Silvermoon City")
        end
    elseif intid == 9 then  -- GM Island (GM only)
        player:Teleport(1, 16222.1, 16252.1, 12.5, 1.6)  -- GM Island coordinates
        if debug then
            print("[TELEPORTER] Teleporting player to GM Island")
        end
    end
    
    player:GossipComplete()
end

-- Register the gossip events
RegisterCreatureGossipEvent(NPC_ID, 1, OnGossipHello)
RegisterCreatureGossipEvent(NPC_ID, 2, OnGossipSelect)
print (" ")
print("[TELEPORTER] > City Teleporter NPC loaded.")
