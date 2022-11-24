local _, ADDON = ...

local CONTACT_DEFAULT_ICON = "INV_Misc_GroupLooking"

local popup, buttonContainer, activeContactIndex

local function CreateWindow()
    local frame = CreateFrame("Frame", "FavoriteContactsEditFrame", UIParent)
    tinsert(UISpecialFrames, frame:GetName()) -- also close frame on escape

    frame:EnableMouse(true)
    frame:SetWidth(419)
    frame:SetHeight((min(ceil(#ADDON.iconFiles / 8), 8) * 45) + 132)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")

    local tex = frame:CreateTexture(nil, "BACKGROUND")
    tex:SetPoint("TOPLEFT", 7, -7)
    tex:SetPoint("BOTTOMRIGHT", -7, 7)
    tex:SetColorTexture(0, 0, 0, 0.8)

    frame.BorderBox = CreateFrame("Frame", nil, frame, "SelectionFrameTemplate")
    frame.BorderBox:SetPoint("TOPLEFT")
    frame.BorderBox:SetPoint("BOTTOMRIGHT")

    -- ElvUI hack
    if InboxFrame.backdrop and ElvUI then
        frame:StripTextures()
        frame:CreateBackdrop('Transparent')
        frame.backdrop:SetAllPoints()
        frame.BorderBox:StripTextures()

        local E, _ = unpack(ElvUI)
        local S = E:GetModule('Skins')
        S:HandleButton(frame.BorderBox.OkayButton, true)
        S:HandleButton(frame.BorderBox.CancelButton, true)
    end

    return frame
end

local function UpdateForm(container, iconText)
    for _, widget in pairs(container.children) do
        widget:SetChecked(iconText == widget:GetUserData("icon"))
    end
end

local function CreateIconButtons(AceGUI, container)
    for _, icon in pairs(ADDON.iconFiles) do
        local button = AceGUI:Create("FC_CheckedButton")
        ADDON:SetTexture(button.image, icon)

        button:SetUserData("icon", icon)
        button:SetCallback("OnClick", function()
            popup.BorderBox.IconName:SetText(icon)
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

    window.BorderBox.ContactNameEditBox = CreateEditBox(AceGUI, L["Contact Name:"], window.BorderBox)
    window.BorderBox.ContactNameEditBox:SetPoint("TOPLEFT", 24, -14)
    window.BorderBox.NoteEditBox = CreateEditBox(AceGUI, L["Contact Note:"], window.BorderBox)
    window.BorderBox.NoteEditBox:SetPoint("TOPLEFT", 24, -36)
    window.BorderBox.IconName = CreateEditBox(AceGUI, MACRO_POPUP_CHOOSE_ICON, window.BorderBox)
    window.BorderBox.IconName:SetPoint("TOPLEFT", 24, -70)

    buttonContainer = AceGUI:Create("ScrollFrame")
    buttonContainer:SetParent({ content = window.BorderBox })
    buttonContainer:SetPoint("TOPLEFT", 24, -95)
    buttonContainer:SetPoint("BOTTOMRIGHT", -24, 35)
    buttonContainer:SetLayout("Flow")
    buttonContainer.frame:Show()

    CreateIconButtons(AceGUI, buttonContainer)

    window:HookScript("OnShow", function()
        ADDON:SetEnableContacts(false)
    end)
    window:HookScript("OnHide", function()
        ADDON:SetEnableContacts(true)
    end)

    window.BorderBox.OnCancel = function() window:Hide() end
    window.BorderBox.OnOkay = function()
        window:Hide()
        local recipient = window.BorderBox.ContactNameEditBox:GetText()
        if recipient ~= "" then
            local icon = window.BorderBox.IconName:GetText()
            if not icon or string.len(icon) == 0 then
                icon = CONTACT_DEFAULT_ICON
            end
            ADDON:SetContact(activeContactIndex, recipient, icon, window.BorderBox.NoteEditBox:GetText())
        end
    end

    return window
end

function ADDON:ShowEditContactPopup(index)
    if not popup then
        popup = CreateForm()
    end

    activeContactIndex = index

    local contact = self.settings.contacts[index] or {}

    local nameEdit = popup.BorderBox.ContactNameEditBox
    nameEdit:SetText(contact.recipient or "")

    popup.BorderBox.NoteEditBox:SetText(contact.note or "")

    local icon = contact.icon or CONTACT_DEFAULT_ICON
    popup.BorderBox.IconName:SetText(icon)

    UpdateForm(buttonContainer, icon)
    popup:Show()
    nameEdit:SetFocus()

    self:SetEnableContacts(false)
end