local ADDON_NAME, ADDON = ...

if (GetLocale() ~= 'ruRU') then
    return
end

local L = ADDON.L or {}

L["Are you sure that you want to delete this Contact?"] = "Вы уверены, что хотите удалить этот Контакт?"
L["Button scale factor set to %d"] = "Масштаб значков установлен в %d "
L["ClickToSend mode disabled"] = "Отключен режим ClickToSend"
L["ClickToSend mode enabled"] = "Включен режим ClickToSend"
L["Contact added (Position: %d, Recipient: %s, Icon: %s)"] = "Контакт добавлен (Позиция: %d, Получатель: %s, Значок: %s)"
L["Contact Name:"] = "Имя контакта:"
L["Contact Note:"] = "Заметка контакта:"
L["Contact removed (Position: %d)"] = "Контакт удален (Позиция: %d)"
L["Create"] = "Создать"
L["No Contact on position %d"] = "Нет контакта в позиции %d"
L["Note changed to %s (Position: %d)"] = "Заметка изменена на %s (Позиция: %d)"
L["Note removed (Position: %d)"] = "Заметка удалена (Позиция: %d)"
L["Position set to %s"] = "Позиция установлена в %s"
L["Size changed to %dx%d"] = "Размер изменен на %dx%d"

-- Settings
L["SETTING_CLICKTOSEND_LABEL"] = "Отправить письмо, щелчком на контакт"
L["SETTING_COLUMN_COUNT_LABEL"] = "Количество столбцов"
L["SETTING_HEAD_DISPLAY"] = "Настройка отображения"
L["SETTING_HEAD_INTERACTION"] = "Действия"
L["SETTING_POSITION_BOTTOM"] = "Снизу"
L["SETTING_POSITION_LABEL"] = "Положение контактов вокруг почтового фрейма"
L["SETTING_POSITION_LEFT"] = "Слева"
L["SETTING_POSITION_RIGHT"] = "Справа"
L["SETTING_POSITION_TOP"] = "Сверху"
L["SETTING_ROW_COUNT_LABEL"] = "Количество строк"
L["SETTING_SCALE_AUTO"] = "Автоматически"
L["SETTING_SCALE_LABEL"] = "Размер"
L["SETTING_SCALE_MANUAL"] = "Вручную"
