local ADDON_NAME, ADDON = ...

local function SupportBulkMailInbox()
    if (not BulkMailInbox) then
        return
    end

    hooksecurefunc(BulkMailInbox, "AdjustSizeAndPosition", function(sender, tooltip)
        if (not tooltip.moved) then
            local extraWidth = MailFrame:GetAttribute("UIPanelLayout-extraWidth")

            local scale = BulkMailInbox.db.profile.scale
            local barHeight = BulkMailInbox._toolbar:GetHeight() * scale
            local uiHeight = UIParent:GetHeight()

            local tipHeight = tooltip:GetHeight() * scale
            local offx = math.min((uiHeight - tipHeight - barHeight) / 2, uiHeight + 12 - MailFrame:GetTop() * MailFrame:GetScale()) + barHeight

            tooltip:ClearAllPoints()
            tooltip:SetPoint("TOPLEFT", UIParent, "TOPLEFT", (MailFrame:GetRight() + extraWidth) * MailFrame:GetScale() / scale, -offx / scale)
        end
    end)
end

ADDON:RegisterLoginCallback(SupportBulkMailInbox)