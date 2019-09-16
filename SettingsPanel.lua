local ADDON_NAME, ADDON = ...

-- WARNING: Also look into ResetUISettings() on new elements

local AceGUI = LibStub("AceGUI-3.0")

local function BuildHeader(parent, text, offsetY)
    local header = AceGUI:Create("Heading")
    header:SetText(text)
    header:SetWidth(580)
    parent:AddChild(header)

    header:SetPoint("TOP", parent.content, "TOP", 0, offsetY)

    return header
end

local function BuildRadio(parent, text, offsetY, otherRadio, callback)
    local button = AceGUI:Create("CheckBox")
    button:SetType("radio")
    button:SetLabel(text)
    button:SetHeight(16)
    button:SetWidth(button.text:GetWidth() + 24)
    parent:AddChild(button)
    button:SetPoint("TOPLEFT", parent.content, "TOP", 0, offsetY)

    button:SetCallback("OnValueChanged", function(self)
        local other = parent[otherRadio]
        if (self:GetValue() and other:GetValue()) then
            other:SetValue(false)
        elseif not self:GetValue() and not other:GetValue() then
            self:SetValue(true)
        end

        callback(self:GetValue())
    end)

    return button
end

local function BuildCheckBox(parent, text, offsetY)
    local button = AceGUI:Create("CheckBox")
    button:SetLabel(text)
    button:SetWidth(button.text:GetWidth()+25)
    button.text:SetJustifyH("LEFT")
    parent:AddChild(button)
    button:SetPoint("TOP", parent.content, "TOP", 0, offsetY)

    return button
end

local function BuildLabel(parent, text, relativeTo)
    local label = AceGUI:Create("Label")
    label:SetFontObject(GameFontNormal)
    label:SetText(text)
    label:SetWidth(280)
    label:SetJustifyH("RIGHT")
    parent:AddChild(label)
    label:SetPoint("RIGHT", relativeTo.frame, "LEFT", -10, 0)

    return label
end

local function BuildSlider(parent, text, offsetY)

    local slider = AceGUI:Create("Slider")
    slider:SetWidth(250)
    slider:SetSliderValues(1, 30, 1)
    slider.slider:SetObeyStepOnDrag(true)
    parent:AddChild(slider)
    slider:SetPoint("TOPLEFT", parent.content, "TOP", 0, offsetY)

    BuildLabel(parent, text, slider)

    return slider
end

local function BuildFrame()
    local title = GetAddOnMetadata(ADDON_NAME, "Title")
    local frame = AceGUI:Create("BlizOptionsGroup")
    frame:SetName(title)
    frame:SetTitle(title)
    frame:SetLayout(nil)

    local L = ADDON.L
    local yOffset

    yOffset = -10
    BuildHeader(frame, L.SETTING_HEAD_DISPLAY, yOffset)

    yOffset = yOffset - 20
    frame.positionDropDown = AceGUI:Create("Dropdown")
    frame.positionDropDown:SetList({
        TOP = L.SETTING_POSITION_TOP,
        LEFT = L.SETTING_POSITION_LEFT,
        RIGHT = L.SETTING_POSITION_RIGHT,
        BOTTOM = L.SETTING_POSITION_BOTTOM,
    }, { "TOP", "LEFT", "RIGHT", "BOTTOM" }, "Dropdown-Item-Toggle")
    frame:AddChild(frame.positionDropDown)
    frame.positionDropDown:SetWidth(100)
    frame.positionDropDown:SetPoint("TOPLEFT", frame.content, "TOP", 0, yOffset)
    BuildLabel(frame, L.SETTING_POSITION_LABEL, frame.positionDropDown)

    yOffset = yOffset - 30
    frame.columnSlider = BuildSlider(frame, L.SETTING_COLUMN_COUNT_LABEL, yOffset)
    yOffset = yOffset - 40
    frame.rowSlider = BuildSlider(frame, L.SETTING_ROW_COUNT_LABEL, yOffset)

    yOffset = yOffset - 60
    frame.scaleRadioAuto = BuildRadio(frame, L.SETTING_SCALE_AUTO, yOffset, "scaleRadioManual", function(value)
        if (value) then
            frame.scaleEditManual:SetDisabled(true)
        else
            frame.scaleEditManual:SetDisabled(false)
        end
    end)
    yOffset = yOffset - 20
    frame.scaleRadioManual = BuildRadio(frame, L.SETTING_SCALE_MANUAL, yOffset, "scaleRadioAuto", function(value)
        if (value) then
            frame.scaleEditManual:SetDisabled(false)
        else
            frame.scaleEditManual:SetDisabled(true)
        end
    end)
    BuildLabel(frame, L.SETTING_SCALE_LABEL, frame.scaleRadioAuto)

    frame.scaleEditManual = AceGUI:Create("EditBox")
    frame.scaleEditManual:DisableButton(true)
    frame.scaleEditManual:SetWidth(80)
    frame.scaleEditManual.editbox:SetNumber(1.0)
    frame.scaleEditManual.editbox:SetJustifyH("CENTER")
    frame:AddChild(frame.scaleEditManual)
    frame.scaleEditManual:SetPoint("LEFT", frame.scaleRadioManual.frame, "RIGHT")
    frame.scaleEditManual:SetDisabled(true)

    yOffset = yOffset - 40
    BuildHeader(frame, L.SETTING_HEAD_INTERACTION, yOffset)

    yOffset = yOffset - 20
    frame.clickCheck = BuildCheckBox(frame, L.SETTING_CLICKTOSEND_LABEL, yOffset)

    return frame
end

local function RefreshHandler(frame)
    frame.positionDropDown:SetValue(ADDON.settings.position)

    frame.columnSlider:SetValue(ADDON.settings.columnCount)
    frame.rowSlider:SetValue(ADDON.settings.rowCount)

    local scale = ADDON.settings.scale
    if scale == "AUTO" then
        frame.scaleRadioAuto:SetValue(true)
    else
        frame.scaleRadioManual:SetValue(true)
        frame.scaleEditManual.editbox:SetNumber(scale)
        frame.scaleEditManual.editbox:SetCursorPosition(0)
    end

    frame.clickCheck:SetValue(ADDON.settings.clickToSend)
end

local function OKHandler(frame)
    ADDON:SetPosition(frame.positionDropDown:GetValue())
    ADDON:SetSize(frame.columnSlider:GetValue(), frame.rowSlider:GetValue())

    if frame.scaleRadioAuto:GetValue() then
        ADDON:SetScale("AUTO")
    else
        ADDON:SetScale(frame.scaleEditManual.editbox:GetNumber())
    end

    ADDON.settings.clickToSend = frame.clickCheck:GetValue()
end

ADDON:RegisterLoginCallback(function()
    local group = BuildFrame()
    group:SetCallback("refresh", RefreshHandler)
    group:SetCallback("okay", OKHandler)
    group:SetCallback("default", ADDON.ResetUISettings)
    InterfaceOptions_AddCategory(group.frame)
end)