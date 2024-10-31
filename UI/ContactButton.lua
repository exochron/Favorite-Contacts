local _, ADDON = ...

local CONTACT_DEFAULT_ICON = "INV_Misc_GroupLooking"

local currentDragContact = 0
local clickTime = 0

local AceGUI = LibStub("AceGUI-3.0")

local function CreateContextMenu(_, rootDescription, contextIndex, container)
    local contact = ADDON:GetContact(container.Module, contextIndex)

    if contact then
        rootDescription:CreateButton(EDIT, function()
            ADDON:ShowEditContactPopup(contextIndex, container)
        end);
        rootDescription:CreateButton(DELETE, function()
            ADDON:DeleteContact(container.Module, contextIndex)
        end);
    else
        rootDescription:CreateButton(ADDON.L["Create"], function()
            ADDON:ShowEditContactPopup(contextIndex, container)
        end);
    end

    rootDescription:CreateButton(CANCEL, function()  end);
end

local function handleContextMenu(button, container)
    MenuUtil.CreateContextMenu(button, CreateContextMenu, button.index, container)
end

local function OnContactButtonClicked(button, _, buttonType)
    if currentDragContact ~= 0 then
        ADDON:StopDrag(button.index)
        return
    end

    local container = button.parent

    if buttonType == "LeftButton" then
        if button.index then
            local contact = ADDON:GetContact(container.Module, button.index)
            if contact then
                button.parent:ContactHandler(contact)
            else
                -- DoubleClick on empty button
                if GetTime() - clickTime < 0.5 then
                    ADDON:ShowEditContactPopup(button.index, container)
                end
                clickTime = GetTime()
            end
        end
        return
    end

    if buttonType == "RightButton" then
        handleContextMenu(button, container)
        return
    end
end

local function CreateContactButton(index, container)
    local button = container.contactButtons[index]

    if button then
        return button
    end

    button = AceGUI:Create("Icon")
    container:AddChild(button)

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
        local contact = ADDON:GetContact(container.Module, widget.index)
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
            ADDON:StartDrag(container.Module, widget.index)
            currentDragContact = widget.index
        end
    end)
    button:SetCallback("OnDragStop", function(widget)
        if not widget.disabled then
            ADDON:StopDrag(widget.index)

            if (false == container.content:IsMouseOver()) then
                ADDON:DeleteContact(container.Module, currentDragContact)
                currentDragContact = 0
            end
        end
    end)
    button:SetCallback("OnReceiveDrag", function(widget)
        if not widget.disabled then
            if currentDragContact ~= 0 then
                ADDON:SwapContacts(container.Module, currentDragContact, widget.index)
                currentDragContact = 0
            elseif CursorHasItem() then
                OnContactButtonClicked(button, "OnClick", "LeftButton")
            end
        end
    end)

    button.index = index

    container.contactButtons[index] = button

    return button
end

function ADDON:UpdateContactButton(index, container)
    if (index < 1 and index > ADDON:GetTotalButtonCount(container.Module)) then
        return
    end

    local button = CreateContactButton(index, container)

    local contact = ADDON:GetContact(container.Module, index)
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

function ADDON:UpdateContactButtons(container)
    local buttonCount = ADDON:GetTotalButtonCount(container.Module)
    for index = 1, buttonCount do
        self:UpdateContactButton(index, container)
    end
end
