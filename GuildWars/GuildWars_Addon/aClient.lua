local AIO = AIO or require("AIO")

if AIO.AddAddon() then
    return
end

-- Register the client-side handlers
local gw_fetchDATA_Handlers = AIO.AddHandlers("gw_fetchDATA", {})

-- Function to create customizable title bars with adjustable size, position, and font
local function CreateTitleBar(parentFrame, titleText, fontName, fontSize, titleColor, iconTexture, iconSize, titleBarWidth, titleBarHeight, offsetX, offsetY)
    local titleBar = CreateFrame("Frame", nil, parentFrame)
    titleBar:SetSize(titleBarWidth or parentFrame:GetWidth(), titleBarHeight or 25)  -- Customizable width and height
    titleBar:SetPoint("TOP", parentFrame, "TOP", offsetX or 0, offsetY or 12)  -- Customizable position
    titleBar:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
        edgeSize = 12
    })
    titleBar:SetBackdropColor(0, 0, 0, 0.9)

    -- Add a text label for the title
    local titleLabel = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    titleLabel:SetPoint("CENTER", titleBar, "CENTER", 0, 0)
    titleLabel:SetFont(fontName or "Fonts\\FRIZQT__.TTF", fontSize or 16) -- Customizable font and size
    titleLabel:SetText(titleText)

    -- Set the text color if provided
    if titleColor then
        titleLabel:SetTextColor(unpack(titleColor)) -- Expects a table like {r, g, b, a}
    end

    -- Optionally, add an icon to the title bar
    if iconTexture then
        local titleIcon = titleBar:CreateTexture(nil, "ARTWORK")
        titleIcon:SetTexture(iconTexture)
        titleIcon:SetSize(iconSize or 24, iconSize or 24)  -- Default icon size is 24x24
        titleIcon:SetPoint("LEFT", titleBar, "LEFT", 10, 0)
    end

    return titleBar
end

-- Function to create icons with tooltips
local function CreateIconWithTooltip(parentFrame, iconTexture, tooltipText, size)
    local icon = CreateFrame("Button", nil, parentFrame)
    icon:SetSize(size or 48, size or 48)
    icon:SetNormalTexture(iconTexture)

    -- Create the tooltip when hovering over the icon
    icon:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(tooltipText, nil, nil, nil, nil, true)
        GameTooltip:Show()
    end)
    
    icon:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    return icon
end

-- Create the main fetchDATA frame (UI)
local gw_fetchDATA_Frame = CreateFrame("Frame", "gw_fetchDATA_Frame", UIParent)
gw_fetchDATA_Frame:SetSize(600, 250)  -- Main window size
gw_fetchDATA_Frame:SetPoint("CENTER")
gw_fetchDATA_Frame:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
gw_fetchDATA_Frame:SetBackdropColor(0, 0, 0, 0.8)
gw_fetchDATA_Frame:SetMovable(true)
gw_fetchDATA_Frame:EnableMouse(true)
gw_fetchDATA_Frame:RegisterForDrag("LeftButton")
gw_fetchDATA_Frame:SetScript("OnDragStart", gw_fetchDATA_Frame.StartMoving)
gw_fetchDATA_Frame:SetScript("OnDragStop", gw_fetchDATA_Frame.StopMovingOrSizing)
gw_fetchDATA_Frame:Hide()  -- Initially hidden

-- Add title bar to the main window with custom width and height
CreateTitleBar(gw_fetchDATA_Frame, "GuildWars", "Fonts\\MORPHEUS.ttf", 16, {1, 0.82, 0, 1}, "Interface\\Icons\\Achievement_GuildPerk_EverybodysFriend", 32, 500, 40, 0, 30)

-- Create left subwindow
local gw_leftSubWindow = CreateFrame("Frame", "gw_leftSubWindow", gw_fetchDATA_Frame)
gw_leftSubWindow:SetSize(300, 250)
gw_leftSubWindow:SetPoint("RIGHT", gw_fetchDATA_Frame, "LEFT", -10, 0)
gw_leftSubWindow:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
gw_leftSubWindow:SetBackdropColor(0, 0, 0, 0.8)
gw_leftSubWindow:Hide()

-- Add title bar to the left subwindow with custom width and height
CreateTitleBar(gw_leftSubWindow, "Left Subwindow", "Fonts\\ARIALN.ttf", 14, {0.5, 0.5, 1, 1}, "Interface\\Icons\\Spell_Arcane_Arcane04", 24, 300, 35)

-- Create Join Button for the left subwindow and assign .guild1 command
local gw_leftJoinButton = CreateFrame("Button", nil, gw_leftSubWindow, "UIPanelButtonTemplate")
gw_leftJoinButton:SetSize(90, 30)
gw_leftJoinButton:SetText("Join")
gw_leftJoinButton:SetPoint("BOTTOMLEFT", gw_leftSubWindow, "BOTTOMLEFT", 10, -10)
gw_leftJoinButton:SetScript("OnClick", function()
    SendChatMessage(".joindream", "SAY")  -- Executes the .guild1 command
end)

-- Create a FontString for description in the left subwindow
local leftGuildDescription = gw_leftSubWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
leftGuildDescription:SetPoint("TOP", 0, -50)
leftGuildDescription:SetText("Left Guild Description: Join the Dream Forgers!")

-- Add horizontal icons at the bottom of the left subwindow
local leftIcon1 = CreateIconWithTooltip(gw_leftSubWindow, "Interface\\Icons\\Spell_Holy_InnerFire", "Tooltip for Icon 1")
leftIcon1:SetPoint("BOTTOMRIGHT", gw_leftSubWindow, "BOTTOMRIGHT", -135, -15)

local leftIcon2 = CreateIconWithTooltip(gw_leftSubWindow, "Interface\\Icons\\Spell_Arcane_Arcane04", "Tooltip for Icon 2")
leftIcon2:SetPoint("LEFT", leftIcon1, "RIGHT", 10, 0)

local leftIcon3 = CreateIconWithTooltip(gw_leftSubWindow, "Interface\\Icons\\Spell_Fire_FlameBolt", "Tooltip for Icon 3")
leftIcon3:SetPoint("LEFT", leftIcon2, "RIGHT", 10, 0)

-- Create right subwindow
local gw_rightSubWindow = CreateFrame("Frame", "gw_rightSubWindow", gw_fetchDATA_Frame)
gw_rightSubWindow:SetSize(300, 250)
gw_rightSubWindow:SetPoint("LEFT", gw_fetchDATA_Frame, "RIGHT", 10, 0)
gw_rightSubWindow:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
gw_rightSubWindow:SetBackdropColor(0, 0, 0, 0.8)
gw_rightSubWindow:Hide()

-- Add title bar to the right subwindow with custom width and height
CreateTitleBar(gw_rightSubWindow, "Right Subwindow", "Fonts\\ARIALN.ttf", 14, {0.5, 1, 0.5, 1}, "Interface\\Icons\\Spell_Nature_HealingTouch", 24, 300, 35)

-- Create Join Button for the right subwindow and assign .guild2 command
local gw_rightJoinButton = CreateFrame("Button", nil, gw_rightSubWindow, "UIPanelButtonTemplate")
gw_rightJoinButton:SetSize(90, 30)
gw_rightJoinButton:SetText("Join")
gw_rightJoinButton:SetPoint("BOTTOMRIGHT", gw_rightSubWindow, "BOTTOMRIGHT", -10, -10)
gw_rightJoinButton:SetScript("OnClick", function()
    SendChatMessage(".joinnightmare", "SAY")  -- Executes the .guild2 command
end)

-- Create a FontString for description in the right subwindow
local rightGuildDescription = gw_rightSubWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
rightGuildDescription:SetPoint("TOP", 0, -50)
rightGuildDescription:SetText("Right Guild Description: Join the Nightmare Forgers!")

-- Add horizontal icons at the bottom of the right subwindow
local rightIcon1 = CreateIconWithTooltip(gw_rightSubWindow, "Interface\\Icons\\Spell_Nature_HealingTouch", "Tooltip for Icon 1")
rightIcon1:SetPoint("BOTTOMLEFT", gw_rightSubWindow, "BOTTOMLEFT", 10, 10)

local rightIcon2 = CreateIconWithTooltip(gw_rightSubWindow, "Interface\\Icons\\Spell_Shadow_ShadowBolt", "Tooltip for Icon 2")
rightIcon2:SetPoint("LEFT", rightIcon1, "RIGHT", 10, 0)

local rightIcon3 = CreateIconWithTooltip(gw_rightSubWindow, "Interface\\Icons\\Spell_Frost_FrostBolt02", "Tooltip for Icon 3")
rightIcon3:SetPoint("LEFT", rightIcon2, "RIGHT", 10, 0)

-- Function to create the bottom bar-shaped subwindow with customizable position and size
local function CreateBarSubWindow(parentFrame, width, height, posX, posY)
    local barSubWindow = CreateFrame("Frame", "gw_barSubWindow", parentFrame)
    barSubWindow:SetSize(width or 600, height or 40)  -- Customizable width and height for the bar
    barSubWindow:SetPoint("TOP", parentFrame, "BOTTOM", posX or 0, posY or -10)  -- Customizable position
    barSubWindow:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    barSubWindow:SetBackdropColor(0, 0, 0, 0.8)
    barSubWindow:Hide()  -- Initially hidden
    
    return barSubWindow
end

-- Call the function to create the bar-shaped subwindow
local gw_barSubWindow = CreateBarSubWindow(gw_fetchDATA_Frame, 600, 40, 0, -20)  -- Adjust width, height, and position as needed

-- Add a customizable title bar to the bar subwindow
CreateTitleBar(gw_barSubWindow, "Guild Experience", "Fonts\\FRIZQT__.TTF", 14, {1, 1, 1, 1}, nil, nil, 500, 20, 0, 20) -- Positions the title 20px to the right and 5px down

-- Add an interactive XP Bar to the bar-shaped subwindow
local xpBar = CreateFrame("StatusBar", nil, gw_barSubWindow)
xpBar:SetSize(580, 20)  -- XP bar size (adjustable)
xpBar:SetPoint("CENTER", gw_barSubWindow, "CENTER", 0, 0)
xpBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
xpBar:SetMinMaxValues(0, 20000)  -- Set maximum XP (20,000 as an example)
xpBar:SetValue(100)  -- Set the current XP value (100 as an example)
xpBar:SetStatusBarColor(0, 0.65, 1)  -- Set the bar color (blue)

-- Add a background for the XP bar
local xpBarBG = xpBar:CreateTexture(nil, "BACKGROUND")
xpBarBG:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
xpBarBG:SetAllPoints(true)
xpBarBG:SetVertexColor(0.15, 0.15, 0.15, 0.8)

-- Create a FontString to display the current XP and max XP (interactive text display)
local xpBarText = xpBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
xpBarText:SetPoint("CENTER", xpBar, "CENTER", 0, 0)

-- Function to update the XP bar and text
local function UpdateXPBar(currentXP, maxXP)
    xpBar:SetMinMaxValues(0, maxXP)  -- Set the max XP
    xpBar:SetValue(currentXP)  -- Set the current XP
    xpBarText:SetText("XP: " .. currentXP .. " / " .. maxXP)  -- Update the displayed text
end

-- Initially set the XP bar (this can later be updated with data from the database)
UpdateXPBar(1700, 20000)  -- Example: 1700 XP out of 20,000 XP

-- Toggle button to open/close subwindows
local gw_toggleButton = CreateFrame("Button", "gw_toggleButton", gw_fetchDATA_Frame, "UIPanelButtonTemplate")
gw_toggleButton:SetSize(100, 30)
gw_toggleButton:SetText("Join Guild")
gw_toggleButton:SetPoint("BOTTOM", gw_fetchDATA_Frame, "BOTTOM", 240, 10)

-- Toggle function for the subwindows and bar
local function ToggleSubWindows()
    if gw_leftSubWindow:IsShown() then
        gw_leftSubWindow:Hide()
        gw_rightSubWindow:Hide()
        gw_barSubWindow:Hide()
    else
        gw_leftSubWindow:Show()
        gw_rightSubWindow:Show()
        gw_barSubWindow:Show()
    end
end

-- Assign the toggle function to the button's OnClick
gw_toggleButton:SetScript("OnClick", ToggleSubWindows)

-- Create FontStrings to display data
local fontData = {
    PlayerName = gw_fetchDATA_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"),
    GuildName = gw_fetchDATA_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal"),
    PlayerKills = gw_fetchDATA_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal"),
    CreatureKills = gw_fetchDATA_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal"),
    NextReset = gw_fetchDATA_Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
}

-- Set positions of the FontStrings
fontData.PlayerName:SetPoint("TOPLEFT", 20, -20)
fontData.GuildName:SetPoint("TOPLEFT", 20, -70)
fontData.PlayerKills:SetPoint("TOPLEFT", 20, -100)
fontData.CreatureKills:SetPoint("TOPLEFT", 20, -130)
fontData.NextReset:SetPoint("TOPLEFT", 20, -160)

-- General function to update FontStrings
local function UpdateFontString(fontString, label, value)
    fontString:SetText(label .. " " .. tostring(value))
end

-- Handler to display the fetched data in the window
function gw_fetchDATA_Handlers.gw_fetchDATA_ShowWindow(playerName, guildName, playerKills, creatureKills, nextReset)
    -- Log the received data
    print("[Client] Data received from server:")
    print("  Player Name: " .. playerName)
    print("  Guild Name: " .. guildName)
    print("  Player Kills: " .. playerKills)
    print("  Creature Kills: " .. creatureKills)
    print("  Next Reset: " .. nextReset)

    -- Update the FontStrings with the received data
    UpdateFontString(fontData.PlayerName, "Greetings", playerName)
    UpdateFontString(fontData.GuildName, "Guild", guildName)
    UpdateFontString(fontData.PlayerKills, "Player Kills", playerKills)
    UpdateFontString(fontData.CreatureKills, "Creature Kills", creatureKills)
    UpdateFontString(fontData.NextReset, "Next Reset", nextReset)

    -- Show the frame
    gw_fetchDATA_Frame:Show()
    print("[Client] gw_fetchDATA frame displayed.")
end

-- Function to close all windows at once
local function CloseAllWindows()
    -- Hide all related windows
    gw_fetchDATA_Frame:Hide()
    gw_leftSubWindow:Hide()
    gw_rightSubWindow:Hide()
    gw_barSubWindow:Hide()
end

-- Create the close button (X) on the main window
local closeButton = CreateFrame("Button", nil, gw_fetchDATA_Frame, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", gw_fetchDATA_Frame, "TOPRIGHT", -5, 30) -- Position in the top-right corner
closeButton:SetScript("OnClick", CloseAllWindows)  -- When clicked, it will close all windows