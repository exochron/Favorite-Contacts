local ADDON_NAME, ADDON = ...

local CONTACT_DEFAULT_ICON = "INV_Misc_GroupLooking"

local contextMenu
local contextMenuIndex
local currentDragContact = 0
local clickTime = 0

local AceGUI = LibStub("AceGUI-3.0")

local function SendMail()
    if SendMailMailButton:IsVisible() and SendMailMailButton:IsEnabled() then
        SendMailMailButton:Click()
    end
end

local function OnContactButtonClicked(button, event, buttonType)
    if currentDragContact ~= 0 then
        ADDON:StopDrag(button.index)
        return
    end

    if buttonType == "LeftButton" then
        if button.index then
            local contact = ADDON.settings.contacts[button.index]
            if contact then
                MailFrameTab_OnClick(nil, 2)
                SendMailNameEditBox:SetText(contact.recipient)
                SendMailSubjectEditBox:SetFocus()

                if CursorHasItem() then
                    SendMailAttachmentButton_OnDropAny()
                end
                if ADDON.settings.clickToSend then
                    SendMail()
                end
            else
                -- DoubleClick on empty button
                if GetTime() - clickTime < 0.5 then
                    ADDON:ShowEditContactPopup(button.index)
                end
                clickTime = GetTime()
            end
        end
        return
    end

    if buttonType == "RightButton" then
        contextMenuIndex = button.index
        ToggleDropDownMenu(1, nil, contextMenu, button.frame, 0, 0)
        return
    end
end

local function CreateContactButton(index)
    local button = ADDON.contactButtons[index]

    if button then
        return button
    end

    button = AceGUI:Create("Icon")
    ADDON.contactContainer:AddChild(button)

    button:SetImageSize(ADDON.CONTACT_BUTTON_SIZE, ADDON.CONTACT_BUTTON_SIZE)
    button:SetHeight(ADDON.CONTACT_BUTTON_SIZE)
    button:SetWidth(ADDON.CONTACT_BUTTON_SIZE + ADDON.CONTACT_BUTTON_MARGIN)

    button.image:SetPoint("TOP", 0, 0)

    button.frame:RegisterForClicks("AnyUp")
    button:SetCallback("OnClick", OnContactButtonClicked)
    button:SetCallback("OnEnter", function(widget)
        if (not widget.index) then
            return
        end
        local contact = ADDON.settings.contacts[widget.index]
        if not contact then
            return
        end

        GameTooltip:SetOwner(widget.frame, "ANCHOR_NONE")
        GameTooltip:SetPoint("TOPLEFT", widget.frame, "TOPRIGHT", 6, 2)
        GameTooltip:SetText(contact.recipient)
        if (contact.note) then
            GameTooltip:AddLine(contact.note, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, 1)
        end
        GameTooltip:Show()
    end)
    button:SetCallback("OnLeave", function()
        GameTooltip:Hide()
    end)

    button.frame:RegisterForDrag("LeftButton", "RightButton")
    button.frame:SetScript("OnDragStart", function(frame)
        frame.obj:Fire("OnDragStart")
    end)
    button.frame:SetScript("OnDragStop", function(frame)
        frame.obj:Fire("OnDragStop")
    end)
    button.frame:SetScript("OnReceiveDrag", function(frame)
        frame.obj:Fire("OnReceiveDrag")
    end)

    button:SetCallback("OnDragStart", function(widget)
        if not widget.disabled then
            ADDON:StartDrag(widget.index)
            currentDragContact = widget.index
        end
    end)
    button:SetCallback("OnDragStop", function(widget)
        if not widget.disabled then
            ADDON:StopDrag(widget.index)

            if (false == ADDON.contactContainer.content:IsMouseOver()) then
                ADDON:DeleteContact(currentDragContact)
                currentDragContact = 0
            end
        end
    end)
    button:SetCallback("OnReceiveDrag", function(widget)
        if not widget.disabled then
            if currentDragContact ~= 0 then
                ADDON:SwapContacts(currentDragContact, widget.index)
                currentDragContact = 0
            elseif CursorHasItem() then
                OnContactButtonClicked(button, "OnClick", "LeftButton")
            end
        end
    end)

    button.index = index

    ADDON.contactButtons[index] = button

    return button
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

        ADDON:SetTexture(button.image, icon)
    else
        button.image:SetAtlas("")
        button:SetImage("Interface\\Buttons\\UI-EmptySlot-Disabled", 0.140625, 0.84375, 0.140625, 0.84375)
    end
end

function ADDON:UpdateContactButtons()
    for index = 1, (self.settings.columnCount * self.settings.rowCount) do
        self:UpdateContactButton(index)
    end
end

local function InitButtonMenu(sender, level)
    local info
    local contact = ADDON.settings.contacts[contextMenuIndex]
    if contact then
        info = {
            notCheckable = true,
            text = EDIT,
            func = function()
                ADDON:ShowEditContactPopup(contextMenuIndex)
            end,
        }
        UIDropDownMenu_AddButton(info, level)

        info = {
            notCheckable = true,
            text = DELETE,
            func = function()
                ADDON:DeleteContact(contextMenuIndex)
            end,
        }
        UIDropDownMenu_AddButton(info, level)
    else
        info = {
            notCheckable = true,
            text = ADDON.L["Create"],
            func = function()
                ADDON:ShowEditContactPopup(contextMenuIndex)
            end,
        }
        UIDropDownMenu_AddButton(info, level)
    end

    info = {
        notCheckable = true,
        text = CANCEL,
        func = mil,
    }
    UIDropDownMenu_AddButton(info, level)
end

ADDON:RegisterLoadUICallback(function()
    ADDON:UpdateContactButtons()

    contextMenu = CreateFrame("Frame", ADDON_NAME .. "ContactButtonContextMenu", ADDON.contactContainer.content, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(contextMenu, InitButtonMenu, "MENU")
end)