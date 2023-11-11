local _, ADDON = ...

ADDON.L = {}
local L = ADDON.L

L["Are you sure that you want to delete this Contact?"] = "Are you sure that you want to delete this Contact?"
L["Button scale factor set to %d"] = "Button scale factor set to %d"
L["ClickToSend mode disabled"] = "ClickToSend mode disabled"
L["ClickToSend mode enabled"] = "ClickToSend mode enabled"
L["Contact added (Position: %d, Recipient: %s, Icon: %s)"] = "Contact added (Position: %d, Recipient: %s, Icon: %s)"
L["Contact Name:"] = "Contact Name:"
L["Contact Note:"] = "Contact Note:"
L["Contact removed (Position: %d)"] = "Contact removed (Position: %d)"
L["Create"] = CREATE or "Create"
L["No Contact on position %d"] = "No Contact on position %d"
L["Note changed to %s (Position: %d)"] = "Note changed to %s (Position: %d)"
L["Note removed (Position: %d)"] = "Note removed (Position: %d)"
L["Position set to %s"] = "Position set to %s"
L["Size changed to %dx%d"] = "Size changed to %dx%d"
L["CREATE_CONTACT_TITLE"] = "Create Contact"
L["EDIT_CONTACT_TITLE"] = "Edit Contact"

-- Settings
L["SETTING_CLICKTOSEND_LABEL"] = "Send mail with click on contact"
L["SETTING_COLUMN_COUNT_LABEL"] = "Number of columns"
L["SETTING_HEAD_DISPLAY"] = "Display Customization"
L["SETTING_HEAD_INTERACTION"] = "Interaction"
L["SETTING_POSITION_BOTTOM"] = "Bottom"
L["SETTING_POSITION_LABEL"] = "Position of contacts around mail frame"
L["SETTING_POSITION_LEFT"] = "Left"
L["SETTING_POSITION_RIGHT"] = "Right"
L["SETTING_POSITION_TOP"] = "Top"
L["SETTING_ROW_COUNT_LABEL"] = "Number of rows"
L["SETTING_SCALE_AUTO"] = "Automatic"
L["SETTING_SCALE_LABEL"] = "Size factor"
L["SETTING_SCALE_MANUAL"] = "Manual"
L["SETTING_SWITCHTAB_LABEL"] = "Directly open \"Write Mail\" on empty inbox"

local locale = GetLocale()
if locale == "deDE" then
    --@localization(locale="deDE", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="deDE", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
elseif locale == "esES" then
    --@localization(locale="esES", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="esES", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
elseif locale == "esMX" then
    --@localization(locale="esMX", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="esMX", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
elseif locale == "frFR" then
    --@localization(locale="frFR", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="frFR", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
elseif locale == "itIT" then
    --@localization(locale="itIT", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="itIT", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
elseif locale == "koKR" then
    --@localization(locale="koKR", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="koKR", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
elseif locale == "ptBR" then
    --@localization(locale="ptBR", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="ptBR", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
elseif locale == "ruRU" then
    --@localization(locale="ruRU", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="ruRU", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
elseif locale == "zhCN" then
    --@localization(locale="zhCN", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="zhCN", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
elseif locale == "zhTW" then
    --@localization(locale="zhTW", format="lua_additive_table", handle-unlocalized=comment)@
    --@localization(locale="zhTW", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@
end