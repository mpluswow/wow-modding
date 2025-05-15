This module introduces zone control, where Guilds can capture zones by interacting with GameObjects to receive bonuses and rewards.
It enhances guild competition and encourages active PvP gameplay.

In the future, it will include custom Boss/Elite creatures for PvE gameplay.

Installation:
-Import both SQL files into your database.
-Place the GuildWars folder into the AzerothCore/lua_scripts directory.
-Place the DBC files into the AzerothCore/data/dbc directory.
-Place the patch-Z.MPQ file into the World of Warcraft/data directory.

Adding a New Zone:
-Use the .zone command to get the MapID, ZoneID, and AreaID.
-Spawn the crystal using: .gobject add 600001
-Add the new zone to GuildWars_Config.lua:


-Players can capture zones for their guild by interacting with a GameObject.
-Capturing a zone requires guild membership.
-Zones enter a cooldown period after being captured.
-Ownership is stored in the guildwars_captured_zone table.
-All captures are logged in the guildwars_capture_history table.

Guild Reputation
Capturing a zone grants +10 reputation with a custom faction (ID 1165) to the capturing player.

XP Bonuses
Guild members receive an XP bonus in zones controlled by their guild.
The bonus percentage is defined per zone in the configuration file.

Gold Rewards
Killing creatures in a controlled zone grants bonus gold (scales with creature level).
The bonus percentage is configurable per zone in the configuration file.
