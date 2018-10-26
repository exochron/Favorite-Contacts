local ADDON_NAME, ADDON = ...

if (GetLocale() == 'prBR') then
    local L = ADDON.L or {}

    L["Are you sure that you want to delete this Contact?"] = "Tem certeza que deseja remover este contato?"
    L["Button scale factor set to %d"] = "Escala do botão fixada em %d"
    L["ClickToSend mode disabled"] = "Modo CliqueParaEnviar desabilitado"
    L["ClickToSend mode enabled"] = "Modo CliqueParaEnviar habilitado"
    L["Contact added (Position: %d, Recipient: %s, Icon: %s)"] = "Contato adicionado (Posição: %d, Destinatário: %s, Ícone: %s)"
    L["Contact Name:"] = "Nome do Contato:"
    L["Contact removed (Position: %d)"] = "Contato removido (Posição: %d)"
    L["Create"] = "Criar"
    L["No Contact on position %d"] = "Nenhum contato na posição %d"
    L["Note changed to %s (Position: %d)"] = "Anotação alterada para %s (Posição: %d)"
    L["Note removed (Position: %d)"] = "Anotação removida (Posição: %d)"
    L["Position set to %s"] = "Posição fixada em %s"
    L["Size changed to %dx%d"] = "Tamanho modificado para %dx%d"

    -- Settings

    ADDON.L = L
end