## Auto-Teleport & Level-Up 

This Eluna Lua script is designed for **AzerothCore 3.3.5a** and automatically handles new player onboarding. 
It levels up new characters, teleports them to Dalaran, and rewards them with gold.

---

## What It Does

When a player logs in **for the first time** (less than 60 seconds of total playtime):

1. Characters are **automatically leveled** to **70**  
2. Characters are **teleported** to a defined location, default Dalaran. 
3. Characters **receive 2500 gold** (value in copper).  

---

## Configuration

You can change the following values at the top of the script:

```lua
local TELEPORT_MAP = 571       -- Destination map ID (Northrend)
local TELEPORT_X = 5940.51     -- X coordinate
local TELEPORT_Y = 623.757     -- Y coordinate
local TELEPORT_Z = 650.654     -- Z coordinate
local TELEPORT_O = 2.73016     -- Orientation
local TARGET_LEVEL = 70        -- Level to set the player to
local REWARD_GOLD = 250000     -- Amount of gold (in copper)
```
