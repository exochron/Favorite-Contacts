local ADDON_NAME, ADDON = ...

local CONFIRM_DELETE_CONTACT = ADDON_NAME .. "_CONFIRM_DELETE_CONTACT"

ADDON.contactContainer = nil
ADDON.contactButtons = {}

local isUILoaded

--region callbacks
local loginCallbacks, loadUICallbacks = {}, {}
function ADDON:RegisterLoginCallback(func)
    table.insert(loginCallbacks, func)
end

function ADDON:RegisterLoadUICallback(func)
    table.insert(loadUICallbacks, func)
end

local function FireCallbacks(callbacks)
    for _, callback in pairs(callbacks) do
        callback()
    end
end
--endregion

function ADDON:SetEnableContacts(enabled)
    for _, button in pairs(ADDON.contactButtons) do
        button:SetDisabled(not enabled)
    end
end

function ADDON:SetContact(index, recipient, icon, note)
    self.settings.contacts[index] = self.settings.contacts[index] or {}
    local contact = self.settings.contacts[index]
    contact.recipient = recipient
    contact.icon = icon
    contact.note = note

    if isUILoaded then
        self:UpdateContactButton(index)
    end
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

function ADDON:DeleteContact(index, confirmed)
    if (not confirmed) then
        if isUILoaded then
            self:SetEnableContacts(false)
        end

        StaticPopupDialogs[CONFIRM_DELETE_CONTACT].OnAccept = function()
            self:DeleteContact(index, true)
            if isUILoaded then
                self:SetEnableContacts(true)
            end
        end
        StaticPopupDialogs[CONFIRM_DELETE_CONTACT].OnCancel = function()
            if isUILoaded then
                self:SetEnableContacts(true)
            end
        end
        StaticPopup_Show(CONFIRM_DELETE_CONTACT)
        return
    end

    self.settings.contacts[index] = nil

    if isUILoaded then
        self:UpdateContactButton(index)
    end
end

function ADDON:SwapContacts(index1, index2)
    if (index1 < 1 or index1 > (self.settings.columnCount * self.settings.rowCount)) then
        return
    end

    if (index2 < 1 or index2 > (self.settings.columnCount * self.settings.rowCount)) then
        return
    end

    local contact1 = self.settings.contacts[index1]
    local contact2 = self.settings.contacts[index2]

    self.settings.contacts[index1] = contact2
    self.settings.contacts[index2] = contact1

    if isUILoaded then
        self:UpdateContactButton(index1)
        self:UpdateContactButton(index2)
    end
end

function ADDON:SetSize(columnCount, rowCount)
    if ADDON.settings.columnCount ~= columnCount or ADDON.settings.rowCount ~= rowCount then
        ADDON.settings.columnCount = columnCount
        ADDON.settings.rowCount = rowCount

        if isUILoaded then
            -- clear all buttons and generate them again
            self.contactContainer:ReleaseChildren()
            self.contactButtons = {}

            ADDON:UpdateContactContainer()
            ADDON:UpdateContactButtons()
        end
    end
end

function ADDON:SetPosition(position)
    if ADDON.settings.position ~= position then
        ADDON.settings.position = position
        if isUILoaded then
            ADDON:UpdateContactContainer()
        end
    end
end

function ADDON:SetScale(scale)
    if ADDON.settings.scale ~= scale then
        ADDON.settings.scale = scale
        if isUILoaded then
            ADDON:UpdateContactContainer()
        end
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, arg1)

    FireCallbacks(loginCallbacks)

    MailFrame:HookScript("OnShow", function()
        if not isUILoaded then
            FireCallbacks(loadUICallbacks)
            isUILoaded = true
        end
    end)
end)