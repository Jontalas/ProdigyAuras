-- ProdigyAuras - Config.lua
-- Handles configuration, profiles, and SavedVariables

ProdigyAuras = ProdigyAuras or {}
local addon = ProdigyAuras
-- local ADDON_NAME = "ProdigyAuras" -- uncomment if needed

-- Default settings will be defined here
addon.defaults = {
    profile = {
        -- exampleSetting = true,
    }
}

-- This table will hold the per-character or global settings
ProdigyAurasDB = ProdigyAurasDB or {} -- Matches ## SavedVariables in .toc

-- addon:DebugPrint("Config.lua cargado.")