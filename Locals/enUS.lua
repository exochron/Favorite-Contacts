local ADDON_NAME, ADDON = ...

local L = ADDON.L or {}

-- context menu
L["Create"] = "Create";

-- dialog
L["Contact Name:"] = "Contact Name:";
L["Are you sure that you want to delete this Contact?"] = "Are you sure that you want to delete this Contact?";

-- command-line
L["Settings scope changed to %s"] = "Settings scope changed to %s";
L["Size changed to %dx%d"] = "Size changed to %dx%d";
L["Contact added (Position: %d, Recipient: %s, Icon: %s)"] = "Contact added (Position: %d, Recipient: %s, Icon: %s)";
L["Contact removed (Position: %d)"] = "Contact removed (Position: %d)";
L["No Contact on position %d"] = "No Contact on position %d";
L["Note changed to %s (Position: %d)"] = "Note changed to %s (Position: %d)";
L["Note removed (Position: %d)"] = "Note removed (Position: %d)";
L["Position set to %s"] = "Position gesetzt auf %s";
L["Button scale factor set to %d"] = "Button scale factor set to %d";
L["ClickToSend mode enabled"] = "ClickToSend mode enabled";
L["ClickToSend mode disabled"] = "ClickToSend mode disabled";

ADDON.L = L