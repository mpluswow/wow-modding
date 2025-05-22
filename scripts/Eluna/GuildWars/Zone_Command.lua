local function GPSInfoCommand(event, player, command)
    if command == "zone" then
        local map = player:GetMapId()
        local zone = player:GetZoneId()
        local area = player:GetAreaId()

        player:SendBroadcastMessage("Map ID: " .. map)
        player:SendBroadcastMessage("Zone ID: " .. zone)
        player:SendBroadcastMessage("Area ID (Subzone): " .. area)

        return false -- block command from further processing
    end
end

RegisterPlayerEvent(42, GPSInfoCommand)
