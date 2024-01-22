local ADDON_NAME, ADDON = ...

local CONTACT_DEFAULT_ICON = "INV_Misc_GroupLooking"

local contextMenu
local contextMenuIndex
local contextMenuContainer
local currentDragContact = 0
local clickTime = 0

local AceGUI = LibStub("AceGUI-3.0")

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
        contextMenuIndex = button.index
        contextMenuContainer = container
        ToggleDropDownMenu(1, nil, contextMenu, button.frame, 0, 0)
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
            ADDON:StartDrag(widget.index)
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

local function InitButtonMenu(_, level)
    local info
    local container = contextMenuContainer
    if not container then
        return
    end

    local contact = ADDON:GetContact(container.Module, contextMenuIndex)
    if contact then
        info = {
            notCheckable = true,
            text = EDIT,
            func = function()
                ADDON:ShowEditContactPopup(contextMenuIndex, container)
            end,
        }
        UIDropDownMenu_AddButton(info, level)

        info = {
            notCheckable = true,
            text = DELETE,
            func = function()
                ADDON:DeleteContact(container.Module, contextMenuIndex)
            end,
        }
        UIDropDownMenu_AddButton(info, level)
    else
        info = {
            notCheckable = true,
            text = ADDON.L["Create"],
            func = function()
                ADDON:ShowEditContactPopup(contextMenuIndex, container)
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

ADDON.Events:RegisterCallback('LoadUI', function()
    contextMenu = CreateFrame("Frame", ADDON_NAME .. "ContactButtonContextMenu", nil, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(contextMenu, InitButtonMenu, "MENU")
end, 'contact-button')