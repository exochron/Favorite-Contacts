local ADDON_NAME, ADDON = ...

local CONTACT_DEFAULT_ICON = "INV_Misc_GroupLooking"
local NUM_ICONS_PER_ROW = 8
local NUM_ICON_ROWS = 8
local NUM_ICONS_SHOWN = NUM_ICONS_PER_ROW * NUM_ICON_ROWS
local ICON_ROW_HEIGHT = 44

local iconFiles
local popup

local function UpdateEditContactPopup()
    local scrollFrame = popup.BorderBox.ScrollFrame
    local numIcons = #iconFiles
    local scrollOffset = FauxScrollFrame_GetOffset(scrollFrame)

    for i = 1, NUM_ICONS_SHOWN do
        local button = popup.BorderBox["Button" .. i]
        local buttonIcon = button.Icon
        local index = (scrollOffset * NUM_ICONS_PER_ROW) + i
        local texture = iconFiles[index]

        if (index <= numIcons and texture) then
            ADDON:SetTexture(buttonIcon, texture)
            button:Show()
        else
            buttonIcon:SetTexture("")
            buttonIcon:SetAtlas("")
            button:Hide()
        end
        if (popup.icon == texture) then
            button:SetChecked(true)
        else
            button:SetChecked(false)
        end
    end

    FauxScrollFrame_Update(scrollFrame, ceil(numIcons / NUM_ICONS_PER_ROW), NUM_ICON_ROWS, ICON_ROW_HEIGHT)
end

local function EditContactPopupSelectTexture(iconIndex)
    popup.icon = iconFiles[iconIndex]
    popup.BorderBox.IconName:SetText(popup.icon)
    UpdateEditContactPopup()
end

local function CreateIconButtons()
    local previous, firstLastRow

    for i = 1, NUM_ICONS_SHOWN do
        local modulo = math.fmod(i, NUM_ICONS_PER_ROW)

        local button = CreateFrame("CheckButton", nil, popup, "FavoriteContactsEditContactButtonTemplate", i)
        if i == 1 then
            button:SetPoint("TOPLEFT", popup.BorderBox.IconLabel, "BOTTOMLEFT", 0, -10)
            firstLastRow = button
        elseif modulo == 1 then
            button:SetPoint("TOPLEFT", firstLastRow, "BOTTOMLEFT", 0, -8)
            firstLastRow = button
        else
            button:SetPoint("LEFT", previous, "RIGHT", 8, 0)
        end

        popup.BorderBox["Button" .. i] = button
        previous = button
    end
end

local function CreateEditContactPopup()
    local L = ADDON.L

    popup = CreateFrame("Frame", nil, UIParent, "FavoriteContactsEditContactPopupTemplate")
    CreateIconButtons()
    popup.BorderBox.NameLabel:SetText(L["Contact Name:"])
    popup.BorderBox.NoteLabel:SetText(L["Contact Note:"])

    popup:SetScript("OnShow", function(sender)

        -- see https://github.com/tomrus88/BlizzardInterfaceCode/blob/c1e5ba067e4ef6b72a824b57b2d104c65c047a3b/Interface/GlueXML/CharacterCreate.lua
        -- for new race and class icons

        iconFiles = {
            -- class
            "ClassIcon_DeathKnight", "ClassIcon_DemonHunter", "ClassIcon_Druid", "ClassIcon_Hunter", "ClassIcon_Mage", "ClassIcon_Monk",
            "ClassIcon_Paladin", "ClassIcon_Priest", "ClassIcon_Rogue", "ClassIcon_Shaman", "ClassIcon_Warlock", "ClassIcon_Warrior",

            -- people - uses texture atlas instead of plain textures
            "raceicon-human-female", "raceicon-human-male",
            "raceicon-gnome-female", "raceicon-gnome-male",
            "raceicon-dwarf-female", "raceicon-dwarf-male",
            "raceicon-nightelf-female", "raceicon-nightelf-male",
            "raceicon-draenei-female", "raceicon-draenei-male",
            "raceicon-worgen-female", "raceicon-worgen-male",
            "raceicon-voidelf-female", "raceicon-voidelf-male",
            "raceicon-lightforged-female", "raceicon-lightforged-male",
            "raceicon-darkirondwarf-female", "raceicon-darkirondwarf-male",
            "raceicon-kultiran-female", "raceicon-kultiran-male",
            "raceicon-pandaren-female", "raceicon-pandaren-male",
            "raceicon-orc-female", "raceicon-orc-male",
            "raceicon-tauren-female", "raceicon-tauren-male",
            "raceicon-troll-female", "raceicon-troll-male",
            "raceicon-undead-female", "raceicon-undead-male",
            "raceicon-bloodelf-female", "raceicon-bloodelf-male",
            "raceicon-goblin-female", "raceicon-goblin-male",
            "raceicon-highmountain-female", "raceicon-highmountain-male",
            "raceicon-nightborne-female", "raceicon-nightborne-male",
            "raceicon-magharorc-female", "raceicon-magharorc-male",
            "raceicon-zandalari-female", "raceicon-zandalari-male",

            --profession
            "inv_misc_gem_01",
            "Trade_Engraving",
            "Trade_Engineering",
            "Trade_Alchemy",
            "inv_inscription_tradeskill01",
            "Trade_Tailoring",
            "inv_misc_armorkit_17",
            "Trade_BlackSmithing",
            "Trade_Herbalism",
            "inv_misc_pelt_wolf_01",
            "Trade_Mining",
            "trade_archaeology",
            "inv_misc_food_15",
            "Trade_Fishing",
            --"spell_holy_sealofsacrifice", -- first aid

            -- faction
            "INV_BannerPVP_01",
            "INV_BannerPVP_02",

            "ACHIEVEMENT_GUILDPERK_MOBILEBANKING",
            "Garrison_Building_TradingPost",

            CONTACT_DEFAULT_ICON,
        }
    end)
    popup:SetScript("OnHide", function()
        iconFiles = nil
        collectgarbage()
    end)

    local scrollFrame = popup.BorderBox.ScrollFrame

    for index = 1, NUM_ICONS_SHOWN do
        local icon = popup.BorderBox["Button" .. index]
        icon:SetScript("OnClick", function(sender)
            local scrollOffset = FauxScrollFrame_GetOffset(scrollFrame)
            EditContactPopupSelectTexture(sender:GetID() + (scrollOffset * NUM_ICONS_PER_ROW))
        end)
    end

    scrollFrame:SetScript("OnVerticalScroll", function(sender, offset)
        FauxScrollFrame_OnVerticalScroll(sender, offset, ICON_ROW_HEIGHT, function() UpdateEditContactPopup() end)
    end)

    popup.BorderBox.OkayButton:SetScript("OnClick", function()
        popup:Hide()

        local index = popup.index
        local recipient = popup.BorderBox.ContactNameEditBox:GetText()
        local note = popup.BorderBox.NoteEditBox:GetText()

        local icon = popup.BorderBox.IconName:GetText()
        if (not icon or string.len(icon) == 0) then
            icon = CONTACT_DEFAULT_ICON
        end

        ADDON:SetContact(index, recipient, icon, note)

        ADDON:SetSelectedContact(-1)
        ADDON:SetEnableContacts(true)
    end)

    popup.BorderBox.CancelButton:SetScript("OnClick", function()
        popup:Hide()

        ADDON:SetSelectedContact(-1)
        ADDON:SetEnableContacts(true)
    end)
end

ADDON:RegisterLoadUICallback(CreateEditContactPopup)

function ADDON:ShowEditContactPopup(index)
    popup.index = index

    local contact = self.settings.contacts[index] or {}
    popup.icon = contact.icon or CONTACT_DEFAULT_ICON

    local nameEdit = popup.BorderBox.ContactNameEditBox
    nameEdit:SetText(contact.recipient or "")

    local noteEdit = popup.BorderBox.NoteEditBox
    noteEdit:SetText(contact.note or "")

    local iconEdit = popup.BorderBox.IconName
    iconEdit:SetText(popup.icon or "")

    popup:Show()
    nameEdit:SetFocus()

    self:SetSelectedContact(popup.index)
    self:SetEnableContacts(false)

    UpdateEditContactPopup()
end