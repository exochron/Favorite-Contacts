local _, ADDON = ...

-- see https://github.com/tomrus88/BlizzardInterfaceCode/blob/classic/Interface/GlueXML/CharacterCreate.lua
-- for new race and class icons

ADDON.iconFiles = {
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

    --specialisations
    "Spell_Nature_StarFall","Ability_druid_catform","Ability_racial_bearform","Spell_nature_healingtouch",
    "ability_hunter_beasttaming","ability_marksmanship","ability_hunter_swiftstrike",
    "Spell_holy_magicalsentry","Spell_fire_firebolt02","Spell_frost_frostbolt02",
    "Spell_holy_holybolt","Ability_paladin_shieldofthetemplar","Spell_holy_auraoflight",
    "Spell_holy_powerwordshield","Spell_holy_guardianspirit","Spell_shadow_shadowwordpain",
    "Ability_rogue_deadlybrew", "Inv_sword_30", "Ability_stealth",
    "Spell_nature_lightning", "Spell_shaman_improvedstormstrike", "Spell_nature_magicimmunity",
    "Spell_shadow_deathcoil", "Spell_shadow_metamorphosis", "Spell_shadow_rainoffire",
    "Ability_warrior_savageblow", "Ability_warrior_innerrage", "Ability_warrior_defensivestance",

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