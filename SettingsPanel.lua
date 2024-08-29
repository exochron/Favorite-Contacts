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

local function BuildRadio(parent, text, offsetY,  callback)
    local button = AceGUI:Create("CheckBox")
    button:SetType("radio")
    button:SetLabel(text)
    button:SetHeight(16)
    button:SetWidth(button.text:GetWidth() + 24)
    parent:AddChild(button)
    button:SetPoint("TOPLEFT", parent.content, "TOP", 0, offsetY)

    button:SetCallback("OnValueChanged", function(self)
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

local function BuildModuleOptions(frame, yOffset)
    local L = ADDON.L

    local positionOptions = { "TOP", "LEFT", "RIGHT", "BOTTOM" }
    if LE_EXPANSION_LEVEL_CURRENT >= LE_EXPANSION_DRAGONFLIGHT then
        positionOptions[#positionOptions+1] = "NONE"
    end

    local elements = {}
    elements.positionDropDown = AceGUI:Create("Dropdown")
    elements.positionDropDown:SetList({
        NONE = L.SETTING_POSITION_NONE,
        TOP = L.SETTING_POSITION_TOP,
        LEFT = L.SETTING_POSITION_LEFT,
        RIGHT = L.SETTING_POSITION_RIGHT,
        BOTTOM = L.SETTING_POSITION_BOTTOM,
    }, positionOptions, "Dropdown-Item-Toggle")
    frame:AddChild(elements.positionDropDown)
    elements.positionDropDown:SetWidth(100)
    elements.positionDropDown:SetPoint("TOPLEFT", frame.content, "TOP", 0, yOffset)
    elements.positionDropDown:SetCallback("OnValueChanged", function(self)
        local disabled = self:GetValue() == "NONE"
        elements.columnSlider:SetDisabled(disabled)
        elements.rowSlider:SetDisabled(disabled)
        elements.scaleRadioAuto:SetDisabled(disabled)
        elements.scaleRadioManual:SetDisabled(disabled)
        elements.scaleEditManual:SetDisabled(disabled)
    end)
    BuildLabel(frame, L.SETTING_POSITION_LABEL_GENERIC, elements.positionDropDown)
    yOffset = yOffset - 30

    elements.columnSlider = BuildSlider(frame, L.SETTING_COLUMN_COUNT_LABEL, yOffset)
    yOffset = yOffset - 40

    elements.rowSlider = BuildSlider(frame, L.SETTING_ROW_COUNT_LABEL, yOffset)
    yOffset = yOffset - 60

    elements.scaleRadioAuto = BuildRadio(frame, L.SETTING_SCALE_AUTO, yOffset, function(value)
        if (value) then
            elements.scaleEditManual:SetDisabled(true)
        else
            elements.scaleEditManual:SetDisabled(false)
        end
        elements.scaleRadioManual:SetValue(not value)
    end)
    yOffset = yOffset - 20
    elements.scaleRadioManual = BuildRadio(frame, L.SETTING_SCALE_MANUAL, yOffset, function(value)
        if (value) then
            elements.scaleEditManual:SetDisabled(false)
        else
            elements.scaleEditManual:SetDisabled(true)
        end
        elements.scaleRadioAuto:SetValue(not value)
    end)
    BuildLabel(frame, L.SETTING_SCALE_LABEL, elements.scaleRadioAuto)

    elements.scaleEditManual = AceGUI:Create("EditBox")
    elements.scaleEditManual:DisableButton(true)
    elements.scaleEditManual:SetWidth(80)
    elements.scaleEditManual.editbox:SetNumber(1.0)
    elements.scaleEditManual.editbox:SetJustifyH("CENTER")
    frame:AddChild(elements.scaleEditManual)
    elements.scaleEditManual:SetPoint("LEFT", elements.scaleRadioManual.frame, "RIGHT")
    elements.scaleEditManual:SetDisabled(true)
    yOffset = yOffset - 20

    return elements, yOffset
end

local function BuildFrame()
    local title = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Title")
    local frame = AceGUI:Create("BlizOptionsGroup")
    frame:SetName(title)
    frame:SetTitle(title)
    frame:SetLayout(nil)

    local L = ADDON.L
    local yOffset

    yOffset = -10
    BuildHeader(frame, L.SETTING_HEAD_MAILBOX, yOffset)
    yOffset = yOffset - 20

    frame.mail, yOffset = BuildModuleOptions(frame, yOffset)

    frame.mail.clickCheck = BuildCheckBox(frame, L.SETTING_CLICKTOSEND_LABEL, yOffset)
    yOffset = yOffset - 20

    frame.mail.autoSwitchCheck = BuildCheckBox(frame, L.SETTING_SWITCHTAB_LABEL, yOffset)
    yOffset = yOffset - 40

    if LE_EXPANSION_LEVEL_CURRENT >= LE_EXPANSION_DRAGONFLIGHT then
        BuildHeader(frame, PLACE_CRAFTING_ORDERS, yOffset)
        yOffset = yOffset - 20
        frame.craftOrder, yOffset = BuildModuleOptions(frame, yOffset)
    end

    return frame
end

local function RefreshModuleOptions(elements, settings)
    elements.positionDropDown:SetValue(settings.position)
    elements.positionDropDown:Fire("OnValueChanged", settings.position)

    elements.columnSlider:SetValue(settings.columnCount)
    elements.rowSlider:SetValue(settings.rowCount)

    local scale = settings.scale
    if scale == "AUTO" then
        elements.scaleRadioAuto:SetValue(true)
        elements.scaleRadioAuto:Fire("OnValueChanged", true)
    else
        elements.scaleRadioManual:SetValue(true)
        elements.scaleRadioManual:Fire("OnValueChanged", true)
        elements.scaleEditManual.editbox:SetNumber(scale)
        elements.scaleEditManual.editbox:SetCursorPosition(0)
    end
end
local function RefreshHandler(frame)
    RefreshModuleOptions(frame.mail, ADDON.settings)

    frame.mail.clickCheck:SetValue(ADDON.settings.clickToSend)
    frame.mail.autoSwitchCheck:SetValue(ADDON.settings.switchTabOnEmptyInbox)

    if LE_EXPANSION_LEVEL_CURRENT >= LE_EXPANSION_DRAGONFLIGHT then
        RefreshModuleOptions(frame.craftOrder, ADDON.settings.craftOrder)
    end
end

local function SaveModuleOptions(moduleName, elements)
    ADDON:SetPosition(moduleName, elements.positionDropDown:GetValue())
    ADDON:SetSize(moduleName, elements.columnSlider:GetValue(), elements.rowSlider:GetValue())

    if elements.scaleRadioAuto:GetValue() then
        ADDON:SetScale(moduleName, "AUTO")
    else
        ADDON:SetScale(moduleName, elements.scaleEditManual.editbox:GetNumber())
    end
end
local function OKHandler(frame)
    SaveModuleOptions('mail', frame.mail)

    ADDON.settings.clickToSend = frame.mail.clickCheck:GetValue()
    ADDON.settings.switchTabOnEmptyInbox = frame.mail.autoSwitchCheck:GetValue()

    if LE_EXPANSION_LEVEL_CURRENT >= LE_EXPANSION_DRAGONFLIGHT then
        SaveModuleOptions('craftOrder', frame.craftOrder)
    end
end

local categoryID
ADDON.Events:RegisterCallback('Login', function()
    local group = BuildFrame()
    group:SetCallback("refresh", RefreshHandler)
    group:SetCallback("okay", OKHandler)
    group:SetCallback("default", ADDON.ResetUISettings)

    local category = Settings.RegisterCanvasLayoutCategory(group.frame, C_AddOns.GetAddOnMetadata(ADDON_NAME, "Title"))
    Settings.RegisterAddOnCategory(category)
    categoryID = category.ID
end, 'settings-panel')

function ADDON:OpenSettings()
    Settings.OpenToCategory(categoryID)
end