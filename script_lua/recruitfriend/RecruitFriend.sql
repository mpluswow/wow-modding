-- Create the 'dreamforge' database
CREATE DATABASE IF NOT EXISTS dreamforge;

-- Use the 'dreamforge' database
USE dreamforge;

-- Create the 'recruitfriend' table
CREATE TABLE IF NOT EXISTS recruitfriend (
    id INT AUTO_INCREMENT PRIMARY KEY,   -- Unique ID for each entry
    recruiter_guid BIGINT UNSIGNED NOT NULL,   -- Recruiter's GUID (Global Unique Identifier)
    recruit_guid BIGINT UNSIGNED NOT NULL,     -- Recruit's GUID (Global Unique Identifier)
    recruit_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date when recruit was made
    INDEX (recruiter_guid),  -- Index to speed up lookups for recruiter
    INDEX (recruit_guid)     -- Index to speed up lookups for recruit
);

