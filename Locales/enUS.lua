-- ProdigyAuras - English Localization
-- WoW Version 11.1.5

ProdigyAuras = ProdigyAuras or {}
ProdigyAuras.L_DATA = ProdigyAuras.L_DATA or {}

ProdigyAuras.L_DATA["enUS"] = {
    -- Core.lua
    L_WARN_GET_VERSION_FAILED = "Warning: Could not retrieve addon Version.",
    L_WARN_GET_TITLE_FAILED = "Warning: Could not retrieve addon Title.",
    L_WARN_GET_AUTHOR_FAILED = "Warning: Could not retrieve addon Author.",
    L_PCALL_ERROR = "pcall error (%s): %s", -- %1: context, %2: error message
    L_METADATA_INITIALIZED = "Metadata initialized. Version: %s",
    L_CORE_LOGIC_INITIALIZING = "%s initializing (core logic)...",
    L_CORE_LOGIC_INITIALIZED = "%s core logic initialized.",
    L_ENABLING_ADDON = "%s enabling...",
    L_ADDON_ENABLED = "%s enabled.",
    L_CMD_TEST_RECEIVED = "Test command received!",
    L_CMD_CONFIG_WIP = "Opening configuration (not yet implemented)...",
    L_CMD_VERSION_INFO = "Version: %s, Author: %s, Title: %s",
    L_CMD_UNKNOWN = "Unknown command. Available commands: /pa test, /pa config, /pa version",
    L_ERR_NO_GETMETADATA_FUNC = "Critical Error: No GetAddOnMetadata function available.",
    L_WARN_C_ADDONS_NOT_FOUND = "Warning: C_AddOns.GetAddOnMetadata not found. Attempting global GetAddOnMetadata (not recommended for %s).", -- %1: WoW version

    -- Config.lua
    L_CONFIG_LOADED = "Config.lua loaded.",
    L_GLOBAL_SETTINGS_INITIALIZED = "Global settings initialized with defaults.",
    L_PROFILE_SETTINGS_INITIALIZED = "Profile settings for this character initialized with defaults.",
    L_PROFILE_SETTING_ADDED = "Added default setting '%s' to current profile.",
    L_DB_INITIALIZED = "Database initialized. Addon Enabled: %s",
    L_WARN_SETTING_NOT_FOUND = "Warning: Setting '%s' not found in DB or defaults.",
    L_PROFILE_SETTING_SET = "Profile setting '%s' set to: %s",
    L_GLOBAL_SETTING_SET = "Global setting '%s' set to: %s",

    -- Utils.lua
    L_UTILS_LOADED = "Utils.lua loaded.",
    L_WARN_PLAYER_CLASS_FAILED = "Warning: Could not retrieve player class information.",
    L_WARN_PLAYER_SPEC_NAME_FAILED = "Warning: Could not retrieve player specialization name for ID: %s",
    L_UNKNOWN_SPEC_ID = "Unknown Spec (ID: %s)",
    L_NO_ACTIVE_SPEC = "Player has no active specialization or GetSpecialization() failed.",
    L_PLAYER_INFO_UPDATED = "Player Info Updated: Class=%s (%s), Spec=%s (ID:%s)",
    L_WARN_PLAYER_INFO_KEY_NOT_FOUND = "Warning: Player info key '%s' not found.",
    L_CURRENT_CLASS_SPEC_INFO = "Current Class: %s, Spec ID: %s", -- For /pa test

    -- Events.lua
    L_EVENTS_LOADED = "Events.lua loaded.",
    L_EVENT_REGISTERED = "Event '%s' registered.",
    L_EVENT_PLAYER_SPEC_CHANGED = "Player specialization changed. Updating info...",
    L_EVENTS_GAME_EVENTS_HANDLER_SET = "Game event handler set for %s.",
    L_EVENTS_ALL_UNREGISTERED = "All game events unregistered.",

    -- FrameManager.lua
    L_FRAMEMANAGER_LOADED = "FrameManager.lua loaded.",
    L_TEST_FRAME_CREATED = "Test frame created.",
    L_TEST_FRAME_POSITION_UPDATED = "Test frame position updated.",
    L_TEST_FRAME_VISIBILITY_UPDATED = "Test frame visibility updated to: %s.",
    L_CMD_TOGGLEFRAME_ENABLED = "Test frame enabled.",
    L_CMD_TOGGLEFRAME_DISABLED = "Test frame disabled.",
    LOC_ERR_CREATE_TEST_FRAME_NOT_FOUND = "Error: CreateTestFrame function not found.",
    LOC_ERR_TOGGLE_TEST_FRAME_NOT_FOUND = "Error: ToggleTestFrame function not found.",
    LOC_ERR_PROFILE_DB_NOT_INIT_TOGGLE = "Error: Profile DB not initialized for ToggleTestFrame.",

    -- IconManager.lua
    L_ICONMANAGER_LOADED = "IconManager.lua loaded.",
    L_TEST_ICON_CREATED = "Test icon created for spell ID: %s.",
    L_ICON_UPDATED = "Icon updated for spell ID: %s.",
}