# AzerothCore Eluna Script Collection

This repository contains a collection of Eluna Lua scripts made for AzerothCore (World of Warcraft 3.3.5a).
Each folder includes a standalone module that can be placed into your lua_scripts directory.
Some scripts may include DBC or SQL changes, so be sure to check the included readme in each folder for setup details.
These scripts are built to help customize gameplay, streamline server features, and add new systems to enhance the experience.


## Script Index

### **AccountCreationBoost**
Automatically boosts new accounts upon creation—could include level, gold, gear, or teleport rewards.

### **DiscordAuctionBOT**
Integrates in-game auction data or items with a Discord bot. Likely designed to sync item posts or player bids through Discord.

### **GuildWars**
Introduces a zone control system for guilds, allowing PvP-driven territory capture, reputation rewards, and competition mechanics.

### **RecruitFriend**
Implements a Recruit-a-Friend system, possibly including XP boosts, summon commands, or time-based rewards for playing together.

### **RestZoneSpeed**
Enhances XP gains in rest zones or inns, possibly speeding up level progression or modifying rested XP mechanics.

### **TeleporterNPC**
Adds a customizable teleportation NPC to allow fast travel between key locations, ideal for funservers or leveling realms.

### **Treasure Goblin**
Spawns a treasure goblin NPC that drops loot or gold upon defeat—great for events or rare map encounters.


## Requirements

- Build AzerothCore with mod-eluna



## Notes

- You can install these scripts individually or all together.
- Some scripts may require specific database or DBC entries (e.g., NPCs or GOs).



## How to Use

1. Copy the desired folder(s) into `.../azerothcore-wotlk/lua_scripts/`
2. Reload Eluna with **.reload eluna** command
3. Verify in-game functionality and logs



