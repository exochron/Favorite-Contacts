local ADDON_NAME, ADDON = ...

local CONTACT_BUTTON_SIZE = 36
local CONTACT_BUTTON_MARGIN = 12

local AceGUI = LibStub("AceGUI-3.0")

local function CreateContainer()
    local contactContainer = AceGUI:Create("SimpleGroup")
    contactContainer:SetLayout()
    contactContainer.frame:SetToplevel(true)
    contactContainer.frame:SetFrameStrata("HIGH")
    contactContainer.content:Hide()

    ADDON.contactContainer = contactContainer
end

function ADDON:UpdateContactContainer()
    local scale = self.settings.scale
    local position = self.settings.position

    local width = ((CONTACT_BUTTON_SIZE + CONTACT_BUTTON_MARGIN) * self.settings.columnCount) - CONTACT_BUTTON_MARGIN
    local height = ((CONTACT_BUTTON_SIZE + CONTACT_BUTTON_MARGIN) * self.settings.rowCount) - CONTACT_BUTTON_MARGIN
    self.contactContainer:SetWidth(width)
    self.contactContainer:SetHeight(height)

    if scale == "AUTO" then
        if position == "TOP" or position == "BOTTOM" then
            scale = MailFrame:GetScale() * MailFrame:GetWidth() / width
        else
            scale = MailFrame:GetScale() * (MailFrame:GetHeight() - 4) / height
        end
    end
    self.contactContainer.frame:SetScale(scale)

    if (position == "LEFT") then
        MailFrame:SetAttribute("UIPanelLayout-xoffset", width * scale + CONTACT_BUTTON_MARGIN)
        MailFrame:SetAttribute("UIPanelLayout-yoffset", 0)
        MailFrame:SetAttribute("UIPanelLayout-extraWidth", 0)
        MailFrame:SetAttribute("UIPanelLayout-extraHeight", 0)

        self.contactContainer:ClearAllPoints()
        self.contactContainer:SetPoint("TOPRIGHT", MailFrame, "TOPLEFT", -CONTACT_BUTTON_MARGIN, 0)

        OpenMailFrame:ClearAllPoints()
        OpenMailFrame:SetPoint("TOPLEFT", InboxFrame, "TOPRIGHT", 0, 0)
    elseif (position == "TOP") then
        MailFrame:SetAttribute("UIPanelLayout-xoffset", 0)
        MailFrame:SetAttribute("UIPanelLayout-yoffset", -((height * scale) + CONTACT_BUTTON_MARGIN))
        MailFrame:SetAttribute("UIPanelLayout-extraWidth", 0)
        MailFrame:SetAttribute("UIPanelLayout-extraHeight", 0)

        self.contactContainer:ClearAllPoints()
        self.contactContainer:SetPoint("BOTTOMLEFT", MailFrame, "TOPLEFT", 0, CONTACT_BUTTON_MARGIN)

        OpenMailFrame:ClearAllPoints()
        OpenMailFrame:SetPoint("TOPLEFT", InboxFrame, "TOPRIGHT", 0, 0)
    elseif (position == "BOTTOM") then
        MailFrame:SetAttribute("UIPanelLayout-xoffset", 0)
        MailFrame:SetAttribute("UIPanelLayout-yoffset", 0)
        MailFrame:SetAttribute("UIPanelLayout-extraWidth", 0)
        MailFrame:SetAttribute("UIPanelLayout-extraHeight", height * scale)

        self.contactContainer:ClearAllPoints()
        self.contactContainer:SetPoint("TOPLEFT", MailFrameTab1, "BOTTOMLEFT", 0, -CONTACT_BUTTON_MARGIN)

        OpenMailFrame:ClearAllPoints()
        OpenMailFrame:SetPoint("TOPLEFT", InboxFrame, "TOPRIGHT", 0, 0)
    else
        MailFrame:SetAttribute("UIPanelLayout-xoffset", 0)
        MailFrame:SetAttribute("UIPanelLayout-yoffset", 0)
        MailFrame:SetAttribute("UIPanelLayout-extraWidth", width * scale + CONTACT_BUTTON_MARGIN)
        MailFrame:SetAttribute("UIPanelLayout-extraHeight", 0)

        self.contactContainer:ClearAllPoints()
        self.contactContainer:SetPoint("TOPLEFT", MailFrame, "TOPRIGHT", CONTACT_BUTTON_MARGIN, 0)

        OpenMailFrame:ClearAllPoints()
        OpenMailFrame:SetPoint("TOPLEFT", InboxFrame, "TOPRIGHT", width * scale + CONTACT_BUTTON_MARGIN, 0)
    end

    UpdateUIPanelPositions(MailFrame)
    UpdateUIPanelPositions(OpenMailFrame)
end

ADDON:RegisterLoadUICallback(function()
    CreateContainer()
    ADDON:UpdateContactContainer()
end)
