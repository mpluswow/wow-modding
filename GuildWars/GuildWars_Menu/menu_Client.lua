local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

-- Registering client-side AIO handlers
local guildBar_Handlers = AIO.AddHandlers("guildBar_", {})

-- Create the main frame for the spell bar (positioned at the top)
local SpellBarFrame = CreateFrame("Frame", "SpellBarFrame", UIParent)
SpellBarFrame:SetSize(550, 50)  -- General size for the spell bar container (can be adjusted)
SpellBarFrame:SetPoint("TOP", UIParent, "TOP", 0, -10)  -- Position at the top of the screen
SpellBarFrame:SetBackdrop({
    bgFile = "",
    edgeFile = "0",
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
SpellBarFrame:SetBackdropColor(0, 0, 0, 0.5)

-- Define the guild bar commands, icons, and individual button parameters
local guildBarCommands = {
    { icon = "Interface\\Icons\\Ability_Warlock_ChaosBolt", command = ".guildbar1", tooltip = "Chaos Bolt", width = 30, height = 30, offsetX = 15, offsetY = 0 },
    { icon = "Interface\\Icons\\Spell_Shadow_ShadowBolt", command = ".guildbar2", tooltip = "Shadow Bolt", width = 30, height = 30, offsetX = 70, offsetY = 0 },
    { icon = "Interface\\Icons\\Spell_Fire_FelFlameRing", command = ".guildbar3", tooltip = "Fel Flame", width = 30, height = 30, offsetX = 120, offsetY = 0 },
    { icon = "Interface\\Icons\\Spell_Shadow_DeathCoil", command = ".guildbar4", tooltip = "Death Coil", width = 30, height = 30, offsetX = 175, offsetY = 0 },
    { icon = "Interface\\Icons\\Ability_Creature_Cursed_04", command = ".guildbar5", tooltip = "Doom Bolt", width = 30, height = 30, offsetX = 225, offsetY = 0 },
    { icon = "Interface\\Icons\\Spell_Shadow_RainOfFire", command = ".guildbar6", tooltip = "Hellfire", width = 30, height = 30, offsetX = 285, offsetY = 0 },
    { icon = "Interface\\Icons\\Spell_Fire_FelFlameRing", command = ".guildbar7", tooltip = "Shadowfury", width = 30, height = 30, offsetX = 330, offsetY = 0 },
    { icon = "Interface\\Icons\\Spell_Shadow_UnstableAffliction_3", command = ".guildbar8", tooltip = "Unstable Affliction", width = 30, height = 30, offsetX = 385, offsetY = 0 },
    { icon = "Interface\\Icons\\Spell_Fire_Fireball02", command = ".guildbar9", tooltip = "Soul Fire", width = 30, height = 30, offsetX = 440, offsetY = 0 },
    { icon = "Interface\\Icons\\Ability_Warlock_DemonicPower", command = ".guildbar10", tooltip = "Chaos Wave", width = 30, height = 30, offsetX = 495, offsetY = 0 },
}

-- Function to create each button (icon) in the spell bar with full customization options
local function CreateCustomSpellBarButton(index, iconTexture, command, tooltipText, width, height, offsetX, offsetY)
    local button = CreateFrame("Button", "SpellBarButton"..index, SpellBarFrame, "SecureActionButtonTemplate")
    button:SetSize(width, height)  -- Set the width and height of the button based on parameters
    button:SetPoint("TOPLEFT", SpellBarFrame, "TOPLEFT", offsetX, offsetY)  -- Position based on offset

    -- Set the normal texture for the button
    local normalTexture = button:CreateTexture()
    normalTexture:SetTexture(iconTexture)
    normalTexture:SetAllPoints(button)
    button:SetNormalTexture(normalTexture)  -- Set the icon texture

    -- Add a tooltip on mouseover
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(tooltipText)
        GameTooltip:Show()
        button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
    end)

    -- Remove the tooltip on mouseout
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
        button:SetHighlightTexture(nil)  -- Remove highlight
    end)

    -- Set the on-click behavior to directly send the command as a chat message
    button:SetScript("OnClick", function()
        SendChatMessage(command, "SAY")  -- Send the command as a chat message
        print("Command executed: ", command)
    end)
end

-- Loop through the guildBarCommands and create each button with individual customization
for index, data in ipairs(guildBarCommands) do
    CreateCustomSpellBarButton(index, data.icon, data.command, data.tooltip, data.width, data.height, data.offsetX, data.offsetY)
end

-- Function to show the spell bar (called when the trigger message is detected)
local function ShowSpellBar()
    SpellBarFrame:Show()
    print("[Client] Spell Bar displayed.")
end

-- Listen for the trigger message in the chat and show the spell bar
local function OnChatMessage(self, event, message, sender, ...)
    if message == "TriggerGuildBar" then
        ShowSpellBar()
    end
end

-- Register event to listen for chat messages
local ChatFrame = CreateFrame("Frame")
ChatFrame:RegisterEvent("CHAT_MSG_SYSTEM")
ChatFrame:SetScript("OnEvent", OnChatMessage)
