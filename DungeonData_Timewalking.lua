-- KwikTip: Timewalking dungeon data
--
-- Appended to KwikTip.DUNGEONS after DungeonData.lua loads.
-- Runtime lookup tables are also built here so that both Midnight and
-- Timewalking entries are included in a single pass.
--
-- Schema is identical to DungeonData.lua. Additional fields:
--   timewalking : true for all entries in this file
--   twPool      : "bc" | "wrath" | "cata" | "mop" | "wod" | "legion"
--
-- instanceIDs sourced from LittleWigs (same GetInstanceInfo() space). Unverified in-game.
-- encounterIDs are 0 — source from LittleWigs TW modules or Wowhead and fill in.
-- uiMapIDs are 0 — verify in-game with: /run print(C_Map.GetBestMapForUnit("player"))
-- tips are empty — fill in pool by pool using Wowhead (primary) + warcraft.wiki.gg (secondary).
--
-- NOTE: Skyreach (WoD TW pool) is already defined in DungeonData.lua as a Midnight M+
-- dungeon (instanceID 1209). It covers both contexts — no duplicate entry needed here.
--
-- NOTE: Pit of Saron (Wrath TW) was removed from the Wrath TW pool in patch 9.1.5.
-- It is defined in DungeonData.lua as a Midnight M+ dungeon. No TW entry needed.

local ADDON_NAME, KwikTip = ...

local twDungeons = {

    -- ============================================================
    -- BURNING CRUSADE TIMEWALKING — 6 dungeons
    -- NOTE: The Black Morass and Old Hillsbrad Foothills (Caverns of Time) have
    --       historically been part of the BC TW pool — verify current pool composition
    --       and add if still active.
    -- ============================================================

    {
        instanceID  = 542,  -- Blood Furnace; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "The Blood Furnace",
        location    = "Hellfire Peninsula",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "bc",
        bosses = {
            {
                encounterID = 0,
                name        = "The Maker",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Broggok",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Keli'dan the Breaker",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 553,  -- The Botanica; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "The Botanica",
        location    = "Netherstorm",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "bc",
        bosses = {
            {
                encounterID = 0,
                name        = "Commander Sarannis",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "High Botanist Freywinn",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Thorngrin the Tender",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Laj",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Warp Splinter",
                tip         = "",
            },
        },
    },

    {
        -- The ORIGINAL TBC version of Magisters' Terrace (instanceID 585).
        -- Completely separate instance from the Midnight rework (instanceID 2811 in DungeonData.lua).
        instanceID  = 585,  -- Magisters' Terrace (TBC); LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Magisters' Terrace",
        location    = "Isle of Quel'Danas",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "bc",
        bosses = {
            {
                encounterID = 0,
                name        = "Selin Fireheart",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Vexallus",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Priestess Delrissa",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Kael'thas Sunstrider",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 557,  -- Mana-Tombs; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Mana-Tombs",
        location    = "Terokkar Forest",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "bc",
        bosses = {
            {
                encounterID = 0,
                name        = "Pandemonius",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Tavarok",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Nexus-Prince Shaffar",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 540,  -- The Shattered Halls; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "The Shattered Halls",
        location    = "Hellfire Peninsula",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "bc",
        bosses = {
            {
                encounterID = 0,
                name        = "Grand Warlock Nethekurse",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Warbringer O'mrogg",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Warchief Kargath Bladefist",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 546,  -- The Underbog; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "The Underbog",
        location    = "Zangarmarsh",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "bc",
        bosses = {
            {
                encounterID = 0,
                name        = "Hungarfen",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Ghaz'an",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Swamplord Musel'ek",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "The Black Stalker",
                tip         = "",
            },
        },
    },

    -- ============================================================
    -- WRATH OF THE LICH KING TIMEWALKING — 6 dungeons
    -- NOTE: Pit of Saron, Utgarde Pinnacle, and Halls of Stone all removed from
    --       the Wrath TW pool in patch 9.1.5. Pit of Saron is in DungeonData.lua
    --       as a Midnight M+ dungeon. The other two are not needed anywhere.
    -- ============================================================

    {
        instanceID  = 601,  -- Azjol-Nerub (instanceID); LittleWigs source, unverified
                            -- NOTE: 601 is also Skyreach's uiMapID — different ID space, no collision
        uiMapID     = 0,
        name        = "Azjol-Nerub",
        location    = "Dragonblight",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "wrath",
        bosses = {
            {
                encounterID = 0,
                name        = "Krik'thir the Gatewatcher",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Hadronox",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Anub'arak",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 632,  -- The Forge of Souls; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "The Forge of Souls",
        location    = "Icecrown",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "wrath",
        bosses = {
            {
                encounterID = 0,
                name        = "Bronjahm",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "The Devourer of Souls",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 604,  -- Gundrak; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Gundrak",
        location    = "Zul'Drak",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "wrath",
        bosses = {
            {
                encounterID = 0,
                name        = "Slad'ran",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Moorabi",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Drakkari Colossus",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Gal'darah",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 602,  -- Halls of Lightning; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Halls of Lightning",
        location    = "The Storm Peaks",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "wrath",
        bosses = {
            {
                encounterID = 0,
                name        = "General Bjarngrim",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Volkhan",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Ionar",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Loken",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 576,  -- The Nexus; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "The Nexus",
        location    = "Borean Tundra",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "wrath",
        bosses = {
            {
                encounterID = 0,
                name        = "Grand Magus Telestra",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Anomalus",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Ormorok the Tree-Shaper",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Keristrasza",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 574,  -- Utgarde Keep; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Utgarde Keep",
        location    = "Howling Fjord",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "wrath",
        bosses = {
            {
                encounterID = 0,
                name        = "Prince Keleseth",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Skarvald & Dalronn",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Ingvar the Plunderer",
                tip         = "",
            },
        },
    },

    -- ============================================================
    -- CATACLYSM TIMEWALKING — 6 dungeons
    -- NOTE: Grim Batol removed from Cata TW pool in patch 9.1.5.
    -- ============================================================

    {
        instanceID  = 645,  -- Blackrock Caverns; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Blackrock Caverns",
        location    = "Blackrock Mountain",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "cata",
        bosses = {
            {
                encounterID = 0,
                name        = "Rom'ogg Bonecrusher",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Corla, Herald of Twilight",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Karsh Steelbender",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Beauty",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Ascendant Lord Obsidius",
                tip         = "",
            },
        },
    },

    {
        -- End Time has a randomised boss order: two of four possible Echoes appear each run,
        -- followed by Murozond. All four Echoes are listed so tips surface regardless of which
        -- two the instance selects. EncounterIDs will differ per Echo — fill in individually.
        instanceID  = 938,  -- End Time; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "End Time",
        location    = "Tanaris",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "cata",
        bosses = {
            {
                encounterID = 0,
                name        = "Echo of Baine",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Echo of Jaina",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Echo of Sylvanas",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Echo of Tyrande",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Murozond",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 755,  -- Lost City of the Tol'vir; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Lost City of the Tol'vir",
        location    = "Uldum",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "cata",
        bosses = {
            {
                encounterID = 0,
                name        = "General Husam",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Augh & Lockmaw",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "High Prophet Barim",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Siamat",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 725,  -- The Stonecore; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "The Stonecore",
        location    = "Deepholm",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "cata",
        bosses = {
            {
                encounterID = 0,
                name        = "Corborus",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Slabhide",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Ozruk",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "High Priestess Azil",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 657,  -- The Vortex Pinnacle; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "The Vortex Pinnacle",
        location    = "Uldum",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "cata",
        bosses = {
            {
                encounterID = 0,
                name        = "Grand Vizier Ertan",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Altairus",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Asaad",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 643,  -- Throne of the Tides; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Throne of the Tides",
        location    = "Shimmering Expanse",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "cata",
        bosses = {
            {
                encounterID = 0,
                name        = "Lady Naz'jar",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Commander Ulthok",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Mindbender Ghur'sha",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Ozumat",
                tip         = "",
            },
        },
    },

    -- ============================================================
    -- MISTS OF PANDARIA TIMEWALKING — 6 dungeons
    -- NOTE: Siege of Niuzao Temple (instanceID 1011) pool membership is disputed
    --       between sources. Flagged for in-game verification — not included yet.
    -- ============================================================

    {
        instanceID  = 962,  -- Gate of the Setting Sun; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Gate of the Setting Sun",
        location    = "Townlong Steppes",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "mop",
        bosses = {
            {
                encounterID = 0,
                name        = "Saboteur Kip'tilak",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Striker Ga'dok",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Commander Ri'mok",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Raigonn",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 994,  -- Mogu'shan Palace; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Mogu'shan Palace",
        location    = "Vale of Eternal Blossoms",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "mop",
        bosses = {
            {
                encounterID = 0,
                name        = "Trial of the King",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Gekkan",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Xin the Weaponmaster",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 1007,  -- Scholomance (MoP revamp); LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Scholomance",
        location    = "Western Plaguelands",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "mop",
        bosses = {
            {
                encounterID = 0,
                name        = "Instructor Chillheart",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Jandice Barov",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Rattlegore",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Lilian Voss",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Darkmaster Gandling",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 959,  -- Shado-Pan Monastery; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Shado-Pan Monastery",
        location    = "Kun-Lai Summit",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "mop",
        bosses = {
            {
                encounterID = 0,
                name        = "Gu Cloudstrike",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Master Snowdrift",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Sha of Violence",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Taran Zhu",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 961,  -- Stormstout Brewery; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Stormstout Brewery",
        location    = "Valley of the Four Winds",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "mop",
        bosses = {
            {
                encounterID = 0,
                name        = "Ook-Ook",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Hoptallus",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Yan-Zhu the Uncasked",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 960,  -- Temple of the Jade Serpent; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Temple of the Jade Serpent",
        location    = "The Jade Forest",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "mop",
        bosses = {
            {
                encounterID = 0,
                name        = "Wise Mari",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Lorewalker Stonestep",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Liu Flameheart",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Sha of Doubt",
                tip         = "",
            },
        },
    },

    -- ============================================================
    -- WARLORDS OF DRAENOR TIMEWALKING — 5 dungeons
    -- NOTE: Skyreach (instanceID 1209) is already defined in DungeonData.lua
    --       as a Midnight M+ Season 1 dungeon. That entry covers TW as well.
    -- NOTE: Iron Docks removed from WoD TW pool in patch 9.1.5.
    -- ============================================================

    {
        instanceID  = 1182,  -- Auchindoun; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Auchindoun",
        location    = "Talador",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "wod",
        bosses = {
            {
                encounterID = 0,
                name        = "Vigilant Kaathar",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Soulbinder Nyami",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Azzakel",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Teron'gor",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 1175,  -- Bloodmaul Slag Mines; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Bloodmaul Slag Mines",
        location    = "Frostfire Ridge",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "wod",
        bosses = {
            {
                encounterID = 0,
                name        = "Slave Watcher Crushto",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Forgemaster Gog'duh & Magmolatus",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Roltall",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Gug'rokk",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 1279,  -- The Everbloom; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "The Everbloom",
        location    = "Gorgrond",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "wod",
        bosses = {
            {
                encounterID = 0,
                name        = "Witherbark",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Ancient Protectors",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Archmage Sol",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Yalnu",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 1208,  -- Grimrail Depot; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Grimrail Depot",
        location    = "Gorgrond",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "wod",
        bosses = {
            {
                encounterID = 0,
                name        = "Rocketspark & Borka",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Nitrogg Thundertower",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Skylord Tovra",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 1176,  -- Shadowmoon Burial Grounds; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Shadowmoon Burial Grounds",
        location    = "Shadowmoon Valley",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "wod",
        bosses = {
            {
                encounterID = 0,
                name        = "Sadana Bloodfury",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Nhallish",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Bonemaw",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Ner'zhul",
                tip         = "",
            },
        },
    },

    -- ============================================================
    -- LEGION TIMEWALKING — 6 dungeons
    -- NOTE: Return to Karazhan is NOT in the Legion TW pool.
    -- ============================================================

    {
        instanceID  = 1501,  -- Black Rook Hold; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Black Rook Hold",
        location    = "Val'sharah",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "legion",
        bosses = {
            {
                encounterID = 0,
                name        = "Amalgam of Souls",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Illysanna Ravencrest",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Smashspite the Hateful",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Kur'talos Ravencrest",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 1571,  -- Court of Stars; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Court of Stars",
        location    = "Suramar",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "legion",
        bosses = {
            {
                encounterID = 0,
                name        = "Patrol Captain Gerdo",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Talixae Flamewreath",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Advisor Melandrus",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 1466,  -- Darkheart Thicket; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Darkheart Thicket",
        location    = "Val'sharah",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "legion",
        bosses = {
            {
                encounterID = 0,
                name        = "Archdruid Glaidalis",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Oakheart",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Dresaron",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Shade of Xavius",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 1456,  -- Eye of Azshara; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Eye of Azshara",
        location    = "Azsuna",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "legion",
        bosses = {
            {
                encounterID = 0,
                name        = "Warlord Parjesh",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Lady Hatecoil",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "King Deepbeard",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Serpentrix",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Wrath of Azshara",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 1458,  -- Neltharion's Lair; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Neltharion's Lair",
        location    = "Highmountain",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "legion",
        bosses = {
            {
                encounterID = 0,
                name        = "Rokmora",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Ularogg Cragshaper",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Naraxas",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Dargrul the Underking",
                tip         = "",
            },
        },
    },

    {
        instanceID  = 1493,  -- Vault of the Wardens; LittleWigs source, unverified
        uiMapID     = 0,
        name        = "Vault of the Wardens",
        location    = "Azsuna",
        season      = "timewalking",
        type        = "max",
        mythicPlus  = false,
        timewalking = true,
        twPool      = "legion",
        bosses = {
            {
                encounterID = 0,
                name        = "Tirathon Saltheril",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Inquisitor Tormentorum",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Ash'Golm",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Glazer",
                tip         = "",
            },
            {
                encounterID = 0,
                name        = "Cordana Felsong",
                tip         = "",
            },
        },
    },
}

-- Append to the main DUNGEONS table (defined in DungeonData.lua)
for _, dungeon in ipairs(twDungeons) do
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

-- Trash mob lookup: npcID (from UnitGUID) → { dungeon, mob }
KwikTip.TRASH_BY_NPCID = {}
for _, dungeon in ipairs(KwikTip.DUNGEONS) do
    if dungeon.trash then
        for _, mob in ipairs(dungeon.trash) do
            KwikTip.TRASH_BY_NPCID[mob.npcID] = { dungeon = dungeon, mob = mob }
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
-- Fallback for rooms where ENCOUNTER_START hasn't fired yet and no subzone text exists.
-- Populated from boss entries that have an npcID field (sourced from Wowhead).
KwikTip.BOSS_BY_NPCID = {}
for _, dungeon in ipairs(KwikTip.DUNGEONS) do
    for _, boss in ipairs(dungeon.bosses) do
        if boss.npcID and boss.npcID ~= 0 then
            KwikTip.BOSS_BY_NPCID[boss.npcID] = { dungeon = dungeon, boss = boss }
        end
    end
end
