-- ProdigyAuras - FrameManager.lua
-- Manages the creation and properties of UI frames.
-- WoW Version 11.1.5

ProdigyAuras = ProdigyAuras or {}
local addon = ProdigyAuras

addon.frames = addon.frames or {} -- Namespace for our frames

function addon:CreateTestFrame()
    if addon.frames.testFrame then
        self:UpdateTestFrameFromSettings() -- Ensure it's up-to-date if already exists
        return
    end

    local frame = CreateFrame("Frame", "ProdigyAurasTestFrame", UIParent)
    -- ... (resto de la configuración del frame: SetSize, SetFrameStrata, scripts OnMouseDown/Up, etc. SIN CAMBIOS) ...
    frame:SetSize(50, 50)
    frame:SetFrameStrata("MEDIUM")
    frame:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            self:StartMoving()
        end
    end)
    frame:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" then
            self:StopMovingOrSizing()
            local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
            local newX = xOfs
            local newY = yOfs
            if relativeTo ~= UIParent or relativePoint ~= "CENTER" then
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

    local texture = frame:CreateTexture(nil, "BACKGROUND")
    texture:SetAllPoints(true)
    texture:SetColorTexture(0.1, 0.8, 0.1, 0.8) -- Greenish, semi-transparent

    frame.texture = texture
    addon.frames.testFrame = frame
    self:DebugPrint("L_TEST_FRAME_CREATED")

    self:UpdateTestFrameFromSettings() -- Call update which will now also handle the icon
end

function addon:UpdateTestFrameFromSettings()
    if not addon.frames.testFrame then return end

    local frame = addon.frames.testFrame
    local isEnabled = addon:GetSetting("enabled")
    local showHelper = addon:GetSetting("showRotationHelper")
    local scale = addon:GetSetting("iconScale") -- This scale is for the main frame, icons will use their own
    local alpha = addon:GetSetting("iconAlpha") -- This alpha is for the main frame
    local position = addon:GetSetting("position")

    if isEnabled and showHelper then
        frame:Show()
    else
        frame:Hide()
    end
    -- No es necesario un DebugPrint aquí ya que CreateTestFrame y ToggleTestFrame ya lo hacen

    frame:SetScale(1.0) -- The main test frame itself might not need scaling from iconScale
                        -- Or, if it does, iconScale might need to be re-evaluated.
                        -- For now, let's assume iconScale is for icons *within* frames.
    frame:SetAlpha(alpha or 1.0) -- Use iconAlpha for the main frame's transparency for now.

    if position and type(position.x) == "number" and type(position.y) == "number" then
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", UIParent, "CENTER", position.x, position.y)
    else
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
    end

    -- >>> NUEVA LÍNEA: Crear/Actualizar el icono de prueba dentro del TestFrame <<<
    if addon.CreateTestDisplayIcon and (isEnabled and showHelper) then
        addon:CreateTestDisplayIcon(frame) -- Pass the testFrame as parent
    elseif addon.icons and addon.icons["TestSpellIcon1"] then
         -- If frame is hidden, also hide the icon if it exists
        addon.icons["TestSpellIcon1"]:Hide()
    end
    
    -- If settings change (e.g. scale/alpha), ensure existing icons are updated
    if addon.icons then
        for _, iconObj in pairs(addon.icons) do
            if iconObj.ApplySettings then
                 iconObj:ApplySettings()
            end
        end
    end
end

-- Function to toggle the visibility of the test frame via settings
function addon:ToggleTestFrame()
    if not ProdigyAurasDB or not ProdigyAurasDB.profile then
        self:DebugPrint("LOC_ERR: Profile DB not initialized for ToggleTestFrame")
        return
    end

    local currentVisibility = self:GetSetting("showRotationHelper")
    local newVisibility = not currentVisibility
    self:SetSetting("showRotationHelper", newVisibility)

    if newVisibility then
        self:DebugPrint("L_CMD_TOGGLEFRAME_ENABLED")
    else
        self:DebugPrint("L_CMD_TOGGLEFRAME_DISABLED")
    end
    self:DebugPrint("L_TEST_FRAME_VISIBILITY_UPDATED", tostring(newVisibility))


    self:UpdateTestFrameFromSettings() -- Update frame based on new setting
end

addon:DebugPrint("L_FRAMEMANAGER_LOADED")