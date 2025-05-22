-- Current ownership + cooldown
CREATE TABLE IF NOT EXISTS guildwars_captured_zone (
    zone_id INT PRIMARY KEY,
    map_id INT NOT NULL,  
    guild_id INT NOT NULL,
    captured_at DATETIME NOT NULL DEFAULT NOW(),
    last_guild_id INT DEFAULT NULL
);

-- Capture history log
CREATE TABLE IF NOT EXISTS guildwars_capture_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    zone_id INT NOT NULL,
    map_id INT NOT NULL,  
    guild_id INT NOT NULL,
    captured_at DATETIME NOT NULL,
    player_name VARCHAR(64)
);