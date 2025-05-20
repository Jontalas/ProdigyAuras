-- ProdigyAuras - Config.lua
-- Handles configuration, profiles, and SavedVariables
-- WoW Version 11.1.5

ProdigyAuras = ProdigyAuras or {}
local addon = ProdigyAuras
-- local ADDON_NAME = "ProdigyAuras" -- No longer needed directly here for DebugPrint prefix

addon.defaultSettings = {
    global = {
        firstRun = true,
    },
    profile = {
        enabled = true,
        showRotationHelper = true,
        iconScale = 1.0,
        iconAlpha = 1.0,
        position = { x = 0, y = 200 },
    }
}

ProdigyAurasDB = ProdigyAurasDB or {}

function addon:InitializeDB()
    if not ProdigyAurasDB.global then
        ProdigyAurasDB.global = {}
        for k, v in pairs(self.defaultSettings.global) do
            ProdigyAurasDB.global[k] = v
        end
        self:DebugPrint("L_GLOBAL_SETTINGS_INITIALIZED")
    end

    if not ProdigyAurasDB.profile then
        ProdigyAurasDB.profile = {}
        for k, v in pairs(self.defaultSettings.profile) do
            if type(v) == "table" then
                ProdigyAurasDB.profile[k] = self:DeepCopyTable(v)
            else
                ProdigyAurasDB.profile[k] = v
            end
        end
        self:DebugPrint("L_PROFILE_SETTINGS_INITIALIZED")
        ProdigyAurasDB.global.firstRun = false
    else
        for k, v in pairs(self.defaultSettings.profile) do
            if ProdigyAurasDB.profile[k] == nil then
                if type(v) == "table" then
                    ProdigyAurasDB.profile[k] = self:DeepCopyTable(v)
                else
                    ProdigyAurasDB.profile[k] = v
                end
                self:DebugPrint("L_PROFILE_SETTING_ADDED", k)
            end
        end
    end
    self:DebugPrint("L_DB_INITIALIZED", tostring(self:GetSetting("enabled", true)))
end

function addon:DeepCopyTable(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[self:DeepCopyTable(orig_key)] = self:DeepCopyTable(orig_value)
        end
        setmetatable(copy, self:DeepCopyTable(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

function addon:GetSetting(key, isProfileSetting)
    isProfileSetting = (isProfileSetting == nil) and true or isProfileSetting

    if isProfileSetting then
        if ProdigyAurasDB.profile and ProdigyAurasDB.profile[key] ~= nil then
            return ProdigyAurasDB.profile[key]
        elseif self.defaultSettings.profile[key] ~= nil then
            return self.defaultSettings.profile[key]
        end
    else
        if ProdigyAurasDB.global and ProdigyAurasDB.global[key] ~= nil then
            return ProdigyAurasDB.global[key]
        elseif self.defaultSettings.global[key] ~= nil then
            return self.defaultSettings.global[key]
        end
    end
    self:DebugPrint("L_WARN_SETTING_NOT_FOUND", key)
    return nil
end

function addon:SetSetting(key, value, isProfileSetting)
    isProfileSetting = (isProfileSetting == nil) and true or isProfileSetting

    if isProfileSetting then
        if not ProdigyAurasDB.profile then ProdigyAurasDB.profile = {} end
        ProdigyAurasDB.profile[key] = value
        self:DebugPrint("L_PROFILE_SETTING_SET", key, tostring(value))
    else
        if not ProdigyAurasDB.global then ProdigyAurasDB.global = {} end
        ProdigyAurasDB.global[key] = value
        self:DebugPrint("L_GLOBAL_SETTING_SET", key, tostring(value))
    end
end

addon:DebugPrint("L_CONFIG_LOADED")