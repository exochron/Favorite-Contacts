local _, ADDON = ...

local CONTACT_DEFAULT_ICON = "INV_Misc_GroupLooking"

local popup, buttonContainer, activeContactIndex

local function CreateWindow()
    local AceGUI = LibStub("AceGUI-3.0")

    local frame = CreateFrame("Frame", "FavoriteContactsEditFrame", UIParent, "ButtonFrameTemplate")
    tinsert(UISpecialFrames, frame:GetName()) -- also close frame on escape

    frame:SetWidth(419)
    frame:SetHeight((min(ceil(#ADDON.iconFiles / 8), 8) * 45) + 191)
    frame:SetPoint("TOPLEFT", MailFrame, "TOPRIGHT", MailFrame:GetAttribute("UIPanelLayout-extraWidth"), 0)
    frame:SetFrameStrata("DIALOG")

    frame.ScrollFrame = CreateFrame("ScrollFrame", nil, frame, "ScrollFrameTemplate")
    frame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", frame.ScrollFrame, "TOPRIGHT", SCROLL_FRAME_SCROLL_BAR_OFFSET_LEFT, 0);
    frame.ScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", frame.ScrollFrame, "BOTTOMRIGHT", SCROLL_FRAME_SCROLL_BAR_OFFSET_LEFT, 0);

    frame.CancelButton = AceGUI:Create("Button")
    frame.CancelButton:SetAutoWidth(true)
    frame.CancelButton:SetText(CANCEL)
    frame.CancelButton:SetParent({ content = frame })
    frame.CancelButton:SetPoint("BOTTOMRIGHT", -6, 4)
    frame.CancelButton:SetCallback("OnClick", function() frame:Hide() end)
    frame.CancelButton.frame:Show()

    frame.SaveButton = AceGUI:Create("Button")
    frame.SaveButton:SetAutoWidth(true)
    frame.SaveButton:SetText(SAVE)
    frame.SaveButton:SetParent({ content = frame })
    frame.SaveButton:SetPoint("RIGHT", frame.CancelButton.frame, "LEFT", -2, 0)
    frame.SaveButton.frame:Show()

    -- ElvUI hack
    if InboxFrame.backdrop and ElvUI then
        frame:StripTextures()
        frame:CreateBackdrop('Transparent')
        frame.backdrop:SetAllPoints()

        local portrait = frame.portrait or frame:GetPortrait()
        portrait:Hide()
    end

    return frame
end

local function UpdateForm(container, iconText)
    for _, widget in pairs(container.children) do
        widget:SetChecked(iconText == widget:GetUserData("icon"))
    end
    ADDON:SetTexture(popup.portrait or popup:GetPortrait(), iconText)
end

local function CreateIconButtons(AceGUI, container)
    for _, icon in pairs(ADDON.iconFiles) do
        local button = AceGUI:Create("FC_CheckedButton")
        ADDON:SetTexture(button.image, icon)

        button:SetUserData("icon", icon)
        button:SetCallback("OnClick", function()
            popup.IconName:SetText(icon)
            UpdateForm(container, icon)
        end)

        container:AddChild(button)
    end
end

local function CreateEditBox(AceGUI, text, parent)
    local edit = AceGUI:Create("EditBox")
    edit:SetLabel(text)
    edit:SetHeight(22)
    edit:SetParent({ content = parent })
    edit:SetPoint("RIGHT", -24, 0)
    edit:DisableButton(true)

    edit.label:ClearAllPoints()
    edit.label:SetPoint("TOPLEFT", 0, -2)

    edit.editbox:ClearAllPoints()
    edit.editbox:SetPoint("LEFT", edit.label, "LEFT", 120, 0)
    edit.editbox:SetPoint("RIGHT")

    edit.frame:Show()

    return edit
end

local function CreateForm()
    local L = ADDON.L
    local AceGUI = LibStub("AceGUI-3.0")

    local window = CreateWindow()

    window.ContactNameEditBox = CreateEditBox(AceGUI, L["Contact Name:"], window)
    window.ContactNameEditBox:SetPoint("TOPLEFT", 24, -70)
    window.NoteEditBox = CreateEditBox(AceGUI, L["Contact Note:"], window)
    window.NoteEditBox:SetPoint("TOPLEFT", window.ContactNameEditBox.frame, "BOTTOMLEFT", 0, 0)

    local divider = window:CreateTexture(nil, "ARTWORK")
    divider:SetAtlas("Options_HorizontalDivider", true)
    divider:SetPoint("CENTER", window.NoteEditBox.frame, "BOTTOM", 0, -7)
    divider:SetWidth(400)

    window.IconName = CreateEditBox(AceGUI, MACRO_POPUP_CHOOSE_ICON, window)
    window.IconName:SetPoint("TOPLEFT", window.NoteEditBox.frame, "BOTTOMLEFT", 0, -14)

    window.ScrollFrame:SetPoint("TOPLEFT",  window.IconName.frame, "BOTTOMLEFT", 0, -3)
    window.ScrollFrame:SetPoint("BOTTOMRIGHT", -44, 35)

    buttonContainer = AceGUI:Create("SimpleGroup")
    buttonContainer:SetParent({ content = window.ScrollFrame })
    buttonContainer:SetPoint("TOPLEFT")
    buttonContainer:SetWidth(360)
    buttonContainer:SetLayout("Flow")
    buttonContainer.frame:Show()
    window.ScrollFrame:SetScrollChild(buttonContainer.frame)

    CreateIconButtons(AceGUI, buttonContainer)

    window:HookScript("OnShow", function()
        ADDON:SetEnableContacts(false)
    end)
    window:HookScript("OnHide", function()
        ADDON:SetEnableContacts(true)
    end)

    window.SaveButton:SetCallback("OnClick", function()
        window:Hide()
        local recipient = window.ContactNameEditBox:GetText()
        if recipient ~= "" then
            local icon = window.IconName:GetText()
            if not icon or string.len(icon) == 0 then
                icon = CONTACT_DEFAULT_ICON
            end
            ADDON:SetContact(activeContactIndex, recipient, icon, window.NoteEditBox:GetText())
        end
    end)

    return window
end

function ADDON:ShowEditContactPopup(index)
    if not popup then
        popup = CreateForm()
    end

    activeContactIndex = index

    local contact = self.settings.contacts[index] or {}

    popup:SetTitle(contact.recipient and ADDON.L.EDIT_CONTACT_TITLE or ADDON.L.CREATE_CONTACT_TITLE)

    local nameEdit = popup.ContactNameEditBox
    nameEdit:SetText(contact.recipient or "")

    popup.NoteEditBox:SetText(contact.note or "")

    local icon = contact.icon or CONTACT_DEFAULT_ICON
    popup.IconName:SetText(icon)

    UpdateForm(buttonContainer, icon)
    popup:Show()
    nameEdit:SetFocus()

    self:SetEnableContacts(false)
end