local ADDON_NAME, ADDON = ...

-- see https://github.com/tomrus88/BlizzardInterfaceCode/blob/c1e5ba067e4ef6b72a824b57b2d104c65c047a3b/Interface/GlueXML/CharacterCreate.lua
-- for new race and class icons

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

    "INV_Misc_GroupLooking",
}