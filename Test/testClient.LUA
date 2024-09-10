-- testCLient.LUA
local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    print("Debug: AIO addon already added, exiting script.")
    return
else
    print("Debug: AIO addon initialized successfully.")
end
-- Add this check at the top to ensure it's not already registered
if ResetInfoHandlers then
    print("Debug: ResetInfoHandlers already exist, skipping re-registration.")
    return
end
-- Register client-side handlers
local ResetInfoHandlers = AIO.AddHandlers("ResetInfo", {})
print("Debug: ResetInfoHandlers registered successfully.")

-- Create a frame for displaying reset information
local ResetInfoFrame = CreateFrame("Frame", "ResetInfoFrame", UIParent)
ResetInfoFrame:SetSize(300, 150)
ResetInfoFrame:SetPoint("CENTER")
ResetInfoFrame:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
ResetInfoFrame:SetBackdropColor(0, 0, 0, 0.8)
ResetInfoFrame:EnableMouse(true)
ResetInfoFrame:SetMovable(true)
ResetInfoFrame:RegisterForDrag("LeftButton")
ResetInfoFrame:SetScript("OnDragStart", ResetInfoFrame.StartMoving)
ResetInfoFrame:SetScript("OnDragStop", ResetInfoFrame.StopMovingOrSizing)
ResetInfoFrame:Hide()
print("Debug: ResetInfoFrame created and initialized successfully.")

-- Title for the frame
ResetInfoFrame.title = ResetInfoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
ResetInfoFrame.title:SetPoint("TOP", ResetInfoFrame, "TOP", 0, -10)
ResetInfoFrame.title:SetText("Reset Information")
print("Debug: Title 'Reset Information' set for the ResetInfoFrame.")

-- Guild Name text
local gwnameText = ResetInfoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
gwnameText:SetPoint("TOPLEFT", ResetInfoFrame, "TOPLEFT", 15, -35)
gwnameText:SetText("Guild Name: Unknown")
print("Debug: Guild Name text field initialized.")

-- Last Reset text
local lastResetText = ResetInfoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
lastResetText:SetPoint("TOPLEFT", ResetInfoFrame, "TOPLEFT", 15, -60)
lastResetText:SetText("Last Reset: Unknown")
print("Debug: Last Reset text field initialized.")

-- Next Reset text
local nextResetText = ResetInfoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
nextResetText:SetPoint("TOPLEFT", ResetInfoFrame, "TOPLEFT", 15, -85)
nextResetText:SetText("Next Reset: Unknown")
print("Debug: Next Reset text field initialized.")

-- Close button
local closeButton = CreateFrame("Button", nil, ResetInfoFrame, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", ResetInfoFrame, "TOPRIGHT", -5, -5)
closeButton:SetScript("OnClick", function()
    print("Debug: Close button clicked. Hiding ResetInfoFrame.")
    ResetInfoFrame:Hide()
end)
print("Debug: Close button initialized.")

function ResetInfoHandlers.ShowAllResetInfo(gwname, last_reset, next_reset)
    -- Debug logs for received data
    print("Client Debug: Received data from server.")
    print("Client Debug: Guild Name: " .. tostring(gwname))
    print("Client Debug: Last Reset: " .. tostring(last_reset))  -- Ensure this is the timestamp
    print("Client Debug: Next Reset: " .. tostring(next_reset))

    -- Force display of received data (no overwriting should occur)
    -- Assign and print each value separately to avoid any overwriting
    gwnameText:SetText("Guild Name: " .. gwname)
    print("Debug: Setting Guild Name Text: " .. gwname)  -- Log UI update

    -- Set the Last Reset text properly
    lastResetText:SetText("Last Reset: " .. last_reset)
    print("Debug: Setting Last Reset Text: " .. last_reset)  -- Log the correct value for Last Reset

    -- Set the Next Reset text properly
    nextResetText:SetText("Next Reset: " .. next_reset)
    print("Debug: Setting Next Reset Text: " .. next_reset)

    -- Ensure that the frame is shown
    local success, err = pcall(function() 
        ResetInfoFrame:Show() 
    end)

    if not success then
        print("Error: Failed to show ResetInfoFrame. Error: " .. tostring(err))
    else
        print("Client Debug: ResetInfoFrame is now visible.")
    end
end
print("Debug: ShowAllResetInfo handler registered successfully.")
