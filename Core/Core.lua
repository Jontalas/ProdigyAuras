-- ProdigyAuras - Core.lua
-- Author: Jontalas
-- Version: 0.1.0

-- Create the main addon table if it doesn't exist
ProdigyAuras = ProdigyAuras or {}
local addon = ProdigyAuras
local addonName = "ProdigyAuras" -- Store addon name locally for convenience

-- Fetch metadata (can be expanded in Config.lua or Utils.lua later)
addon.version = GetAddOnMetadata(addonName, "Version") or "0.1.0"
addon.author = GetAddOnMetadata(addonName, "Author") or "Jontalas"
addon.title = GetAddOnMetadata(addonName, "Title") or addonName

-- Simple debug print function (can be moved to Utils.lua and enhanced)
local function DebugPrint(message)
    print(addon.title .. ": " .. tostring(message))
end
addon.DebugPrint = DebugPrint -- Make it accessible from other files if needed

-- Event handler function for ADDON_LOADED
local function OnAddOnLoaded(self, event, loadedAddonName)
    if loadedAddonName == addonName then
        DebugPrint("Addon cargado. Versión: " .. addon.version)
        DebugPrint("Bienvenido a " .. addon.title .. "! Escribe /pa o /prodigyauras para comandos.")
        
        -- Unregister the event after it's fired for our addon
        self:UnregisterEvent("ADDON_LOADED")
    end
end

-- Function to initialize the addon (called on PLAYER_LOGIN)
function addon:Initialize()
    DebugPrint("Inicializando " .. addon.title .. "...")
    -- Initialize other modules here in the future
end

-- Function to enable the addon (called after Initialize)
function addon:Enable()
    DebugPrint("Habilitando " .. addon.title .. "...")
    
    -- Create a frame to handle ADDON_LOADED for our specific addon
    local loadFrame = CreateFrame("Frame")
    loadFrame:RegisterEvent("ADDON_LOADED")
    loadFrame:SetScript("OnEvent", OnAddOnLoaded)
    
    -- Register slash commands
    SLASH_PRODIGYAURAS1 = "/prodigyauras"
    SLASH_PRODIGYAURAS2 = "/pa"
    SlashCmdList["PRODIGYAURAS"] = function(msg, editBox) -- Note the correct table for SlashCmdList
        msg = string.lower(msg or "") -- Ensure msg is a string and lowercase
        if msg == "test" then
            DebugPrint("Comando de prueba recibido!")
        elseif msg == "config" then
            DebugPrint("Abriendo configuración (aún no implementado)...")
            -- Future: Code to open config panel will go here
        elseif msg == "version" then
            DebugPrint("Versión actual: " .. addon.version)
        else
            DebugPrint("Comando desconocido. Comandos disponibles: /pa test, /pa config, /pa version")
        end
    end
    
    DebugPrint(self.title .. " habilitado.")
end

-- Main addon loading sequence
local mainFrame = CreateFrame("Frame")
mainFrame:RegisterEvent("PLAYER_LOGIN")
mainFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        -- Initialize and Enable the addon
        addon:Initialize()
        addon:Enable()
        
        -- Unregister PLAYER_LOGIN after first login to prevent re-initialization on /reload
        -- unless explicitly needed for some re-initialization logic.
        self:UnregisterEvent("PLAYER_LOGIN")
    end
end)

DebugPrint("Core.lua cargado.")