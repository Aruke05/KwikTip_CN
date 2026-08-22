-- KwikTip_CN: additional dungeon detection catalog (strategy prose removed)
local ADDON_NAME, KwikTip = ...

local additionalDungeons = {
    {
        instanceID = 542,
        uiMapID = 0,
        name = "The Blood Furnace",
        location = "Hellfire Peninsula",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "The Maker",
                encounterID = 1922,
            },
            {
                name = "Broggok",
                encounterID = 1924,
            },
            {
                name = "Keli'dan the Breaker",
                encounterID = 1923,
            },
        },
        timewalking = true,
        twPool = "bc",
    },
    {
        instanceID = 553,
        uiMapID = 0,
        name = "The Botanica",
        location = "Netherstorm",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Commander Sarannis",
                encounterID = 1925,
            },
            {
                name = "High Botanist Freywinn",
                encounterID = 1926,
            },
            {
                name = "Thorngrin the Tender",
                encounterID = 1928,
            },
            {
                name = "Laj",
                encounterID = 1927,
            },
            {
                name = "Warp Splinter",
                encounterID = 1929,
            },
        },
        timewalking = true,
        twPool = "bc",
    },
    {
        instanceID = 585,
        uiMapID = 0,
        name = "Magisters' Terrace",
        location = "Isle of Quel'Danas",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Selin Fireheart",
                encounterID = 1897,
            },
            {
                name = "Vexallus",
                encounterID = 1898,
            },
            {
                name = "Priestess Delrissa",
                encounterID = 1895,
            },
            {
                name = "Kael'thas Sunstrider",
                encounterID = 1894,
            },
        },
        timewalking = true,
        twPool = "bc",
    },
    {
        instanceID = 557,
        uiMapID = 0,
        name = "Mana-Tombs",
        location = "Terokkar Forest",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Pandemonius",
                encounterID = 1900,
            },
            {
                name = "Tavarok",
                encounterID = 1901,
            },
            {
                name = "Nexus-Prince Shaffar",
                encounterID = 1899,
            },
        },
        timewalking = true,
        twPool = "bc",
    },
    {
        instanceID = 540,
        uiMapID = 0,
        name = "The Shattered Halls",
        location = "Hellfire Peninsula",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Grand Warlock Nethekurse",
                encounterID = 1936,
            },
            {
                name = "Warbringer O'mrogg",
                encounterID = 1937,
            },
            {
                name = "Warchief Kargath Bladefist",
                encounterID = 1938,
            },
        },
        timewalking = true,
        twPool = "bc",
    },
    {
        instanceID = 546,
        uiMapID = 0,
        name = "The Underbog",
        location = "Zangarmarsh",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Hungarfen",
                encounterID = 1946,
            },
            {
                name = "Ghaz'an",
                encounterID = 1945,
            },
            {
                name = "Swamplord Musel'ek",
                encounterID = 1947,
            },
            {
                name = "The Black Stalker",
                encounterID = 1948,
            },
        },
        timewalking = true,
        twPool = "bc",
    },
    {
        instanceID = 601,
        uiMapID = 0,
        name = "Azjol-Nerub",
        location = "Dragonblight",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Krik'thir the Gatewatcher",
                encounterID = 1971,
            },
            {
                name = "Hadronox",
                encounterID = 1972,
            },
            {
                name = "Anub'arak",
                encounterID = 1973,
            },
        },
        timewalking = true,
        twPool = "wrath",
    },
    {
        instanceID = 632,
        uiMapID = 0,
        name = "The Forge of Souls",
        location = "Icecrown",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Bronjahm",
                encounterID = 2006,
            },
            {
                name = "The Devourer of Souls",
                encounterID = 2007,
            },
        },
        timewalking = true,
        twPool = "wrath",
    },
    {
        instanceID = 604,
        uiMapID = 0,
        name = "Gundrak",
        location = "Zul'Drak",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Slad'ran",
                encounterID = 1978,
            },
            {
                name = "Moorabi",
                encounterID = 1980,
            },
            {
                name = "Drakkari Colossus",
                encounterID = 1983,
            },
            {
                name = "Gal'darah",
                encounterID = 1981,
            },
        },
        timewalking = true,
        twPool = "wrath",
    },
    {
        instanceID = 602,
        uiMapID = 0,
        name = "Halls of Lightning",
        location = "The Storm Peaks",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "General Bjarngrim",
                encounterID = 1987,
            },
            {
                name = "Volkhan",
                encounterID = 1985,
            },
            {
                name = "Ionar",
                encounterID = 1984,
            },
            {
                name = "Loken",
                encounterID = 1986,
            },
        },
        timewalking = true,
        twPool = "wrath",
    },
    {
        instanceID = 576,
        uiMapID = 0,
        name = "The Nexus",
        location = "Borean Tundra",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Grand Magus Telestra",
                encounterID = 521,
            },
            {
                name = "Anomalus",
                encounterID = 522,
            },
            {
                name = "Ormorok the Tree-Shaper",
                encounterID = 524,
            },
            {
                name = "Keristrasza",
                encounterID = 527,
            },
        },
        timewalking = true,
        twPool = "wrath",
    },
    {
        instanceID = 574,
        uiMapID = 0,
        name = "Utgarde Keep",
        location = "Howling Fjord",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Prince Keleseth",
                encounterID = 2026,
            },
            {
                name = "Skarvald & Dalronn",
                encounterID = 2024,
            },
            {
                name = "Ingvar the Plunderer",
                encounterID = 2025,
            },
        },
        timewalking = true,
        twPool = "wrath",
    },
    {
        instanceID = 645,
        uiMapID = 0,
        name = "Blackrock Caverns",
        location = "Blackrock Mountain",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Rom'ogg Bonecrusher",
                encounterID = 1040,
            },
            {
                name = "Corla, Herald of Twilight",
                encounterID = 1038,
            },
            {
                name = "Karsh Steelbender",
                encounterID = 1039,
            },
            {
                name = "Beauty",
                encounterID = 1037,
            },
            {
                name = "Ascendant Lord Obsidius",
                encounterID = 1036,
            },
        },
        timewalking = true,
        twPool = "cata",
    },
    {
        instanceID = 938,
        uiMapID = 0,
        name = "End Time",
        location = "Tanaris",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Echo of Baine",
                encounterID = 1881,
            },
            {
                name = "Echo of Jaina",
                encounterID = 1883,
            },
            {
                name = "Echo of Sylvanas",
                encounterID = 1882,
            },
            {
                name = "Echo of Tyrande",
                encounterID = 1884,
            },
            {
                name = "Murozond",
                encounterID = 1271,
            },
        },
        timewalking = true,
        twPool = "cata",
    },
    {
        instanceID = 755,
        uiMapID = 0,
        name = "Lost City of the Tol'vir",
        location = "Uldum",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "General Husam",
                encounterID = 1052,
            },
            {
                name = "Lockmaw & Augh",
                encounterID = 1054,
            },
            {
                name = "High Prophet Barim",
                encounterID = 1053,
            },
            {
                name = "Siamat",
                encounterID = 1055,
            },
        },
        timewalking = true,
        twPool = "cata",
    },
    {
        instanceID = 725,
        uiMapID = 324,
        name = "The Stonecore",
        location = "Deepholm",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Corborus",
                encounterID = 1056,
            },
            {
                name = "Slabhide",
                encounterID = 1059,
            },
            {
                name = "Ozruk",
                encounterID = 1058,
            },
            {
                name = "High Priestess Azil",
                encounterID = 1057,
            },
        },
        timewalking = true,
        twPool = "cata",
    },
    {
        instanceID = 657,
        uiMapID = 0,
        name = "The Vortex Pinnacle",
        location = "Uldum",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Grand Vizier Ertan",
                encounterID = 1043,
            },
            {
                name = "Altairus",
                encounterID = 1041,
            },
            {
                name = "Asaad",
                encounterID = 1042,
            },
        },
        timewalking = true,
        twPool = "cata",
    },
    {
        instanceID = 643,
        uiMapID = 0,
        name = "Throne of the Tides",
        location = "Shimmering Expanse",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Lady Naz'jar",
                encounterID = 1045,
            },
            {
                name = "Commander Ulthok",
                encounterID = 1044,
            },
            {
                name = "Mindbender Ghur'sha",
                encounterID = 1046,
            },
            {
                name = "Ozumat",
                encounterID = 1047,
            },
        },
        timewalking = true,
        twPool = "cata",
    },
    {
        instanceID = 962,
        uiMapID = 0,
        name = "Gate of the Setting Sun",
        location = "Townlong Steppes",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Saboteur Kip'tilak",
                encounterID = 1397,
            },
            {
                name = "Striker Ga'dok",
                encounterID = 1405,
            },
            {
                name = "Commander Ri'mok",
                encounterID = 1406,
            },
            {
                name = "Raigonn",
                encounterID = 1419,
            },
        },
        timewalking = true,
        twPool = "mop",
    },
    {
        instanceID = 994,
        uiMapID = 0,
        name = "Mogu'shan Palace",
        location = "Vale of Eternal Blossoms",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Trial of the King",
                encounterID = 1442,
            },
            {
                name = "Gekkan",
                encounterID = 2129,
            },
            {
                name = "Xin the Weaponmaster",
                encounterID = 1441,
            },
        },
        timewalking = true,
        twPool = "mop",
    },
    {
        instanceID = 1007,
        uiMapID = 0,
        name = "Scholomance",
        location = "Western Plaguelands",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Instructor Chillheart",
                encounterID = 1426,
            },
            {
                name = "Jandice Barov",
                encounterID = 1427,
            },
            {
                name = "Rattlegore",
                encounterID = 1428,
            },
            {
                name = "Lilian Voss",
                encounterID = 1429,
            },
            {
                name = "Darkmaster Gandling",
                encounterID = 1430,
            },
        },
        timewalking = true,
        twPool = "mop",
    },
    {
        instanceID = 959,
        uiMapID = 0,
        name = "Shado-Pan Monastery",
        location = "Kun-Lai Summit",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Gu Cloudstrike",
                encounterID = 1303,
            },
            {
                name = "Master Snowdrift",
                encounterID = 1304,
            },
            {
                name = "Sha of Violence",
                encounterID = 1305,
            },
            {
                name = "Taran Zhu",
                encounterID = 1306,
            },
        },
        timewalking = true,
        twPool = "mop",
    },
    {
        instanceID = 961,
        uiMapID = 0,
        name = "Stormstout Brewery",
        location = "Valley of the Four Winds",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Ook-Ook",
                encounterID = 1412,
            },
            {
                name = "Hoptallus",
                encounterID = 1413,
            },
            {
                name = "Yan-Zhu the Uncasked",
                encounterID = 1414,
            },
        },
        timewalking = true,
        twPool = "mop",
    },
    {
        instanceID = 960,
        uiMapID = 0,
        name = "Temple of the Jade Serpent",
        location = "The Jade Forest",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Wise Mari",
                encounterID = 1418,
            },
            {
                name = "Lorewalker Stonestep",
                encounterID = 1417,
            },
            {
                name = "Liu Flameheart",
                encounterID = 1416,
            },
            {
                name = "Sha of Doubt",
                encounterID = 1439,
            },
        },
        timewalking = true,
        twPool = "mop",
    },
    {
        instanceID = 1182,
        uiMapID = 0,
        name = "Auchindoun",
        location = "Talador",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Vigilant Kaathar",
                encounterID = 1686,
            },
            {
                name = "Soulbinder Nyami",
                encounterID = 1685,
            },
            {
                name = "Azzakel",
                encounterID = 1678,
            },
            {
                name = "Teron'gor",
                encounterID = 1714,
            },
        },
        timewalking = true,
        twPool = "wod",
    },
    {
        instanceID = 1175,
        uiMapID = 0,
        name = "Bloodmaul Slag Mines",
        location = "Frostfire Ridge",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Slave Watcher Crushto",
                encounterID = 1653,
            },
            {
                name = "Forgemaster Gog'duh & Magmolatus",
                encounterID = 1655,
            },
            {
                name = "Roltall",
                encounterID = 1652,
            },
            {
                name = "Gug'rokk",
                encounterID = 1654,
            },
        },
        timewalking = true,
        twPool = "wod",
    },
    {
        instanceID = 1279,
        uiMapID = 0,
        name = "The Everbloom",
        location = "Gorgrond",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Witherbark",
                encounterID = 1746,
            },
            {
                name = "Ancient Protectors",
                encounterID = 1757,
            },
            {
                name = "Archmage Sol",
                encounterID = 1751,
            },
            {
                name = "Yalnu",
                encounterID = 1756,
            },
        },
        timewalking = true,
        twPool = "wod",
    },
    {
        instanceID = 1208,
        uiMapID = 0,
        name = "Grimrail Depot",
        location = "Gorgrond",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Rocketspark & Borka",
                encounterID = 1715,
            },
            {
                name = "Nitrogg Thundertower",
                encounterID = 1732,
            },
            {
                name = "Skylord Tovra",
                encounterID = 1736,
            },
        },
        timewalking = true,
        twPool = "wod",
    },
    {
        instanceID = 1176,
        uiMapID = 0,
        name = "Shadowmoon Burial Grounds",
        location = "Shadowmoon Valley",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Sadana Bloodfury",
                encounterID = 1677,
            },
            {
                name = "Nhallish",
                encounterID = 1688,
            },
            {
                name = "Bonemaw",
                encounterID = 1679,
            },
            {
                name = "Ner'zhul",
                encounterID = 1682,
            },
        },
        timewalking = true,
        twPool = "wod",
    },
    {
        instanceID = 1501,
        uiMapID = 0,
        name = "Black Rook Hold",
        location = "Val'sharah",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Amalgam of Souls",
                encounterID = 1832,
            },
            {
                name = "Illysanna Ravencrest",
                encounterID = 1833,
            },
            {
                name = "Smashspite the Hateful",
                encounterID = 1834,
            },
            {
                name = "Kur'talos Ravencrest",
                encounterID = 1835,
            },
        },
        timewalking = true,
        twPool = "legion",
    },
    {
        instanceID = 1571,
        uiMapID = 0,
        name = "Court of Stars",
        location = "Suramar",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Patrol Captain Gerdo",
                encounterID = 1868,
            },
            {
                name = "Talixae Flamewreath",
                encounterID = 1869,
            },
            {
                name = "Advisor Melandrus",
                encounterID = 1870,
            },
        },
        timewalking = true,
        twPool = "legion",
    },
    {
        instanceID = 1466,
        uiMapID = 0,
        name = "Darkheart Thicket",
        location = "Val'sharah",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Archdruid Glaidalis",
                encounterID = 1836,
            },
            {
                name = "Oakheart",
                encounterID = 1837,
            },
            {
                name = "Dresaron",
                encounterID = 1838,
            },
            {
                name = "Shade of Xavius",
                encounterID = 1839,
            },
        },
        timewalking = true,
        twPool = "legion",
    },
    {
        instanceID = 1456,
        uiMapID = 0,
        name = "Eye of Azshara",
        location = "Azsuna",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Warlord Parjesh",
                encounterID = 1810,
            },
            {
                name = "Lady Hatecoil",
                encounterID = 1811,
            },
            {
                name = "King Deepbeard",
                encounterID = 1812,
            },
            {
                name = "Serpentrix",
                encounterID = 1813,
            },
            {
                name = "Wrath of Azshara",
                encounterID = 1814,
            },
        },
        timewalking = true,
        twPool = "legion",
    },
    {
        instanceID = 1458,
        uiMapID = 0,
        name = "Neltharion's Lair",
        location = "Highmountain",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Rokmora",
                encounterID = 1790,
            },
            {
                name = "Ularogg Cragshaper",
                encounterID = 1791,
            },
            {
                name = "Naraxas",
                encounterID = 1792,
            },
            {
                name = "Dargrul the Underking",
                encounterID = 1793,
            },
        },
        timewalking = true,
        twPool = "legion",
    },
    {
        instanceID = 1493,
        uiMapID = 0,
        name = "Vault of the Wardens",
        location = "Azsuna",
        season = "timewalking",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Tirathon Saltheril",
                encounterID = 1815,
            },
            {
                name = "Inquisitor Tormentorum",
                encounterID = 1850,
            },
            {
                name = "Ash'Golm",
                encounterID = 1816,
            },
            {
                name = "Glazer",
                encounterID = 1817,
            },
            {
                name = "Cordana Felsong",
                encounterID = 1818,
            },
        },
        timewalking = true,
        twPool = "legion",
    },
}

for _, dungeon in ipairs(additionalDungeons) do
    KwikTip.DUNGEONS[#KwikTip.DUNGEONS + 1] = dungeon
end

-- ============================================================
-- Runtime lookups — built here after all dungeon data is loaded
-- (Midnight + Timewalking entries combined in a single pass)
-- ============================================================

-- Primary: instanceID (GetInstanceInfo() 8th return) → dungeon
KwikTip.DUNGEON_BY_INSTANCEID = {}
for _, dungeon in ipairs(KwikTip.DUNGEONS) do
    if dungeon.instanceID ~= 0 then
        KwikTip.DUNGEON_BY_INSTANCEID[dungeon.instanceID] = dungeon
    end
end

-- Fallback: uiMapID (C_Map.GetBestMapForUnit) → dungeon
-- Also used for position queries (C_Map.GetPlayerMapPosition requires a uiMapID).
KwikTip.DUNGEON_BY_UIMAPID = {}
for _, dungeon in ipairs(KwikTip.DUNGEONS) do
    if dungeon.uiMapID ~= 0 then
        KwikTip.DUNGEON_BY_UIMAPID[dungeon.uiMapID] = dungeon
    end
    if dungeon.altMapIDs then
        for _, id in ipairs(dungeon.altMapIDs) do
            KwikTip.DUNGEON_BY_UIMAPID[id] = dungeon
        end
    end
end

-- Trash mob lookup: npcID → { dungeon, mob }
-- NOTE: not queried at runtime in Midnight 12.x — hostile NPC GUIDs are tainted and cannot be
-- resolved via C_CreatureInfo.GetCreatureID. Retained for potential future use.
KwikTip.TRASH_BY_NPCID = {}
for _, dungeon in ipairs(KwikTip.DUNGEONS) do
    if dungeon.trash then
        for _, mob in ipairs(dungeon.trash) do
            if mob.npcID and mob.npcID ~= 0 then
                KwikTip.TRASH_BY_NPCID[mob.npcID] = { dungeon = dungeon, mob = mob }
            end
        end
    end
end

-- Boss lookup: encounterID (ENCOUNTER_START event) → { dungeon, boss }
-- altEncounterIDs handles bosses that fire different encounterIDs per variant (e.g. delve event types).
KwikTip.BOSS_BY_ENCOUNTERID = {}
for _, dungeon in ipairs(KwikTip.DUNGEONS) do
    for _, boss in ipairs(dungeon.bosses) do
        local entry = { dungeon = dungeon, boss = boss }
        if boss.encounterID ~= 0 then
            KwikTip.BOSS_BY_ENCOUNTERID[boss.encounterID] = entry
        end
        if boss.altEncounterIDs then
            for _, id in ipairs(boss.altEncounterIDs) do
                if id ~= 0 then
                    KwikTip.BOSS_BY_ENCOUNTERID[id] = entry
                end
            end
        end
    end
end

-- Boss NPC lookup: npcID → { dungeon, boss }
-- NOTE: not queried at runtime in Midnight 12.x — hostile NPC GUIDs are tainted and cannot be
-- resolved via C_CreatureInfo.GetCreatureID. npcID/altNpcIDs fields on boss entries are
-- reference data only (useful for Wowhead cross-referencing). Retained for potential future use.
KwikTip.BOSS_BY_NPCID = {}
for _, dungeon in ipairs(KwikTip.DUNGEONS) do
    for _, boss in ipairs(dungeon.bosses) do
        local entry = { dungeon = dungeon, boss = boss }
        if boss.npcID and boss.npcID ~= 0 then
            KwikTip.BOSS_BY_NPCID[boss.npcID] = entry
        end
        if boss.altNpcIDs then
            for _, id in ipairs(boss.altNpcIDs) do
                if id ~= 0 then
                    KwikTip.BOSS_BY_NPCID[id] = entry
                end
            end
        end
    end
end
