local _, ADDON = ...

local checkWithNextUpdate = false

local function ShowHandler()
    if ADDON.settings.switchTabOnEmptyInbox then
        C_Timer.After(0.01, function()
            if MailFrame.inboxBeingChecked then
                checkWithNextUpdate = true
            else
                checkWithNextUpdate = false
                if GetInboxNumItems() == 0 then
                    MailFrameTab2:Click()
                end
            end
        end)
    end
end

ADDON.Events:RegisterCallback('LoadUI', function()
    if MailFrame:IsShown() then
        ShowHandler()
    end

    MailFrame:HookScript("OnShow", ShowHandler)
    MailFrame:HookScript("OnEvent", function(_, event)
        if ADDON.settings.switchTabOnEmptyInbox then
            if event == "MAIL_INBOX_UPDATE" then
                if checkWithNextUpdate and GetInboxNumItems() == 0 then
                    MailFrameTab2:Click()
                end
                checkWithNextUpdate = false
            end
        end
    end)
end, 'auto-switch')