-- Database information
local DATABASE_NAME = "acore_characters"
local TABLE_NAME = "recruitfriend"

-- Recruit a friend command (store relationship in the database)
local function RecruitFriend(event, recruiter, command)
    if command:sub(1, 13) == "recruitfriend" then
        local recruitName = command:sub(15)

        -- Find the recruit player by name
        local recruit = GetPlayerByName(recruitName)
        if recruit then
            local recruiterGUID = recruiter:GetGUIDLow()
            local recruitGUID = recruit:GetGUIDLow()

            -- Check if this recruit has already been recruited
            local query = string.format("SELECT id FROM %s.%s WHERE recruit_guid = %d", DATABASE_NAME, TABLE_NAME, recruitGUID)
            local result = WorldDBQuery(query)
            if result then
                recruiter:SendBroadcastMessage("This player has already been recruited.")
                return false
            end

            -- Insert the recruit relationship into the database
            local insertQuery = string.format("INSERT INTO %s.%s (recruiter_guid, recruit_guid) VALUES (%d, %d)",
                                              DATABASE_NAME, TABLE_NAME, recruiterGUID, recruitGUID)
            WorldDBExecute(insertQuery)

            -- Send confirmation messages to both players
            recruiter:SendBroadcastMessage("You have successfully recruited " .. recruit:GetName() .. "!")
            recruit:SendBroadcastMessage("You have been recruited by " .. recruiter:GetName() .. "!")

        else
            recruiter:SendBroadcastMessage("Player not found.")
        end

        return false -- Prevent further command processing
    end
end

-- Bonus XP logic (read from the database to determine the relationship)
local function OnXPReward(event, player, amount)
    local playerGUID = player:GetGUIDLow()

    -- Check if this player has a recruiter in the database
    local query = string.format("SELECT recruiter_guid FROM %s.%s WHERE recruit_guid = %d", DATABASE_NAME, TABLE_NAME, playerGUID)
    local result = WorldDBQuery(query)

    if result then
        local recruiterGUID = result:GetUInt32(0)
        local recruiter = GetPlayerByGUID(recruiterGUID)

        if recruiter and recruiter:IsWithinDistInMap(player, 50) then
            -- Award bonus XP to both the player and the recruiter
            local bonusXP = amount * 0.5 -- 50% bonus XP
            player:GiveXP(bonusXP)
            recruiter:GiveXP(bonusXP)

            player:SendBroadcastMessage("You earned bonus XP from Recruit-A-Friend!")
            recruiter:SendBroadcastMessage("You earned bonus XP from your recruit leveling up!")
        end
    end
end

-- Summon Friend command (retrieve recruit relationship from the database)
local function SummonFriend(event, player, command)
    if command:sub(1, 12) == "summonfriend" then
        local recruitName = command:sub(14)
        
        -- Find the recruit player by name
        local recruit = GetPlayerByName(recruitName)
        if not recruit then
            player:SendBroadcastMessage("Player not found or not online.")
            return false
        end
        
        -- Check if player and recruit are of the same faction
        if player:GetTeam() ~= recruit:GetTeam() then
            player:SendBroadcastMessage("You cannot summon a player from the opposite faction.")
            return false
        end

        local playerGUID = player:GetGUIDLow()
        local recruitGUID = recruit:GetGUIDLow()

        -- Check if this player is the recruiter of the named recruit
        local query = string.format("SELECT recruit_guid FROM %s.%s WHERE recruiter_guid = %d AND recruit_guid = %d", DATABASE_NAME, TABLE_NAME, playerGUID, recruitGUID)
        local result = WorldDBQuery(query)

        if result then
            -- Teleport the recruit to the recruiter (summoner)
            recruit:Teleport(player:GetMapId(), player:GetX(), player:GetY(), player:GetZ(), player:GetO())
            player:SendBroadcastMessage("You have summoned your recruit to your location!")
            recruit:SendBroadcastMessage("You have been summoned by your recruiter!")
        else
            player:SendBroadcastMessage("This player is not your recruit.")
        end

        return false -- Prevent further command processing
    end
end

-- Register commands and events
RegisterPlayerEvent(42, RecruitFriend)    -- "/recruitfriend"
RegisterPlayerEvent(13, OnXPReward)       -- Trigger when XP is rewarded
RegisterPlayerEvent(42, SummonFriend)     -- "/summonfriend"
print (" ")
print(">Recruit-A-Friend system loaded.")
