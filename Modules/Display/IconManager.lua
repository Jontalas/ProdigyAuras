-- ProdigyAuras - IconManager.lua
-- Manages the creation and display of spell icons.
-- WoW Version 11.1.5

ProdigyAuras = ProdigyAuras or {}
local addon = ProdigyAuras
addon.icons = addon.icons or {} -- Namespace for our icon objects

local ICON_SIZE = 36 -- Default size of the icon before scaling

-- Creates and returns a new icon object
-- parentFrame: The frame this icon will be a child of
-- spellID: The spell ID to display (can be nil initially)
-- position: Table { point = "CENTER", relativeTo = parentFrame, relativePoint = "CENTER", xOfs = 0, yOfs = 0 }
function addon:CreateIconObject(name, parentFrame, spellID, position)
    local iconFrameName = "ProdigyAurasIcon_" .. name
    if _G[iconFrameName] then -- Check if frame with this name already exists
        addon:DebugPrint("LOC_ERR: Icon frame already exists: " .. iconFrameName) -- Add loc key if needed
        return _G[iconFrameName] -- Return existing if duplicate name, though ideally names are unique
    end

    local icon = CreateFrame("Button", iconFrameName, parentFrame) -- Button for potential clicks
    icon:SetSize(ICON_SIZE, ICON_SIZE) -- Base size, scale will be applied
    icon.spellID = spellID

    -- Texture for the spell icon
    icon.texture = icon:CreateTexture(nil, "ARTWORK")
    icon.texture:SetAllPoints(true)

    -- Cooldown spiral
    icon.cooldown = CreateFrame("Cooldown", iconFrameName .. "Cooldown", icon, "CooldownFrameTemplate")
    icon.cooldown:SetAllPoints(true)
    icon.cooldown:SetHideCountdownNumbers(true) -- We'll use our own text for consistency

    -- Text for stack count
    icon.stackText = icon:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    icon.stackText:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -2, 2)
    icon.stackText:SetJustifyH("RIGHT")
    icon.stackText:SetText("")

    -- Text for keybind
    icon.keybindText = icon:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    icon.keybindText:SetPoint("TOPLEFT", icon, "TOPLEFT", 2, -2)
    icon.keybindText:SetJustifyH("LEFT")
    icon.keybindText:SetText("")
    
    -- Text for cooldown count (optional, if you want numbers separate from spiral)
    icon.cooldownText = icon:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    icon.cooldownText:SetPoint("CENTER", 0, 0)
    icon.cooldownText:SetText("")


    -- Function to update the icon's visual based on spellID, cooldown, stacks
    function icon:Update(newSpellID, startTime, duration, stacks, keybind)
        self.spellID = newSpellID
        if self.spellID then
            local texturePath = C_Spell.GetSpellTexture(self.spellID)
            if texturePath then
                self.texture:SetTexture(texturePath)
            else
                self.texture:SetTexture(nil) -- Clear texture if spell not found
                addon:DebugPrint("LOC_WARN: No texture found for spell ID: " .. tostring(self.spellID)) -- Add loc key
            end
            self:Show()
        else
            self.texture:SetTexture(nil)
            self:Hide() -- Hide if no spell ID
        end

        if startTime and duration and duration > 0 then
            CooldownFrame_Set(self.cooldown, startTime, duration, 1, true) -- Show cooldown
            self.cooldown:Show()
        else
            self.cooldown:Hide()
        end

        if stacks and stacks > 1 then
            self.stackText:SetText(stacks)
            self.stackText:Show()
        else
            self.stackText:Hide()
        end

        if keybind and keybind ~= "" then
            self.keybindText:SetText(keybind)
            self.keybindText:Show()
        else
            self.keybindText:Hide()
        end
        
        -- addon:DebugPrint("L_ICON_UPDATED", tostring(self.spellID)) -- Can be spammy
    end

    -- Apply settings like scale and alpha
    function icon:ApplySettings()
        local scale = addon:GetSetting("iconScale") or 1.0
        local alpha = addon:GetSetting("iconAlpha") or 1.0
        self:SetScale(scale)
        self:SetAlpha(alpha)
    end

    -- Initial setup
    if position then
        icon:SetPoint(position.point, position.relativeTo, position.relativePoint, position.xOfs, position.yOfs)
    else
        icon:SetPoint("CENTER", parentFrame, "CENTER", 0, 0) -- Default to center of parent
    end

    icon:Update(spellID) -- Initial texture set
    icon:ApplySettings() -- Apply scale/alpha from settings

    addon.icons[name] = icon -- Store it
    return icon
end

-- Example function to create a test icon (e.g., Fireball - Spell ID 133)
function addon:CreateTestDisplayIcon(parentFrame)
    if not parentFrame then
        addon:DebugPrint("LOC_ERR: Parent frame not provided for test icon.") -- Add loc key
        return
    end

    -- Check if test icon already exists to prevent duplicates on multiple calls
    if addon.icons["TestSpellIcon1"] then
        addon.icons["TestSpellIcon1"]:ApplySettings() -- Re-apply settings if it exists
        return addon.icons["TestSpellIcon1"]
    end
    
    local testSpellID = 133 -- Fireball
    -- Position it in the center of the parent frame (which is ProdigyAurasTestFrame)
    local iconPos = { point = "CENTER", relativeTo = parentFrame, relativePoint = "CENTER", xOfs = 0, yOfs = 0 }
    
    local testIcon = self:CreateIconObject("TestSpellIcon1", parentFrame, testSpellID, iconPos)
    
    if testIcon then
        self:DebugPrint("L_TEST_ICON_CREATED", tostring(testSpellID))
        -- Example of setting a cooldown (starts a 5s cooldown that began 2s ago)
        -- testIcon:Update(testSpellID, GetTime() - 2, 5, 3, "1") -- Spell, StartTime, Duration, Stacks, Keybind
    end
    return testIcon
end

addon:DebugPrint("L_ICONMANAGER_LOADED")