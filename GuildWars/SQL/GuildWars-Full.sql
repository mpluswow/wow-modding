-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.39 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for acore_guildwars
CREATE DATABASE IF NOT EXISTS `acore_guildwars` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `acore_guildwars`;

-- Dumping structure for table acore_guildwars.player_claimed_rewards
CREATE TABLE IF NOT EXISTS `player_claimed_rewards` (
  `guid` int unsigned NOT NULL,
  `player_name` varchar(255) NOT NULL,
  `lvl_1` tinyint(1) DEFAULT '0',
  `lvl_2` tinyint(1) DEFAULT '0',
  `lvl_3` tinyint(1) DEFAULT '0',
  `lvl_4` tinyint(1) DEFAULT '0',
  `lvl_5` tinyint(1) DEFAULT '0',
  `lvl_6` tinyint(1) DEFAULT '0',
  `lvl_7` tinyint(1) DEFAULT '0',
  `lvl_8` tinyint(1) DEFAULT '0',
  `lvl_9` tinyint(1) DEFAULT '0',
  `lvl_10` tinyint(1) DEFAULT '0',
  `lvl_11` tinyint(1) DEFAULT '0',
  `lvl_12` tinyint(1) DEFAULT '0',
  `lvl_13` tinyint(1) DEFAULT '0',
  `lvl_14` tinyint(1) DEFAULT '0',
  `lvl_15` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`guid`),
  UNIQUE KEY `player_name` (`player_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table acore_guildwars.player_claimed_rewards: ~0 rows (approximately)

-- Dumping structure for table acore_guildwars.player_level
CREATE TABLE IF NOT EXISTS `player_level` (
  `guid` int unsigned NOT NULL,
  `player_name` varchar(255) NOT NULL,
  `player_level` int unsigned DEFAULT '1',
  `experience` int unsigned DEFAULT '0',
  `creature_kills` int unsigned DEFAULT '0',
  `player_kills` int unsigned DEFAULT '0',
  `next_level` int unsigned NOT NULL,
  `last_reset` datetime DEFAULT NULL,
  `next_reset` datetime DEFAULT NULL,
  PRIMARY KEY (`guid`),
  UNIQUE KEY `player_name` (`player_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table acore_guildwars.player_level: ~0 rows (approximately)

-- Dumping structure for table acore_guildwars.player_level_brackets
CREATE TABLE IF NOT EXISTS `player_level_brackets` (
  `level` int unsigned NOT NULL,
  `min_xp` int unsigned NOT NULL,
  `max_xp` int unsigned NOT NULL,
  `title_reward` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table acore_guildwars.player_level_brackets: ~15 rows (approximately)
INSERT INTO `player_level_brackets` (`level`, `min_xp`, `max_xp`, `title_reward`) VALUES
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

-- Dumping structure for table acore_guildwars.player_reward_brackets
CREATE TABLE IF NOT EXISTS `player_reward_brackets` (
  `level` int NOT NULL,
  `gold` int NOT NULL DEFAULT '0',
  `title_id` int DEFAULT NULL,
  `item_id1` int DEFAULT NULL,
  `item_id2` int DEFAULT NULL,
  `item_id3` int DEFAULT NULL,
  `item_id4` int DEFAULT NULL,
  `stat_1` int DEFAULT '0',
  `stat_2` int DEFAULT '0',
  `stat_3` int DEFAULT '0',
  `stat_4` int DEFAULT '0',
  PRIMARY KEY (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table acore_guildwars.player_reward_brackets: ~15 rows (approximately)
INSERT INTO `player_reward_brackets` (`level`, `gold`, `title_id`, `item_id1`, `item_id2`, `item_id3`, `item_id4`, `stat_1`, `stat_2`, `stat_3`, `stat_4`) VALUES
	(1, 10, 0, 101, 102, NULL, NULL, 1, 0, 0, 0),
	(2, 20, 0, 103, NULL, NULL, NULL, 1, 1, 0, 0),
	(3, 30, 2, 12345, NULL, NULL, NULL, 1, 1, 1, 0),
	(4, 40, 3, 12346, NULL, NULL, NULL, 1, 1, 1, 1),
	(5, 50, 3, 12347, 12348, NULL, NULL, 2, 1, 1, 1),
	(6, 60, 2, 12349, 12350, NULL, NULL, 2, 2, 1, 1),
	(7, 70, 1, 12351, 12352, NULL, NULL, 2, 2, 2, 1),
	(8, 80, 1, 12353, 12354, 12355, NULL, 2, 2, 2, 2),
	(9, 90, 2, 12356, 12357, 12358, NULL, 3, 2, 2, 2),
	(10, 100, 2, 12359, 12360, 12361, NULL, 3, 3, 2, 2),
	(11, 110, 3, 12362, 12363, 12364, 12365, 3, 3, 3, 2),
	(12, 120, 3, 12366, 12367, 12368, 12369, 3, 3, 3, 3),
	(13, 130, 4, 12370, 12371, 12372, 12373, 4, 3, 3, 3),
	(14, 140, 4, 12374, 12375, 12376, 12377, 4, 4, 3, 3),
	(15, 150, 5, 12378, 12379, 12380, 12381, 4, 4, 4, 4);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
