-- ProdigyAuras - Core.lua
-- Author: Jontalas
-- Designed for WoW Version 11.1.5 (Interface 110100)

ProdigyAuras = ProdigyAuras or {}
local addon = ProdigyAuras
local ADDON_NAME = "ProdigyAuras"

-- Localization Setup
addon.currentLocale = GetLocale()
addon.defaultLocale = "enUS" -- <<< CHANGED: Default locale is now English
addon.L_DATA = addon.L_DATA or {} -- This should be populated by Locale files

function addon:L(key, ...)
    local langDataToUse -- This will hold the chosen language's data table

    -- 1. Try the game's current locale if we have a translation for it (e.g., esES)
    if self.L_DATA[self.currentLocale] then
        langDataToUse = self.L_DATA[self.currentLocale]
    else
        -- 2. Otherwise, fall back to our defined default locale (which is now enUS)
        langDataToUse = self.L_DATA[self.defaultLocale]
    end

    -- 3. Ensure langDataToUse is a table, even if a locale file was somehow missing
    langDataToUse = langDataToUse or {}

    local localizedString = langDataToUse[key]

    if localizedString then
        if select("#", ...) > 0 then
            return string.format(localizedString, ...)
        else
            return localizedString
        end
    else
        -- If the key is STILL not found (i.e., missing from the chosen langData),
        -- then it's a genuine missing localization key.
        return "LOC_ERR: " .. key 
    end
end

-- Initialize basic properties
addon.title = ADDON_NAME
addon.version = "0.0.0-pre"
addon.author = "Jontalas"
addon.isInitialized = false
addon.isEnabled = false
addon.metadataInitialized = false

-- Debug print function (its logic for deciding to localize or print raw remains the same)
function addon:DebugPrint(messageKey, ...)
    if self.L_DATA and (self.L_DATA[self.currentLocale] and self.L_DATA[self.currentLocale][messageKey] or 
                       self.L_DATA[self.defaultLocale] and self.L_DATA[self.defaultLocale][messageKey]) then 
                       -- Note: The check for self.L_DATA["enUS"] specifically is covered if defaultLocale is enUS
        print(ADDON_NAME .. ": " .. self:L(messageKey, ...))
    else
        print(ADDON_NAME .. ": " .. tostring(messageKey)) 
    end
end


local function InitializeMetadata()
    if addon.metadataInitialized then return end

    local getMetadataFunc
    if C_AddOns and C_AddOns.GetAddOnMetadata then
        getMetadataFunc = C_AddOns.GetAddOnMetadata
    else
        getMetadataFunc = GetAddOnMetadata 
        addon:DebugPrint("L_WARN_C_ADDONS_NOT_FOUND", "11.1.5") -- Uses self:L, which respects new default
    end

    if not getMetadataFunc then
        addon:DebugPrint("L_ERR_NO_GETMETADATA_FUNC")
        addon.metadataInitialized = true
        return
    end

    local successVersion, versionOrError = pcall(getMetadataFunc, ADDON_NAME, "Version")
    local successTitle, titleOrError = pcall(getMetadataFunc, ADDON_NAME, "Title")
    local successAuthor, authorOrError = pcall(getMetadataFunc, ADDON_NAME, "Author")

    if successVersion and versionOrError then
        addon.version = versionOrError
    else
        addon:DebugPrint("L_WARN_GET_VERSION_FAILED")
        if not successVersion then addon:DebugPrint("L_PCALL_ERROR", "Version", tostring(versionOrError)) end
    end

    if successTitle and titleOrError then
        addon.title = titleOrError
    else
        addon:DebugPrint("L_WARN_GET_TITLE_FAILED")
        if not successTitle then addon:DebugPrint("L_PCALL_ERROR", "Title", tostring(titleOrError)) end
    end
    
    if successAuthor and authorOrError then
        addon.author = authorOrError
    else
        addon:DebugPrint("L_WARN_GET_AUTHOR_FAILED")
         if not successAuthor then addon:DebugPrint("L_PCALL_ERROR", "Author", tostring(authorOrError)) end
    end

    addon:DebugPrint("L_METADATA_INITIALIZED", addon.version)
    addon.metadataInitialized = true
end

function addon:Initialize()
    if self.isInitialized then return end
    self:DebugPrint("L_CORE_LOGIC_INITIALIZING", self.title)
    self.isInitialized = true
    self:DebugPrint("L_CORE_LOGIC_INITIALIZED", self.title)
end

function addon:Enable()
    if self.isEnabled then return end
    self:DebugPrint("L_ENABLING_ADDON", self.title)

    if self.UpdatePlayerInfo then
        self:UpdatePlayerInfo()
    end

    if self.RegisterGameEvents then
        self:RegisterGameEvents()
    end

    if self.CreateTestFrame then -- Ensure FrameManager.lua (and this func) is loaded
        self:CreateTestFrame()
    else
        self:DebugPrint("LOC_ERR: CreateTestFrame function not found.") -- Add loc key if needed
    end

    SLASH_PRODIGYAURAS1 = "/prodigyauras"
    SLASH_PRODIGYAURAS2 = "/pa"
    SlashCmdList["PRODIGYAURAS"] = function(msg, editBox)
        msg = string.lower(msg or "")
        if msg == "test" then
            ProdigyAuras:DebugPrint("L_CMD_TEST_RECEIVED")
            if ProdigyAuras.GetPlayerInfo then
                 ProdigyAuras:DebugPrint("L_CURRENT_CLASS_SPEC_INFO", ProdigyAuras:GetPlayerInfo("className") or "N/A", ProdigyAuras:GetPlayerInfo("specId") or "N/A")
            end
        elseif msg == "config" then
            ProdigyAuras:DebugPrint("L_CMD_CONFIG_WIP")
        elseif msg == "toggleframe" then
            if ProdigyAuras.ToggleTestFrame then
                ProdigyAuras:ToggleTestFrame()
            else
                ProdigyAuras:DebugPrint("LOC_ERR: ToggleTestFrame function not found.") -- Add loc key
            end
        elseif msg == "version" then
            ProdigyAuras:DebugPrint("L_CMD_VERSION_INFO", ProdigyAuras.version, ProdigyAuras.author, ProdigyAuras.title)
        else
            ProdigyAuras:DebugPrint("L_CMD_UNKNOWN")
        end
    end
    
    self:DebugPrint("L_ADDON_ENABLED", self.title)
    self.isEnabled = true
end

local mainFrame = CreateFrame("Frame")
mainFrame:SetScript("OnEvent", function(selfFrame, event, arg1, ...)
    if event == "ADDON_LOADED" then
        if arg1 == ADDON_NAME then
            -- print(ADDON_NAME .. " ADDON_LOADED event for self.")
        end
    elseif event == "PLAYER_ENTERING_WORLD" then 
        if not ProdigyAuras.metadataInitialized then
             InitializeMetadata()
        end

        if ProdigyAuras.InitializeDB then
            ProdigyAuras:InitializeDB()
        end

        if not ProdigyAuras.isInitialized then
            ProdigyAuras:Initialize()
        end
        if not ProdigyAuras.isEnabled then
            ProdigyAuras:Enable()
        end
        
        selfFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end
end)

mainFrame:RegisterEvent("ADDON_LOADED")
mainFrame:RegisterEvent("PLAYER_ENTERING_WORLD")