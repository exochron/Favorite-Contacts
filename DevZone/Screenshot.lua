local _, ADDON = ...

function ADDON:TakeScreenshots()

    -- hide UI elements
    local UIElementsToHide={
        ChatFrame1,
        MainMenuBar,
        PlayerFrame,
        BuffFrame,
    }
    for _, frame in pairs(UIElementsToHide) do
        frame:Hide()
    end

    if WeakAuras then
        WeakAuras:Toggle() -- turn off WA
    end

    MailFrame_Show()

    -- give time to load properly
    C_Timer.After(0.5, function()
        local gg = LibStub("GalleryGenerator")

        gg:TakeScreenshots(
            {
                function(api)
                    api:BackScreen()
                    MailFrameTab1:Click() -- switch to inbox
                end,
                function(api)
                    api:BackScreen()
                    MailFrameTab2:Click() -- switch to send mail
                    -- create new entry menu
                    api:Point(ADDON.contactButtons[10].frame)
                    api:Click(ADDON.contactButtons[10].frame, "RightButton")
                end,
                function(api)
                    -- edit menu existing (Ptr: Powaa)
                    api:BackScreen()
                    api:Click(ADDON.contactButtons[9].frame, "RightButton")
                    api:Point(DropDownList1Button1)
                end,
                function(api)
                    api:BackScreen()
                    -- edit existing (Ptr: Powaa)
                    api:Click(ADDON.contactButtons[9].frame, "RightButton")
                    api:Click(DropDownList1Button1)
                end,
                function(api)
                    api:BackScreen()
                    ADDON:OpenSettings()
                end,
            },
            function()
                for _, frame in pairs(UIElementsToHide) do
                    frame:Show()
                end
                if WeakAuras then
                    WeakAuras:Toggle() -- turn on WA
                end
            end
        )
    end)
end