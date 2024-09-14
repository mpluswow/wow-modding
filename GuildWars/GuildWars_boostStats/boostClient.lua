local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

-- Register client-side handlers
local StatBoostHandlers = AIO.AddHandlers("StatBoost", {})

-- Create the minimap icon (initially hidden)
local StatBonusFrame = CreateFrame("Button", "StatBonusFrame", Minimap)
StatBonusFrame:SetSize(24, 24)
StatBonusFrame:SetPoint("TOPLEFT", Avatar, "TOPLEFT", 220, -45)
StatBonusFrame:Hide()  -- Icon is hidden by default

-- Set the icon texture (this can be customized)
StatBonusFrame:SetNormalTexture("Interface\\Icons\\INV_Misc_QuestionMark") -- Replace with a proper icon path

-- Tooltip handling
StatBonusFrame:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:SetText("Stat Bonuses Applied", 1, 1, 1)
    GameTooltip:Show()
end)

StatBonusFrame:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

-- AIO handler to show the icon and update the tooltip with the player's name and stat bonuses
function StatBoostHandlers.ShowStatBonus(playerName, statBonus)
    -- Update the tooltip to show the player's name, followed by the bonuses for each stat
    StatBonusFrame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText(playerName .. " Bonus", 1, 1, 1)  -- Display player's name followed by "Bonus"
        GameTooltip:AddLine("Strength: +" .. statBonus, 0.5, 1, 0.5)
        GameTooltip:AddLine("Agility: +" .. statBonus, 0.5, 1, 0.5)
        GameTooltip:AddLine("Stamina: +" .. statBonus, 0.5, 1, 0.5)
        GameTooltip:AddLine("Intellect: +" .. statBonus, 0.5, 1, 0.5)
        GameTooltip:AddLine("Spirit: +" .. statBonus, 0.5, 1, 0.5)
        GameTooltip:Show()
    end)

    -- Show the icon when the stat bonuses have been applied
    StatBonusFrame:Show()
end
