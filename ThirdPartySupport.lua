local ADDON_NAME, ADDON = ...

local function SupportBulkMailInbox()
    if BulkMailInbox then
        hooksecurefunc(BulkMailInbox, "AdjustSizeAndPosition", function(sender, tooltip)
            if not tooltip.moved and MailFrame and MailFrame:GetTop() then
                local extraWidth = MailFrame:GetAttribute("UIPanelLayout-extraWidth")
                local point, relativeTo, relativePoint, xOfs, yOfs = tooltip:GetPoint(1)
                tooltip:ClearAllPoints()
                tooltip:SetPoint(point, relativeTo, relativePoint, xOfs + extraWidth + ADDON.CONTACT_BUTTON_MARGIN, yOfs)
            end
        end)
    end
end
ADDON.Events:RegisterCallback('Login', SupportBulkMailInbox, 'bulkmail-inbox')

local function SupportBulkMail()
    if BulkMail then
        hooksecurefunc(BulkMail, "ShowSendQueueGUI", function()
            local tooltip = BulkMail.sendQueueTooltip
            if not tooltip.moved then
                local extraWidth = MailFrame:GetAttribute("UIPanelLayout-extraWidth")
                local point, relativeTo, relativePoint, xOfs, yOfs = tooltip:GetPoint(1)
                tooltip:ClearAllPoints()
                tooltip:SetPoint(point, relativeTo, relativePoint, extraWidth + ADDON.CONTACT_BUTTON_MARGIN, yOfs)
            end
        end)
    end
end
ADDON.Events:RegisterCallback('Login', SupportBulkMail, 'bulkmail')

local function SupportMasque()
    local Masque = LibStub("Masque", true)
    if Masque then
        Masque:Group(ADDON_NAME, "Edit Window")
        Masque:Group(ADDON_NAME, "Mail", "mail")
        if LE_EXPANSION_LEVEL_CURRENT >= LE_EXPANSION_DRAGONFLIGHT then
            Masque:Group(ADDON_NAME, "Crafting Order", "craftOrder")
        end
    end
end
ADDON.Events:RegisterCallback('Login', SupportMasque, 'masque')