# Recruit-A-Friend System (Eluna Lua for AzerothCore)

This Lua script adds a full **Recruit-A-Friend system** to your AzerothCore server (3.3.5a).  
It allows players to recruit other players, earn bonus XP together, 
and even **summon each other** in-game—just like Blizzard's old RAF system.

---

## ✨ Features

- `/recruitfriend <player>` — Link a player as your recruit
- `/summonfriend <player>` — Teleport your recruit to your location
- Bonus XP — When leveling together within range (50 yards), both recruiter and recruit earn **50% extra XP**
- Data is saved in a database table, so the system is persistent

---


## Database Setup

Create the required table in your **`acore_characters`** database:

```sql
CREATE TABLE recruitfriend (
  id INT AUTO_INCREMENT PRIMARY KEY,
  recruiter_guid INT UNSIGNED NOT NULL,
  recruit_guid INT UNSIGNED NOT NULL
);
