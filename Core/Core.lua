-- ProdigyAuras - Core.lua
-- Author: Jontalas
-- Designed for WoW Version 11.1.5 (Interface 110100)

ProdigyAuras = ProdigyAuras or {}
local addon = ProdigyAuras
local ADDON_NAME = "ProdigyAuras" -- Must match .toc filename and folder name

-- Initialize basic properties
addon.title = ADDON_NAME -- Fallback, will be updated from .toc
addon.version = "0.0.0-pre" -- Fallback, will be updated from .toc
addon.author = "Jontalas" -- Fallback, will be updated from .toc
addon.isInitialized = false
addon.isEnabled = false
addon.metadataInitialized = false

-- Debug print function
function addon:DebugPrint(message)
    print(ADDON_NAME .. ": " .. tostring(message))
end

local function InitializeMetadata()
    if addon.metadataInitialized then return end

    addon:DebugPrint("Attempting to initialize metadata (WoW 11.1.5)...")

    local getMetadataFunc
    if C_AddOns and C_AddOns.GetAddOnMetadata then
        getMetadataFunc = C_AddOns.GetAddOnMetadata
        addon:DebugPrint("Using C_AddOns.GetAddOnMetadata.")
    else
        -- This fallback is unlikely to be needed or work correctly in 11.1.5 if C_AddOns itself is missing.
        getMetadataFunc = GetAddOnMetadata 
        addon:DebugPrint("Warning: C_AddOns.GetAddOnMetadata not found. Attempting global GetAddOnMetadata (not recommended for 11.1.5).")
    end

    if not getMetadataFunc then
        addon:DebugPrint("Critical Error: No GetAddOnMetadata function available.")
        addon.metadataInitialized = true -- Mark as initialized to prevent retries, but with errors.
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

    addon:DebugPrint("Metadata initialization complete. Version: " .. addon.version .. ", Title: " .. addon.title .. ", Author: " .. addon.author)
    addon.metadataInitialized = true
end

function addon:Initialize()
    if self.isInitialized then return end
    self:DebugPrint("Initializing " .. self.title .. " (core logic)...")
    self.isInitialized = true
    self:DebugPrint(self.title .. " core logic initialized.")
end

function addon:Enable()
    if self.isEnabled then return end
    self:DebugPrint("Enabling " .. self.title .. "...")
    
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
    
    self:DebugPrint(self.title .. " enabled and slash commands registered.")
    self.isEnabled = true
end

local mainFrame = CreateFrame("Frame")
mainFrame:SetScript("OnEvent", function(selfFrame, event, arg1, ...)
    if event == "ADDON_LOADED" then
        if arg1 == ADDON_NAME then
            ProdigyAuras:DebugPrint("Event: ADDON_LOADED for " .. arg1)
        end
    elseif event == "PLAYER_ENTERING_WORLD" then 
        ProdigyAuras:DebugPrint("Event: PLAYER_ENTERING_WORLD (Arg1: " .. (arg1 and tostring(arg1) or "nil") .. ")")
        if not ProdigyAuras.metadataInitialized then
             InitializeMetadata()
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

ProdigyAuras:DebugPrint("Core.lua procesado y eventos registrados (WoW 11.1.5).")