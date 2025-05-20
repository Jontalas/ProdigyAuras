-- ProdigyAuras - Config.lua
-- Handles configuration, profiles, and SavedVariables
-- WoW Version 11.1.5

ProdigyAuras = ProdigyAuras or {}
local addon = ProdigyAuras
local ADDON_NAME = "ProdigyAuras"

-- This table will hold the default settings for the addon.
-- We'll structure it thinking about future options.
addon.defaultSettings = {
    global = { -- Settings that apply across all characters
        firstRun = true,
        -- exampleGlobalSetting = "defaultValue",
    },
    profile = { -- Settings that can be character-specific or profile-specific
        enabled = true,
        showRotationHelper = true,
        iconScale = 1.0,
        iconAlpha = 1.0,
        -- exampleProfileSetting = 123,
        position = { x = 0, y = 200 }, -- Default position for main display elements
    }
}

-- This is our main database table, declared in ProdigyAuras.toc as ## SavedVariables: ProdigyAurasDB
-- WoW will automatically save this table's contents for us.
-- We will initialize it as character-specific by default.
ProdigyAurasDB = ProdigyAurasDB or {}

-- Function to initialize the character's settings if they don't exist
function addon:InitializeDB()
    if not ProdigyAurasDB.global then
        ProdigyAurasDB.global = {}
        -- Deep copy default global settings
        for k, v in pairs(self.defaultSettings.global) do
            ProdigyAurasDB.global[k] = v
        end
        self:DebugPrint("Global settings initialized with defaults.")
    end

    -- For character-specific settings, we'll store them under a key, e.g., character's name.
    -- However, WoW's SavedVariables can be set to be "per character" directly in the .toc
    -- by using ## SavedVariablesPerCharacter: ProdigyAurasDB_Character
    -- For simplicity now, we'll assume ProdigyAurasDB itself is loaded per character if
    -- that's the desired default. If it's global, we need a sub-table for current char.

    -- Let's assume ProdigyAurasDB is loaded per-character by default in modern WoW if not specified as global.
    -- If it's the first time for this character (or settings are wiped):
    if not ProdigyAurasDB.profile then
        ProdigyAurasDB.profile = {}
        -- Deep copy default profile settings
        for k, v in pairs(self.defaultSettings.profile) do
            if type(v) == "table" then
                ProdigyAurasDB.profile[k] = self:DeepCopyTable(v) -- Need a deep copy for tables
            else
                ProdigyAurasDB.profile[k] = v
            end
        end
        self:DebugPrint("Profile settings for this character initialized with defaults.")
        ProdigyAurasDB.global.firstRun = false -- Mark that at least one profile has been set up.
    else
        -- Ensure all default keys exist in the current profile (for when new settings are added)
        for k, v in pairs(self.defaultSettings.profile) do
            if ProdigyAurasDB.profile[k] == nil then
                if type(v) == "table" then
                    ProdigyAurasDB.profile[k] = self:DeepCopyTable(v)
                else
                    ProdigyAurasDB.profile[k] = v
                end
                self:DebugPrint("Added missing default setting '" .. k .. "' to current profile.")
            end
        end
    end
    self:DebugPrint("Database initialized. Addon Enabled: " .. tostring(self:GetSetting("enabled", true))) -- true for profile setting
end

-- Utility for deep copying a table (important for default settings)
function addon:DeepCopyTable(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[self:DeepCopyTable(orig_key)] = self:DeepCopyTable(orig_value)
        end
        setmetatable(copy, self:DeepCopyTable(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- Function to get a setting value
-- Takes the setting name and an optional boolean 'isProfileSetting' (defaults to true)
function addon:GetSetting(key, isProfileSetting)
    isProfileSetting = (isProfileSetting == nil) and true or isProfileSetting -- Default to profile setting

    if isProfileSetting then
        if ProdigyAurasDB.profile and ProdigyAurasDB.profile[key] ~= nil then
            return ProdigyAurasDB.profile[key]
        elseif self.defaultSettings.profile[key] ~= nil then
            return self.defaultSettings.profile[key] -- Fallback to default if not in DB
        end
    else -- Global setting
        if ProdigyAurasDB.global and ProdigyAurasDB.global[key] ~= nil then
            return ProdigyAurasDB.global[key]
        elseif self.defaultSettings.global[key] ~= nil then
            return self.defaultSettings.global[key] -- Fallback to default
        end
    end
    self:DebugPrint("Warning: Setting '" .. key .. "' not found in DB or defaults.")
    return nil -- Setting not found
end

-- Function to set a setting value
-- Takes the setting name, its value, and an optional boolean 'isProfileSetting'
function addon:SetSetting(key, value, isProfileSetting)
    isProfileSetting = (isProfileSetting == nil) and true or isProfileSetting

    if isProfileSetting then
        if not ProdigyAurasDB.profile then ProdigyAurasDB.profile = {} end -- Ensure profile table exists
        ProdigyAurasDB.profile[key] = value
        self:DebugPrint("Profile setting '" .. key .. "' set to: " .. tostring(value))
    else -- Global setting
        if not ProdigyAurasDB.global then ProdigyAurasDB.global = {} end -- Ensure global table exists
        ProdigyAurasDB.global[key] = value
        self:DebugPrint("Global setting '" .. key .. "' set to: " .. tostring(value))
    end
end

addon:DebugPrint("Config.lua cargado.")