local _, ADDON = ...

ADDON.CONTACT_BUTTON_SIZE = 36
ADDON.CONTACT_BUTTON_MARGIN = 3

local function CreateContainer()
    local AceGUI = LibStub("AceGUI-3.0")
    local contactContainer = AceGUI:Create("SimpleGroup")
    contactContainer:SetLayout("Flow")
    contactContainer.frame:SetToplevel(true)
    contactContainer.frame:SetFrameStrata("HIGH")
    contactContainer.frame:SetFrameLevel(max(InboxFrame:GetFrameLevel(), SendMailFrame:GetFrameLevel()))
    contactContainer:SetAutoAdjustHeight(false)
    contactContainer.content:SetAllPoints() -- ElvUI moves content

    return contactContainer
end

function ADDON:UpdateContactContainer()
    local scale = self.settings.scale
    local position = self.settings.position

    local width = ((ADDON.CONTACT_BUTTON_SIZE + ADDON.CONTACT_BUTTON_MARGIN) * self.settings.columnCount) + 1
    local height = ((ADDON.CONTACT_BUTTON_SIZE + ADDON.CONTACT_BUTTON_MARGIN) * self.settings.rowCount) + 1
    self.contactContainer:SetWidth(width)
    self.contactContainer:SetHeight(height)

    if scale == "AUTO" then
        if position == "TOP" or position == "BOTTOM" then
            scale = MailFrame:GetScale() * MailFrame:GetWidth() / width
        else
            scale = MailFrame:GetScale() * (MailFrame:GetHeight() + 5) / height
        end
    end
    self.contactContainer.frame:SetScale(scale)

    local xoffset, yoffset, extraHeight, extraWidth = 0, 0, 0, 0
    self.contactContainer:ClearAllPoints()
    OpenMailFrame:ClearAllPoints()

    if position == "LEFT" then
        xoffset = width * scale + ADDON.CONTACT_BUTTON_MARGIN
        self.contactContainer:SetPoint("TOPRIGHT", MailFrame, "TOPLEFT", -ADDON.CONTACT_BUTTON_MARGIN, 3)
        OpenMailFrame:SetPoint("TOPLEFT", InboxFrame, "TOPRIGHT", 0, 0)
    elseif position == "TOP" then
        yoffset = -((height * scale) + ADDON.CONTACT_BUTTON_MARGIN)
        self.contactContainer:SetPoint("BOTTOMLEFT", MailFrame, "TOPLEFT", 0, ADDON.CONTACT_BUTTON_MARGIN)
        OpenMailFrame:SetPoint("TOPLEFT", InboxFrame, "TOPRIGHT", 0, 0)
    elseif position == "BOTTOM" then
        extraHeight = height * scale
        self.contactContainer:SetPoint("TOPLEFT", MailFrameTab1, "BOTTOMLEFT", 0, -ADDON.CONTACT_BUTTON_MARGIN)
        OpenMailFrame:SetPoint("TOPLEFT", InboxFrame, "TOPRIGHT", 0, 0)
    else
        extraWidth = width * scale + ADDON.CONTACT_BUTTON_MARGIN
        self.contactContainer:SetPoint("TOPLEFT", MailFrame, "TOPRIGHT", ADDON.CONTACT_BUTTON_MARGIN, 3)
        OpenMailFrame:SetPoint("TOPLEFT", InboxFrame, "TOPRIGHT", width * scale + ADDON.CONTACT_BUTTON_MARGIN, 0)
    end

    MailFrame:SetAttribute("UIPanelLayout-xoffset", xoffset)
    MailFrame:SetAttribute("UIPanelLayout-yoffset", yoffset)
    MailFrame:SetAttribute("UIPanelLayout-extraWidth", extraWidth)
    MailFrame:SetAttribute("UIPanelLayout-extraHeight", extraHeight)

    UpdateUIPanelPositions(MailFrame)
    UpdateUIPanelPositions(OpenMailFrame)
end

ADDON:RegisterLoadUICallback(function()
    ADDON.contactContainer = CreateContainer()
    ADDON:UpdateContactContainer()

    ADDON.contactContainer.frame:Show()

    MailFrame:HookScript("OnShow", function()
        ADDON.contactContainer.frame:Show()
    end)
    MailFrame:HookScript("OnHide", function()
        ADDON.contactContainer.frame:Hide()
    end)
end)
