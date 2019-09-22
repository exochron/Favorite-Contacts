local ADDON_NAME, ADDON = ...

function ADDON:SetTexture(texture, iconName)
    if iconName:sub(1, 9) == "raceicon-" then
        texture:SetAtlas(iconName)
    else
        texture:SetTexture("INTERFACE\\ICONS\\" .. iconName)
        texture:SetTexCoord(0, 1, 0, 1)
    end
end