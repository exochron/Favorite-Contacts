local ADDON_NAME, ADDON = ...

local CONTACT_BUTTON_SIZE = 36
local CONTACT_BUTTON_MARGIN = 12

local function CreateContainer()
    local contactContainer = CreateFrame("Frame", nil, UIParent)
    contactContainer:SetToplevel(true)
    contactContainer:SetFrameStrata("HIGH")
    contactContainer:Hide()

    ADDON.contactContainer = contactContainer
end

function ADDON:UpdateContactContainer()
    self.contactContainer:SetScale(self.settings.scale)

    local width = (CONTACT_BUTTON_SIZE + CONTACT_BUTTON_MARGIN) * self.settings.columnCount
    local height = (CONTACT_BUTTON_SIZE + CONTACT_BUTTON_MARGIN) * self.settings.rowCount
    self.contactContainer:SetSize(width, height)

    if (self.settings.position == "LEFT") then
        MailFrame:SetAttribute("UIPanelLayout-xoffset", width * self.settings.scale + CONTACT_BUTTON_MARGIN)
        MailFrame:SetAttribute("UIPanelLayout-yoffset", 0)
        MailFrame:SetAttribute("UIPanelLayout-extraWidth", 0)
        MailFrame:SetAttribute("UIPanelLayout-extraHeight", 0)

        self.contactContainer:ClearAllPoints()
        self.contactContainer:SetPoint("TOPRIGHT", MailFrame, "TOPLEFT", -CONTACT_BUTTON_MARGIN, 0)

        OpenMailFrame:ClearAllPoints()
        OpenMailFrame:SetPoint("TOPLEFT", InboxFrame, "TOPRIGHT", 0, 0)
    elseif (self.settings.position == "TOP") then
        MailFrame:SetAttribute("UIPanelLayout-xoffset", 0)
        MailFrame:SetAttribute("UIPanelLayout-yoffset", -(height * self.settings.scale + CONTACT_BUTTON_MARGIN))
        MailFrame:SetAttribute("UIPanelLayout-extraWidth", 0)
        MailFrame:SetAttribute("UIPanelLayout-extraHeight", 0)

        self.contactContainer:ClearAllPoints()
        self.contactContainer:SetPoint("BOTTOMLEFT", MailFrame, "TOPLEFT", 0, CONTACT_BUTTON_MARGIN)

        OpenMailFrame:ClearAllPoints()
        OpenMailFrame:SetPoint("TOPLEFT", InboxFrame, "TOPRIGHT", 0, 0)
    elseif (self.settings.position == "BOTTOM") then
        MailFrame:SetAttribute("UIPanelLayout-xoffset", 0)
        MailFrame:SetAttribute("UIPanelLayout-yoffset", 0)
        MailFrame:SetAttribute("UIPanelLayout-extraWidth", 0)
        MailFrame:SetAttribute("UIPanelLayout-extraHeight", height * self.settings.scale)

        self.contactContainer:ClearAllPoints()
        self.contactContainer:SetPoint("TOPLEFT", MailFrameTab1, "BOTTOMLEFT", 0, -CONTACT_BUTTON_MARGIN)

        OpenMailFrame:ClearAllPoints()
        OpenMailFrame:SetPoint("TOPLEFT", InboxFrame, "TOPRIGHT", 0, 0)
    else
        MailFrame:SetAttribute("UIPanelLayout-xoffset", 0)
        MailFrame:SetAttribute("UIPanelLayout-yoffset", 0)
        MailFrame:SetAttribute("UIPanelLayout-extraWidth", width * self.settings.scale + CONTACT_BUTTON_MARGIN)
        MailFrame:SetAttribute("UIPanelLayout-extraHeight", 0)

        self.contactContainer:ClearAllPoints()
        self.contactContainer:SetPoint("TOPLEFT", MailFrame, "TOPRIGHT", CONTACT_BUTTON_MARGIN, 0)

        OpenMailFrame:ClearAllPoints()
        OpenMailFrame:SetPoint("TOPLEFT", InboxFrame, "TOPRIGHT", width * self.settings.scale + CONTACT_BUTTON_MARGIN, 0)
    end

    UpdateUIPanelPositions(MailFrame)
    UpdateUIPanelPositions(OpenMailFrame)
end

ADDON:RegisterLoadUICallback(function()
    CreateContainer()
    ADDON:UpdateContactContainer()
end)
