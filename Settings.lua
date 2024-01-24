local _, ADDON = ...

FavoriteContactsSettings = FavoriteContactsSettings or {}

local defaultSettings = {
    contacts = {},
    columnCount = 2,
    rowCount = 9,
    position = "RIGHT",
    scale = "AUTO",
    clickToSend = false,
    switchTabOnEmptyInbox = true,
}

if LE_EXPANSION_LEVEL_CURRENT >= LE_EXPANSION_DRAGONFLIGHT then
    defaultSettings['craftOrder'] = {
        contacts = {},
        columnCount = 2,
        rowCount = 12,
        position = "RIGHT",
        scale = "AUTO",
    }
end

function ADDON:ResetUISettings()
    ADDON.settings.columnCount = 2
    ADDON.settings.rowCount = 9
    ADDON.settings.position = "RIGHT"
    ADDON.settings.scale = "AUTO"
    ADDON.settings.clickToSend = false
    ADDON.settings.switchTabOnEmptyInbox = true
end

local function CombineSettings(settings, defaultSettings)
    for key, value in pairs(defaultSettings) do
        if (settings[key] == nil) then
            settings[key] = value
        elseif (type(value) == "table") and next(value) ~= nil then
            if type(settings[key]) ~= "table" then
                settings[key] = {}
            end
            CombineSettings(settings[key], value)
        end
    end

    -- cleanup old still existing settings
    for key, _ in pairs(settings) do
        if (defaultSettings[key] == nil) then
            settings[key] = nil
        end
    end
end

-- Settings have to be loaded during PLAYER_LOGIN
ADDON.Events:RegisterCallback('PreLogin', function()
    local realmName = "realm_" .. GetRealmName()

    if not FavoriteContactsSettings[realmName] then
        FavoriteContactsSettings[realmName] = {}
    end

    CombineSettings(FavoriteContactsSettings[realmName], defaultSettings)
    ADDON.settings = FavoriteContactsSettings[realmName]
end, 'settings')