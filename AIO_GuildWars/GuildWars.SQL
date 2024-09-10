CREATE DATABASE IF NOT EXISTS `acore_guildwars` 
USE `acore_guildwars`;


CREATE TABLE IF NOT EXISTS `player_solo_ranking` (
  `guid` bigint unsigned NOT NULL,
  `player_name` varchar(255) DEFAULT NULL,
  `guild_id` bigint unsigned NOT NULL,
  `guild_name` varchar(50) NOT NULL,
  `player_kills` int unsigned DEFAULT '0',
  `creature_kills` int unsigned DEFAULT '0',
  `last_reset` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `next_reset` timestamp NOT NULL,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

