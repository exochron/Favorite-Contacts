local ADDON_NAME, ADDON = ...

local CONTACT_BUTTON = ADDON_NAME .. "ContactButton"
local CONTACT_DEFAULT_ICON = "INV_Misc_GroupLooking"
local CONTACT_BUTTON_MARGIN = 12

local contextMenu
local contextMenuIndex
local currentDragContact = 0

local function SendMail()
    if (not SendMailMailButton:IsVisible() or
            not SendMailMailButton:IsEnabled())
    then
        return
    end

    SendMailMailButton:Click()
end

local function OnContactButtonClicked(button, buttonType)
    if (currentDragContact ~= 0) then
        ADDON:StopDrag(button.index)
        return
    end

    if (buttonType == "LeftButton") then
        if (button.index) then
            local contact = ADDON.settings.contacts[button.index]
            if (contact) then
                MailFrameTab_OnClick(nil, 2)
                SendMailNameEditBox:SetText(contact.recipient)
                SendMailSubjectEditBox:SetFocus()

                if (ADDON.settings.clickToSend) then
                    SendMail()
                end
            end
        end
        return
    end

    if (buttonType == "RightButton") then
        contextMenuIndex = button.index
        MSA_ToggleDropDownMenu(1, nil, contextMenu, button, 0, 0)
        return
    end
end

local function CreateContactButton(index)
    local button = ADDON.contactButtons[index]
    if (not button) then
        button = CreateFrame("CheckButton", CONTACT_BUTTON .. index, ADDON.contactContainer.content, "PopupButtonTemplate", index)
    end

    button:SetToplevel(true)
    button:RegisterForClicks("AnyUp")
    button:RegisterForDrag("LeftButton", "RightButton")
    button:SetScript("OnMouseDown", function(sender)
        if (sender:IsEnabled()) then
            sender:SetChecked(true)
        end
    end)
    button:SetScript("PreClick", function(sender) sender:SetChecked(false) end)
    button:SetScript("OnClick", function(sender, buttonType) OnContactButtonClicked(sender, buttonType) end)
    button:SetScript("OnDoubleClick", function(sender)
        if (sender:IsEnabled()) then
            sender:SetChecked(false)
        end

        if (not ADDON.settings.contacts[sender.index]) then
            ADDON:ShowEditContactPopup(sender.index)
        end
    end)
    button:SetScript("OnDragStart", function(sender)
        if (sender:IsEnabled()) then
            ADDON:StartDrag(sender.index)
            currentDragContact = sender.index
        end
    end)
    button:SetScript("OnDragStop", function(sender)
        if (sender:IsEnabled()) then
            ADDON:StopDrag(sender.index)

            if (false == ADDON.contactContainer.content:IsMouseOver()) then
                ADDON:DeleteContact(currentDragContact)
                currentDragContact = 0
            end
        end
    end)
    button:SetScript("OnReceiveDrag", function(sender)
        if (sender:IsEnabled()) then
            ADDON:SwapContacts(currentDragContact, index)
            currentDragContact = 0
        end
    end)

    button:SetScript("OnEnter", function(sender)
        if (not sender.index) then return end
        local contact = ADDON.settings.contacts[index]
        if (not contact) then return end

        GameTooltip:SetOwner(sender, "ANCHOR_NONE")
        GameTooltip:SetPoint("TOPLEFT", sender, "TOPRIGHT", 6, 2)
        GameTooltip:SetText(contact.recipient)
        if (contact.note) then
            GameTooltip:AddLine(contact.note, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, 1)
        end
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function(sender)
        GameTooltip:Hide()
    end)

    button.index = index
    button.icon = _G[CONTACT_BUTTON .. index .. "Icon"]

    ADDON.contactButtons[index] = button

    return button
end

local function SetContactButtonPosition(button)
    local index = button.index

    button:ClearAllPoints()
    if (index == 1) then
        button:SetPoint("TOPLEFT", ADDON.contactContainer.content, "TOPLEFT", 0, -1)
    elseif (mod(index, ADDON.settings.rowCount) == 1) then
        local relativeTo = ADDON.contactButtons[index - ADDON.settings.rowCount]
        button:SetPoint("LEFT", relativeTo, "RIGHT", CONTACT_BUTTON_MARGIN, 0)
    else
        local relativeTo = ADDON.contactButtons[index - 1]
        button:SetPoint("TOP", relativeTo, "BOTTOM", 0, -CONTACT_BUTTON_MARGIN)
    end
end


function ADDON:UpdateContactButton(index)
    if (index < 1 and index > self.settings.columnCount * self.settings.rowCount) then
        return
    end

    local button = CreateContactButton(index)

    local contact = self.settings.contacts[index]
    if (contact) then
        local icon = contact.icon
        if (not icon or string.len(icon) == 0) then
            icon = CONTACT_DEFAULT_ICON
            contact.icon = icon
        end

        ADDON:SetTexture(button.icon, icon)
    else
        button.icon:SetTexture("")
        button.icon:SetAtlas("")
    end

    SetContactButtonPosition(button)

    button:Show()
end

function ADDON:UpdateContactButtons()
    for index = 1, (self.settings.columnCount * self.settings.rowCount) do
        self:UpdateContactButton(index)
    end
end

local function InitButtonMenu(sender, level)
    local info = MSA_DropDownMenu_CreateInfo()
    info.notCheckable = true

    local contact = ADDON.settings.contacts[contextMenuIndex]
    if (contact) then
        info.text = EDIT
        info.func = function()
            ADDON:ShowEditContactPopup(contextMenuIndex)
        end
        MSA_DropDownMenu_AddButton(info, level)

        info.text = DELETE
        info.func = function()
            ADDON:DeleteContact(contextMenuIndex)
        end
        MSA_DropDownMenu_AddButton(info, level)
    else
        info.text = ADDON.L["Create"]
        info.func = function()
            ADDON:ShowEditContactPopup(contextMenuIndex)
        end
        MSA_DropDownMenu_AddButton(info, level)
    end

    info.text = CANCEL
    info.func = nil
    MSA_DropDownMenu_AddButton(info, level)
end

ADDON:RegisterLoadUICallback(function()
    ADDON:UpdateContactButtons()

    contextMenu = MSA_DropDownMenu_Create(CONTACT_BUTTON .. "ContextMenu", ADDON.contactContainer.content)
    MSA_DropDownMenu_Initialize(contextMenu, function(sender, level) InitButtonMenu(sender, level) end, "MENU")
end)