local ADDON_NAME, ADDON = ...

-- WARNING: Also look into ResetUISettings() on new elements

local function BuildRadio(parentFrame, text, relativeTo)
    local button = CreateFrame("CheckButton", nil, parentFrame, "UIRadioButtonTemplate")
    button:SetPoint("LEFT", relativeTo, "RIGHT", 15, 0)
    button.text:SetText(text)
    button:SetScript("OnClick", function(self)
        self:GetParent():HandleGroup(self)
    end)
    button:SetHitRectInsets(0, -button.text:GetWidth() - 5, 0, 0)

    return button
end

local function BuildRadioGroup(parentFrame, callback)
    local frame = CreateFrame("Frame", nil, parentFrame)
    frame.HandleGroup = function(self, sender)
        sender:SetChecked(true)
        for _, childFrame in ipairs({ self:GetChildren() }) do
            if sender ~= childFrame then
                childFrame:SetChecked(false)
            end
        end
        if callback then
            callback()
        end
    end

    return frame
end

local function BuildLabel(frame, text, yOffset)
    local label = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    label:SetText(text)
    label:SetPoint("TOP", -label:GetWidth() / 2, yOffset)

    return label
end

local function BuildSlider(frame, text, yOffset)
    local label = BuildLabel(frame, text, yOffset)

    local slider = CreateFrame("Slider", nil, frame, "OptionsSliderTemplate")
    slider:SetPoint("LEFT", label, "RIGHT", 15, 0)
    slider:SetWidth(250)
    slider:SetValueStep(1)
    slider:SetStepsPerPage(1)
    slider:SetMinMaxValues(1, 20)
    slider:SetObeyStepOnDrag(true)
    slider.Low:SetText(1)
    slider.High:SetText(20)
    slider:SetScript("OnValueChanged", function(self, value)
        self.Text:SetText(value)
    end)

    return slider
end


local function BuildFrame()
    local frame = CreateFrame("Frame")
    local L = ADDON.L

    local titleFont = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    titleFont:SetPoint("TOPLEFT", 22, -22)
    titleFont:SetText(GetAddOnMetadata(ADDON_NAME, "Title"))

    local radioGroup = BuildRadioGroup(frame)
    local positionLabel = BuildLabel(frame, L.SETTING_POSITION_LABEL, -70)
    frame.positionRadioTop = BuildRadio(radioGroup, L.SETTING_POSITION_TOP, positionLabel)
    frame.positionRadioLeft = BuildRadio(radioGroup, L.SETTING_POSITION_LEFT, frame.positionRadioTop.text)
    frame.positionRadioRight = BuildRadio(radioGroup, L.SETTING_POSITION_RIGHT, frame.positionRadioLeft.text)
    frame.positionRadioBottom = BuildRadio(radioGroup, L.SETTING_POSITION_BOTTOM, frame.positionRadioRight.text)

    frame.columnSlider = BuildSlider(frame, L.SETTING_COLUMN_COUNT_LABEL, -100)
    frame.rowSlider = BuildSlider(frame, L.SETTING_ROW_COUNT_LABEL, -130)

    local scaleLabel = BuildLabel(frame, L.SETTING_SCALE_LABEL, -160)
    local scaleGroup = BuildRadioGroup(frame, function()
        local enabled = frame.scaleRadioManual:GetChecked()
        local color = 0.5
        if enabled then
            color = 1.0
        end
        frame.scaleEditManual:SetEnabled(enabled)
        frame.scaleEditManual:SetTextColor(color, color, color, 1.0)
    end)
    frame.scaleRadioAuto = BuildRadio(scaleGroup, L.SETTING_SCALE_AUTO, scaleLabel)
    frame.scaleRadioManual = BuildRadio(scaleGroup, L.SETTING_SCALE_MANUAL, frame.scaleRadioAuto.text)
    frame.scaleEditManual = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    frame.scaleEditManual:SetSize(183 - frame.scaleRadioAuto.text:GetWidth() - frame.scaleRadioManual.text:GetWidth(), 20)
    frame.scaleEditManual:SetAutoFocus(false)
    frame.scaleEditManual:SetPoint("LEFT", frame.scaleRadioManual.text, "RIGHT", 10, 0)
    frame.scaleEditManual:SetNumber(1)
    frame.scaleEditManual:SetCursorPosition(0)

    local clickLabel = BuildLabel(frame, L.SETTING_CLICKTOSEND_LABEL, -190)
    local clickGroup = BuildRadioGroup(frame)
    frame.clickRadioOn = BuildRadio(clickGroup, ENABLE, clickLabel)
    frame.clickRadioOff = BuildRadio(clickGroup, DISABLE, frame.clickRadioOn.text)

    return frame
end

local function RefreshHandler(frame)
    local position = ADDON.settings.position
    frame.positionRadioTop:SetChecked(position == "TOP")
    frame.positionRadioLeft:SetChecked(position == "LEFT")
    frame.positionRadioRight:SetChecked(position == "RIGHT")
    frame.positionRadioBottom:SetChecked(position == "BOTTOM")

    frame.columnSlider:SetValue(ADDON.settings.columnCount)
    frame.rowSlider:SetValue(ADDON.settings.rowCount)

    local scale = ADDON.settings.scale
    if scale == "AUTO" then
        frame.scaleRadioAuto:GetParent():HandleGroup(frame.scaleRadioAuto)
    else
        frame.scaleRadioManual:GetParent():HandleGroup(frame.scaleRadioManual)
        frame.scaleEditManual:SetText(scale)
    end

    local click = ADDON.settings.clickToSend
    frame.clickRadioOn:SetChecked(click)
    frame.clickRadioOff:SetChecked(not click)
end

local function OKHandler(frame)
    local position = ADDON.settings.position
    if position ~= "TOP" and frame.positionRadioTop:GetChecked() then
        position = "TOP"
    elseif position ~= "LEFT" and frame.positionRadioLeft:GetChecked() then
        position = "LEFT"
    elseif position ~= "RIGHT" and frame.positionRadioRight:GetChecked() then
        position = "RIGHT"
    elseif position ~= "BOTTOM" and frame.positionRadioBottom:GetChecked() then
        position = "BOTTOM"
    end
    ADDON:SetPosition(position)

    ADDON:SetSize(frame.columnSlider:GetValue(), frame.rowSlider:GetValue())

    if frame.scaleRadioAuto:GetChecked() then
        ADDON:SetScale("AUTO")
    else
        ADDON:SetScale(frame.scaleEditManual:GetNumber())
    end

    ADDON.settings.clickToSend = frame.clickRadioOn:GetChecked()
end

ADDON:RegisterLoginCallback(function()
    local frame = BuildFrame()
    frame.name = GetAddOnMetadata(ADDON_NAME, "Title")
    frame.refresh = RefreshHandler
    frame.okay = OKHandler
    frame.default = ADDON.ResetUISettings
    InterfaceOptions_AddCategory(frame)
end)