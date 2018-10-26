local ADDON_NAME, ADDON = ...

if (GetLocale() == 'deDE') then
    local L = ADDON.L or {}

    L["Are you sure that you want to delete this Contact?"] = "Kontakt wirklich entfernen?"
    L["Button scale factor set to %d"] = "Button Skalierungsfaktor gesetzt auf %d"
    L["ClickToSend mode disabled"] = "ClickToSend-Modus deaktiviert"
    L["ClickToSend mode enabled"] = "ClickToSend-Modus aktiviert"
    L["Contact added (Position: %d, Recipient: %s, Icon: %s)"] = "Kontakt hinzugefügt (Position: %d, Empfänger: %s, Symbol: %s)"
    L["Contact Name:"] = "Kontakt Name:"
    L["Contact removed (Position: %d)"] = "Kontakt entfernt (Position: %d)"
    L["Create"] = "Erstellen"
    L["No Contact on position %d"] = "Kein Kontakt an Position %d"
    L["Note changed to %s (Position: %d)"] = "Notiz geändert zu %s (Position: %d)"
    L["Note removed (Position: %d)"] = "Notiz entfernt (Position: %d)"
    L["Position set to %s"] = "Position gesetzt auf %s"
    L["Size changed to %dx%d"] = "Größe geändert auf %dx%d"

    -- Settings
    L["SETTING_CLICKTOSEND_LABEL"] = "Verschicke Post mit Klick auf den Kontakt"
    L["SETTING_COLUMN_COUNT_LABEL"] = "Anzahl der Spalten"
    L["SETTING_POSITION_BOTTOM"] = "Unten"
    L["SETTING_POSITION_LABEL"] = "Positioniere Kontakte um das Post Fenster"
    L["SETTING_POSITION_LEFT"] = "Links"
    L["SETTING_POSITION_RIGHT"] = "Rechts"
    L["SETTING_POSITION_TOP"] = "Oben"
    L["SETTING_ROW_COUNT_LABEL"] = "Anzahl der Zeilen"
    L["SETTING_SCALE_AUTO"] = "Automatisch"
    L["SETTING_SCALE_LABEL"] = "Vergrößerungsfaktor"
    L["SETTING_SCALE_MANUAL"] = "Manuell"

    ADDON.L = L
end