local ADDON_NAME, ADDON = ...

local CONFIRM_DELETE_CONTACT = ADDON_NAME .. "_CONFIRM_DELETE_CONTACT"

-- see: https://www.townlong-yak.com/framexml/live/CallbackRegistry.lua
ADDON.Events = CreateFromMixins(EventRegistry)
ADDON.Events:OnLoad()
ADDON.Events:SetUndefinedEventsAllowed(true)

local modules = {}

function ADDON:RegisterModule(name, settingsTable)
    modules[name] = settingsTable
end

function ADDON:SetEnableContacts(enabled)
    self.Events:TriggerEvent("ContainerEnabled", enabled)
end

function ADDON:SetContact(module, index, recipient, icon, note)
    modules[module].contacts[index] = modules[module].contacts[index] or {}
    local contact = modules[module].contacts[index]
    contact.recipient = recipient
    contact.icon = icon
    contact.note = note

    self.Events:TriggerEvent("ContactUpdated", module, index)
end

function ADDON:GetContact(module, index)
    return modules[module].contacts[index]
end
function ADDON:GetTotalButtonCount(module)
    return modules[module].columnCount * modules[module].rowCount
end

StaticPopupDialogs[CONFIRM_DELETE_CONTACT] = {
    text = ADDON.L["Are you sure that you want to delete this Contact?"],
    button1 = YES,
    button2 = NO,
    OnAccept = function() end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

function ADDON:DeleteContact(module, index, confirmed)
    if (not confirmed) then
        self:SetEnableContacts(false)

        StaticPopupDialogs[CONFIRM_DELETE_CONTACT].OnAccept = function()
            self:DeleteContact(module, index, true)
            self:SetEnableContacts(true)
        end
        StaticPopupDialogs[CONFIRM_DELETE_CONTACT].OnCancel = function()
            self:SetEnableContacts(true)
        end
        StaticPopup_Show(CONFIRM_DELETE_CONTACT)
        return
    end

    modules[module].contacts[index] = nil

    self.Events:TriggerEvent("ContactUpdated", module, index)
end

function ADDON:SwapContacts(module, index1, index2)
    if (index1 < 1 or index1 > (modules[module].columnCount * modules[module].rowCount)) then
        return
    end

    if (index2 < 1 or index2 > (modules[module].columnCount * modules[module].rowCount)) then
        return
    end

    local contact1 = modules[module].contacts[index1]
    local contact2 = modules[module].contacts[index2]

    modules[module].contacts[index1] = contact2
    modules[module].contacts[index2] = contact1

    self.Events:TriggerEvent("ContactUpdated", module, index1)
    self.Events:TriggerEvent("ContactUpdated", module, index2)
end

function ADDON:SetSize(module, columnCount, rowCount)
    if modules[module].columnCount ~= columnCount or modules[module].rowCount ~= rowCount then
        modules[module].columnCount = columnCount
        modules[module].rowCount = rowCount

        self.Events:TriggerEvent("ContainerUpdated", module)
    end
end

function ADDON:SetPosition(module, position)
    if modules[module].position ~= position then
        modules[module].position = position
        self.Events:TriggerEvent("ContainerUpdated", module)
    end
end

function ADDON:SetScale(module, scale)
    if modules[module].scale ~= scale then
        modules[module].scale = scale
        self.Events:TriggerEvent("ContainerUpdated", module)
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
    ADDON.Events:TriggerEvent("PreLogin")
    ADDON.Events:TriggerEvent("Login")
    ADDON.Events:UnregisterEvents({"PreLogin", "Login"})
end)