local ADDON_NAME, ADDON = ...

-- couldn't use SetCursor() because of missing Atlas features => therefore usage of own cursor frame.
-- couldn't use dragIcon:StartMoving() properly => therefore usage of own update Ticker.

local dragIcon

local function SetDragIconWithCursor()
    dragIcon:ClearAllPoints()
    dragIcon:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", GetCursorPosition())
end


local function CreateDragIcon()
    dragIcon = CreateFrame("Frame")
    dragIcon:SetSize(20,20)
    dragIcon:SetDontSavePosition()
    dragIcon:SetMovable(false)
    dragIcon:EnableMouse(false)
    dragIcon:SetFrameStrata("TOOLTIP")
    dragIcon.background = dragIcon:CreateTexture(nil, "BACKGROUND")
    dragIcon.background:SetAllPoints()

    dragIcon:Hide()

    dragIcon:SetScript('OnShow', function()
        SetDragIconWithCursor()
        dragIcon.timer = C_Timer.NewTicker(0.013, SetDragIconWithCursor) --0.013s = ~70fps
        --self.dragIcon:StartMoving()
    end)

    dragIcon:SetScript('OnHide', function()
        dragIcon.timer:Cancel()
        --self.dragIcon:StopMovingOrSizing()
    end)
end
ADDON:RegisterLoadUICallback(CreateDragIcon)

function ADDON:StartDrag(index)
    local contact = self.settings.contacts[index]
    if (not contact) then
        return
    end

    dragIcon.background:SetAtlas('')
    dragIcon.background:SetTexture('')
    self:SetTexture(dragIcon.background, contact.icon)
    dragIcon:Show()
end

function ADDON:StopDrag()
    dragIcon:Hide()
end