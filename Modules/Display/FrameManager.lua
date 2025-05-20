-- ProdigyAuras - FrameManager.lua
-- Manages the creation and properties of UI frames.
-- WoW Version 11.1.5

ProdigyAuras = ProdigyAuras or {}
local addon = ProdigyAuras

addon.frames = addon.frames or {} -- Namespace for our frames

function addon:CreateTestFrame()
    if addon.frames.testFrame then return end -- Don't create if it already exists

    local frame = CreateFrame("Frame", "ProdigyAurasTestFrame", UIParent)
    frame:SetSize(50, 50) -- Default size, scale will modify this
    frame:SetFrameStrata("MEDIUM")
    frame:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            self:StartMoving()
        end
    end)
    frame:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" then
            self:StopMovingOrSizing()
            -- Save new position
            local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
            -- We want to save coordinates relative to center of screen for simplicity
            local newX = xOfs
            local newY = yOfs
            if relativeTo ~= UIParent or relativePoint ~= "CENTER" then
                 -- If not anchored to UIParent center, convert. This is a simplified example.
                 -- A more robust solution would handle different anchors or use GetCenter().
                local uiParentWidth = UIParent:GetWidth()
                local uiParentHeight = UIParent:GetHeight()
                local frameCenterX, frameCenterY = self:GetCenter()
                newX = frameCenterX - (uiParentWidth / 2)
                newY = frameCenterY - (uiParentHeight / 2)
            end
            
            addon:SetSetting("position", { x = newX, y = newY })
            addon:DebugPrint("L_TEST_FRAME_POSITION_UPDATED")
        end
    end)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    -- frame:RegisterForDrag("LeftButton") -- Covered by OnMouseDown/Up for simple move

    local texture = frame:CreateTexture(nil, "BACKGROUND")
    texture:SetAllPoints(true)
    texture:SetColorTexture(0.1, 0.8, 0.1, 0.8) -- Greenish, semi-transparent

    frame.texture = texture -- Store reference if needed
    addon.frames.testFrame = frame
    self:DebugPrint("L_TEST_FRAME_CREATED")

    self:UpdateTestFrameFromSettings()
end

function addon:UpdateTestFrameFromSettings()
    if not addon.frames.testFrame then return end

    local frame = addon.frames.testFrame
    local isEnabled = addon:GetSetting("enabled") -- Overall addon enabled state
    local showHelper = addon:GetSetting("showRotationHelper") -- Specific setting for this frame/group
    local scale = addon:GetSetting("iconScale")
    local alpha = addon:GetSetting("iconAlpha") -- Not used yet, but good to have
    local position = addon:GetSetting("position")

    if isEnabled and showHelper then
        frame:Show()
    else
        frame:Hide()
    end
    self:DebugPrint("L_TEST_FRAME_VISIBILITY_UPDATED", tostring(isEnabled and showHelper))

    frame:SetScale(scale or 1.0)
    frame:SetAlpha(alpha or 1.0)

    -- Set position (relative to center of UIParent)
    if position and type(position.x) == "number" and type(position.y) == "number" then
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", UIParent, "CENTER", position.x, position.y)
    else
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 200) -- Default fallback
    end
end

-- Function to toggle the visibility of the test frame via settings
function addon:ToggleTestFrame()
    if not ProdigyAurasDB or not ProdigyAurasDB.profile then
        self:DebugPrint("LOC_ERR: Profile DB not initialized for ToggleTestFrame") -- Add loc key if needed
        return
    end

    local currentVisibility = self:GetSetting("showRotationHelper")
    local newVisibility = not currentVisibility
    self:SetSetting("showRotationHelper", newVisibility) -- Save the new state

    if newVisibility then
        self:DebugPrint("L_CMD_TOGGLEFRAME_ENABLED")
    else
        self:DebugPrint("L_CMD_TOGGLEFRAME_DISABLED")
    end

    self:UpdateTestFrameFromSettings() -- Update frame based on new setting
end

addon:DebugPrint("L_FRAMEMANAGER_LOADED")