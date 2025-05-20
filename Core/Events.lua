-- ProdigyAuras - Events.lua
-- Handles game events for the addon
-- WoW Version 11.1.5

ProdigyAuras = ProdigyAuras or {}
local addon = ProdigyAuras

-- Create a frame to handle events if it doesn't exist from Core.lua
-- Or, ideally, use the one from Core.lua if passed or made globally accessible.
-- For now, let's assume Core.lua's mainFrame can be used or we create one here.
-- To keep things modular, Events.lua will manage its own event registrations
-- on a frame it controls or is given.

-- We will use the mainFrame created in Core.lua.
-- If mainFrame is not globally accessible via ProdigyAuras.mainFrame,
-- this approach needs adjustment. For now, we assume Core.lua makes it available,
-- or we pass it during an initialization phase.

-- Let's create a dedicated event frame for this module for better encapsulation.
addon.eventFrame = addon.eventFrame or CreateFrame("Frame", "ProdigyAurasEventFrame")

-- Function to register all necessary game events
function addon:RegisterGameEvents()
    if not self.eventFrame then
        self:DebugPrint("LOC_ERR: Event frame not found in Events.lua") -- Should have a proper loc key if this was user facing
        return
    end

    -- PLAYER_SPECIALIZATION_CHANGED
    self.eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    self:DebugPrint("L_EVENT_REGISTERED", "PLAYER_SPECIALIZATION_CHANGED")

    -- Add other events here as needed, for example:
    -- self.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD") -- Already handled in Core.lua for init
    -- self.eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
    -- self.eventFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    -- self.eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

    self.eventFrame:SetScript("OnEvent", function(selfFrame, event, ...)
        -- self:DebugPrint("Event fired: " .. event) -- Generic event fire log, can be noisy

        if event == "PLAYER_SPECIALIZATION_CHANGED" then
            ProdigyAuras:DebugPrint("L_EVENT_PLAYER_SPEC_CHANGED")
            if ProdigyAuras.UpdatePlayerInfo then
                ProdigyAuras:UpdatePlayerInfo() -- Call the function from Utils.lua
            else
                ProdigyAuras:DebugPrint("LOC_ERR: UpdatePlayerInfo function not found when spec changed.")
            end
        -- elseif event == "PLAYER_TARGET_CHANGED" then
            -- Handle target change
        -- elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
            -- Handle spell success
        end
    end)
    self:DebugPrint("L_EVENTS_GAME_EVENTS_HANDLER_SET", "ProdigyAurasEventFrame") -- New loc key needed
end

-- Unregister events (e.g., when addon is disabled, though not strictly necessary for simple cases)
function addon:UnregisterGameEvents()
    if self.eventFrame then
        self.eventFrame:UnregisterAllEvents()
        self:DebugPrint("L_EVENTS_ALL_UNREGISTERED") -- New loc key needed
    end
end


-- Add new localization keys for the above DebugPrint messages:
-- L_EVENTS_GAME_EVENTS_HANDLER_SET = "Manejador de eventos del juego configurado para %s."
-- L_EVENTS_ALL_UNREGISTERED = "Todos los eventos del juego han sido desregistrados."

-- L_EVENTS_GAME_EVENTS_HANDLER_SET = "Game event handler set for %s."
-- L_EVENTS_ALL_UNREGISTERED = "All game events unregistered."


addon:DebugPrint("L_EVENTS_LOADED")