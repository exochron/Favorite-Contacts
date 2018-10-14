local ADDON_NAME, ADDON = ...

-- TODO:
--  - auto sclae
--  - settings panel

local CONFIRM_DELETE_CONTACT = ADDON_NAME .. "_CONFIRM_DELETE_CONTACT"

ADDON.contactContainer = nil
ADDON.contactButtons = {}

-- region callbacks
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

function ADDON:SetTexture(texture, iconName)
    if (iconName:sub(1,9) == "raceicon-") then
        texture:SetAtlas(iconName)
    else
        texture:SetTexture("INTERFACE\\ICONS\\" .. iconName)
    end
end

function ADDON:SendMail()
    if (not SendMailMailButton:IsVisible() or
        not SendMailMailButton:IsEnabled())
    then
        return
    end

    SendMailMailButton:Click()
end

function ADDON:SetSelectedContact(selectedIndex)
    for _, contactButton in pairs(ADDON.contactButtons) do
        contactButton:SetChecked(false)
    end

    if (selectedIndex >= 1 and selectedIndex <= (self.settings.columnCount * self.settings.rowCount)) then
        local button = ADDON.contactButtons[selectedIndex]
        button:SetChecked(true)
    end
end

function ADDON:SetEnableContacts(enabled)
    for _, button in pairs(ADDON.contactButtons) do
        button:SetEnabled(enabled)

        if (enabled) then
            button.icon:SetAlpha(1.0)
        else
            button.icon:SetAlpha(0.5)
        end
    end
end

function ADDON:SetContact(index, recipient, icon, note)
    self.settings.contacts[index] = self.settings.contacts[index] or { }
    local contact = self.settings.contacts[index]
    contact.recipient = recipient
    contact.icon = icon
    contact.note = note

    self:UpdateContactButton(index)
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
        self:SetSelectedContact(index)
        self:SetEnableContacts(false)

        StaticPopupDialogs[CONFIRM_DELETE_CONTACT].OnAccept = function()
            self:DeleteContact(index, true)
            self:SetSelectedContact(0)
            self:SetEnableContacts(true)
        end
        StaticPopupDialogs[CONFIRM_DELETE_CONTACT].OnCancel = function()
            self:SetSelectedContact(0)
            self:SetEnableContacts(true)
        end
        StaticPopup_Show(CONFIRM_DELETE_CONTACT)
        return
    end

    self.settings.contacts[index] = nil

    self:UpdateContactButton(index)
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

    self:UpdateContactButton(index1)
    self:UpdateContactButton(index2)
end

function ADDON:Load()
    FireCallbacks(loginCallbacks)

    local initUI = true
    MailFrame:HookScript("OnShow", function()
        if initUI then
            FireCallbacks(loadUICallbacks)
            initUI = false
        end
    end)

    MailFrame:HookScript("OnShow", function()
        local frameLevel = max(InboxFrame:GetFrameLevel(), SendMailFrame:GetFrameLevel())
        self.contactContainer:SetFrameLevel(frameLevel)
        self.contactContainer:Show()
    end)
    MailFrame:HookScript("OnHide", function() self.contactContainer:Hide() end)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, arg1)
    ADDON:Load()
end)