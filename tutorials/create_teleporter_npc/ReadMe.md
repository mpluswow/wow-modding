# AzerothCore Teleporter NPC with Custom Gossip Menu

This guide provides step-by-step instructions on how to create a Teleporter NPC in AzerothCore that offers teleportation options to the main cities 
for both Alliance and Horde players using Lua scripting with Eluna.

## What You Will Need

- [mod-eluna](https://github.com/azerothcore/mod-eluna).
- A text editor for writing Lua scripts (e.g., Visual Studio Code, Notepad++).
- Basic knowledge of Lua scripting and SQL.

## Step 1: Creating the NPC in the Database

Before scripting the NPC, you must create the NPC and its model in your database.

### 1.1 Insert the NPC's Model into the `creature_model_info` Table

First, define the model for the NPC in the `creature_model_info` table:

```sql
INSERT INTO `creature_template_model` (
    `CreatureID`,
    `CreatureDisplayID`,
    `DisplayScale`,
    `Probability`,
    `VerifiedBuild`
) VALUES (
    600000,         -- CreatureID from `creature_template`
    28089,         -- Model ID 
    1.0,           -- Scale
    1.0,           -- Probability (always use this model)
    NULL           -- Verified build (optional)
);

```
### 1.2 Insert the NPC into the creature_template Table
Next, create the NPC in the creature_template table:

```sql
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
```
### Step 2: Writing the Lua Script
Next, you need to write the Lua script that will handle the teleportation logic for your NPC.

### 2.1 Create the Lua Script File
Create a new Lua script file named city_teleporter.lua in your Eluna scripts directory (e.g., lua_scripts/custom/).

### 2.2 Write the Lua Script
Insert the following Lua script into city_teleporter.lua:

```lua
local NPC_ID = 600000  -- NPC entry ID

-- Function to display the gossip menu
function OnGossipHello(event, player, creature)
    player:GossipClearMenu()  -- Clear any existing menu
    
    if player:IsAlliance() then
        player:GossipMenuAddItem(2, "|TInterface\\Icons\\inv_misc_rune_01:30|t Teleport to Stormwind", 1, 1)  -- Icon for Stormwind
        player:GossipMenuAddItem(2, "|TInterface\\Icons\\achievement_boss_ragnaros:30|t Teleport to Ironforge", 1, 2)  -- Icon for Ironforge
        player:GossipMenuAddItem(2, "|TInterface\\Icons\\inv_misc_rune_07:30|t Teleport to Darnassus", 1, 3)  -- Icon for Darnassus
        player:GossipMenuAddItem(2, "|TInterface\\Icons\\inv_misc_rune_10:30|t Teleport to The Exodar", 1, 4)  -- Icon for Exodar
    elseif player:IsHorde() then
        player:GossipMenuAddItem(2, "|TInterface\\Icons\\inv_misc_rune_05:30|t Teleport to Orgrimmar", 1, 5)  -- Icon for Orgrimmar
        player:GossipMenuAddItem(2, "|TInterface\\Icons\\inv_misc_rune_06:30|t Teleport to Thunder Bluff", 1, 6)  -- Icon for Thunder Bluff
        player:GossipMenuAddItem(2, "|TInterface\\Icons\\inv_misc_rune_09:30|t Teleport to Undercity", 1, 7)  -- Icon for Undercity
        player:GossipMenuAddItem(2, "|TInterface\\Icons\\inv_misc_rune_11:30|t Teleport to Silvermoon City", 1, 8)  -- Icon for Silvermoon
    end
    
    -- Add GM Island teleport for Game Masters only
    if player:IsGM() then
        player:GossipMenuAddItem(4, "|TInterface\\Icons\\achievement_guildperk_hastyhearth:30|t Teleport to GM Island", 1, 9)  -- Icon for GM Island
    end
    
    player:GossipSendMenu(1, creature, 1)
end

-- Function to handle player selection
function OnGossipSelect(event, player, creature, sender, intid, code)
    player:GossipClearMenu()
    
    if intid == 1 then  -- Stormwind
        player:Teleport(0, -8833.38, 628.62, 94.00, 3.61)
    elseif intid == 2 then  -- Ironforge
        player:Teleport(0, -4981.25, -881.542, 502.66, 5.41)
    elseif intid == 3 then  -- Darnassus
        player:Teleport(1, 9951.52, 2280.32, 1341.39, 1.59)
    elseif intid == 4 then  -- The Exodar
        player:Teleport(530, -3987.29, -11846.6, -2.01903, 0.63)
    elseif intid == 5 then  -- Orgrimmar
        player:Teleport(1, 1676.21, -4315.29, 61.52, 2.83)
    elseif intid == 6 then  -- Thunder Bluff
        player:Teleport(1, -1274.45, 71.8601, 128.16, 2.90)
    elseif intid == 7 then  -- Undercity
        player:Teleport(0, 1586.48, 239.562, -52.149, 0.05)
    elseif intid == 8 then  -- Silvermoon City
        player:Teleport(530, 9473.03, -7279.67, 14.29, 6.26)
    elseif intid == 9 then  -- GM Island (GM only)
        player:Teleport(1, 16222.1, 16252.1, 12.5, 1.6)  -- GM Island coordinates
    end
    
    player:GossipComplete()
end

-- Register the gossip events
RegisterCreatureGossipEvent(NPC_ID, 1, OnGossipHello)
RegisterCreatureGossipEvent(NPC_ID, 2, OnGossipSelect)

```
### Step 3: Loading the Script into AzerothCore
Save the Lua script to your Eluna scripts directory 
(e.g., lua_scripts/custom/city_teleporter.lua).

Restart your AzerothCore server to load the new script / .reload eluna.

### Step 4: Testing Your Teleporter NPC
Log into your server and spawn the NPC you created.


### Congratulations! 
You have successfully created a Teleporter NPC in AzerothCore that allows players to teleport to their faction's main cities using a custom Lua script. 
This guide can be expanded upon to include more features or additional teleportation locations as needed.
