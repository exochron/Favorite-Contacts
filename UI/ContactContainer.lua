local _, ADDON = ...

ADDON.CONTACT_BUTTON_SIZE = 36
ADDON.CONTACT_BUTTON_MARGIN = 3

function ADDON:CreateContactContainer(frameLevel)
    local AceGUI = LibStub("AceGUI-3.0")
    local container = AceGUI:Create("SimpleGroup")
    container:SetLayout("Flow")
    container.frame:SetToplevel(true)
    container.frame:SetFrameStrata("HIGH")
    container.frame:SetFrameLevel(frameLevel)
    container:SetAutoAdjustHeight(false)
    container.content:SetAllPoints() -- ElvUI moves content

    container.contactButtons = {}

    return container
end

function ADDON:UpdateContactContainer(container, settings)
    -- clear all buttons and generate them again
    container.contactButtons = {}
    container:ReleaseChildren()

    local scale = settings.scale
    local position = settings.position
    local referenceFrame = container.AttachFrame

    local width = ((ADDON.CONTACT_BUTTON_SIZE + ADDON.CONTACT_BUTTON_MARGIN) * settings.columnCount)+1
    local height = ((ADDON.CONTACT_BUTTON_SIZE + ADDON.CONTACT_BUTTON_MARGIN) * settings.rowCount)+1
    container:SetWidth(width)
    container:SetHeight(height)

    if scale == "AUTO" then
        if position == "TOP" or position == "BOTTOM" then
            scale = referenceFrame:GetScale() * referenceFrame:GetWidth() / width
        else
            scale = referenceFrame:GetScale() * (referenceFrame:GetHeight()+5) / height
        end
    end
    container.frame:SetScale(scale)

    local xOffset, yOffset, extraHeight, extraWidth = 0, 0, 0, 0
    container:ClearAllPoints()

    if position == "LEFT" then
        xOffset = width * scale + ADDON.CONTACT_BUTTON_MARGIN
        container:SetPoint("TOPRIGHT", referenceFrame, "TOPLEFT", -ADDON.CONTACT_BUTTON_MARGIN, 2)
    elseif position == "TOP" then
        yOffset = -((height * scale) + ADDON.CONTACT_BUTTON_MARGIN)
        container:SetPoint("BOTTOMLEFT", referenceFrame, "TOPLEFT", 0, ADDON.CONTACT_BUTTON_MARGIN)
    elseif position == "BOTTOM" then
        extraHeight = height * scale
        container:SetPoint("TOPLEFT", referenceFrame, "BOTTOMLEFT", 0, -32 -ADDON.CONTACT_BUTTON_MARGIN)
    elseif position == "RIGHT" then
        extraWidth = width * scale + ADDON.CONTACT_BUTTON_MARGIN
        container:SetPoint("TOPLEFT", referenceFrame, "TOPRIGHT", ADDON.CONTACT_BUTTON_MARGIN, 2)
    end

    referenceFrame:SetAttribute("UIPanelLayout-xoffset", xOffset)
    referenceFrame:SetAttribute("UIPanelLayout-yoffset", yOffset)
    referenceFrame:SetAttribute("UIPanelLayout-extraWidth", extraWidth)
    referenceFrame:SetAttribute("UIPanelLayout-extraHeight", extraHeight)

    UpdateUIPanelPositions(referenceFrame)
end