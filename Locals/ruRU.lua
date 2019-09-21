﻿local ADDON_NAME, ADDON = ...

if (GetLocale() == 'ruRU') then
    local L = ADDON.L or {}

    L["Are you sure that you want to delete this Contact?"] = "Вы уверены, что хотите удалить этот Контакт?"
    L["Button scale factor set to %d"] = "Масштаб значков установлен в %d "
    L["ClickToSend mode disabled"] = "Отключен режим ClickToSend"
    L["ClickToSend mode enabled"] = "Включен режим ClickToSend"
    L["Contact added (Position: %d, Recipient: %s, Icon: %s)"] = "Контакт добавлен (Позиция: %d, Получатель: %s, Значок: %s)"
    L["Contact Name:"] = "Имя контакта:"
    --[[Translation missing --]]
    --[[ L["Contact Note:"] = "Contact Note:"--]]
    L["Contact removed (Position: %d)"] = "Контакт удален (Позиция: %d)"
    L["Create"] = "Создать"
    L["No Contact on position %d"] = "Нет контакта в позиции %d"
    L["Note changed to %s (Position: %d)"] = "Примечание изменено на %s (Позиция: %d)"
    L["Note removed (Position: %d)"] = "Примечание удалено (Позиция: %d)"
    L["Position set to %s"] = "Позиция установлена в %s"
    L["Size changed to %dx%d"] = "Размер изменен на %dx%d"

    -- Settings
    L["SETTING_CLICKTOSEND_LABEL"] = "Отправить письмо, нажав на контакт"
    L["SETTING_COLUMN_COUNT_LABEL"] = "Количество столбцов"
    L["SETTING_POSITION_BOTTOM"] = "Низ"
    L["SETTING_POSITION_LABEL"] = "Положение контактов вокруг почтового фрейма"
    L["SETTING_POSITION_LEFT"] = "Лево"
    L["SETTING_POSITION_RIGHT"] = "Право"
    L["SETTING_POSITION_TOP"] = "Верх"
    L["SETTING_ROW_COUNT_LABEL"] = "Количество строк"
    L["SETTING_SCALE_AUTO"] = "Автоматически"
    L["SETTING_SCALE_LABEL"] = "Размер"
    L["SETTING_SCALE_MANUAL"] = "Вручную"

    ADDON.L = L
end