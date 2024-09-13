Registering a new player in the player_level and player_claimed_rewards tables.
Resetting player data after a 30-day period.
Debugging support with messages that help trace the script's functionality.

How It Works:

### 1. Checking and Registering a Player:
When a player logs in, the script first checks if the player exists in the 
'player_level' table by querying the database using the player's 'guid'.

### If the player does not exist:

Register the player in the player_level table with default values:

- 'player_level' set to 1.
- 'experience' set to 0.
- 'next_level' fetched from the 'player_level_brackets' table.
- The current time is recorded as 'last_reset'.
- The 'next_reset' is set to 30 days from the current time.

Registers the player in the 'player_claimed_rewards' table, 
where fields 'lvl_1' to 'lvl_15' are set to '0' (indicating that no rewards have been claimed).


### 2. Resetting Player Data After 30 Days:

The script handle statistic reset, checks if 30 days have passed since the player's last_reset.
If the current time is greater than or equal to next_reset, the player's data is reset:

- 'player_level' is reset to 1.
- 'experience' is reset to 0.
- 'next_level' is fetched from the 'player_level_brackets' table.

The player's 'last_reset' is updated to the current time, and 'next_reset' is set to 30 days later,
claimed rewards in the 'player_claimed_rewards' table are also reset by setting 'lvl_1' to 'lvl_15' back to '0'.


### 3. Debugging Support:

The script includes a debugging feature that prints information to the server console to help trace the script's actions.
The debug flag can be set to 'true' or 'false' at the top of the script.
