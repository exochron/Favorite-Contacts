local ADDON_NAME, ADDON = ...

SLASH_FAVORITECONTACTS1, SLASH_FAVORITECONTACTS2 = '/favoritecontacts', '/fc'
function SlashCmdList.FAVORITECONTACTS(msg)

    local L = ADDON.L
    local command, parameter1, parameter2
    if msg then
        command, parameter1, parameter2 = strsplit(" ", msg)
        command = command:lower()
    end

    if (command == "size") then
        local columnCount = tonumber(parameter1)
        local rowCount = tonumber(parameter2)
        if (type(columnCount) == "number" and type(rowCount) == "number") then
            ADDON:SetSize(columnCount, rowCount)
            print(string.format("Favorite Contacts: " .. L["Size changed to %dx%d"], columnCount, rowCount))
            return
        end
    end

    if (command == "contact") then
        local index = tonumber(parameter1)
        local recipient = tostring(parameter2)
        local icon = tostring(parameter3)
        if (type(index) == "number" and index >= 1) then
            if (recipient and string.len(recipient) > 0) then
                ADDON:SetContact(index, recipient, icon)
                if (not icon or string.len(icon) == 0) then
                    icon = "<empty>"
                end
                print(string.format("Favorite Contacts: " .. L["Contact added (Position: %d, Recipient: %s, Icon: %s)"], index, recipient, icon))
                return
            else
                ADDON:DeleteContact(index, true)
                print(string.format("Favorite Contacts: " .. L["Contact removed (Position: %d)"], index))
                return
            end
        end
    end

    if (command == "note") then
        local index = tonumber(parameter1)
        local note = tostring(parameter2)
        if (type(index) == "number" and index >= 1) then
            local contact = ADDON.settings.contacts[index]
            if (not contact) then
                print(string.format("Favorite Contacts: " .. L["No Contact on position %d"], index))
                return
            end
            if (note and string.len(note) > 0) then
                contact.note = note
                print(string.format("Favorite Contacts: " .. L["Note changed to %s (Position: %d)"], note, index))
                return
            end
            contact.note = nil
            print(string.format("Favorite Contacts: " .. L["Note removed (Position: %d)"], index))
            return
        end
    end

    if (command == "position") then
        local position = string.upper(tostring(parameter1))
        if (position == "TOP" or position == "LEFT" or position == "BOTTOM" or position == "RIGHT") then
            ADDON:SetPosition(position)
            print(string.format("Favorite Contacts: " .. L["Position set to %s"], position))
            return
        end
    end

    if (command == "scale") then
        local scale = tonumber(parameter1)
        if (parameter1 == "AUTO" or (type(scale) == "number" and scale > 0)) then
            ADDON:SetScale(scale or parameter1)
            print(string.format("Favorite Contacts: " .. L["Button scale factor set to %d"], scale))
            return
        end
    end

    if (command == "clicktosend") then
        local onOff = tostring(parameter1)
        if (not onOff or string.len(onOff) == 0) then
            ADDON.settings.clickToSend = not ADDON.settings.clickToSend
            if (ADDON.settings.clickToSend) then
                print(string.format("Favorite Contacts: " .. L["ClickToSend mode enabled"]))
            else
                print(string.format("Favorite Contacts: " .. L["ClickToSend mode disabled"]))
            end
            return
        end
        if (onOff == "on") then
            ADDON.settings.clickToSend = true
            print(string.format("Favorite Contacts: " .. L["ClickToSend mode enabled"]))
            return
        end
        if (onOff == "off") then
            ADDON.settings.clickToSend = false
            print(string.format("Favorite Contacts: " .. L["ClickToSend mode disabled"]))
            return
        end
    end

    -- open double to prevent stupid interface bug
    local title = GetAddOnMetadata(ADDON_NAME, "Title")
    InterfaceOptionsFrame_OpenToCategory(title)
    InterfaceOptionsFrame_OpenToCategory(title)

    --print("Syntax:")
    --print("/fc size <column count> <rows count>")
    --print("/fc position (TOP | LEFT | BOTTOM | RIGHT)")
    --print("/fc scale <button scale factor>")
    --print("/fc contact <index> [<recipient> [<icon>]]")
    --print("/fc note <index> [<note>]")
    --print("/fc clicktosend [on|off]")
end