local ADDON_NAME, ADDON = ...

local MODULE_NAME = 'craftOrder'

local container

local function showContainer()
    if ADDON.settings.craftOrder.position == "NONE" then
        return
    end

    if not container then
        ADDON.Events:TriggerEvent("LoadUI")
        ADDON.Events:UnregisterEvents({"LoadUI"})

        container = ADDON:CreateContactContainer(ProfessionsCustomerOrdersFrame:GetFrameLevel())
        container.Module = MODULE_NAME
        container.AttachFrame = ProfessionsCustomerOrdersFrame
        container.ContactHandler = function(_, contact)
            ProfessionsCustomerOrdersFrame.Form:SetOrderRecipient(Enum.CraftingOrderType.Personal)
            ProfessionsCustomerOrdersFrame.Form.OrderRecipientDropDown.Text:SetText(PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_PRIVATE)
            ProfessionsCustomerOrdersFrame.Form.OrderRecipientTarget:SetText(contact.recipient)
        end

        ADDON:UpdateContactContainer(container, ADDON.settings.craftOrder)
        ADDON:UpdateContactButtons(container)

        ProfessionsCustomerOrdersFrame:HookScript("OnHide", function()
            container.frame:Hide()
        end)
        ProfessionsCustomerOrdersFrame.Form:HookScript("OnHide", function()
            container.frame:Hide()
        end)
    end

    container.frame:Show()
end

ADDON.Events:RegisterCallback('Login', function()
    ADDON:RegisterModule(MODULE_NAME, ADDON.settings.craftOrder)

    EventRegistry:RegisterCallback("ProfessionsCustomerOrders.RecipeSelected", showContainer, ADDON_NAME)
    EventRegistry:RegisterCallback("ProfessionsCustomerOrders.RecraftCategorySelected", showContainer, ADDON_NAME)
end)

ADDON.Events:RegisterCallback("ContactUpdated", function(_, module, index)
    if container and module == MODULE_NAME then
        ADDON:UpdateContactButton(index, container)
    end
end, MODULE_NAME)
ADDON.Events:RegisterCallback("ContainerUpdated", function(_, module)
    if container and module == MODULE_NAME then
        ADDON:UpdateContactContainer(container, ADDON.settings.craftOrder)
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