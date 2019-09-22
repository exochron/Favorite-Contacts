local ADDON_NAME, ADDON = ...

local CONTACT_DEFAULT_ICON = "INV_Misc_GroupLooking"
local NUM_ICONS_PER_ROW = 8
local NUM_ICON_ROWS = 8
local NUM_ICONS_SHOWN = NUM_ICONS_PER_ROW * NUM_ICON_ROWS
local ICON_ROW_HEIGHT = 44

local popup

local function UpdateEditContactPopup()
    local scrollFrame = popup.BorderBox.ScrollFrame
    local numIcons = #ADDON.iconFiles
    local scrollOffset = FauxScrollFrame_GetOffset(scrollFrame)

    for i = 1, NUM_ICONS_SHOWN do
        local button = popup.BorderBox["Button" .. i]
        local buttonIcon = button.Icon
        local index = (scrollOffset * NUM_ICONS_PER_ROW) + i
        local texture = ADDON.iconFiles[index]

        if (index <= numIcons and texture) then
            ADDON:SetTexture(buttonIcon, texture)
            button:Show()
        else
            buttonIcon:SetTexture("")
            buttonIcon:SetAtlas("")
            button:Hide()
        end
        if (popup.BorderBox.IconName:GetText() == texture) then
            button:SetChecked(true)
        else
            button:SetChecked(false)
        end
    end

    FauxScrollFrame_Update(scrollFrame, ceil(numIcons / NUM_ICONS_PER_ROW), NUM_ICON_ROWS, ICON_ROW_HEIGHT)
end

local function EditContactPopupSelectTexture(iconIndex)
    popup.BorderBox.IconName:SetText(ADDON.iconFiles[iconIndex])
    UpdateEditContactPopup()
end

local function CreateIconButtons()
    local previous, firstLastRow

    for i = 1, NUM_ICONS_SHOWN do
        local modulo = math.fmod(i, NUM_ICONS_PER_ROW)

        local button = CreateFrame("CheckButton", nil, popup, "FavoriteContactsEditContactButtonTemplate", i)
        if i == 1 then
            button:SetPoint("TOPLEFT", popup.BorderBox.IconLabel, "BOTTOMLEFT", 0, -10)
            firstLastRow = button
        elseif modulo == 1 then
            button:SetPoint("TOPLEFT", firstLastRow, "BOTTOMLEFT", 0, -8)
            firstLastRow = button
        else
            button:SetPoint("LEFT", previous, "RIGHT", 8, 0)
        end

        popup.BorderBox["Button" .. i] = button
        previous = button
    end
end

local function CreateEditContactPopup()
    local L = ADDON.L

    popup = CreateFrame("Frame", nil, UIParent, "FavoriteContactsEditContactPopupTemplate")
    CreateIconButtons()
    popup.BorderBox.NameLabel:SetText(L["Contact Name:"])
    popup.BorderBox.NoteLabel:SetText(L["Contact Note:"])

    local scrollFrame = popup.BorderBox.ScrollFrame

    for index = 1, NUM_ICONS_SHOWN do
        local icon = popup.BorderBox["Button" .. index]
        icon:SetScript("OnClick", function(sender)
            local scrollOffset = FauxScrollFrame_GetOffset(scrollFrame)
            EditContactPopupSelectTexture(sender:GetID() + (scrollOffset * NUM_ICONS_PER_ROW))
        end)
    end

    scrollFrame:SetScript("OnVerticalScroll", function(sender, offset)
        FauxScrollFrame_OnVerticalScroll(sender, offset, ICON_ROW_HEIGHT, function() UpdateEditContactPopup() end)
    end)

    popup.BorderBox.OkayButton:SetScript("OnClick", function()
        popup:Hide()

        local index = popup.index
        local recipient = popup.BorderBox.ContactNameEditBox:GetText()
        local note = popup.BorderBox.NoteEditBox:GetText()

        local icon = popup.BorderBox.IconName:GetText()
        if (not icon or string.len(icon) == 0) then
            icon = CONTACT_DEFAULT_ICON
        end

        ADDON:SetContact(index, recipient, icon, note)

        ADDON:SetEnableContacts(true)
    end)

    popup.BorderBox.CancelButton:SetScript("OnClick", function()
        popup:Hide()

        ADDON:SetEnableContacts(true)
    end)
end

ADDON:RegisterLoadUICallback(CreateEditContactPopup)

function ADDON:ShowEditContactPopup(index)
    popup.index = index

    local contact = self.settings.contacts[index] or {}

    local nameEdit = popup.BorderBox.ContactNameEditBox
    nameEdit:SetText(contact.recipient or "")

    local noteEdit = popup.BorderBox.NoteEditBox
    noteEdit:SetText(contact.note or "")

    local iconEdit = popup.BorderBox.IconName
    iconEdit:SetText(contact.icon or CONTACT_DEFAULT_ICON)

    UpdateEditContactPopup()
    popup:Show()
    nameEdit:SetFocus()

    self:SetEnableContacts(false)
end