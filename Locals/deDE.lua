local ADDON_NAME, ADDON = ...

if (GetLocale() == 'deDE') then
    local L = ADDON.L or {}

    -- context menu
    L["Create"] = "Erstellen";

    -- dialog
    L["Contact Name:"] = "Kontakt Name:";
    L["Are you sure that you want to delete this Contact?"] = "Kontakt wirklich entfernen?";

    -- command-line
    L["Settings scope changed to %s"] = "Geltungsbereich von Einstellungen geändert auf %s";
    L["Size changed to %dx%d"] = "Größe geändert auf %dx%d";
    L["Contact added (Position: %d, Recipient: %s, Icon: %s)"] = "Kontakt hinzugefügt (Position: %d, Empfänger: %s, Symbol: %s)";
    L["Contact removed (Position: %d)"] = "Kontakt entfernt (Position: %d)";
    L["No Contact on position %d"] = "Kein Kontakt an Position %d";
    L["Note changed to %s (Position: %d)"] = "Notiz geändert zu %s (Position: %d)";
    L["Note removed (Position: %d)"] = "Notiz entfernt (Position: %d)";
    L["Position set to %s"] = "Position gesetzt auf %s";
    L["Button scale factor set to %d"] = "Button Skalierungsfaktor gesetzt auf %d";
    L["ClickToSend mode enabled"] = "ClickToSend-Modus aktiviert";
    L["ClickToSend mode disabled"] = "ClickToSend-Modus deaktiviert";

    ADDON.L = L
end