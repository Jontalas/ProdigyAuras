-- ProdigyAuras - Localización en Español (España)
-- WoW Version 11.1.5

ProdigyAuras = ProdigyAuras or {}
ProdigyAuras.L_DATA = ProdigyAuras.L_DATA or {}

ProdigyAuras.L_DATA["esES"] = {
    -- Core.lua
    L_WARN_GET_VERSION_FAILED = "Advertencia: No se pudo recuperar la versión del addon.",
    L_WARN_GET_TITLE_FAILED = "Advertencia: No se pudo recuperar el título del addon.",
    L_WARN_GET_AUTHOR_FAILED = "Advertencia: No se pudo recuperar el autor del addon.",
    L_PCALL_ERROR = "Error de pcall (%s): %s", -- %1: context (e.g., "Version"), %2: error message
    L_METADATA_INITIALIZED = "Metadatos inicializados. Versión: %s",
    L_CORE_LOGIC_INITIALIZING = "%s inicializando (lógica principal)...",
    L_CORE_LOGIC_INITIALIZED = "%s lógica principal inicializada.",
    L_ENABLING_ADDON = "%s habilitándose...",
    L_ADDON_ENABLED = "%s habilitado.",
    L_CMD_TEST_RECEIVED = "¡Comando de prueba recibido!",
    L_CMD_CONFIG_WIP = "Abriendo configuración (aún no implementado)...",
    L_CMD_VERSION_INFO = "Versión: %s, Autor: %s, Título: %s",
    L_CMD_UNKNOWN = "Comando desconocido. Comandos disponibles: /pa test, /pa config, /pa version",
    L_ERR_NO_GETMETADATA_FUNC = "Error Crítico: No hay función GetAddOnMetadata disponible.",
    L_WARN_C_ADDONS_NOT_FOUND = "Advertencia: C_AddOns.GetAddOnMetadata no encontrado. Intentando GetAddOnMetadata global (no recomendado para %s).", -- %1: WoW version

    -- Config.lua
    L_CONFIG_LOADED = "Config.lua cargado.",
    L_GLOBAL_SETTINGS_INITIALIZED = "Ajustes globales inicializados por defecto.",
    L_PROFILE_SETTINGS_INITIALIZED = "Ajustes de perfil para este personaje inicializados por defecto.",
    L_PROFILE_SETTING_ADDED = "Ajuste por defecto '%s' añadido al perfil actual.",
    L_DB_INITIALIZED = "Base de datos inicializada. Addon Habilitado: %s",
    L_WARN_SETTING_NOT_FOUND = "Advertencia: Ajuste '%s' no encontrado en la BD o en los valores por defecto.",
    L_PROFILE_SETTING_SET = "Ajuste de perfil '%s' establecido a: %s",
    L_GLOBAL_SETTING_SET = "Ajuste global '%s' establecido a: %s",

    -- Utils.lua
    L_UTILS_LOADED = "Utils.lua cargado.",
    L_WARN_PLAYER_CLASS_FAILED = "Advertencia: No se pudo recuperar la información de clase del jugador.",
    L_WARN_PLAYER_SPEC_NAME_FAILED = "Advertencia: No se pudo recuperar el nombre de la especialización del jugador para el ID: %s",
    L_UNKNOWN_SPEC_ID = "Especialización Desconocida (ID: %s)",
    L_NO_ACTIVE_SPEC = "El jugador no tiene especialización activa o GetSpecialization() falló.",
    L_PLAYER_INFO_UPDATED = "Info Jugador Actualizada: Clase=%s (%s), Spec=%s (ID:%s)",
    L_WARN_PLAYER_INFO_KEY_NOT_FOUND = "Advertencia: Clave de información del jugador '%s' no encontrada.",
    L_CURRENT_CLASS_SPEC_INFO = "Clase Actual: %s, ID Spec: %s", -- For /pa test

    -- Events.lua
    L_EVENTS_LOADED = "Events.lua cargado.",
    L_EVENT_REGISTERED = "Evento '%s' registrado.",
    L_EVENT_PLAYER_SPEC_CHANGED = "Especialización del jugador cambiada. Actualizando información...",
    L_EVENTS_GAME_EVENTS_HANDLER_SET = "Manejador de eventos del juego configurado para %s.",
    L_EVENTS_ALL_UNREGISTERED = "Todos los eventos del juego han sido desregistrados.",

    -- FrameManager.lua
    L_FRAMEMANAGER_LOADED = "FrameManager.lua cargado.",
    L_TEST_FRAME_CREATED = "Frame de prueba creado.",
    L_TEST_FRAME_POSITION_UPDATED = "Posición del frame de prueba actualizada.",
    L_TEST_FRAME_VISIBILITY_UPDATED = "Visibilidad del frame de prueba actualizada a: %s.",
    L_CMD_TOGGLEFRAME_ENABLED = "Frame de prueba habilitado.",
    L_CMD_TOGGLEFRAME_DISABLED = "Frame de prueba deshabilitado.",
    LOC_ERR_CREATE_TEST_FRAME_NOT_FOUND = "Error: Función CreateTestFrame no encontrada.",
    LOC_ERR_TOGGLE_TEST_FRAME_NOT_FOUND = "Error: Función ToggleTestFrame no encontrada.",
    LOC_ERR_PROFILE_DB_NOT_INIT_TOGGLE = "Error: Base de datos del perfil no inicializada para ToggleTestFrame.",

    -- IconManager.lua
    L_ICONMANAGER_LOADED = "IconManager.lua cargado.",
    L_TEST_ICON_CREATED = "Icono de prueba creado para el hechizo ID: %s.",
    L_ICON_UPDATED = "Icono actualizado para el hechizo ID: %s.",
}