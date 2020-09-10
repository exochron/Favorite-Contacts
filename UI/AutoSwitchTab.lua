local _, ADDON = ...

local checkWithNextUpdate = false

MailFrame:HookScript("OnShow", function()
    if ADDON.settings.switchTabOnEmptyInbox then
        C_Timer.After(0.01, function()
            if MailFrame.inboxBeingChecked then
                checkWithNextUpdate = true
            else
                checkWithNextUpdate = false
                if GetInboxNumItems() == 0 then
                    MailFrameTab_OnClick(nil, 2)
                end
            end
        end)
    end
end)
MailFrame:HookScript("OnEvent", function(self, event)
    if ADDON.settings.switchTabOnEmptyInbox then
        if event == "MAIL_INBOX_UPDATE" then
            if checkWithNextUpdate and GetInboxNumItems() == 0 then
                MailFrameTab_OnClick(nil, 2)
            end
            checkWithNextUpdate = false
        end
    end
end)