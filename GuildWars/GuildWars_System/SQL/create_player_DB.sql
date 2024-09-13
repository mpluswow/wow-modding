-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS acore_guildwars;
USE acore_guildwars;

-- Table to store individual player progress
CREATE TABLE IF NOT EXISTS player_level (
    guid INT UNSIGNED NOT NULL,                 -- Player's unique GUID
    player_name VARCHAR(255) NOT NULL,          -- Player's name
    player_level INT UNSIGNED DEFAULT 1,        -- Player's current level
    experience INT UNSIGNED DEFAULT 0,          -- Current XP
    next_level INT UNSIGNED NOT NULL,           -- XP required for the next level
    last_reset DATETIME DEFAULT NULL,           -- Timestamp of the last reset
    next_reset DATETIME DEFAULT NULL,           -- Timestamp for the next scheduled reset
    PRIMARY KEY (guid),
    UNIQUE (player_name)
);

-- Table to track claimed rewards for each level to avoid multiple claims
CREATE TABLE IF NOT EXISTS player_claimed_rewards (
    guid INT UNSIGNED NOT NULL,                 -- Player's unique GUID
    player_name VARCHAR(255) NOT NULL,          -- Player's name
    lvl_1 BOOLEAN DEFAULT FALSE,                -- Reward claimed for level 1
    lvl_2 BOOLEAN DEFAULT FALSE,                -- Reward claimed for level 2
    lvl_3 BOOLEAN DEFAULT FALSE,                -- Reward claimed for level 3
    lvl_4 BOOLEAN DEFAULT FALSE,                -- Reward claimed for level 4
    lvl_5 BOOLEAN DEFAULT FALSE,                -- Reward claimed for level 5
    lvl_6 BOOLEAN DEFAULT FALSE,                -- Reward claimed for level 6
    lvl_7 BOOLEAN DEFAULT FALSE,                -- Reward claimed for level 7
    lvl_8 BOOLEAN DEFAULT FALSE,                -- Reward claimed for level 8
    lvl_9 BOOLEAN DEFAULT FALSE,                -- Reward claimed for level 9
    lvl_10 BOOLEAN DEFAULT FALSE,               -- Reward claimed for level 10
    lvl_11 BOOLEAN DEFAULT FALSE,               -- Reward claimed for level 11
    lvl_12 BOOLEAN DEFAULT FALSE,               -- Reward claimed for level 12
    lvl_13 BOOLEAN DEFAULT FALSE,               -- Reward claimed for level 13
    lvl_14 BOOLEAN DEFAULT FALSE,               -- Reward claimed for level 14
    lvl_15 BOOLEAN DEFAULT FALSE,               -- Reward claimed for level 15
    PRIMARY KEY (guid),
    UNIQUE (player_name)
);

-- Table to store level brackets from 1 to 15, including XP ranges and rewards
CREATE TABLE IF NOT EXISTS player_level_brackets (
    level INT UNSIGNED NOT NULL,               -- Level number (1-15)
    min_xp INT UNSIGNED NOT NULL,              -- Minimum XP required for this level
    max_xp INT UNSIGNED NOT NULL,              -- Maximum XP required for this level
    title_reward VARCHAR(255),                 -- Title or reward given at this level
    PRIMARY KEY (level)
);

-- Insert level bracket data
INSERT INTO player_level_brackets (level, min_xp, max_xp, title_reward) VALUES
(1, 0, 999, 'Novice'),
(2, 1000, 2999, 'Apprentice'),
(3, 3000, 5999, 'Journeyman'),
(4, 6000, 9999, 'Adventurer'),
(5, 10000, 14999, 'Warrior'),
(6, 15000, 20999, 'Champion'),
(7, 21000, 27999, 'Hero'),
(8, 28000, 35999, 'Veteran'),
(9, 36000, 44999, 'Elite'),
(10, 45000, 54999, 'Master'),
(11, 55000, 65999, 'Grandmaster'),
(12, 66000, 77999, 'Legendary'),
(13, 78000, 90999, 'Mythic'),
(14, 91000, 104999, 'Eternal'),
(15, 105000, 119999, 'Immortal');
