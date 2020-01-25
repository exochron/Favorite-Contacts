local ADDON_NAME, ADDON = ...

-- see https://github.com/tomrus88/BlizzardInterfaceCode/blob/c1e5ba067e4ef6b72a824b57b2d104c65c047a3b/Interface/GlueXML/CharacterCreate.lua
-- for new race and class icons

local interfaceVersion = select(4, GetBuildInfo())

if interfaceVersion < 20000 then

    ADDON.iconFiles = {
        -- class - uses plain textures with coordinates
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes,0,0.25,0,0.25", --WARRIOR
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes,0.25,0.49609375,0,0.25", --MAGE
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes,0.49609375,0.7421875,0,0.25", --ROGUE
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes,0.7421875,0.98828125,0,0.25", --DRUID
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes,0,0.25,0.25,0.5", --HUNTER
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes,0.25,0.49609375,0.25,0.5", --SHAMAN
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes,0.49609375,0.7421875,0.25,0.5", --PRIEST
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes,0.7421875,0.98828125,0.25,0.5", --WARLOCK
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes,0,0.25,0.5,0.75", --PALADIN

        -- people - uses plain textures with coordinates
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0,0.25,0,0.25", --HUMAN_MALE
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0,0.25,0.5,0.75", --HUMAN_FEMALE
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.25,0.5,0,0.25", --DWARF_MALE
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.25,0.5,0.5,0.75", --DWARF_FEMALE
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.5,0.75,0,0.25", --GNOME_MALE
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.5,0.75,0.5,0.75", --GNOME_FEMALE
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.75,1.0,0,0.25", --NIGHTELF_MALE
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.75,1.0,0.5,0.75", --NIGHTELF_FEMALE

        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0,0.25,0.25,0.5", --TAUREN_MALE
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0,0.25,0.75,1.0", --TAUREN_FEMALE
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.25,0.5,0.25,0.5", --SCOURGE_MALE
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.25,0.5,0.75,1.0", --SCOURGE_FEMALE
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.5,0.75,0.25,0.5", --TROLL_MALE
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.5,0.75,0.75,1.0", --TROLL_FEMALE
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.75,1.0,0.25,0.5", --ORC_MALE
        "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.75,1.0,0.75,1.0", --ORC_FEMALE

        --profession
        "inv_misc_gem_01",
        "Trade_Engraving",
        "Trade_Engineering",
        "Trade_Alchemy",
        "Trade_Tailoring",
        "inv_misc_armorkit_17",
        "Trade_BlackSmithing",
        "Trade_Herbalism",
        "inv_misc_pelt_wolf_01",
        "Trade_Mining",
        "inv_misc_food_15",
        "Trade_Fishing",
        "spell_holy_sealofsacrifice", -- first aid

        -- faction
        "INV_BannerPVP_01",
        "INV_BannerPVP_02",
    }
else
    ADDON.iconFiles = {
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
        "raceicon-mechagnome-female", "raceicon-mechagnome-male",
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
        "raceicon-vulpera-female", "raceicon-vulpera-male",

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

        "INV_Misc_GroupLooking",
    }
end