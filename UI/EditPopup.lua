local ADDON_NAME, ADDON = ...

local AceGUI = LibStub("AceGUI-3.0")

local CONTACT_DEFAULT_ICON = "INV_Misc_GroupLooking"

local popup, buttonContainer

local function CreateWindow()
    local frame = CreateFrame("Frame", nil, UIParent)

    frame:EnableMouse(true)
    frame:SetWidth(419)
    frame:SetHeight(492)
    frame:SetPoint("CENTER")

    local tex = frame:CreateTexture(nil, "BACKGROUND")
    tex:SetPoint("TOPLEFT", 7, -7)
    tex:SetPoint("BOTTOMRIGHT", -7, 7)
    tex:SetColorTexture(0, 0, 0, 0.8)

    local subFrame = CreateFrame("Frame", nil, frame, "SelectionFrameTemplate")
    subFrame:SetPoint("TOPLEFT")
    subFrame:SetPoint("BOTTOMRIGHT")

    frame.BorderBox = subFrame

    -- ElvUI hack
    if MailFrame.backdrop then
        frame:StripTextures()
        frame:CreateBackdrop('Transparent')
        frame.backdrop:SetAllPoints()
        subFrame:StripTextures()
    end

    return frame
end

local function UpdateForm(container)
    local iconText = popup.BorderBox.IconName:GetText()

    for _, widget in pairs(container.children) do
        if iconText == widget:GetUserData("icon") then
            widget:SetChecked(true)
        else
            widget:SetChecked(false)
        end
    end
end

local function CreateIconButtons(container)
    for _, icon in pairs(ADDON.iconFiles) do
        local button = AceGUI:Create("FC_CheckedButton")
        ADDON:SetTexture(button.image, icon)

        button:SetUserData("icon", icon)
        button:SetCallback("OnClick", function(widget)
            popup.BorderBox.IconName:SetText(widget:GetUserData("icon"))
            UpdateForm(container)
        end)

        container:AddChild(button)
    end
end

local function CreateEditBox(text)
    local edit = AceGUI:Create("EditBox")
    edit:SetLabel(text)
    edit:SetWidth(371)
    edit:SetHeight(22)
    edit:SetParent({ content = popup.BorderBox })
    edit:DisableButton(true)

    edit.label:ClearAllPoints()
    edit.label:SetPoint("TOPLEFT", 0, -2)

    edit.editbox:ClearAllPoints()
    edit.editbox:SetPoint("LEFT", edit.label, "LEFT", 120, 0)
    edit.editbox:SetPoint("RIGHT")

    edit.frame:Show()

    return edit
end

local function CreateCloseButton(text, func)
    local button = AceGUI:Create("Button")
    button:SetAutoWidth(true)
    button:SetText(text)
    button:SetParent({ content = popup.BorderBox })
    button:SetCallback("OnClick", function()
        PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
        popup:Hide()

        if func then
            func()
        end
    end)
    button.frame:Show()

    return button
end

local function CreateForm()
    local L = ADDON.L

    popup = CreateWindow()

    popup.BorderBox.ContactNameEditBox = CreateEditBox(L["Contact Name:"])
    popup.BorderBox.ContactNameEditBox:SetPoint("TOPLEFT", 24, -14)
    popup.BorderBox.NoteEditBox = CreateEditBox(L["Contact Note:"])
    popup.BorderBox.NoteEditBox:SetPoint("TOPLEFT", 24, -36)
    popup.BorderBox.IconName = CreateEditBox(MACRO_POPUP_CHOOSE_ICON)
    popup.BorderBox.IconName:SetPoint("TOPLEFT", 24, -70)

    local scrollcontainer = AceGUI:Create("SimpleGroup")
    scrollcontainer:SetWidth(370)
    scrollcontainer:SetHeight(360)
    scrollcontainer:SetParent({ content = popup.BorderBox })
    scrollcontainer:SetPoint("TOP", 0, -95)
    scrollcontainer:SetLayout("Fill")

    buttonContainer = AceGUI:Create("ScrollFrame")
    buttonContainer:SetLayout("Flow")
    scrollcontainer:AddChild(buttonContainer)

    CreateIconButtons(buttonContainer)

    popup:HookScript("OnShow", function()
        ADDON:SetEnableContacts(false)
    end)
    popup:HookScript("OnHide", function()
        ADDON:SetEnableContacts(true)
    end)

    popup.BorderBox.OkayButton:Hide()
    popup.BorderBox.CancelButton:Hide()

    local cancelButton = CreateCloseButton(CANCEL)
    cancelButton:SetPoint("BOTTOMRIGHT", -11, 11)

    local okayButton = CreateCloseButton(OKAY, function()
        local index = popup.index
        local recipient = popup.BorderBox.ContactNameEditBox:GetText()
        local note = popup.BorderBox.NoteEditBox:GetText()

        local icon = popup.BorderBox.IconName:GetText()
        if (not icon or string.len(icon) == 0) then
            icon = CONTACT_DEFAULT_ICON
        end

        if recipient ~= "" then
            ADDON:SetContact(index, recipient, icon, note)
        end
    end)
    okayButton:SetWidth(math.max(cancelButton.frame:GetWidth(), 78))
    okayButton:SetPoint("RIGHT", cancelButton.frame, "LEFT", -2, 0)

    return popup
end

function ADDON:ShowEditContactPopup(index)
    if not popup then
        popup = CreateForm()
    end

    popup.index = index

    local contact = self.settings.contacts[index] or {}

    local nameEdit = popup.BorderBox.ContactNameEditBox
    nameEdit:SetText(contact.recipient or "")

    local noteEdit = popup.BorderBox.NoteEditBox
    noteEdit:SetText(contact.note or "")

    local iconEdit = popup.BorderBox.IconName
    iconEdit:SetText(contact.icon or CONTACT_DEFAULT_ICON)

    UpdateForm(buttonContainer)
    popup:Show()
    nameEdit:SetFocus()

    self:SetEnableContacts(false)
end