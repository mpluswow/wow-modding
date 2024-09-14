local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

-- Register client-side handlers
local guildBar_Handlers = AIO.AddHandlers("guildBar_", {})

-- Create the main frame for the button in the lower right corner
local MainButtonFrame = CreateFrame("Frame", "MainButtonFrame", UIParent)
MainButtonFrame:SetSize(35, 35)  -- Size of the main button
MainButtonFrame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -10, 10)  -- Positioned in the bottom-right corner

-- Define the icons and buttons that will appear when clicked
local guildBarCommands = {
    { icon = "Interface\\Icons\\Ability_Warlock_ChaosBolt", command = ".tg", tooltip = "GuildWars Menu", offsetY = 50 },
    { icon = "Interface\\Icons\\Spell_Shadow_ShadowBolt", command = ".guildbar2", tooltip = "Shadow Bolt", offsetY = 100 },
    { icon = "Interface\\Icons\\Spell_Fire_FelFlameRing", command = ".guildbar3", tooltip = "Fel Flame", offsetY = 150 },
    { icon = "Interface\\Icons\\Spell_Shadow_DeathCoil", command = ".guildbar4", tooltip = "Death Coil", offsetY = 200 },
    { icon = "Interface\\Icons\\Ability_Creature_Cursed_04", command = ".guildbar5", tooltip = "Doom Bolt", offsetY = 250 },
}

-- Function to create the buttons with icons
local function CreateCustomSpellBarButton(index, iconTexture, command, tooltipText, offsetY)
    local button = CreateFrame("Button", "SpellBarButton"..index, MainButtonFrame, "SecureActionButtonTemplate")
    button:SetSize(45, 45)  -- Size of the buttons
    button:SetPoint("BOTTOMRIGHT", MainButtonFrame, "BOTTOMRIGHT", 0, offsetY)  -- Positioned relative to the main button
    button:Hide()  -- Hide by default (will be shown when submenu is unfolded)

    -- Set the icon texture for the button
    local normalTexture = button:CreateTexture()
    normalTexture:SetTexture(iconTexture)
    normalTexture:SetAllPoints(button)
    button:SetNormalTexture(normalTexture)

    -- Add a highlight texture for mouseover
    button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")

    -- Add a tooltip on mouseover
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(tooltipText)
        GameTooltip:Show()
    end)

    -- Remove the tooltip on mouseout
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    -- Set the on-click behavior to send the command as a chat message
    button:SetScript("OnClick", function()
        SendChatMessage(command, "SAY")  -- Send the command as a chat message
    end)

    return button
end

-- Create the main button that will trigger the expansion
local MainButton = CreateFrame("Button", "MainButton", MainButtonFrame, "SecureActionButtonTemplate")
MainButton:SetSize(45, 45)
MainButton:SetPoint("BOTTOMRIGHT", MainButtonFrame, "BOTTOMRIGHT", 0, 0)

-- Set the texture for the main button
local mainButtonTexture = MainButton:CreateTexture()
mainButtonTexture:SetTexture("Interface/test/gw_menu_icon")  -- Main button icon
mainButtonTexture:SetAllPoints(MainButton)
MainButton:SetNormalTexture(mainButtonTexture)

-- Add a highlight texture to the main button for mouseover
MainButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")

-- Create a toggle variable to track if the menu is open or closed
local isMenuOpen = false

-- Function to show or hide the buttons based on the toggle
local function ToggleButtons()
    isMenuOpen = not isMenuOpen  -- Flip the state of the menu (open/closed)
    for index, data in ipairs(guildBarCommands) do
        local button = _G["SpellBarButton"..index]
        if button then
            if isMenuOpen then
                button:Show()  -- Show the buttons when the menu is open
            else
                button:Hide()  -- Hide the buttons when the menu is closed
            end
        end
    end
end

-- Create the spell bar buttons and hide them by default
for index, data in ipairs(guildBarCommands) do
    CreateCustomSpellBarButton(index, data.icon, data.command, data.tooltip, data.offsetY)
end

-- Toggle buttons on main button click (click to expand/collapse the menu)
MainButton:SetScript("OnClick", function()
    ToggleButtons()
end)

-- Function to close the submenu buttons with ESC key, without hiding the main button
local function CloseMenuOnEscape()
    if isMenuOpen then
        ToggleButtons()  -- Close the submenu
    end
end

