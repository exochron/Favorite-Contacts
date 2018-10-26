local ADDON_NAME, ADDON = ...

if (GetLocale() == 'frFR') then
    local L = ADDON.L or {}

    L["Are you sure that you want to delete this Contact?"] = "Êtes-vous sûr de vouloir supprimer ce contact ?"
    L["Button scale factor set to %d"] = "Réglage de la taille des boutons sur %d"
    L["ClickToSend mode disabled"] = "Cliquez ici pour désactivé"
    L["ClickToSend mode enabled"] = "Cliquez ici pour activé"
    L["Contact added (Position: %d, Recipient: %s, Icon: %s)"] = "Contact ajouté (Position: %d, Destinataire: %s, icônes: %s)"
    L["Contact Name:"] = "Nom du contact :"
    L["Contact removed (Position: %d)"] = "Contact enlevé (Position: %d)"
    L["Create"] = "Créer"
    L["No Contact on position %d"] = "Pas de contact sur cette position %d"
    L["Note changed to %s (Position: %d)"] = "Remarque changée à %s (Position: %d)"
    L["Note removed (Position: %d)"] = "Remarque retirée (Position: %d)"
    L["Position set to %s"] = "Position réglée sur %s"
    L["Size changed to %dx%d"] = "Taille changé %dx%d"

    -- Settings

    ADDON.L = L
end