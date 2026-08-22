-- KwikTip_CN: dungeon detection catalog (strategy prose intentionally removed)
local ADDON_NAME, KwikTip = ...

-- Stable instance, map, encounter, NPC and sub-zone metadata only.
-- All HUD bodies are user-authored and stored in KwikTipCNDB.customTips.
KwikTip.DUNGEONS = {
    {
        instanceID = 2805,
        uiMapID = 2492,
        altMapIDs = {
            2537,
            2493,
            2494,
            2496,
            2497,
            2498,
            2499,
        },
        name = "Windrunner Spire",
        location = "Eversong Woods",
        season = "midnight",
        type = "level",
        mythicPlus = false,
        bosses = {
            {
                name = "Emberdawn",
                encounterID = 3056,
                npcID = 231606,
            },
            {
                name = "Derelict Duo",
                encounterID = 3057,
                npcID = 231626,
                altNpcIDs = {
                    231629,
                },
            },
            {
                name = "Commander Kroluk",
                encounterID = 3058,
                npcID = 231631,
            },
            {
                name = "The Restless Heart",
                encounterID = 3059,
                npcID = 231636,
            },
        },
        trash = {
            {
                name = "Restless Steward",
                npcID = 232070,
            },
            {
                name = "Spellguard Magus",
                npcID = 232113,
            },
            {
                name = "Creeping Spindleweb",
                npcID = 232067,
            },
            {
                name = "Territorial Dragonhawk",
                npcID = 232097,
            },
            {
                name = "Bloated Lasher",
                npcID = 232094,
            },
            {
                name = "Ardent Cutthroat",
                npcID = 231616,
            },
            {
                name = "Devoted Woebringer",
                npcID = 231615,
            },
            {
                name = "Dutiful Groundskeeper",
                npcID = 232071,
            },
            {
                name = "Phalanx Breaker",
                npcID = 232121,
            },
            {
                name = "Apex Lynx",
                npcID = 0,
            },
            {
                name = "Loyal Worg",
                npcID = 0,
            },
            {
                name = "Flesh Behemoth",
                npcID = 0,
            },
            {
                name = "Spectral Axethrower",
                npcID = 232447,
            },
        },
        areas = {
            {
                id = "2805:1",
                subzone = "The Promenade",
                mapID = 2492,
            },
            {
                id = "2805:2",
                mapID = 2493,
                bossIndex = 1,
            },
            {
                id = "2805:3",
                mapID = 2494,
                bossIndex = 2,
            },
            {
                id = "2805:4",
                subzone = "Sylvanas's Quarters",
            },
            {
                id = "2805:5",
                subzone = "Windrunner Vault",
                bossIndex = 3,
            },
            {
                id = "2805:6",
                subzone = "The Pinnacle",
                bossIndex = 4,
            },
        },
    },
    {
        instanceID = 2813,
        challengeMapID = 587,
        uiMapID = 2433,
        altMapIDs = {
            2435,
            2434,
            2393,
        },
        name = "Murder Row",
        location = "Silvermoon City",
        season = "midnight",
        type = "level",
        mythicPlus = true,
        bosses = {
            {
                name = "Kystia Manaheart",
                encounterID = 3101,
                journalEncounterID = 2679,
                npcID = 252458,
            },
            {
                name = "Zaen Bladesorrow",
                encounterID = 3102,
                journalEncounterID = 2680,
                npcID = 234649,
            },
            {
                name = "Xathuux the Annihilator",
                encounterID = 3103,
                journalEncounterID = 2681,
                npcID = 234647,
            },
            {
                name = "Lithiel Cinderfury",
                encounterID = 3105,
                journalEncounterID = 2682,
                npcID = 237415,
            },
        },
        trash = {
            {
                name = "Corrupted Ghoul",
                npcID = 0,
            },
            {
                name = "Hateful Shaper",
                npcID = 0,
            },
            {
                name = "Ghostly Retainer",
                npcID = 0,
            },
            {
                name = "Vilethorn Sapling",
                npcID = 0,
            },
            {
                name = "Fel Bat",
                npcID = 0,
            },
            {
                name = "Shadowmire Attendant",
                npcID = 0,
            },
            {
                name = "Wrathguard Invader",
                npcID = 0,
            },
            {
                name = "Doomguard Sentry",
                npcID = 0,
            },
        },
        areas = {
            {
                id = "2813:1",
                subzone = "Silvermoon Pet Shop",
                bossIndex = 1,
            },
            {
                id = "2813:2",
                subzone = "The Illicit Rain",
                bossIndex = 2,
            },
            {
                id = "2813:3",
                subzone = "Augurs' Terrace",
                bossIndex = 3,
            },
            {
                id = "2813:4",
                subzone = "Lithiel's Landing",
                bossIndex = 4,
            },
        },
    },
    {
        instanceID = 2825,
        challengeMapID = 586,
        uiMapID = 2514,
        altMapIDs = {
            2564,
            2513,
        },
        name = "Den of Nalorakk",
        location = "Zul'Aman",
        season = "midnight",
        type = "level",
        mythicPlus = true,
        bosses = {
            {
                name = "The Hoardmonger",
                encounterID = 3207,
                journalEncounterID = 2776,
                npcID = 248710,
            },
            {
                name = "Sentinel of Winter",
                encounterID = 3208,
                journalEncounterID = 2777,
                npcID = 261053,
            },
            {
                name = "Nalorakk",
                encounterID = 3209,
                journalEncounterID = 2778,
                npcID = 258877,
            },
        },
        trash = {
            {
                name = "Keen-Eyed Striker",
                npcID = 0,
            },
            {
                name = "Thornclaw Gatherer",
                npcID = 0,
            },
            {
                name = "Territorial Matriarch",
                npcID = 0,
            },
            {
                name = "Earthwhisper Tender",
                npcID = 0,
            },
            {
                name = "Spirit of Hunger",
                npcID = 0,
            },
            {
                name = "Frostfang",
                npcID = 0,
            },
            {
                name = "Terra Rumbler",
                npcID = 0,
            },
            {
                name = "Avatar of Determination",
                npcID = 0,
            },
            {
                name = "Glacial Revenant",
                npcID = 0,
            },
            {
                name = "Frigid Mauler",
                npcID = 0,
            },
            {
                name = "The Winter Squall",
                npcID = 0,
            },
            {
                name = "Stormbound Mystic",
                npcID = 0,
            },
            {
                name = "Ruthless Totemcaller",
                npcID = 0,
            },
            {
                name = "Grizzled Warbringer",
                npcID = 0,
            },
            {
                name = "Bonded Beasttamer",
                npcID = 0,
            },
            {
                name = "Loyal Saberfang",
                npcID = 0,
            },
            {
                name = "Loa Speaker Nanea",
                npcID = 0,
            },
        },
        areas = {
            {
                id = "2825:1",
                subzone = "Enduring Winter",
                bossIndex = 1,
            },
            {
                id = "2825:2",
                subzone = "The Foraging",
            },
            {
                id = "2825:3",
                subzone = "Dreamer's Passage",
                bossIndex = 3,
            },
            {
                id = "2825:4",
                subzone = "The Heart of Rage",
                bossIndex = 3,
            },
        },
    },
    {
        instanceID = 2874,
        uiMapID = 2501,
        name = "Maisara Caverns",
        location = "Zul'Aman",
        season = "midnight",
        type = "level",
        mythicPlus = false,
        bosses = {
            {
                name = "Muro'jin and Nekraxx",
                encounterID = 3212,
                npcID = 247570,
                altNpcIDs = {
                    247572,
                },
            },
            {
                name = "Vordaza",
                encounterID = 3213,
                npcID = 248595,
            },
            {
                name = "Rak'tul, Vessel of Souls",
                encounterID = 3214,
                npcID = 248605,
            },
        },
        trash = {
            {
                name = "Keen Headhunter",
                npcID = 242964,
            },
            {
                name = "Dread Souleater",
                npcID = 248686,
            },
            {
                name = "Ritual Hexxer",
                npcID = 248685,
            },
            {
                name = "Hulking Juggernaut",
                npcID = 248678,
            },
            {
                name = "Hexbound Eagle",
                npcID = 249020,
            },
            {
                name = "Bramblemaw Bear",
                npcID = 249022,
            },
            {
                name = "Reanimated Warrior",
                npcID = 248692,
            },
            {
                name = "Grim Skirmisher",
                npcID = 248690,
            },
            {
                name = "Restless Gnarldin",
                npcID = 249030,
            },
            {
                name = "Frenzied Berserker",
                npcID = 0,
            },
            {
                name = "Tormented Shade",
                npcID = 249036,
            },
            {
                name = "Rokh'zal",
                npcID = 253683,
            },
            {
                name = "Bound Defender",
                npcID = 249025,
            },
            {
                name = "Hollow Soulrender",
                npcID = 249024,
            },
            {
                name = "Hex Guardian",
                npcID = 0,
            },
            {
                name = "Umbral Shadow Binder",
                npcID = 0,
            },
            {
                name = "Gloomwing Bat",
                npcID = 253473,
            },
        },
        areas = {
            {
                id = "2874:1",
                subzone = "Wailing Depths",
                bossIndex = 1,
            },
            {
                id = "2874:2",
                subzone = "Dais of Suffering",
                bossIndex = 2,
            },
            {
                id = "2874:3",
                subzone = "Echoing Span",
                bossIndex = 3,
            },
        },
    },
    {
        instanceID = 2811,
        uiMapID = 2511,
        altMapIDs = {
            2424,
            2515,
            2516,
            2517,
            2519,
            2520,
        },
        name = "Magisters' Terrace",
        location = "Isle of Quel'Danas",
        season = "midnight",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Arcanotron Custos",
                encounterID = 3071,
                npcID = 231861,
            },
            {
                name = "Seranel Sunlash",
                encounterID = 3072,
                npcID = 231863,
            },
            {
                name = "Gemellus",
                encounterID = 3073,
                npcID = 231864,
            },
            {
                name = "Degentrius",
                encounterID = 3074,
                npcID = 231865,
            },
        },
        trash = {
            {
                name = "Arcane Magister",
                npcID = 241326,
            },
            {
                name = "Arcane Magister",
                npcID = 232369,
            },
            {
                name = "Arcane Magister",
                npcID = 257644,
            },
            {
                name = "Lightward Healer",
                npcID = 234486,
            },
            {
                name = "Animated Codex",
                npcID = 251917,
            },
            {
                name = "Blazing Pyromancer",
                npcID = 257161,
            },
            {
                name = "Brightscale Wyrm",
                npcID = 24761,
            },
            {
                name = "Shadowrift Voidcaller",
                npcID = 234068,
            },
            {
                name = "Void Infuser",
                npcID = 249086,
            },
            {
                name = "Devouring Tyrant",
                npcID = 234066,
            },
            {
                name = "Arcane Sentry",
                npcID = 0,
            },
            {
                name = "Sunblade Enforcer",
                npcID = 241325,
            },
            {
                name = "Spellwoven Familiar",
                npcID = 259387,
            },
            {
                name = "Runed Spellbreaker",
                npcID = 241444,
            },
            {
                name = "Voidling",
                npcID = 0,
            },
            {
                name = "Dreaded Voidwalker",
                npcID = 0,
            },
            {
                name = "Unstable Voidling",
                npcID = 0,
            },
        },
        areas = {
            {
                id = "2811:1",
                subzone = "Arcane Atheneum",
            },
            {
                id = "2811:2",
                subzone = "Observation Grounds",
                bossIndex = 1,
            },
            {
                id = "2811:3",
                subzone = "Grand Magister Asylum",
                bossIndex = 2,
            },
            {
                id = "2811:4",
                subzone = "Tower of Theory",
            },
            {
                id = "2811:5",
                subzone = "Constellarium",
                bossIndex = 3,
            },
            {
                id = "2811:6",
                subzone = "Celestial Orrery",
                bossIndex = 4,
            },
        },
    },
    {
        instanceID = 2915,
        uiMapID = 2556,
        name = "Nexus-Point Xenas",
        location = "Voidstorm",
        season = "midnight",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Chief Corewright Kasreth",
                encounterID = 3328,
                npcID = 241539,
            },
            {
                name = "Corewarden Nysarra",
                encounterID = 3332,
                npcID = 254227,
            },
            {
                name = "Lothraxion",
                encounterID = 3333,
                npcID = 241546,
            },
        },
        trash = {
            {
                name = "Shadowguard Defender",
                npcID = 241643,
            },
            {
                name = "Flux Engineer",
                npcID = 241647,
            },
            {
                name = "Nexus Adept",
                npcID = 248708,
            },
            {
                name = "Circuit Seer",
                npcID = 248373,
            },
            {
                name = "Cursed Voidcaller",
                npcID = 248706,
            },
            {
                name = "Grand Nullifier",
                npcID = 251853,
            },
            {
                name = "Duskfright Herald",
                npcID = 241660,
            },
            {
                name = "Dreadflail",
                npcID = 251024,
            },
            {
                name = "Corewright Arcanist",
                npcID = 241644,
            },
            {
                name = "Lingering Image",
                npcID = 0,
            },
        },
        areas = {
            {
                id = "2915:1",
                subzone = "The Bazaar",
            },
            {
                id = "2915:2",
                subzone = "Corespark Engineway",
                bossIndex = 1,
            },
            {
                id = "2915:3",
                subzone = "Core Defense Nullward",
                bossIndex = 2,
            },
            {
                id = "2915:4",
                subzone = "The Nexus Core",
                bossIndex = 3,
            },
        },
    },
    {
        instanceID = 2859,
        challengeMapID = 584,
        uiMapID = 2500,
        name = "The Blinding Vale",
        location = "Harandar",
        season = "midnight",
        type = "max",
        mythicPlus = true,
        bosses = {
            {
                name = "Lightblossom Trinity",
                encounterID = 3199,
                journalEncounterID = 2769,
                npcID = 243028,
                altNpcIDs = {
                    243029,
                    243030,
                },
            },
            {
                name = "Ikuzz the Light Hunter",
                encounterID = 3200,
                journalEncounterID = 2770,
                npcID = 244887,
            },
            {
                name = "Lightwarden Ruia",
                encounterID = 3201,
                journalEncounterID = 2771,
                npcID = 245912,
            },
            {
                name = "Ziekket",
                encounterID = 3202,
                journalEncounterID = 2772,
                npcID = 247676,
            },
        },
        trash = {
            {
                name = "Lasher",
                npcID = 0,
            },
            {
                name = "Lightgorged Lasher",
                npcID = 0,
            },
            {
                name = "Radiant Spellsower",
                npcID = 0,
            },
            {
                name = "Underbrush Stalker",
                npcID = 0,
            },
            {
                name = "Virid Grovekeeper",
                npcID = 0,
            },
            {
                name = "Sporeblight Belcher",
                npcID = 0,
            },
            {
                name = "Thorny Saptor",
                npcID = 0,
            },
            {
                name = "Lightfeather Petalwing",
                npcID = 0,
            },
            {
                name = "Leafy Grovecrawler",
                npcID = 0,
            },
            {
                name = "Overgrown Hydra",
                npcID = 0,
            },
            {
                name = "Spineshield Beetle",
                npcID = 0,
            },
            {
                name = "Luminous Thornmaw",
                npcID = 0,
            },
            {
                name = "Potatoad Matriarch",
                npcID = 0,
            },
            {
                name = "Newborn Potadpole",
                npcID = 0,
            },
        },
        areas = {
            {
                id = "2859:1",
                subzone = "The Luminous Garden",
                bossIndex = 1,
            },
            {
                id = "2859:2",
                subzone = "The Gilded Tangle",
                bossIndex = 2,
            },
            {
                id = "2859:3",
                subzone = "Warden's Retreat",
                bossIndex = 3,
            },
            {
                id = "2859:4",
                subzone = "Conviction's Crucible",
                bossIndex = 4,
            },
        },
    },
    {
        instanceID = 2923,
        challengeMapID = 585,
        uiMapID = 2572,
        altMapIDs = {
            2573,
            2574,
        },
        name = "Voidscar Arena",
        location = "Voidstorm",
        season = "midnight",
        type = "max",
        mythicPlus = true,
        bosses = {
            {
                name = "Taz'Rah",
                encounterID = 3285,
                journalEncounterID = 2791,
                npcID = 238887,
            },
            {
                name = "Atroxus",
                encounterID = 3286,
                journalEncounterID = 2792,
                npcID = 239008,
            },
            {
                name = "Charonus",
                encounterID = 3287,
                journalEncounterID = 2793,
                npcID = 248015,
            },
        },
        trash = {
            {
                name = "Lost Sethrak",
                npcID = 0,
            },
            {
                name = "Feral Saberon",
                npcID = 0,
            },
            {
                name = "Enthralled Shaman",
                npcID = 0,
            },
            {
                name = "Dominated Brawler",
                npcID = 0,
            },
            {
                name = "Brutal Overseer",
                npcID = 0,
            },
            {
                name = "Aegyra the Unyielding",
                npcID = 0,
            },
            {
                name = "Longtooth Tuskarr",
                npcID = 0,
            },
            {
                name = "Voidtouched Magi",
                npcID = 0,
            },
            {
                name = "Raj'kess the Spellstorm",
                npcID = 0,
            },
            {
                name = "Sycophantic Tarasek",
                npcID = 0,
            },
            {
                name = "Chitigoth",
                npcID = 0,
            },
            {
                name = "Raging Raptor",
                npcID = 0,
            },
            {
                name = "Protective Turtle",
                npcID = 0,
            },
            {
                name = "Brutok",
                npcID = 0,
            },
            {
                name = "Abducted Drakonid",
                npcID = 0,
            },
            {
                name = "Angry Krolusk",
                npcID = 0,
            },
            {
                name = "Savage Shredclaw",
                npcID = 0,
            },
            {
                name = "Killvore Screamer",
                npcID = 0,
            },
            {
                name = "Agitated Voidscythe",
                npcID = 0,
            },
            {
                name = "Blistercreep",
                npcID = 0,
            },
            {
                name = "Watchful Harrower",
                npcID = 0,
            },
            {
                name = "Devouring Brutalizer",
                npcID = 0,
            },
            {
                name = "Voidminder",
                npcID = 0,
            },
            {
                name = "Scavenging Siphoid",
                npcID = 0,
            },
        },
        areas = {
            {
                id = "2923:1",
                subzone = "The Den",
                bossIndex = 1,
            },
            {
                id = "2923:2",
                mapID = 2573,
                bossIndex = 2,
            },
            {
                id = "2923:3",
                mapID = 2574,
                bossIndex = 3,
            },
        },
    },
    {
        instanceID = 2526,
        uiMapID = 2097,
        altMapIDs = {
            2025,
            2098,
        },
        name = "Algeth'ar Academy",
        location = "Thaldraszus",
        season = "legacy",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Overgrown Ancient",
                encounterID = 2563,
                npcID = 196482,
            },
            {
                name = "Crawth",
                encounterID = 2564,
                npcID = 191736,
            },
            {
                name = "Vexamus",
                encounterID = 2562,
                npcID = 194181,
            },
            {
                name = "Echo of Doragosa",
                encounterID = 2565,
                npcID = 190609,
            },
        },
        trash = {
            {
                name = "Unruly Textbook",
                npcID = 196044,
            },
            {
                name = "Spectral Invoker",
                npcID = 196202,
            },
            {
                name = "Vile Lasher",
                npcID = 197219,
            },
            {
                name = "Corrupted Manafiend",
                npcID = 196045,
            },
            {
                name = "Aggravated Skitterfly",
                npcID = 0,
            },
            {
                name = "Territorial Eagle",
                npcID = 0,
            },
            {
                name = "Alpha Eagle",
                npcID = 0,
            },
            {
                name = "Spellbound Battle Axe",
                npcID = 0,
            },
        },
        areas = {
            {
                id = "2526:1",
                subzone = "Terrace of Lectures",
                bossIndex = 3,
            },
            {
                id = "2526:2",
                subzone = "The Botanica",
                bossIndex = 1,
            },
            {
                id = "2526:3",
                subzone = "The Pitch",
                bossIndex = 2,
            },
            {
                id = "2526:4",
                subzone = "The Headteacher's Enclave",
                bossIndex = 4,
            },
        },
    },
    {
        instanceID = 658,
        uiMapID = 184,
        name = "Pit of Saron",
        location = "Icecrown",
        season = "legacy",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Forgemaster Garfrost",
                encounterID = 1999,
                npcID = 36494,
            },
            {
                name = "Ick & Krick",
                encounterID = 2001,
                npcID = 36476,
                altNpcIDs = {
                    36477,
                },
            },
            {
                name = "Scourgelord Tyrannus",
                encounterID = 2000,
                npcID = 36658,
            },
        },
        trash = {
            {
                name = "Arcanist Cadaver",
                npcID = 252603,
            },
            {
                name = "Quarry Tormentor",
                npcID = 252561,
            },
            {
                name = "Dreadpulse Lich",
                npcID = 252563,
            },
            {
                name = "Rimebone Coldwraith",
                npcID = 252566,
            },
            {
                name = "Plungetalon Gargoyle",
                npcID = 252606,
            },
            {
                name = "Glacieth",
                npcID = 0,
            },
            {
                name = "Rotting Ghoul",
                npcID = 0,
            },
            {
                name = "Wrathbone Enforcer",
                npcID = 0,
            },
            {
                name = "Yumjar Graveblade",
                npcID = 0,
            },
        },
        areas = {
            {
                id = "658:1",
                subzone = "Scourgelord's Command",
                bossIndex = 3,
            },
        },
    },
    {
        instanceID = 1753,
        uiMapID = 903,
        name = "Seat of the Triumvirate",
        location = "Argus",
        season = "legacy",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Zuraal the Ascended",
                encounterID = 2065,
                npcID = 122313,
            },
            {
                name = "Saprish",
                encounterID = 2066,
                npcID = 122316,
            },
            {
                name = "Viceroy Nezhar",
                encounterID = 2067,
                npcID = 124309,
            },
            {
                name = "L'ura",
                encounterID = 2068,
                npcID = 214650,
            },
        },
        trash = {
            {
                name = "Ruthless Riftstalker",
                npcID = 122413,
            },
            {
                name = "Shadowguard Champion",
                npcID = 0,
            },
            {
                name = "Umbral War Adept",
                npcID = 0,
            },
            {
                name = "Merciless Subjugator",
                npcID = 124171,
            },
            {
                name = "Bound Voidcaller",
                npcID = 122412,
            },
            {
                name = "Dark Conjuror",
                npcID = 0,
            },
            {
                name = "Rift Warden",
                npcID = 0,
            },
            {
                name = "Dire Voidbender",
                npcID = 0,
            },
        },
        areas = {
            {
                id = "1753:1",
                subzone = "Triad's Conservatory",
                bossIndex = 1,
            },
            {
                id = "1753:2",
                subzone = "Shadowguard Incursion",
                bossIndex = 2,
            },
            {
                id = "1753:3",
                subzone = "The Seat of the Triumvirate",
                bossIndex = 3,
            },
        },
    },
    {
        instanceID = 2933,
        uiMapID = 2547,
        name = "Collegiate Calamity",
        location = "Eversong Woods",
        season = "midnight",
        type = "delve",
        mythicPlus = false,
        bosses = {
            {
                name = "Hydrangea",
                encounterID = 3367,
            },
            {
                name = "Infiltrator Garand",
                encounterID = 3405,
            },
            {
                name = "Voidscorned Vagrant",
                encounterID = 3404,
            },
        },
    },
    {
        instanceID = 2952,
        uiMapID = 0,
        name = "The Shadow Enclave",
        location = "Eversong Woods",
        season = "midnight",
        type = "delve",
        mythicPlus = false,
        bosses = {
            {
                name = "Lord Antenorian",
                encounterID = 3368,
            },
        },
    },
    {
        instanceID = 2953,
        uiMapID = 2545,
        name = "Parhelion Plaza",
        location = "Isle of Quel'Danas",
        season = "midnight",
        type = "delve",
        mythicPlus = false,
        bosses = {
            {
                name = "Gladius Slaurna",
                encounterID = 3307,
            },
        },
    },
    {
        instanceID = 2961,
        uiMapID = 2503,
        name = "Twilight Crypts",
        location = "Zul'Aman",
        season = "midnight",
        type = "delve",
        mythicPlus = false,
        bosses = {
            {
                name = "Blademaster Darza",
                encounterID = 3360,
            },
        },
    },
    {
        instanceID = 2962,
        uiMapID = 2535,
        name = "Atal'Aman",
        location = "Zul'Aman",
        season = "midnight",
        type = "delve",
        mythicPlus = false,
        bosses = {
            {
                name = "Spiritflayer Jin'Ma",
                encounterID = 3433,
                altEncounterIDs = {
                    3434,
                    3435,
                },
            },
        },
    },
    {
        instanceID = 3003,
        uiMapID = 2525,
        name = "The Darkway",
        location = "Zul'Aman",
        season = "midnight",
        type = "delve",
        mythicPlus = false,
        bosses = {
            {
                name = "Infiltrator Gulkat",
                encounterID = 3361,
            },
        },
    },
    {
        instanceID = 2963,
        uiMapID = 2525,
        name = "The Grudge Pit",
        location = "Harandar",
        season = "midnight",
        type = "delve",
        mythicPlus = false,
        bosses = {
            {
                name = "Brightthorn",
                encounterID = 3364,
            },
            {
                name = "Gyrospore",
                encounterID = 3363,
            },
            {
                name = "Mycomight",
                encounterID = 3362,
            },
        },
    },
    {
        instanceID = 2964,
        uiMapID = 2505,
        name = "Gulf of Memory",
        location = "Harandar",
        season = "midnight",
        type = "delve",
        mythicPlus = false,
        bosses = {
            {
                name = "Lumenia",
                encounterID = 3416,
            },
            {
                name = "Mul'tha'ul",
                encounterID = 3359,
            },
        },
    },
    {
        instanceID = 2965,
        uiMapID = 2528,
        name = "Sunkiller Sanctum",
        location = "Harandar",
        season = "midnight",
        type = "delve",
        mythicPlus = false,
        bosses = {
            {
                name = "Esuritus",
                encounterID = 3398,
            },
        },
    },
    {
        instanceID = 2979,
        uiMapID = 2506,
        name = "Shadowguard Point",
        location = "Voidstorm",
        season = "midnight",
        type = "delve",
        mythicPlus = false,
        bosses = {
            {
                name = "Chief-Arcanist Patram",
                encounterID = 3365,
            },
        },
    },
    {
        instanceID = 0,
        uiMapID = 0,
        name = "The Ring of Glory",
        location = "The Coiled Isle",
        season = "midnight",
        type = "delve",
        mythicPlus = false,
        bosses = {
            {
                name = "(TODO — new S2 delve; verify boss name from Icy Veins S2 guide)",
                encounterID = 0,
            },
        },
    },
    {
        instanceID = 0,
        uiMapID = 2635,
        name = "Gnarldor Isle",
        location = "The Coiled Isle",
        season = "midnight",
        type = "delve",
        mythicPlus = false,
        bosses = {
            {
                name = "(TODO — new S2 delve; verify boss name from Icy Veins S2 guide)",
                encounterID = 0,
            },
        },
    },
    {
        instanceID = 3079,
        uiMapID = 2634,
        name = "Venomfall Deeps",
        location = "The Coiled Isle",
        season = "midnight",
        type = "delve",
        mythicPlus = false,
        bosses = {
            {
                name = "Aztarek",
                encounterID = 3525,
            },
        },
    },
    {
        instanceID = 1209,
        uiMapID = 601,
        altMapIDs = {
            602,
        },
        name = "Skyreach",
        location = "Spires of Arak",
        season = "legacy",
        type = "max",
        mythicPlus = false,
        bosses = {
            {
                name = "Ranjit",
                encounterID = 1698,
                npcID = 75964,
            },
            {
                name = "Araknath",
                encounterID = 1699,
                npcID = 76141,
            },
            {
                name = "Rukhran",
                encounterID = 1700,
                npcID = 76379,
            },
            {
                name = "High Sage Viryx",
                encounterID = 1701,
                npcID = 76266,
            },
        },
        trash = {
            {
                name = "Adorned Bladetalon",
                npcID = 79303,
            },
            {
                name = "Solar Elemental",
                npcID = 0,
            },
            {
                name = "Driving Gale-Caller",
                npcID = 78932,
            },
            {
                name = "Adept of the Dawn",
                npcID = 0,
            },
            {
                name = "Blinding Sun Priestess",
                npcID = 79462,
            },
        },
        areas = {
            {
                id = "1209:1",
                mapID = 602,
                bossIndex = 4,
            },
            {
                id = "1209:2",
                subzone = "Lower Quarter",
                bossIndex = 1,
            },
            {
                id = "1209:3",
                subzone = "Grand Spire",
                bossIndex = 2,
            },
            {
                id = "1209:4",
                subzone = "The Overlook",
                bossIndex = 3,
            },
        },
    },
    {
        instanceID = 1762,
        challengeMapID = 249,
        uiMapID = 1004,
        name = "Kings' Rest",
        location = "Zuldazar",
        season = "legacy",
        type = "max",
        mythicPlus = true,
        bosses = {
            {
                name = "The Golden Serpent",
                encounterID = 2139,
                journalEncounterID = 2165,
                npcID = 0,
            },
            {
                name = "Mchimba the Embalmer",
                encounterID = 2142,
                journalEncounterID = 2171,
                npcID = 0,
            },
            {
                name = "The Council of Tribes",
                encounterID = 2140,
                journalEncounterID = 2170,
                npcID = 0,
            },
            {
                name = "Dazar, the First King",
                encounterID = 2143,
                journalEncounterID = 2172,
                npcID = 0,
            },
        },
        trash = {
            {
                name = "Shadow of Zul",
                npcID = 0,
            },
            {
                name = "King Rahu'ai",
                npcID = 0,
            },
            {
                name = "Guard Captain Atu",
                npcID = 0,
            },
            {
                name = "Seneschal M'bara",
                npcID = 0,
            },
            {
                name = "King Timaji",
                npcID = 0,
            },
            {
                name = "Queen Wasi",
                npcID = 0,
            },
            {
                name = "Queen Patlaa",
                npcID = 0,
            },
            {
                name = "Spectral Shaman",
                npcID = 0,
            },
            {
                name = "Phantom Hex Priest",
                npcID = 0,
            },
            {
                name = "Royal Berserker",
                npcID = 0,
            },
            {
                name = "Ghostly Brute",
                npcID = 0,
            },
        },
    },
    {
        instanceID = 1877,
        challengeMapID = 250,
        uiMapID = 1038,
        name = "Temple of Sethraliss",
        location = "Vol'dun",
        season = "legacy",
        type = "max",
        mythicPlus = true,
        bosses = {
            {
                name = "Adderis and Aspix",
                encounterID = 2124,
                journalEncounterID = 2142,
                npcID = 0,
                altNpcIDs = {
                    0,
                },
            },
            {
                name = "Merektha",
                encounterID = 2125,
                journalEncounterID = 2143,
                npcID = 0,
            },
            {
                name = "Galvazzt",
                encounterID = 2126,
                journalEncounterID = 2144,
                npcID = 0,
            },
            {
                name = "Avatar of Sethraliss",
                encounterID = 2127,
                journalEncounterID = 2145,
                npcID = 0,
            },
        },
        trash = {
            {
                name = "Storm Adept",
                npcID = 0,
            },
            {
                name = "Sandswept Hunter",
                npcID = 0,
            },
            {
                name = "Barbed Krolusk",
                npcID = 0,
            },
            {
                name = "Shrouded Fang",
                npcID = 0,
            },
            {
                name = "Sandfury Stonefist",
                npcID = 0,
            },
            {
                name = "Sand-Sworn Rider",
                npcID = 0,
            },
            {
                name = "Krolusk Matriarch",
                npcID = 0,
            },
            {
                name = "Poisonous Viper",
                npcID = 0,
            },
            {
                name = "Lightning Serpent",
                npcID = 0,
            },
            {
                name = "Brood Tender",
                npcID = 0,
            },
            {
                name = "Faithless Subjugator",
                npcID = 0,
            },
            {
                name = "Agitated Nimbus",
                npcID = 0,
            },
            {
                name = "Imbued Stormcaller",
                npcID = 0,
            },
            {
                name = "Static Anomaly",
                npcID = 0,
            },
            {
                name = "Orb Watcher",
                npcID = 0,
            },
            {
                name = "Temple Disruptor",
                npcID = 0,
            },
            {
                name = "Twisted Hexxer",
                npcID = 0,
            },
            {
                name = "Faithless Tormentor",
                npcID = 0,
            },
        },
    },
    {
        instanceID = 2521,
        challengeMapID = 399,
        uiMapID = 2094,
        name = "Ruby Life Pools",
        location = "The Waking Shores",
        season = "midnight",
        type = "max",
        mythicPlus = true,
        bosses = {
            {
                name = "Melidrussa Chillworn",
                encounterID = 2609,
                journalEncounterID = 2488,
                npcID = 0,
            },
            {
                name = "Kokia Blazehoof",
                encounterID = 2606,
                journalEncounterID = 2485,
                npcID = 0,
            },
            {
                name = "Kyrakka and Erkhart Stormvein",
                encounterID = 2623,
                journalEncounterID = 2503,
                npcID = 0,
                altNpcIDs = {
                    0,
                },
            },
        },
        trash = {
            {
                name = "Primal Juggernaut",
                npcID = 0,
            },
            {
                name = "Deepstone Earthshaper",
                npcID = 0,
            },
            {
                name = "Earthbound Guardian",
                npcID = 0,
            },
            {
                name = "Flashfrost Chillweaver",
                npcID = 0,
            },
            {
                name = "Infused Whelp",
                npcID = 0,
            },
            {
                name = "Primalist Cinderweaver",
                npcID = 0,
            },
            {
                name = "Ashseer Flamelasher",
                npcID = 0,
            },
            {
                name = "Blazebound Destroyer",
                npcID = 0,
            },
            {
                name = "Flamegullet",
                npcID = 0,
            },
            {
                name = "Thunderhead",
                npcID = 0,
            },
            {
                name = "Ruinous Stormbringer",
                npcID = 0,
            },
            {
                name = "Storm Warrior",
                npcID = 0,
            },
            {
                name = "Primal Thundercloud",
                npcID = 0,
            },
            {
                name = "Tempest Channeler",
                npcID = 0,
            },
            {
                name = "High Channeler Ryvati",
                npcID = 0,
            },
        },
    },
    {
        instanceID = 2993,
        challengeMapID = 588,
        uiMapID = 2588,
        name = "Altar of Fangs",
        location = "The Coiled Isle",
        season = "midnight",
        type = "max",
        mythicPlus = true,
        bosses = {
            {
                name = "Rav'i",
                encounterID = 3456,
                journalEncounterID = 2878,
                npcID = 0,
            },
            {
                name = "The Writhing Coil",
                encounterID = 3457,
                journalEncounterID = 2879,
                npcID = 0,
            },
            {
                name = "Zul'jan",
                encounterID = 3458,
                journalEncounterID = 2880,
                npcID = 0,
            },
        },
        trash = {
            {
                name = "Venom Leech",
                npcID = 0,
            },
            {
                name = "Twinfang Harrower",
                npcID = 0,
            },
            {
                name = "Ravenous Descendant",
                npcID = 0,
            },
            {
                name = "Primal Serpent",
                npcID = 0,
            },
            {
                name = "Ritual Chieftain",
                npcID = 0,
            },
            {
                name = "High Evolutionist",
                npcID = 0,
            },
            {
                name = "Rattling Writhe",
                npcID = 0,
            },
            {
                name = "Bloodletter",
                npcID = 0,
            },
            {
                name = "Hatchling",
                npcID = 0,
            },
            {
                name = "Ascendant Serpent",
                npcID = 0,
            },
            {
                name = "Blade of the Altar",
                npcID = 0,
            },
            {
                name = "Ula'tek's Chosen",
                npcID = 0,
            },
            {
                name = "Living Venom",
                npcID = 0,
            },
        },
    },
    {
        instanceID = 2912,
        uiMapID = 2529,
        altMapIDs = {
            2530,
        },
        name = "The Voidspire",
        location = "Quel'Thalas",
        season = "midnight",
        type = "raid",
        mythicPlus = false,
        bosses = {
            {
                name = "Imperator Averzian",
                encounterID = 3176,
                npcID = 240435,
            },
            {
                name = "Vorasius",
                encounterID = 3177,
                npcID = 240434,
            },
            {
                name = "Fallen-King Salhadaar",
                encounterID = 3179,
                npcID = 240432,
            },
            {
                name = "Vaelgor & Ezzorak",
                encounterID = 3178,
                npcID = 242056,
                altNpcIDs = {
                    244552,
                },
            },
            {
                name = "Lightblinded Vanguard",
                encounterID = 3180,
                npcID = 240431,
                altNpcIDs = {
                    240437,
                    240438,
                },
            },
            {
                name = "Crown of the Cosmos",
                encounterID = 3181,
                npcID = 240430,
                altNpcIDs = {
                    243805,
                    243810,
                    243811,
                },
            },
        },
        areas = {
            {
                id = "2912:1",
                subzone = "The Approach",
                bossIndex = 1,
            },
            {
                id = "2912:2",
                subzone = "Behemoth's Rise",
                bossIndex = 2,
            },
            {
                id = "2912:3",
                subzone = "The Riftlabs",
                bossIndex = 3,
            },
            {
                id = "2912:4",
                subzone = "Devouring Stronghold",
                bossIndex = 4,
            },
            {
                id = "2912:5",
                subzone = "Celestial Orrery",
                bossIndex = 6,
            },
        },
    },
    {
        instanceID = 2913,
        uiMapID = 2533,
        name = "March on Quel'Danas",
        location = "Isle of Quel'Danas",
        season = "midnight",
        type = "raid",
        mythicPlus = false,
        bosses = {
            {
                name = "Belo'ren, Child of Al'ar",
                encounterID = 3182,
                npcID = 240387,
            },
            {
                name = "Midnight Falls",
                encounterID = 3183,
                npcID = 240391,
            },
        },
        areas = {
            {
                id = "2913:1",
                subzone = "Court of the Phoenix",
                bossIndex = 1,
            },
            {
                id = "2913:2",
                subzone = "The Darkwell",
                bossIndex = 2,
            },
        },
    },
    {
        instanceID = 2939,
        uiMapID = 2531,
        altMapIDs = {
            2532,
        },
        name = "The Dreamrift",
        location = "The Dreamrift",
        season = "midnight",
        type = "raid",
        mythicPlus = false,
        bosses = {
            {
                name = "Chimaerus the Undreamt God",
                encounterID = 3306,
                npcID = 245569,
            },
        },
        areas = {
            {
                id = "2939:1",
                subzone = "Den of the Undreamt",
                bossIndex = 1,
            },
        },
    },
    {
        instanceID = 0,
        uiMapID = 0,
        name = "Venomous Abyss",
        location = "The Coiled Isle",
        season = "midnight",
        type = "raid",
        mythicPlus = false,
        bosses = {
            {
                name = "Nek'zali the Soulcoiler",
                encounterID = 0,
                npcID = 0,
            },
            {
                name = "Entombed Sentinels",
                encounterID = 0,
                npcID = 0,
            },
            {
                name = "The Lost Explorers",
                encounterID = 0,
                npcID = 0,
            },
            {
                name = "Vashnik the Malignant",
                encounterID = 0,
                npcID = 0,
            },
            {
                name = "Sszorak",
                encounterID = 0,
                npcID = 0,
            },
            {
                name = "The Twin Fangs",
                encounterID = 0,
                npcID = 0,
            },
            {
                name = "The Coiled Altar",
                encounterID = 0,
                npcID = 0,
            },
            {
                name = "Ula'tek",
                encounterID = 0,
                npcID = 0,
            },
        },
    },
}

KwikTip.AFFIXES = {
    [3] = {
        name = "Volcanic",
    },
    [6] = {
        name = "Raging",
    },
    [7] = {
        name = "Bolstering",
    },
    [8] = {
        name = "Sanguine",
    },
    [9] = {
        name = "Tyrannical",
    },
    [10] = {
        name = "Fortified",
    },
    [11] = {
        name = "Bursting",
    },
    [12] = {
        name = "Grievous",
    },
    [13] = {
        name = "Explosive",
    },
    [14] = {
        name = "Quaking",
    },
    [123] = {
        name = "Spiteful",
    },
    [124] = {
        name = "Storming",
    },
    [134] = {
        name = "Entangling",
    },
    [135] = {
        name = "Afflicted",
    },
    [136] = {
        name = "Incorporeal",
    },
}
