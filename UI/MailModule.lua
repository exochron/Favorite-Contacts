local _, ADDON = ...

local MODULE_NAME = 'mail'

local container, OnNextInfoUpdate

local function UpdateContainer()
    ADDON:UpdateContactContainer(container, ADDON.settings)
    ADDON:UpdateContactButtons(container)

    if ADDON.settings.position == "RIGHT" then
        local width = container.frame:GetWidth() * container.frame:GetScale()
        OpenMailFrame:SetPoint("TOPLEFT", InboxFrame, "TOPRIGHT", width + ADDON.CONTACT_BUTTON_MARGIN, 0)
    else
        OpenMailFrame:SetPoint("TOPLEFT", InboxFrame, "TOPRIGHT", 0, 0)
    end
    UpdateUIPanelPositions(OpenMailFrame)
end

local function ClickToSend()
    if ADDON.settings.clickToSend and SendMailMailButton:IsVisible() and SendMailMailButton:IsEnabled() then
        SendMailMailButton:Click()
    end
end

local function ContactHandler(_, contact)
    MailFrameTab_OnClick(nil, 2)
    SendMailNameEditBox:SetText(contact.recipient)
    local handler = SendMailNameEditBox:GetScript("OnTextChanged")
    if handler then
        handler(SendMailNameEditBox, contact.recipient)
    end
    SendMailSubjectEditBox:SetFocus()

    if CursorHasItem() then
        OnNextInfoUpdate = ClickToSend
        SendMailAttachmentButton_OnDropAny() -- triggers event: MAIL_SEND_INFO_UPDATE
    else
        ClickToSend()
    end
end

ADDON.Events:RegisterCallback('Login', function()
    ADDON:RegisterModule(MODULE_NAME, ADDON.settings)

    MailFrame:HookScript("OnEvent", function(_, event)
        if event == "MAIL_SEND_INFO_UPDATE" and OnNextInfoUpdate then
            OnNextInfoUpdate()
            OnNextInfoUpdate = nil
        end
    end)

    MailFrame:HookScript("OnShow", function()
        if ADDON.settings.position == "NONE" then
            return
        end

        if not container then
            ADDON.Events:TriggerEvent("LoadUI")
            ADDON.Events:UnregisterEvents({"LoadUI"})

            container = ADDON:CreateContactContainer(max(InboxFrame:GetFrameLevel(), SendMailFrame:GetFrameLevel()))
            container.Module = MODULE_NAME
            container.AttachFrame = MailFrame
            container.ContactHandler = ContactHandler

            UpdateContainer()

            MailFrame:HookScript("OnHide", function()
                container.frame:Hide()
            end)

            ADDON.MailContainer = container -- only for screenshots
        end

        container.frame:Show()
    end )
end)

ADDON.Events:RegisterCallback("ContactUpdated", function(_, module, index)
    if container and module == MODULE_NAME then
        ADDON:UpdateContactButton(index, container)
    end
end, MODULE_NAME)
ADDON.Events:RegisterCallback("ContainerUpdated", function(_, module)
    if container and module == MODULE_NAME then
        UpdateContainer()
    end
end, MODULE_NAME)
ADDON.Events:RegisterCallback("ContainerEnabled", function(_, enabled)
    if container then
        for _, button in pairs(container.contactButtons) do
            button:SetDisabled(not enabled)
        end
    end
end, MODULE_NAME)
