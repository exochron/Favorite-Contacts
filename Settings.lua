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

local function GetForeverRuleset()
    if C_GameRules.IsGameRuleActive(Enum.GameRule.PvPRuleset) then
        return "PvP"
    elseif C_GameRules.IsGameRuleActive(Enum.GameRule.RPRuleset) then
        return "RP"
    elseif C_GameRules.IsGameRuleActive(Enum.GameRule.HardcoreRuleset) then
        return "HC"
    end
    return "PvE"
end

-- During the first 2 weeks of Forever FC still used GetRealmName() as profile name.
-- At some point that function only returned "". This fix cleans up those shaky profiles.
-- Later: remove after 2027-05
local function FixForeverProfiles()
    if FavoriteContactsSettings["realm_"] then
        FavoriteContactsSettings["realm_"] = nil
    end
    for key, settings in pairs(FavoriteContactsSettings) do
        if strfind(key, "CAMWOW", 1, true) then
            local _,_,_,_,rule = strsplit(" ", key)
            if rule then
                local restoredKey = "realm_"..rule
                if not FavoriteContactsSettings[restoredKey] then
                    FavoriteContactsSettings[restoredKey] = settings
                end
            end
            FavoriteContactsSettings[key] = nil
        end
    end
end

-- Settings have to be loaded during PLAYER_LOGIN
ADDON.Events:RegisterCallback('PreLogin', function()
    local realmName = "realm_"
    if WOW_PROJECT_ID == WOW_PROJECT_CAMELOT then
        FixForeverProfiles()
        realmName = realmName .. GetForeverRuleset()
    else
        realmName = realmName .. GetRealmName()
    end

    if not FavoriteContactsSettings[realmName] then
        FavoriteContactsSettings[realmName] = {}
    end

    CombineSettings(FavoriteContactsSettings[realmName], defaultSettings)
    ADDON.settings = FavoriteContactsSettings[realmName]
end, 'settings')