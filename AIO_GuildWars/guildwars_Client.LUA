local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local GuildWarsHandlers = AIO.AddHandlers("GuildWars", {})

local MainFrame = CreateFrame("Frame", "MainFrame", UIParent)
MainFrame:SetSize(480, 250)
MainFrame:SetPoint("CENTER")

MainFrame:SetBackdrop({
    bgFile = "Interface/test/GuildWars_MainBG.blp",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
MainFrame:SetBackdropColor(0.4, 0.4, 0.4, 1.2)
MainFrame:SetBackdropBorderColor(1, 1, 1, 1)
MainFrame:SetMovable(true)
MainFrame:EnableMouse(true)
MainFrame:RegisterForDrag("LeftButton")
MainFrame:SetScript("OnDragStart", MainFrame.StartMoving)
MainFrame:SetScript("OnDragStop", MainFrame.StopMovingOrSizing)
MainFrame:Hide()

local TitleBar = CreateFrame("Frame", nil, MainFrame)
TitleBar:SetSize(400, 35)
TitleBar:SetPoint("TOP", MainFrame, "TOP", 0, 25)

TitleBar:SetBackdrop({
    bgFile = "Interface/test/GuildWars_BarBG1.blp",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 17
})
TitleBar:SetBackdropColor(0.3, 0.3, 0.3, 1)
TitleBar:SetBackdropBorderColor(1, 1, 1, 1)

local TitleText = TitleBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
TitleText:SetPoint("CENTER", TitleBar, "CENTER", 0, 0)
TitleText:SetText("GuildWars")
TitleText:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
TitleText:SetTextColor(1, 0.82, 0)

-- Add a FontString to display the guild name
local GuildNameText = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
GuildNameText:SetPoint("TOPLEFT", MainFrame, "TOPLEFT", 20, -50)
GuildNameText:SetText("Guild: Not Available")  -- Default text
GuildNameText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")  -- Set font, size, and outline
GuildNameText:SetTextColor(1, 1, 1)  -- Set color to white (RGB values range from 0 to 1)

-- Handler to update the guild name when received from the server
function GuildWarsHandlers.UpdateGuildName(guildGWName)
    GuildNameText:SetText("Guild: " .. tostring(guildGWName))
end

-- Add a FontString to display creature kills
local CreatureKillsText = MainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
CreatureKillsText:SetPoint("TOPLEFT", MainFrame, "TOPLEFT", 20, -80)
CreatureKillsText:SetText("Creature Kills: 0")  -- Default text
CreatureKillsText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")  -- Set font, size, and outline
CreatureKillsText:SetTextColor(1, 1, 0)  -- Set color to yellow (RGB values range from 0 to 1)

-- Handler to update creature kills when received from the server
function GuildWarsHandlers.UpdateCreatureKills(creatureGWKills)
    CreatureKillsText:SetText("Creature Kills: " .. tostring(creatureGWKills))
end


local MainCloseButton = CreateFrame("Button", nil, MainFrame, "UIPanelCloseButton")
MainCloseButton:SetPoint("TOPRIGHT", MainFrame, "TOPRIGHT", 25, 65)

local function CloseAllFrames()
    MainFrame:Hide()
    LeftSubWindow:Hide()
    RightSubWindow:Hide()
end

MainCloseButton:SetScript("OnClick", CloseAllFrames)

local XPBarFrame = CreateFrame("Frame", "XPBarFrame", MainFrame)
XPBarFrame:SetSize(420, 32)
XPBarFrame:SetPoint("TOP", MainFrame, "BOTTOM", 0, 5)

XPBarFrame:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
XPBarFrame:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
XPBarFrame:SetBackdropBorderColor(1, 1, 1, 1)

local XPBar = CreateFrame("StatusBar", nil, XPBarFrame)
XPBar:SetSize(410, 20)
XPBar:SetPoint("CENTER", XPBarFrame, "CENTER", 0, 0)
XPBar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
XPBar:GetStatusBarTexture():SetHorizTile(false)
XPBar:SetStatusBarColor(0.0, 0.65, 0.9)

local XPBarBG = XPBar:CreateTexture(nil, "BACKGROUND")
XPBarBG:SetAllPoints(true)
XPBarBG:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
XPBarBG:SetVertexColor(0.3, 0.3, 0.3, 0.8)

local XPBarText = XPBar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
XPBarText:SetPoint("CENTER", XPBar, "CENTER", -15, 0)
XPBarText:SetText("Guild XP: 0 / 1000")

local function UpdateXPBar(currentXP, maxXP)
    currentXP = tonumber(currentXP) or 0
    maxXP = tonumber(maxXP) or 1
    XPBar:SetMinMaxValues(0, maxXP)
    XPBar:SetValue(currentXP)
    XPBarText:SetText("Guild XP: " .. tostring(currentXP) .. " / " .. tostring(maxXP))
end

local LeftSubWindow = CreateFrame("Frame", "LeftSubWindow", UIParent)
LeftSubWindow:SetSize(320, 200)
LeftSubWindow:SetPoint("TOPRIGHT", MainFrame, "TOPLEFT", 5, 0)

LeftSubWindow:SetBackdrop({
    bgFile = "Interface/test/GuildWars_SubLeftBG.blp",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
LeftSubWindow:SetBackdropColor(0.3, 0.3, 0.3, 1)
LeftSubWindow:SetBackdropBorderColor(1, 1, 1, 1)
LeftSubWindow:Hide()

local LeftSubWindowTitleBar = CreateFrame("Frame", nil, LeftSubWindow)
LeftSubWindowTitleBar:SetSize(225, 35)
LeftSubWindowTitleBar:SetPoint("TOP", LeftSubWindow, "TOP", 0, 18)

LeftSubWindowTitleBar:SetBackdrop({
    bgFile = "Interface/test/GuildWars_BarBG1.blp",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16
})
LeftSubWindowTitleBar:SetBackdropColor(0.3, 0.3, 0.3, 1)
LeftSubWindowTitleBar:SetBackdropBorderColor(1, 1, 1, 1)

local LeftSubWindowTitleText = LeftSubWindowTitleBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
LeftSubWindowTitleText:SetPoint("CENTER", LeftSubWindowTitleBar, "CENTER", 0, 0)
LeftSubWindowTitleText:SetText("Dreamweaver's")
LeftSubWindowTitleText:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
LeftSubWindowTitleText:SetTextColor(1, 0.82, 0)

local RightSubWindow = CreateFrame("Frame", "RightSubWindow", UIParent)
RightSubWindow:SetSize(320, 200)
RightSubWindow:SetPoint("TOPLEFT", MainFrame, "TOPRIGHT", -5, 0)

RightSubWindow:SetBackdrop({
    bgFile = "Interface/test/GuildWars_SubRightBG",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
RightSubWindow:SetBackdropColor(0.4, 0.4, 0.4, 1)
RightSubWindow:SetBackdropBorderColor(1, 1, 1, 1)
RightSubWindow:Hide()

local RightSubWindowTitleBar = CreateFrame("Frame", nil, RightSubWindow)
RightSubWindowTitleBar:SetSize(225, 35)
RightSubWindowTitleBar:SetPoint("TOP", RightSubWindow, "TOP", 0, 18)

RightSubWindowTitleBar:SetBackdrop({
    bgFile = "Interface/test/GuildWars_BarBG1.blp",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16
})
RightSubWindowTitleBar:SetBackdropColor(0.3, 0.3, 0.3, 1)
RightSubWindowTitleBar:SetBackdropBorderColor(1, 1, 1, 1)

local RightSubWindowTitleText = RightSubWindowTitleBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
RightSubWindowTitleText:SetPoint("CENTER", RightSubWindowTitleBar, "CENTER", 0, 0)
RightSubWindowTitleText:SetText("Echoes of Fear")
RightSubWindowTitleText:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
RightSubWindowTitleText:SetTextColor(1, 0.82, 0)

local function CreateIcon(parent, texturePath, tooltipText, xOffset, isRight)
    local icon = CreateFrame("Button", nil, parent)
    icon:SetSize(48, 48)
    if isRight then
        icon:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -xOffset, -175)
    else
        icon:SetPoint("TOPLEFT", xOffset, -175)
    end
    local iconTexture = icon:CreateTexture(nil, "ARTWORK")
    iconTexture:SetAllPoints()
    iconTexture:SetTexture(texturePath)
    icon:SetScript("OnEnter", function()
        GameTooltip:SetOwner(icon, "ANCHOR_RIGHT")
        GameTooltip:SetText(tooltipText, 1, 1, 1, true)
        GameTooltip:Show()
    end)
    icon:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    return icon
end

local function CreateDescriptionText(parent, descriptionText)
    local description = parent:CreateFontString(nil, "OVERLAY")
    description:SetFont("Fonts\\FRIZQT__.TTF", 12)
    description:SetPoint("TOPLEFT", 20, -30)
    description:SetWidth(285)
    description:SetJustifyH("LEFT")
    description:SetWordWrap(true)
    description:SetTextColor(1, 0.9, 0.6)
    description:SetText(descriptionText)
    return description
end

CreateDescriptionText(LeftSubWindow, 
    "The Dreamweavers are protectors of the mystical realm of dreams, where they shape hope and serenity.\n\n" ..
    "Guardians of the fragile balance between reality and the dreamscape, they harness the power of dreams to heal, guide, and inspire.\n\n" ..
    " Their mission is to defend the waking world from corruption, ensuring the peace of both worlds is maintained.\n" 
)
CreateIcon(LeftSubWindow, "Interface/Icons/Spell_Frost_IceStorm.blp", "First Left Icon Tooltip", 40)
CreateIcon(LeftSubWindow, "Interface/Icons/Ability_Warrior_ShieldWall.blp", "Second Left Icon Tooltip", 100)
CreateIcon(LeftSubWindow, "Interface/Icons/Ability_BackStab.blp", "Third Left Icon Tooltip", 160)

CreateDescriptionText(RightSubWindow, 
    "In the darkest corners of the world, the Echoes of Fear thrive on terror and chaos.\n\n" ..
    "Born from the whispers of forgotten nightmares, they wield fear as a weapon,\n" ..
    "turning the darkest fears of their enemies into reality.\n\n" ..
    "Their goal is to plunge the world into eternal night, where only the strong can survive.\n"
)
CreateIcon(RightSubWindow, "Interface/Icons/Ability_Mage_FrostFireBolt.blp", "Basic Bonus:\n\n- Travel Speed +3%\n- Earn 5 Gold Daily\n- Event Entry Ticket +1\n", 40, true)
CreateIcon(RightSubWindow, "Interface/Icons/Spell_Holy_HolyBolt.blp", "Epic Bonus:\n\n- Spell Power +50\n- Attack Speed +5%\n- Crafting Materials +10%\n", 100, true)
CreateIcon(RightSubWindow, "Interface/Icons/Spell_Frost_FrostArmor.blp", "Legendary Bonus:\n\n- Magic Damage +100\n- Free Teleports to Major Cities\n- Double Event Tickets\n", 160, true)

local function CreateJoinButton(parent, isRight)
    local joinButton = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    joinButton:SetSize(100, 30)
    joinButton:SetText("Join")
    if isRight then
        joinButton:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -210, -15)
    else
        joinButton:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 210, -15)
    end
    joinButton:SetScript("OnClick", function()
        print("Join button clicked on " .. (isRight and "Echoes of Fear" or "Dreamweaver's"))
    end)
    return joinButton
end

CreateJoinButton(LeftSubWindow, false)
CreateJoinButton(RightSubWindow, true)

local ToggleSubWindowButton = CreateFrame("Button", "ToggleSubWindowButton", MainFrame, "UIPanelButtonTemplate")
ToggleSubWindowButton:SetSize(100, 20)
ToggleSubWindowButton:SetPoint("BOTTOMLEFT", MainFrame, "BOTTOMLEFT", 365, 15)
ToggleSubWindowButton:SetText("Pick a Guild")

local function ToggleSubWindows()
    if LeftSubWindow:IsShown() and RightSubWindow:IsShown() then
        LeftSubWindow:Hide()
        RightSubWindow:Hide()
        ToggleSubWindowButton:SetText("Pick a Guild")
    else
        LeftSubWindow:Show()
        RightSubWindow:Show()
        ToggleSubWindowButton:SetText("Close")
    end
end

ToggleSubWindowButton:SetScript("OnClick", ToggleSubWindows)

function GuildWarsHandlers.UpdateXP(currentXP, maxXP)
    UpdateXPBar(currentXP, maxXP)
    MainFrame:Show()
end

