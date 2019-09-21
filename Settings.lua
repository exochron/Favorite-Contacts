local ADDON_NAME, ADDON = ...

FavoriteContactsSettings = FavoriteContactsSettings or {}

local defaultSettings = {
    contacts = {},
    columnCount = 2,
    rowCount = 9,
    position = "RIGHT",
    scale = "AUTO",
    clickToSend = false,
    reorderContacts = true,
}

function ADDON:ResetUISettings()
    ADDON.settings.columnCount = 2
    ADDON.settings.rowCount = 9
    ADDON.settings.position = "RIGHT"
    ADDON.settings.scale = "AUTO"
    ADDON.settings.clickToSend = false
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

local function CheckContactOrder()
    -- [2.1] With AceGui we're now arranging the buttons from left to right. prior it was per column from top to bottom.
    if ADDON.settings.reorderContacts and #ADDON.settings.contacts > 0 and ADDON.settings.rowCount > 1 and ADDON.settings.columnCount > 1 then
        local mappedContacts = {}
        local rows = ADDON.settings.rowCount
        local cols = ADDON.settings.columnCount
        for index, contact in pairs(ADDON.settings.contacts) do
            local x = ceil(index / rows)
            local y = mod(index, rows)
            if y == 0 then
                y = rows
            end
            local mappedIndex = (y-1) * cols + x
            mappedContacts[mappedIndex] = contact
        end

        ADDON.settings.contacts = mappedContacts
    end

    ADDON.settings.reorderContacts = false
end

-- Settings have to be loaded during PLAYER_LOGIN
ADDON:RegisterLoginCallback(function()
    local realmName = "realm_" .. GetRealmName()

    if not FavoriteContactsSettings[realmName] then
        FavoriteContactsSettings[realmName] = {}
    end

    CombineSettings(FavoriteContactsSettings[realmName], defaultSettings)
    ADDON.settings = FavoriteContactsSettings[realmName]

    CheckContactOrder()
end)