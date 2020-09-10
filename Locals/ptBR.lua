local _, ADDON = ...

if GetLocale() ~= 'ptBR' then
    return
end

local L = ADDON.L or {}

--@localization(locale="ptBR", format="lua_additive_table", handle-unlocalized=comment)@
--@localization(locale="ptBR", namespace="Settings", format="lua_additive_table", handle-unlocalized=comment)@