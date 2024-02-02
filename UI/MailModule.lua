local _, ADDON = ...

local MODULE_NAME = 'mail'

local container

local function SendMail()
    if SendMailMailButton:IsVisible() and SendMailMailButton:IsEnabled() then
        SendMailMailButton:Click()
    end
end

ADDON.Events:RegisterCallback('Login', function()
    ADDON:RegisterModule(MODULE_NAME, ADDON.settings)

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
            container.ContactHandler = function(_, contact)
                MailFrameTab_OnClick(nil, 2)
                SendMailNameEditBox:SetText(contact.recipient)
                SendMailSubjectEditBox:SetFocus()

                if CursorHasItem() then
                    SendMailAttachmentButton_OnDropAny()
                end
                if ADDON.settings.clickToSend then
                    SendMail()
                end
            end

            ADDON:UpdateContactContainer(container, ADDON.settings)
            ADDON:UpdateContactButtons(container)

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
        ADDON:UpdateContactContainer(container, ADDON.settings)
        ADDON:UpdateContactButtons(container)
    end
end, MODULE_NAME)
ADDON.Events:RegisterCallback("ContainerEnabled", function(_, enabled)
    if container then
        for _, button in pairs(container.contactButtons) do
            button:SetDisabled(not enabled)
        end
    end
end, MODULE_NAME)
