-- ProdigyAuras - Core.lua
-- Author: Jontalas
-- Designed for WoW Version 11.1.5 (Interface 110100)

ProdigyAuras = ProdigyAuras or {}
local addon = ProdigyAuras
local ADDON_NAME = "ProdigyAuras" -- Must match .toc filename and folder name

-- Initialize basic properties
addon.title = ADDON_NAME
addon.version = "0.0.0-pre"
addon.author = "Jontalas"
addon.isInitialized = false
addon.isEnabled = false
addon.metadataInitialized = false

-- Debug print function
function addon:DebugPrint(message)
    print(ADDON_NAME .. ": " .. tostring(message))
end

local function InitializeMetadata()
    if addon.metadataInitialized then return end

    -- addon:DebugPrint("Attempting to initialize metadata (WoW 11.1.5)...") -- Kept for deeper debugging if needed

    local getMetadataFunc
    if C_AddOns and C_AddOns.GetAddOnMetadata then
        getMetadataFunc = C_AddOns.GetAddOnMetadata
        -- addon:DebugPrint("Using C_AddOns.GetAddOnMetadata.") -- Kept for deeper debugging
    else
        getMetadataFunc = GetAddOnMetadata 
        addon:DebugPrint("Warning: C_AddOns.GetAddOnMetadata not found. Attempting global GetAddOnMetadata (not recommended for 11.1.5).")
    end

    if not getMetadataFunc then
        addon:DebugPrint("Critical Error: No GetAddOnMetadata function available.")
        addon.metadataInitialized = true
        return
    end

    local successVersion, versionOrError = pcall(getMetadataFunc, ADDON_NAME, "Version")
    local successTitle, titleOrError = pcall(getMetadataFunc, ADDON_NAME, "Title")
    local successAuthor, authorOrError = pcall(getMetadataFunc, ADDON_NAME, "Author")

    if successVersion and versionOrError then
        addon.version = versionOrError
    else
        addon:DebugPrint("Warning: Could not retrieve addon Version.")
        if not successVersion then addon:DebugPrint("pcall error (Version): " .. tostring(versionOrError)) end
    end

    if successTitle and titleOrError then
        addon.title = titleOrError
    else
        addon:DebugPrint("Warning: Could not retrieve addon Title.")
        if not successTitle then addon:DebugPrint("pcall error (Title): " .. tostring(titleOrError)) end
    end
    
    if successAuthor and authorOrError then
        addon.author = authorOrError
    else
        addon:DebugPrint("Warning: Could not retrieve addon Author.")
         if not successAuthor then addon:DebugPrint("pcall error (Author): " .. tostring(authorOrError)) end
    end

    addon:DebugPrint("Metadata initialized. Version: " .. addon.version) -- Simplified confirmation
    addon.metadataInitialized = true
end

function addon:Initialize()
    if self.isInitialized then return end
    self:DebugPrint(self.title .. " initializing (core logic)...")
    self.isInitialized = true
    self:DebugPrint(self.title .. " core logic initialized.")
end

function addon:Enable()
    if self.isEnabled then return end
    self:DebugPrint(self.title .. " enabling...")
    
    SLASH_PRODIGYAURAS1 = "/prodigyauras"
    SLASH_PRODIGYAURAS2 = "/pa"
    SlashCmdList["PRODIGYAURAS"] = function(msg, editBox)
        msg = string.lower(msg or "")
        if msg == "test" then
            ProdigyAuras:DebugPrint("Comando de prueba recibido!")
        elseif msg == "config" then
            ProdigyAuras:DebugPrint("Abriendo configuración (aún no implementado)...")
        elseif msg == "version" then
            ProdigyAuras:DebugPrint("Versión: " .. ProdigyAuras.version .. ", Autor: " .. ProdigyAuras.author .. ", Título: " .. ProdigyAuras.title)
        else
            ProdigyAuras:DebugPrint("Comando desconocido. Comandos disponibles: /pa test, /pa config, /pa version")
        end
    end
    
    self:DebugPrint(self.title .. " enabled.")
    self.isEnabled = true
end

local mainFrame = CreateFrame("Frame")
mainFrame:SetScript("OnEvent", function(selfFrame, event, arg1, ...)
    if event == "ADDON_LOADED" then
        if arg1 == ADDON_NAME then
            -- Initial ADDON_LOADED for self is a good point to know the file is processed
            -- but most initialization happens at PLAYER_ENTERING_WORLD.
            -- ProdigyAuras:DebugPrint("Event: ADDON_LOADED for " .. arg1) -- Removed for cleaner console
        end
    elseif event == "PLAYER_ENTERING_WORLD" then 
        -- ProdigyAuras:DebugPrint("Event: PLAYER_ENTERING_WORLD") -- Removed for cleaner console
        
        if not ProdigyAuras.metadataInitialized then
             InitializeMetadata()
        end

        ProdigyAuras:InitializeDB() -- Initialize the configuration database

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

-- ProdigyAuras:DebugPrint("Core.lua procesado y eventos registrados.") -- Removed for cleaner console