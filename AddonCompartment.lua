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
    })
end