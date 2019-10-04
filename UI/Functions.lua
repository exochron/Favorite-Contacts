local ADDON_NAME, ADDON = ...

function ADDON:SetTexture(texture, iconName)
    if iconName:sub(1, 9) == "raceicon-" then

        -- the atlas texture itself has no border. so it looks a bit too sharp.
        -- somehow setting a regular texture beforehand keeps the border of that image for the atlas.
        -- dont ask me why. just accept it :)
        texture:SetTexture("INTERFACE\\ICONS\\INV_Misc_GroupLooking")
        texture:SetTexCoord(0, 1, 0, 1)

        texture:SetAtlas(iconName)
    elseif iconName:sub(1, 10) == "Interface\\" then
        local path, a, b, c, d = strsplit(",", iconName)
        texture:SetTexture(path)
        texture:SetTexCoord(a, b, c, d)
    else
        texture:SetTexture("INTERFACE\\ICONS\\" .. iconName)
        texture:SetTexCoord(0, 1, 0, 1)
    end
end