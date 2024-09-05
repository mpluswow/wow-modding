###GuildWars System SQL Script

This SQL script sets up the necessary structure for a guild-based leveling system in the game. It allows guild members to complete tasks to earn XP and level up their guild. As guilds progress, they unlock rewards such as gold and items. The script creates tables for storing guild levels, tasks, and the XP required for leveling.

###1. Database Creation
The script begins by creating a database named `dreamforge`:

```sql
CREATE DATABASE IF NOT EXISTS dreamforge;
```
This ensures the database is created if it does not already exist.
```sql
USE dreamforge;
```
This command selects the dreamforge database so that all subsequent operations are performed within it.

2. Table Definitions
a. `guildwars_level_bracket`
This table defines the guild leveling system. Each row represents a guild level and contains the following fields:

`level`: The level number of the guild (e.g., 1, 2, 3, etc.).
`xp_required`: The total XP required to reach this level from the previous level.
`reward`: A textual description of the reward for reaching this level.
`gold_amount`: The amount of gold given to the guild upon reaching the level.
`item_id`: An optional ID of an item rewarded to the guild upon reaching this level. If no item is rewarded, this field is set to NULL.

b. `guildwars_task`
This table contains templates for tasks that guild members can complete to earn XP. Each task has the following fields:

`task_id`: A unique identifier for the task.
`task_name`: The name of the task (e.g., 'Kill Creature', 'Collect Rare Item').
`task_description`: A description of the task (e.g., 'Kill any creature to earn guild XP').
`xp_amount`: The amount of XP awarded for completing the task.

c. `guildwars_level`
This table tracks each guild’s progress by storing the guild’s current level and XP:

`guild_id`: A unique identifier for each guild.
`guild_level`: The current level of the guild (default is level 1).
`current_xp`: The current amount of XP that the guild has accumulated.

###3. Data Insertion

a. `guildwars_level_bracket`

The script inserts predefined guild levels (from level 1 to level 15), each with its own XP requirement, reward, gold, and item rewards. For example:

`Level 1 requires 1,000 XP and rewards 100 gold.`
`Level 3 requires 5,000 XP and rewards 300 gold and an item with item_id 12345.`

b. `guildwars_task`

The script also inserts a set of general task templates, such as:

`Kill Creature`: Rewards `50 XP` for killing any Creature.
`Collect Rare Item`: Rewards `80 XP` for collecting any Rare Item.
`Complete Dungeon`: Rewards `150 XP` for completing any Dungeon.

###4. Adjustments for XP Scaling

The XP rewards are kept at lower values to ensure that guilds do not level up too quickly, encouraging a gradual progression system. For example, 
killing any creature awards only `50 XP`, ensuring that it takes more time and effort to reach higher guild levels.

