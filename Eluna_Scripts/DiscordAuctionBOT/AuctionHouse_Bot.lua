json = require("dkjson")

local auctionConfig = {
    auctionWebhookURL = "YourWebhookHERE!",
    goldEmoji = "<:gold:1218538239384883240>",
    silverEmoji = "<:silver:1218538237346316369>",
    copperEmoji = "<:copper:1218538235312078950>",
    itemLinkDB = "http://wow.tanados.com/database/?",
    thumbnailIcons = true,
    itemIconDB = "https://wow.tanados.com/database/static/images/wow/icons/large/",
    botImage = "https://img.freepik.com/premium-vector/hand-drawn-auction-house-icon-sticker-style-vector-illustration_755164-11215.jpg",  -- Replace with a valid URL
    itemQuality = {
        [0] = {color = 10329501, name = "Poor"},
        [1] = {color = 16777215, name = "Common"},
        [2] = {color = 2031360, name = "Uncommon"},
        [3] = {color = 28893, name = "Rare"},
        [4] = {color = 10696174, name = "Epic"},
        [5] = {color = 16744448, name = "Legendary"},
        [6] = {color = 15125632, name = "Artifact"},
        [7] = {color = 52479, name = "Heirloom"}
    }
}

-- This version sends the JSON payload via standard input, avoiding shell quote issues.
local function SendDiscordEmbed(message, webhookURL)
    local curlCommand = 'curl -X POST -H "Content-Type: application/json" -d @- ' .. webhookURL
    local curlProcess = io.popen(curlCommand, 'w')
    curlProcess:write(message)
    curlProcess:close()
end

local function GetIconFromDBC(itemId)
    if auctionConfig.thumbnailIcons then
        local queryResult = WorldDBQuery("SELECT InventoryIcon_1 FROM db_itemdisplayinfo_12340 WHERE ID = (SELECT displayid FROM item_template WHERE entry = " .. itemId .. ")")
        if queryResult then
            local icon = queryResult:GetString(0)
            if icon and icon ~= "" then
                return auctionConfig.itemIconDB .. icon:lower() .. '.jpg'
            else
                -- Handle the case where icon data is missing or empty
                print("Icon data for itemId " .. itemId .. " is missing or empty.")
                return ""
            end
        else
            -- Handle the case where the query did not return a result
            print("Query did not return a result for itemId: " .. itemId)
            return ""
        end
    else
        return ""
    end
end

local function GetPlayerIcon(player)
    local race = string.gsub(player:GetRaceAsString(), " ", ""):lower()
    local gender = "male"  -- Default to "male" to ensure 'gender' always has a value
    if player:GetGender() == 1 then
        gender = "female"
    end
    return auctionConfig.itemIconDB .. 'race_' .. race .. '_' .. gender .. '.jpg'
end

local function EscapeQuotes(text)
    if not text then
        return ""
    end
    text = string.gsub(text, '"', '\\"')
    text = string.gsub(text, "'", "\\'")
    return text
end

local function ConvertCopperToGoldSilverCopper(copper)
    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local copper = copper % 100
    local parts = {}
    
    if gold > 0 then table.insert(parts, gold .. auctionConfig.goldEmoji) end
    if silver > 0 then table.insert(parts, silver .. auctionConfig.silverEmoji) end
    if copper > 0 then table.insert(parts, copper .. auctionConfig.copperEmoji) end
    
    return table.concat(parts, " ")  -- Concatenates the parts array with a space, avoiding leading/trailing spaces
end

local function ConvertSecondsToReadableTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    return hours, minutes
end

local function FormatDiscordTimestamp(expireTime)
    return os.date("!%Y-%m-%dT%H:%M:%S.000Z", expireTime)
end

local function OnAuctionAdd(event, auctionId, owner, item, expireTime, buyout, startBid, currentBid, bidderGUIDLow)
    local embed = {
        title = EscapeQuotes(item:GetName()),
        description = string.format('Item Level: %s\nSelling %d for\nBuyout: %s\nBid: %s',
            item:GetItemLevel(), 
            item:GetCount(), 
            ConvertCopperToGoldSilverCopper(buyout), 
            ConvertCopperToGoldSilverCopper(startBid)),
        url = auctionConfig.itemLinkDB .. 'item=' .. tostring(item:GetEntry()),
        color = auctionConfig.itemQuality[item:GetQuality()].color,
        thumbnail = {
            url = GetIconFromDBC(item:GetEntry())  -- Ensure this returns a valid image URL
        },
        author = {
            name = owner:GetName() .. " listed",
            icon_url = GetPlayerIcon(owner)  -- Ensure this returns a valid image URL
        },
        footer = {
            text = "Listed until " .. os.date("%m/%d/%Y %I:%M %p", expireTime)
        }
    }

    -- Convert the Lua table to a JSON string
    local message = json.encode({embeds = {embed}, username = "Auction House", avatar_url = auctionConfig.botImage})
    -- Send the message using the safe streaming method
    SendDiscordEmbed(message, auctionConfig.auctionWebhookURL)
end

RegisterServerEvent(26, OnAuctionAdd)
