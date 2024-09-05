-- Create the 'dreamforge' database if it doesn't already exist
CREATE DATABASE IF NOT EXISTS dreamforge;

-- Switch to using the 'dreamforge' database
USE dreamforge;

-- Create a table to store guild level brackets and their associated rewards
CREATE TABLE IF NOT EXISTS guildwars_level_bracket (
    level INT PRIMARY KEY,               -- The level of the guild (e.g., 1 to 15)
    xp_required INT NOT NULL,            -- The amount of XP required to reach this level
    reward VARCHAR(255) NOT NULL,        -- The reward given to the guild upon reaching this level
    gold_amount INT NOT NULL DEFAULT 0,  -- The amount of gold awarded to the guild when reaching this level
    item_id INT DEFAULT NULL             -- The ID of an optional item that is awarded when reaching this level
);

-- Create a table to store task templates
CREATE TABLE IF NOT EXISTS guildwars_task (
    task_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each task
    task_name VARCHAR(255) NOT NULL,         -- Name of the task (e.g., 'Kill Creature')
    task_description TEXT NOT NULL,          -- Description of the task (e.g., 'Kill any creature to earn XP')
    xp_amount INT NOT NULL                   -- The amount of XP rewarded for completing the task
);

-- Create a table to store each guild's current level and XP progress
CREATE TABLE IF NOT EXISTS guildwars_level (
    guild_id INT PRIMARY KEY,                -- Unique identifier for each guild
    guild_level INT NOT NULL DEFAULT 1,       -- The current level of the guild (starts at level 1)
    current_xp INT NOT NULL DEFAULT 0         -- The current XP of the guild (starts at 0)
);

-- Insert the guild level brackets, the XP required, and the rewards for each level
INSERT INTO guildwars_level_bracket (level, xp_required, reward, gold_amount, item_id)
VALUES 
(1, 1000, 'Small Bonus', 100, NULL),       -- Reaching level 1 requires 1000 XP, rewards 100 gold, no item
(2, 2500, 'Minor Bonus', 200, NULL),       -- Reaching level 2 requires 2500 XP, rewards 200 gold, no item
(3, 5000, 'Moderate Bonus', 300, 12345),   -- Reaching level 3 requires 5000 XP, rewards 300 gold, item with ID 12345
(4, 10000, 'Improved Bonus', 400, NULL),   -- Reaching level 4 requires 10000 XP, rewards 400 gold, no item
(5, 15000, 'Advanced Bonus', 500, NULL),   -- Reaching level 5 requires 15000 XP, rewards 500 gold, no item
(6, 20000, 'Powerful Bonus', 600, 54321),  -- Reaching level 6 requires 20000 XP, rewards 600 gold, item with ID 54321
(7, 30000, 'Superior Bonus', 700, NULL),   -- Reaching level 7 requires 30000 XP, rewards 700 gold, no item
(8, 45000, 'Greater Bonus', 800, NULL),    -- Reaching level 8 requires 45000 XP, rewards 800 gold, no item
(9, 60000, 'Epic Bonus', 900, NULL),       -- Reaching level 9 requires 60000 XP, rewards 900 gold, no item
(10, 80000, 'Legendary Bonus', 1000, 67890), -- Reaching level 10 requires 80000 XP, rewards 1000 gold, item with ID 67890
(11, 100000, 'Master Bonus', 1100, NULL),  -- Reaching level 11 requires 100000 XP, rewards 1100 gold, no item
(12, 125000, 'Grandmaster Bonus', 1200, NULL), -- Reaching level 12 requires 125000 XP, rewards 1200 gold, no item
(13, 150000, 'Elite Bonus', 1300, 98765),  -- Reaching level 13 requires 150000 XP, rewards 1300 gold, item with ID 98765
(14, 180000, 'Supreme Bonus', 1400, NULL), -- Reaching level 14 requires 180000 XP, rewards 1400 gold, no item
(15, 210000, 'Ultimate Bonus', 1500, NULL);-- Reaching level 15 requires 210000 XP, rewards 1500 gold, no item

-- Insert general tasks for earning XP in the guild system
INSERT INTO guildwars_task (task_name, task_description, xp_amount)
VALUES 
('Kill Creature', 'Kill any creature to earn guild XP', 50),    -- Killing any creature earns 50 XP
('Kill Elite Creature', 'Kill any elite creature to earn guild XP', 100), -- Killing an elite creature earns 100 XP
('Collect Item', 'Collect any item to earn guild XP', 30),      -- Collecting any item earns 30 XP
('Collect Rare Item', 'Collect any rare item to earn guild XP', 80), -- Collecting a rare item earns 80 XP
('Complete Dungeon', 'Complete any dungeon run to earn guild XP', 150); -- Completing any dungeon earns 150 XP
