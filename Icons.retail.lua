local _, ADDON = ...

-- see https://github.com/tomrus88/BlizzardInterfaceCode/blob/c1e5ba067e4ef6b72a824b57b2d104c65c047a3b/Interface/GlueXML/CharacterCreate.lua
-- for new race and class icons

ADDON.iconFiles = {
    "INV_Misc_GroupLooking",
    "ACHIEVEMENT_GUILDPERK_MOBILEBANKING",
    "Garrison_Building_TradingPost",

    -- class
    "ClassIcon_DeathKnight", "ClassIcon_DemonHunter", "ClassIcon_Druid", "classicon_evoker", "ClassIcon_Hunter",
    "ClassIcon_Mage", "ClassIcon_Monk", "ClassIcon_Paladin", "ClassIcon_Priest", "ClassIcon_Rogue", "ClassIcon_Shaman",
    "ClassIcon_Warlock", "ClassIcon_Warrior",

    --specialisations
    "Spell_Deathknight_BloodPresence", "Spell_Deathknight_FrostPresence","Spell_Deathknight_UnholyPresence",
    "Ability_DemonHunter_SpecDPS","Ability_DemonHunter_SpecTank",
    "Spell_Nature_StarFall","Ability_druid_catform","Ability_racial_bearform","Spell_nature_healingtouch",
    "Classicon_evoker_devastation","Classicon_evoker_preservation",
    "Ability_hunter_bestialdiscipline","Ability_hunter_focusedaim","Ability_hunter_camouflage",
    "Spell_holy_magicalsentry","Spell_fire_firebolt02","Spell_frost_frostbolt02",
    "Spell_monk_brewmaster_spec", "Spell_monk_mistweaver_spec", "Spell_monk_windwalker_spec",
    "Spell_holy_holybolt","Ability_paladin_shieldofthetemplar","Spell_holy_auraoflight",
    "Spell_holy_powerwordshield","Spell_holy_guardianspirit","Spell_shadow_shadowwordpain",
    "Ability_rogue_deadlybrew", "Inv_sword_30", "Ability_stealth",
    "Spell_nature_lightning", "Spell_shaman_improvedstormstrike", "Spell_nature_magicimmunity",
    "Spell_shadow_deathcoil", "Spell_shadow_metamorphosis", "Spell_shadow_rainoffire",
    "Ability_warrior_savageblow", "Ability_warrior_innerrage", "Ability_warrior_defensivestance",

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
    "raceicon-dracthyr-female", "raceicon-dracthyr-male",
    "raceicon-dracthyrvisage-female", "raceicon-dracthyrvisage-male",
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
    "ui_profession_alchemy",
    "ui_profession_blacksmithing",
    "ui_profession_cooking",
    "ui_profession_enchanting",
    "ui_profession_engineering",
    "ui_profession_fishing",
    "ui_profession_herbalism",
    "ui_profession_inscription",
    "ui_profession_jewelcrafting",
    "ui_profession_leatherworking",
    "ui_profession_mining",
    "ui_profession_skinning",
    "ui_profession_tailoring",
    "trade_archaeology",
    --"spell_holy_sealofsacrifice", -- first aid

    -- faction
    "INV_BannerPVP_01",
    "INV_BannerPVP_02",
}