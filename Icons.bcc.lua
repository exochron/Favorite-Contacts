local _, ADDON = ...

-- see https://github.com/tomrus88/BlizzardInterfaceCode/blob/tbc/Interface/GlueXML/CharacterCreate.lua
-- for new race and class icons

ADDON.iconFiles = {
    -- class
    "ClassIcon_Druid", "ClassIcon_Hunter", "ClassIcon_Mage", "ClassIcon_Paladin", "ClassIcon_Priest",
    "ClassIcon_Rogue", "ClassIcon_Shaman", "ClassIcon_Warlock", "ClassIcon_Warrior",

    -- people - uses plain textures with coordinates
    "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0,0.125,0,0.25", --HUMAN_MALE
    "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0,0.125,0.5,0.75", --HUMAN_FEMALE
    "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.125,0.25,0,0.25", --DWARF_MALE
    "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.125,0.25,0.5,0.75", --DWARF_FEMALE
    "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.25,0.375,0,0.25", --GNOME_MALE
    "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.25,0.375,0.5,0.75", --GNOME_FEMALE
    "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.375,0.5,0,0.25", --NIGHTELF_MALE
    "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.375,0.5,0.5,0.75", --NIGHTELF_FEMALE
    "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.5,0.625,0,0.25", --DRAENEI_MALE
    "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.5,0.625,0.5,0.75", --DRAENEI_FEMALE

    "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0,0.125,0.25,0.5", --TAUREN_MALE
    "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0,0.125,0.75,1.0", --TAUREN_FEMALE
    "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.125,0.25,0.25,0.5", --SCOURGE_MALE
    "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.125,0.25,0.75,1.0", --SCOURGE_FEMALE
    "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.25,0.375,0.25,0.5", --TROLL_MALE
    "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.25,0.375,0.75,1.0", --TROLL_FEMALE
    "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.375,0.5,0.25,0.5", --ORC_MALE
    "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.375,0.5,0.75,1.0", --ORC_FEMALE
    "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.5,0.625,0.25,0.5", --BLOODELF_MALE
    "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races,0.5,0.625,0.75,1.0", --BLOODELF_FEMALE

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

    "INV_Misc_GroupLooking",
}
