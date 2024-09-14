INSERT INTO creature_template (
    entry,                    -- Unique ID for the NPC
    name,                     -- Name of the NPC
    subname,                  -- Subname (optional)
    gossip_menu_id,           -- Gossip menu ID (0 if not using a pre-defined menu)
    minlevel,                 -- Minimum level of the NPC
    maxlevel,                 -- Maximum level of the NPC
    faction,                  -- Faction ID to determine NPC's hostility
    npcflag,                  -- Flags to enable the gossip menu
    speed_walk,               -- Walk speed
    speed_run,                -- Run speed
    scale,                    -- Size scale of the NPC
    `rank`,                     -- Rank of the NPC (0 = Normal, 1 = Elite, etc.)
    AIName,                   -- AI script (leave blank if not using)
    ScriptName                -- Script name for Eluna script
) VALUES (
    60000,                    -- Replace 60000 with the NPC's entry ID if you used a different ID.
    'City Teleporter',        -- Name of the NPC
    'Choose your destination',-- Subname of the NPC
    0,                        -- Gossip menu ID (0 for custom Lua menu)
    80,                       -- Min level (80 for a max-level NPC)
    80,                       -- Max level (same as min level)
    35,                       -- Faction (35 = Friendly to players)
    1,                        -- NPCFlag (1 = Gossip)
    1.0,                      -- Walk speed
    1.14286,                  -- Run speed
    1.0,                      -- Scale
    0,                        -- Rank (0 = Normal)
    '',                       -- AIName (leave blank)
    ''     -- ScriptName (match with your Lua script name)
);