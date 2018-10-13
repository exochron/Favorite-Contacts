local ADDON_NAME, ADDON = ...

if (GetLocale() == 'prBR') then
    local L = ADDON.L or {}

    -- context menu
    L["Create"] = "Criar";

    -- dialog
    L["Contact Name:"] = "Nome do Contato:";
    L["Are you sure that you want to delete this Contact?"] = "Tem certeza que deseja remover este contato?";

    -- command-line
    L["Settings scope changed to %s"] = "Escopo das configurações modificado para %s";
    L["Size changed to %dx%d"] = "Tamanho modificado para %dx%d";
    L["Contact added (Position: %d, Recipient: %s, Icon: %s)"] = "Contato adicionado (Posição: %d, Destinatário: %s, Ícone: %s)";
    L["Contact removed (Position: %d)"] = "Contato removido (Posição: %d)";
    --L["No Contact on position %d"] = "No Contact on position %d";
    --L["Note changed to %s (Position: %d)"] = "Note changed to %s (Position: %d)";
    --L["Note removed (Position: %d)"] = "Note removed (Position: %d)";
    L["Position set to %s"] = "Posição fixada em %s";
    L["Button scale factor set to %d"] = "Escala do botão fixada em %d";
    --L["ClickToSend mode enabled"] = "ClickToSend mode enabled";
    --L["ClickToSend mode disabled"] = "ClickToSend mode disabled";

    ADDON.L = L
end