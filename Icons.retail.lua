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
    "Ability_DemonHunter_SpecDPS","Ability_DemonHunter_SpecTank", "Classicon_demonhunter_void",
    "Spell_Nature_StarFall","Ability_druid_catform","Ability_racial_bearform","Spell_nature_healingtouch",
    "Classicon_evoker_devastation","Classicon_evoker_preservation", "Classicon_evoker_augmentation",
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
    "raceicon128-human-female", "raceicon128-human-male",
    "raceicon128-gnome-female", "raceicon128-gnome-male",
    "raceicon128-dwarf-female", "raceicon128-dwarf-male",
    "raceicon128-nightelf-female", "raceicon128-nightelf-male",
    "raceicon128-draenei-female", "raceicon128-draenei-male",
    "raceicon128-worgen-female", "raceicon128-worgen-male",
    "raceicon128-voidelf-female", "raceicon128-voidelf-male",
    "raceicon128-lightforged-female", "raceicon128-lightforged-male",
    "raceicon128-darkirondwarf-female", "raceicon128-darkirondwarf-male",
    "raceicon128-kultiran-female", "raceicon128-kultiran-male",
    "raceicon128-mechagnome-female", "raceicon128-mechagnome-male",
    "raceicon128-pandaren-female", "raceicon128-pandaren-male",
    "raceicon128-dracthyr-female", "raceicon128-dracthyr-male",
    "raceicon128-dracthyrvisage-female", "raceicon128-dracthyrvisage-male",
    "raceicon128-earthen-female", "raceicon128-earthen-male",
    "raceicon128-haranir-female", "raceicon128-haranir-male",
    "raceicon128-orc-female", "raceicon128-orc-male",
    "raceicon128-tauren-female", "raceicon128-tauren-male",
    "raceicon128-troll-female", "raceicon128-troll-male",
    "raceicon128-undead-female", "raceicon128-undead-male",
    "raceicon128-bloodelf-female", "raceicon128-bloodelf-male",
    "raceicon128-goblin-female", "raceicon128-goblin-male",
    "raceicon128-highmountain-female", "raceicon128-highmountain-male",
    "raceicon128-nightborne-female", "raceicon128-nightborne-male",
    "raceicon128-magharorc-female", "raceicon128-magharorc-male",
    "raceicon128-zandalari-female", "raceicon128-zandalari-male",
    "raceicon128-vulpera-female", "raceicon128-vulpera-male",

    -- faction
    "INV_BannerPVP_01",
    "INV_BannerPVP_02",

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

}