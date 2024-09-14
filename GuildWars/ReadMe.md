### How to install:

- AIO_Server => AzerothCore\bin\RelWithDebInfo\lua_scripts

- WoW 3.3.5a Client => AddOns\Interface\AIO_Client

- All other files => AzerothCore\bin\RelWithDebInfo\lua_scripts

## First Login
Ignore this ERROR at first Player login.

Player was not registered before so theres no next_reset date set at innitial check.
After a relog it works as intended as player is now registered.

```
[REWARD-CHECK] Error: Player level not found for player Dex
[REGISTRATION] Checking if player Dex (GUID: 10) exists in the database...
[REGISTRATION] Player not found in player_level table. Registering player...
[REGISTRATION] Next level XP for level 1: 999
[REGISTRATION] Player Dex successfully registered in player_level.
[REGISTRATION] Registering player Dex in player_claimed_rewards table...
[REGISTRATION] Player Dex successfully registered in player_claimed_rewards.
[REGISTRATION] Checking if player Dex needs a reset...
[REGISTRATION] Error: Could not retrieve next_reset for player Dex.
[LEVEL-UP] Checking if player Dex (GUID: 10) can level up...
```
