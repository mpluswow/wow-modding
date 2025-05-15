
# GuildWars Module for AzerothCore

The **GuildWars** module introduces a zone control system that allows **guilds** to capture in-game zones by interacting with special GameObjects. Once a guild controls a zone, its members receive experience bonuses, gold rewards, and reputation gains. This system encourages active PvP competition and guild cooperation.

Future updates will include custom PvE content such as boss and elite creature encounters tied to zone control.

---

## Features

- Zone capturing through in-game GameObject interaction
- Captures restricted to players with a guild
- Cooldown period after zone capture to prevent immediate recapture
- Ownership data stored in the `guildwars_captured_zone` table
- Full capture logging in the `guildwars_capture_history` table
- Reputation gain (+10) with custom faction ID `1165` for successful captures
- XP bonuses for guild members in zones their guild controls (per-zone configurable)
- Gold rewards when killing creatures in controlled zones (scales with creature level, per-zone configurable)
- Future PvE expansions: custom bosses and elite spawns in contested zones

---

## Installation

1. **SQL Setup**
   - Import both SQL files into your AzerothCore world database.

2. **Server Files**
   - Place the `GuildWars` folder into your server’s `lua_scripts` directory:
     ```
     your-server/src/server/scripts/lua_scripts/
     ```

3. **DBC Files**
   - Place the provided DBC files into the following directory:
     ```
     AzerothCore/data/dbc/
     ```

4. **Client Patch**
   - Copy `patch-Z.MPQ` to your WoW client's data directory:
     ```
     World of Warcraft/Data/
     ```

---

## Adding a New Zone

1. Use the `.zone` command in-game to get the following:
   - MapID
   - ZoneID
   - AreaID

2. Spawn the capture crystal GameObject:
   ```bash
   .gobject add 600001
   ```


3. Register the new zone in the `GuildWars_Config.lua` file using the captured zone identifiers.

---

## Gameplay Mechanics

* Players must be in a **guild** to interact with capture objects.
* Zones enter a **cooldown period** after being captured before they can be taken again.
* **Experience bonuses** apply to guild members in zones their guild controls. The bonus percentage is set in the config file.
* **Gold bonuses** for killing creatures in controlled zones scale with the creature's level and are defined in the config file.
* Successful captures reward +10 reputation with faction ID `1165`.

---

## Database Tables Used

* `guildwars_captured_zone`: Stores current zone ownership information.
* `guildwars_capture_history`: Logs all capture events for auditing and history.

---

## Compatibility

This module is designed for:

* AzerothCore 3.3.5a
* Eluna Lua Engine

It may require adaptation for other cores or older revisions.

---

## Contributing

Feel free to fork, enhance, and submit pull requests. All improvements and PvE feature additions are welcome.

```

Let me know if you want me to add a sample config block or include code snippets from the Lua file for context.
```
