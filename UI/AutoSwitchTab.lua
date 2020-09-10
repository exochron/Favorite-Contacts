local ADDON_NAME, ADDON = ...

MailFrame:HookScript("OnShow", function()
    if ADDON.settings.switchTabOnEmptyInbox then
        C_Timer.After(0.02, function()
            local numItems, totalItems = GetInboxNumItems()
            if numItems == 0 and totalItems == 0 then
                MailFrameTab_OnClick(nil, 2)
            end
        end);
    end
end)