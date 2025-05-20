-- ProdigyAuras - Utils.lua
-- Utility functions for the addon
-- WoW Version 11.1.5

ProdigyAuras = ProdigyAuras or {}
local addon = ProdigyAuras

addon.player = {
    className = "UNKNOWN",
    classToken = "UNKNOWN",
    specId = 0,
    specName = "UNKNOWN",
}

function addon:UpdatePlayerInfo()
    local classNameLoc, classTokenEng = UnitClass("player")
    if classNameLoc and classTokenEng then
        self.player.className = classNameLoc
        self.player.classToken = classTokenEng
    else
        self:DebugPrint("L_WARN_PLAYER_CLASS_FAILED")
    end

    local specID = GetSpecialization()
    if specID and specID > 0 then
        self.player.specId = specID
        local _, specNameLoc = GetSpecializationInfo(specID)
        if specNameLoc then
            self.player.specName = specNameLoc
        else
            self:DebugPrint("L_WARN_PLAYER_SPEC_NAME_FAILED", specID)
            self.player.specName = self:L("L_UNKNOWN_SPEC_ID", specID)
        end
    else
        self.player.specId = 0
        self.player.specName = "None" -- This could also be localized if needed, e.g. L_NO_SPEC
        self:DebugPrint("L_NO_ACTIVE_SPEC")
    end

    self:DebugPrint("L_PLAYER_INFO_UPDATED", self.player.className, self.player.classToken, self.player.specName, self.player.specId)
end

function addon:GetPlayerInfo(key)
    if self.player and self.player[key] then
        return self.player[key]
    end
    self:DebugPrint("L_WARN_PLAYER_INFO_KEY_NOT_FOUND", tostring(key))
    return nil
end

addon:DebugPrint("L_UTILS_LOADED")