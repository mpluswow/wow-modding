# WoW Transport Setup Guide

This guide provides step-by-step instructions on how to set up and modify transports in World of Warcraft. 
Transports in WoW are special game objects that move along predefined paths, enabling player movement across different locations. 
These transports, such as ships and zeppelins, are integral for water and air travel in the game.

## What Are Transports in WoW?

Transports in WoW are special game objects that move along predefined paths specified in the DBC files. 
These transports allow players to move with them until they disembark. 
There are about 20 blizzlike transports in a typical WoW server setup, primarily used for water and air travel. 
Ground transport is less common due to system limitations. 
When using AzerothCore, we can add one using the database instead.

## What You Will Need

To set up or modify transports, you will need:

- A MySQL database editor.
- The following SQL-DBC tables:
  - `taxinodes_dbc`
  - `taxipath_dbc`
  - `taxipathnode_dbc`

## Working with `taxinodes_dbc`

The `taxinodes_dbc` table defines the destinations, like docks, but not the actual paths that transports will follow. 
The coordinates (X, Y, Z) define the location, and the name is for reference. 
The last two columns, which specify the entry of the creature used as the mount for the taxi path, are not relevant for transports and can be left empty.

## Defining Paths with `taxipath_dbc`

The `taxipath_dbc` table connects two TaxiNodes. 
To define a path:

- Create a new row with the entries of the two nodes you want to connect.
- The last column specifies the price for the taxi ride, but this value doesn’t affect transports.
- Although each TaxiPath connects only two TaxiNodes, your transport can stop at multiple points along the path.

## Setting Waypoints with `taxipathnode_dbc`

The `taxipathnode_dbc` table is where you define the path the transport will follow. This includes:
- Entering the ID of the TaxiPath.
- The coordinates (X, Y, Z) for each waypoint.
- Assigning a unique point ID for each waypoint to avoid client or server crashes.
- Optionally specifying that a transport stops at a waypoint for a set duration by entering values in columns 8 and 9 (e.g., 10 seconds).

## Tips for Creating Transport Paths

- Each TaxiPath needs at least three waypoints to avoid crashes.
- Keep waypoint distances even to prevent buggy results and avoid sharp turns.
- Mark waypoints you've entered using a game object or NPC to keep track of them.
- Be precise when entering coordinates; a single typo can lead to significant issues.
- Ground transports are challenging because they often "fly" above or "sink" below the terrain between waypoints.
- Players on transports ignore world collisions, which can be both a feature and a drawback depending on your design.

## Creating the Game Object (`acore_world.gameobject_template`)

You need to create the game object that will be used as the transport.

- **Entry**: Unique identifier.
- **Type**: Set this to 15 (11 is for elevators, which use a different system).
- **DisplayID**: Choose based on the model you want; it must have collisions.
- **Flags**: Most transports use a value of 40.
- **data0**: ID of your TaxiPath.
- **data1**: Speed, with 30 being the most common value.
- **data2**: Acceleration modifier, usually set to 1.
- **Other fields**: Most other fields can be left as default, but feel free to experiment.

## Adding the Transport (`acore_world.transports`)

Finally, add your transport to the `acore_world.transports` table. 
Create a new row with a unique GUID, enter the entry of your transport game object, and give it a name for reference. 
Once added, the transport should be operational, though fine-tuning might be necessary to ensure smooth operation.

## Example SQL
```sql
-- Insert a new taxi node into taxinodes_dbc
INSERT INTO taxinodes_dbc (
    ID,                   -- Unique ID for the taxi node
    ContinentID,          -- ID of the map where the taxi node is located (0 = Eastern Kingdoms)
    X,                    -- X coordinate of the taxi node
    Y,                    -- Y coordinate of the taxi node
    Z,                    -- Z coordinate of the taxi node
    Name_Lang_enUS,       -- Name of the taxi node in English (US)
    Name_Lang_enGB,       -- Name of the taxi node in English (GB)
    MountCreatureID_1,    -- ID of the creature used for ground mounts (set to 0 for ships/zeppelins)
    MountCreatureID_2     -- ID of the creature used for flying mounts (set to 0 if not applicable)
) VALUES (
    441,                  -- The ID for this new taxi node, must be unique in the table
    0,                    -- The map ID for Eastern Kingdoms
    -8913.23,             -- X coordinate for Northshire Abbey
    -188.49,              -- Y coordinate for Northshire Abbey
    81.88,                -- Z coordinate for Northshire Abbey
    'Northshire Abbey',   -- Name displayed for the taxi node in the English (US) client
    'Northshire Abbey',   -- Name displayed for the taxi node in the English (GB) client
    0,                    -- Ground mount ID (set to 0 for ships/zeppelins)
    0                     -- Flying mount ID (0 because it’s not needed for a ship)
);

-- Insert a new taxi path into taxipath_dbc
INSERT INTO taxipath_dbc (
    ID,                   -- Unique ID for the taxi path
    FromTaxiNode,         -- The ID of the starting taxi node
    ToTaxiNode,           -- The ID of the destination taxi node
    Cost                  -- The cost in copper for using this path (0 if no cost)
) VALUES (
    1979,                 -- Unique ID for this taxi path
    2,                    -- The ID of the Stormwind taxi node (assumed to be 2)
    441,                  -- The ID of the newly created Northshire Abbey node
    100                   -- Cost for the taxi path (e.g., 100 copper = 1 silver)
);

-- Insert the return path from Northshire Abbey to Stormwind into taxipath_dbc
INSERT INTO taxipath_dbc (
    ID,                   -- Unique ID for the taxi path
    FromTaxiNode,         -- The ID of the starting taxi node (Northshire Abbey)
    ToTaxiNode,           -- The ID of the destination taxi node (Stormwind)
    Cost                  -- The cost in copper for using this path
) VALUES (
    1980,                 -- Unique ID for this return taxi path
    441,                  -- The ID of the Northshire Abbey taxi node
    2,                    -- The ID of the Stormwind taxi node
    100                   -- Cost for the return path (100 copper)
);

-- Define the waypoints for the path from Stormwind to Northshire Abbey in taxipathnode_dbc
INSERT INTO taxipathnode_dbc (
    ID,                   -- Unique ID for each waypoint node
    PathID,               -- The ID of the taxi path this node belongs to
    NodeIndex,            -- The order of this node in the path (starting from 0)
    ContinentID,          -- The map ID where this waypoint is located
    LocX,                 -- X coordinate of the waypoint
    LocY,                 -- Y coordinate of the waypoint
    LocZ                  -- Z coordinate of the waypoint
) VALUES
    (46875, 1979, 0, 0, -8833.38, 626.07, 94.06),  -- The first waypoint (start at Stormwind dock)
    (46876, 1979, 1, 0, -8870.00, 218.00, 85.00),  -- The second waypoint (mid-point between Stormwind and Northshire Abbey)
    (46877, 1979, 2, 0, -8913.23, -188.49, 81.88); -- The third waypoint (arrival at Northshire Abbey)

-- Define the waypoints for the return path from Northshire Abbey to Stormwind in taxipathnode_dbc
INSERT INTO taxipathnode_dbc (
    ID,                   -- Unique ID for each waypoint node
    PathID,               -- The ID of the taxi path this node belongs to
    NodeIndex,            -- The order of this node in the path (starting from 0)
    ContinentID,          -- The map ID where this waypoint is located
    LocX,                 -- X coordinate of the waypoint
    LocY,                 -- Y coordinate of the waypoint
    LocZ                  -- Z coordinate of the waypoint
) VALUES
    (46878, 1980, 0, 0, -8913.23, -188.49, 81.88), -- The first waypoint (start at Northshire Abbey)
    (46879, 1980, 1, 0, -8870.00, 218.00, 85.00),  -- The second waypoint (mid-point between Northshire Abbey and Stormwind)
    (46880, 1980, 2, 0, -8833.38, 626.07, 94.06);  -- The third waypoint (arrival at Stormwind dock)
