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
    local positionLabel = BuildLabel(frame, "Position of contacts around mail frame", -70)
    frame.positionRadioTop = BuildRadio(radioGroup, "Top", positionLabel)
    frame.positionRadioLeft = BuildRadio(radioGroup, "Left", frame.positionRadioTop.text)
    frame.positionRadioRight = BuildRadio(radioGroup, "Right", frame.positionRadioLeft.text)
    frame.positionRadioBottom = BuildRadio(radioGroup, "Bottom", frame.positionRadioRight.text)

    frame.columnSlider = BuildSlider(frame, "Number of columns", -100)
    frame.rowSlider = BuildSlider(frame, "Number of rows", -130)

    local scaleLabel = BuildLabel(frame, "Scale size", -160)
    local scaleGroup = BuildRadioGroup(frame, function()
        local enabled = frame.scaleRadioManual:GetChecked()
        local color = 0.5
        if enabled then
            color = 1.0
        end
        frame.scaleEditManual:SetEnabled(enabled)
        frame.scaleEditManual:SetTextColor(color, color, color, 1.0)
    end)
    frame.scaleRadioAuto = BuildRadio(scaleGroup, "Automatic", scaleLabel)
    frame.scaleRadioManual = BuildRadio(scaleGroup, "Manual:", frame.scaleRadioAuto.text)
    frame.scaleEditManual = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
    frame.scaleEditManual:SetSize(183 - frame.scaleRadioAuto.text:GetWidth() - frame.scaleRadioManual.text:GetWidth(), 20)
    frame.scaleEditManual:SetAutoFocus(false)
    frame.scaleEditManual:SetPoint("LEFT", frame.scaleRadioManual.text, "RIGHT", 10, 0)
    frame.scaleEditManual:SetText("1") -- doesnt work? oO

    local clickLabel = BuildLabel(frame, "Click To Send ??", -190)
    local clickGroup = BuildRadioGroup(frame)
    frame.clickRadioOn = BuildRadio(clickGroup, ENABLE, clickLabel)
    frame.clickRadioOff = BuildRadio(clickGroup, DISABLE, frame.clickRadioOn.text)

    return frame
end

local function OKHandler(frame)
end

ADDON:RegisterLoginCallback(function()
    local frame = BuildFrame()
    frame.name = GetAddOnMetadata(ADDON_NAME, "Title")
    frame.refresh = function(frame)
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
    frame.okay = OKHandler
    frame.default = ADDON.ResetUISettings
    InterfaceOptions_AddCategory(frame)
end)