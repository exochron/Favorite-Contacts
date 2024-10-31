local ADDON_NAME, ADDON = ...

if AddonCompartmentFrame then
    AddonCompartmentFrame:RegisterAddon({
        text = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Title"),
        icon = C_AddOns.GetAddOnMetadata(ADDON_NAME, "IconTexture"),
        registerForAnyClick = true,
        notCheckable = true,
        func = function()
            ADDON:OpenSettings()
        end,
        funcOnEnter = function(menuItem)
            GameTooltip:SetOwner(menuItem, "ANCHOR_CURSOR")
            GameTooltip:SetText("|T" .. C_AddOns.GetAddOnMetadata(ADDON_NAME, "IconTexture") .. ":0|t " .. C_AddOns.GetAddOnMetadata(ADDON_NAME, "Title"))
            GameTooltip:Show()
        end,
        funcOnLeave = function()
            GameTooltip:Hide()
        end,
    })
end