local _, ADDON = ...

local raceprefix = "raceicon128-"
if C_GameRules.AccountHasSDEnabled() then
    raceprefix = "raceicon-sd-"
end

ADDON.iconFiles = {
    "ACHIEVEMENT_GUILDPERK_MOBILEBANKING",
    "Garrison_Building_TradingPost",

    -- faction
    "INV_BannerPVP_01",
    "INV_BannerPVP_02",

    -- class
    "ClassIcon_Druid", "ClassIcon_Hunter", "ClassIcon_Mage", "ClassIcon_Paladin", "ClassIcon_Priest",
    "ClassIcon_Rogue", "ClassIcon_Shaman", "ClassIcon_Warlock", "ClassIcon_Warrior",

    --specialisations
    "Spell_Nature_StarFall","Ability_racial_bearform","Spell_nature_healingtouch",
    "ability_hunter_beasttaming","ability_marksmanship","ability_hunter_swiftstrike",
    "Spell_holy_magicalsentry","Spell_fire_firebolt02","Spell_frost_frostbolt02",
    "Spell_holy_holybolt","spell_holy_devotionaura","Spell_holy_auraoflight",
    "spell_holy_wordfortitude","Spell_holy_guardianspirit","Spell_shadow_shadowwordpain",
    "ability_rogue_eviscerate", "ability_backstab", "Ability_stealth",
    "Spell_nature_lightning", "spell_nature_lightningshield", "Spell_nature_magicimmunity",
    "Spell_shadow_deathcoil", "Spell_shadow_metamorphosis", "Spell_shadow_rainoffire",
    "Ability_warrior_savageblow", "Ability_warrior_innerrage", "Ability_warrior_defensivestance",

    -- people - uses texture atlas instead of plain textures
    raceprefix.."human-female", raceprefix.."human-male",
    raceprefix.."gnome-female", raceprefix.."gnome-male",
    raceprefix.."dwarf-female", raceprefix.."dwarf-male",
    raceprefix.."nightelf-female", raceprefix.."nightelf-male",
    "raceicon128-skyborne-female", "raceicon128-skyborne-male",
    raceprefix.."orc-female", raceprefix.."orc-male",
    raceprefix.."tauren-female", raceprefix.."tauren-male",
    raceprefix.."troll-female", raceprefix.."troll-male",
    raceprefix.."undead-female", raceprefix.."undead-male",

    --profession
    "trade_alchemy",
    "trade_blacksmithing",
    "trade_engraving", --enchanting
    "trade_engineering",
    "spell_nature_naturetouchgrow", -- herbalism
    "trade_leatherworking",
    "trade_mining",
    "inv_misc_pelt_wolf_01", --skinning
    "trade_tailoring",
    "inv_misc_food_15", -- cooking
    "trade_fishing",
    "spell_holy_sealofsacrifice", -- first aid

    "INV_Misc_GroupLooking",
}