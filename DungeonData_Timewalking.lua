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
                tip         = "Break Chains of Woe immediately — Skullcracker kills everyone within 12 yards; run 15+ yards as soon as chains shatter.",
                notes = {
                    { role = "general", text = "Break Chains of Woe immediately — Skullcracker follows within seconds and kills anyone within 12 yards." },
                    { role = "general", text = "Run 15+ yards from the boss the moment chains break." },
                    { role = "tank",    text = "Defensives during Wounding Strike — healing on you is reduced 25% for 6s." },
                },
            },
            {
                encounterID = 0,
                name        = "Corla, Herald of Twilight",
                tip         = "Rotate in/out of Evolution beams at ~70 stacks to stop Zealot transformation; interrupt Dark Command — fears the tank.",
                notes = {
                    { role = "general",   text = "Rotate in/out of Evolution beams — exit at ~70 stacks, re-enter after the debuff drops, to stop Zealots transforming." },
                    { role = "general",   text = "Kill any Evolved Twilight Drakonid that slip through — their bleeds are severe." },
                    { role = "interrupt", text = "Dark Command — fears the tank; interrupt every cast." },
                },
            },
            {
                encounterID = 0,
                name        = "Karsh Steelbender",
                tip         = "Tank kites boss briefly through central lava to build 1–3 armor stacks, group burns during the window; 6+ stacks = severe group fire damage.",
                notes = {
                    { role = "general", text = "Tank drags boss through the central lava pillar briefly (1–3 stacks) — burn hard during each window, then retreat." },
                    { role = "tank",    text = "Don't over-stack — 6+ stacks deal severe AoE fire damage to the whole group." },
                    { role = "healer",  text = "CDs at 5+ stacks as fire AoE ramps with each pass." },
                },
            },
            {
                encounterID = 0,
                name        = "Beauty",
                tip         = "Kill 3 pups first — never kill Runty (the small one) or she permanently berserk-enrages. Face boss away; top everyone before AoE Fear.",
                notes = {
                    { role = "general", text = "Kill 3 of the 4 pups first — never kill Runty (the small one) or Beauty permanently berserk-enrages." },
                    { role = "tank",    text = "Face boss away from the group; don't stand near lava edges (Charge knockback)." },
                    { role = "healer",  text = "Top everyone before the group-wide AoE Fear lands." },
                },
            },
            {
                encounterID = 0,
                name        = "Ascendant Lord Obsidius",
                tip         = "Designate a kiter for the unkillable Shadow adds (stacking healing reduction); taunt the new body immediately when Obsidius transforms at ~66%/33%.",
                notes = {
                    { role = "general", text = "Designate one player to kite the unkillable Shadow adds — they apply stacking healing reduction to whoever they hit." },
                    { role = "tank",    text = "Taunt the correct body immediately when Obsidius transforms at ~66% and ~33%." },
                    { role = "healer",  text = "Dispel Twilight Corruption; watch Shadow add stacks reducing healing on the tank." },
                },
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
                tip         = "Click and throw Baine's totem back at him — stuns + deals 5% HP. Spread across platforms; Pulverize sinks the target's platform. Healer dispels Molten Blast.",
                notes = {
                    { role = "general", text = "Click the thrown totem and hurl it back — stuns Baine and deals 5% of his max HP." },
                    { role = "general", text = "Spread across separate platforms — Pulverize targets a ranged player and sinks that platform." },
                    { role = "healer",  text = "Dispel Molten Blast from the tank regularly." },
                },
            },
            {
                encounterID = 0,
                name        = "Echo of Jaina",
                tip         = "Run into Flarecore orbs to detonate them safely — undetonated ones wipe the group. Assign 3-person interrupt chain for Frostbolt Volley. Dodge Frost Blades.",
                notes = {
                    { role = "general",   text = "Run into Flarecore orbs to safely detonate them — undetonated ones explode and wipe the group." },
                    { role = "general",   text = "Dodge Frost Blades by strafing — direct hit encases you for 5s." },
                    { role = "interrupt", text = "Frostbolt Volley — assign 3 rotational interrupters before the fight." },
                },
            },
            {
                encounterID = 0,
                name        = "Echo of Sylvanas",
                tip         = "Calling of the Highborne: instantly burst one ghoul to open a gap in the chain ring, escape through it, kill the rest before they reach Sylvanas (Sacrifice = wipe).",
                notes = {
                    { role = "general", text = "Calling of the Highborne: instantly burst one ghoul to open a gap in the chain ring, then escape and kill the rest." },
                    { role = "general", text = "Ghouls reaching Sylvanas triggers Sacrifice — ~300k shadow AoE wipe." },
                    { role = "general", text = "Spread 10+ yards for Black Arrow; avoid blight zones on the ground." },
                },
            },
            {
                encounterID = 0,
                name        = "Echo of Tyrande",
                tip         = "Keep moving — dodge Moonlance splits and Eye of the Goddess orbs (50k + 5s silence). Stay 15+ yards away. Interrupt Stardust. Healer CD at 30% for Tears of Elune.",
                notes = {
                    { role = "general",   text = "Keep moving — dodge Moonlance splits and orbiting Eye of the Goddess (contact = 50k + 5s silence)." },
                    { role = "general",   text = "Stay 15+ yards from the boss — Dark Moonlight halves your cast speed." },
                    { role = "healer",    text = "Save a major CD for Tears of Elune at 30% — raining damage persists for the rest of the fight." },
                    { role = "interrupt", text = "Stardust — top priority; channeled AoE hitting all players." },
                },
            },
            {
                encounterID = 0,
                name        = "Murozond",
                tip         = "Hourglass of Time (5 charges) fully restores HP/mana, resets all CDs, and clears bomb zones — use before wiping, or deliberately to re-use major DPS cooldowns.",
                notes = {
                    { role = "general", text = "Hourglass of Time (5 charges) fully restores HP/mana, resets all CDs, and clears bomb zones — use before wiping." },
                    { role = "general", text = "Spread to slow Distortion Bomb zone accumulation — the arena becomes unlivable quickly." },
                    { role = "tank",    text = "Face boss away — Infinite Breath is a lethal frontal cone." },
                    { role = "dps",     text = "Trigger Hourglass deliberately to reset major CDs — treat it as a DPS cooldown, not just a recovery tool." },
                },
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
                tip         = "Move away from Mystic Trap placements before they detonate (7-yard radius). Move perpendicular to Shockwave lines. Tank kites on Heroic to spread traps.",
                notes = {
                    { role = "general", text = "Move away from Mystic Trap placements before they detonate — 7-yard radius knockback after 2s." },
                    { role = "general", text = "Move perpendicular to dodge Shockwave ground lines." },
                    { role = "tank",    text = "Kite the boss around the arena on Heroic to spread trap placements and avoid saturation." },
                },
            },
            {
                encounterID = 0,
                name        = "Lockmaw & Augh",
                tip         = "Spread to avoid stacking poison puddles. Burst crocolisk adds immediately on Scent of Blood — they fixate hard. Dispel/Soothe Venomous Rage at 30%.",
                notes = {
                    { role = "general", text = "Spread out — Viscous Poison creates lingering ground puddles; cleanse the DoT." },
                    { role = "dps",     text = "Burst crocolisk adds immediately on Scent of Blood — they fixate hard on one player." },
                    { role = "healer",  text = "Dispel Paralytic Blow Dart (Heroic); Soothe/Tranquilize Venomous Rage at 30% if available." },
                },
            },
            {
                encounterID = 0,
                name        = "High Prophet Barim",
                tip         = "At 50%, immediately kill every Soul Fragment before it reaches the Harbinger — each one heals it massively. Tank kites Harbinger in large circles. Dispel Plague of Ages.",
                notes = {
                    { role = "general", text = "At 50%, kill every Soul Fragment before it reaches the Harbinger — each one heals it massively and amps its damage." },
                    { role = "tank",    text = "Taunt the Harbinger instantly and kite it in large circles, away from Soul Fragment paths." },
                    { role = "healer",  text = "Dispel Plague of Ages (bouncing Nature DoT); stay outside the 13-yard Hallowed Ground zone in Phase 2." },
                },
            },
            {
                encounterID = 0,
                name        = "Siamat",
                tip         = "Kill 3 Servants to land Siamat; kite Minions away separately (dangerous at 5%). Phase 2: burn Siamat hard — ignore new adds. Healer CD for Wailing Winds on landing.",
                notes = {
                    { role = "general", text = "Kill 3 Servants to land Siamat — kite Minions away separately (Chain Lightning + storms at 5% HP)." },
                    { role = "general", text = "Phase 2: burn Siamat hard — ignore all new adds." },
                    { role = "healer",  text = "CD for Wailing Winds on landing — heavy AoE with knockbacks for 6s." },
                },
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
                tip         = "During burrow, watch dust clouds and dodge thrashing charges — lethal on Heroic. Kill Rock Borers. Heroic: destroy crystal shards immediately (25% damage-taken debuff on contact).",
                notes = {
                    { role = "general", text = "During burrow, watch dust clouds and dodge thrashing charges — direct hit is lethal on Heroic." },
                    { role = "general", text = "Kill Rock Borer adds during the burrow phase." },
                    { role = "dps",     text = "Heroic: destroy crystal shards immediately — contact stacks a 25% damage-taken debuff." },
                },
            },
            {
                encounterID = 0,
                name        = "Slabhide",
                tip         = "Move away from Lava Fissure marks (erupts after 5s). During air phase dodge stalactites; Heroic: hide behind them for Crystal Storm LoS on landing. Face boss away.",
                notes = {
                    { role = "general", text = "Move away from Lava Fissure ground marks — erupts after 5s and leaves a persistent pool." },
                    { role = "general", text = "During air phase dodge falling stalactites; Heroic: hide behind them to LoS Crystal Storm on landing." },
                    { role = "tank",    text = "Face boss away at all times — Sand Blast is a wide 60-degree frontal cone." },
                },
            },
            {
                encounterID = 0,
                name        = "Ozruk",
                tip         = "Attack normally during Spike Shield — reflected damage onto yourself breaks Paralyze before Shatter. Step back when shield ends. Heroic tank: run through the boss on Ground Slam.",
                notes = {
                    { role = "general", text = "Attack during Spike Shield — reflected self-damage is what breaks Paralyze before Shatter fires." },
                    { role = "general", text = "Step back when Spike Shield ends — Shatter erupts spikes in all directions." },
                    { role = "tank",    text = "Heroic: run through the boss during Ground Slam to dodge the one-shot cone." },
                },
            },
            {
                encounterID = 0,
                name        = "High Priestess Azil",
                tip         = "Position Gravity Wells between the boss and incoming adds to funnel and kill them. Altar phase: move immediately on Seismic Shard dust clouds — lethal on Heroic. Decurse Curse of Blood.",
                notes = {
                    { role = "general",   text = "Position Gravity Wells between the boss and incoming add spawns to funnel and kill Devout Followers." },
                    { role = "general",   text = "Altar phase: move immediately on Seismic Shard dust clouds — direct hit is lethal on Heroic." },
                    { role = "healer",    text = "Decurse Curse of Blood; save CDs for after Seismic Shards land." },
                    { role = "interrupt", text = "Force Grip — grips and throws a random player; interrupt to prevent." },
                },
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
                tip         = "Stay inside the cyclone ring at all times — outside deals continuous Nature damage. Stack under the boss when cyclones retract; spread as they expand. Heroic: face Lurking Tempests.",
                notes = {
                    { role = "general", text = "Stay inside the cyclone ring at all times — standing outside deals continuous Nature damage." },
                    { role = "general", text = "Stack under the boss when cyclones retract inward; spread as they expand again." },
                    { role = "general", text = "Heroic: face Lurking Tempests when they spawn during retraction — turning away triggers attacks." },
                },
            },
            {
                encounterID = 0,
                name        = "Altairus",
                tip         = "Reposition when wind changes — upwind grants +100% attack/cast speed, downwind halves it. Chilling Breath target: move away from group. Tank stand downwind; let DPS take upwind buff.",
                notes = {
                    { role = "general", text = "Reposition when wind changes — upwind grants +100% attack/cast speed, downwind halves it." },
                    { role = "general", text = "Chilling Breath target: move away from the group before the breath cone lands." },
                    { role = "tank",    text = "Stand downwind deliberately — lets melee DPS take the upwind speed buff." },
                },
            },
            {
                encounterID = 0,
                name        = "Asaad",
                tip         = "Move inside the triangular Grounding Field before Supremacy of the Storm fires — anyone outside takes lethal damage. Spread during normal phases. Heroic: jump before Static Cling completes.",
                notes = {
                    { role = "general", text = "Move inside the triangular Grounding Field before Supremacy of the Storm fires — anyone outside takes lethal damage." },
                    { role = "general", text = "Spread during non-Supremacy phases to reduce Chain Lightning bounce damage." },
                    { role = "general", text = "Heroic: jump just before Static Cling completes to avoid an 18s root." },
                },
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
                tip         = "Interrupt Shock Blast every cast — uninterrupted it one-shots the tank. Move out of Geyser ground markers immediately (5s fuse). Add phases at 60%/30%: CC two, kill one, interrupt Chain Lightning.",
                notes = {
                    { role = "general",   text = "Move out of Geyser ground markers immediately — 5s fuse, then ~155k Frost damage and a knockup." },
                    { role = "dps",       text = "Add phases at 60%/30%: CC two adds, kill one; interrupt Chain Lightning from the casters." },
                    { role = "interrupt", text = "Shock Blast — top priority every cast; uninterrupted it one-shots the tank and spawns Shock Orbs." },
                },
            },
            {
                encounterID = 0,
                name        = "Commander Ulthok",
                tip         = "Move out of Dark Fissure zones — direct hit can one-shot, pools spawn chasing oozes. Tank kites in circles to spread fissures; CD immediately on Crushing Claw (+100% physical damage taken).",
                notes = {
                    { role = "general", text = "Move out of Dark Fissure zones — direct hit can one-shot; pools spawn chasing oozes." },
                    { role = "tank",    text = "Kite boss in circles to spread fissures; CD immediately on Crushing Claw (+100% physical damage taken)." },
                    { role = "healer",  text = "Spike heal tank after Crushing Claw; reposition everyone after Shockwave knockback." },
                },
            },
            {
                encounterID = 0,
                name        = "Mindbender Ghur'sha",
                tip         = "P1: destroy Stormflurry Totem immediately. P2: DPS the mind-controlled player to 50% HP to break it — full duration kills them on Heroic. Use pillars to LoS Terrifying Vision.",
                notes = {
                    { role = "general",   text = "P1: destroy Stormflurry Totem immediately — it doubles Erunak's attack speed." },
                    { role = "general",   text = "P2: DPS the mind-controlled player to 50% HP to break it — full duration kills them on Heroic." },
                    { role = "general",   text = "P2: use pillars to LoS Terrifying Vision and avoid the group-wide fear." },
                    { role = "interrupt", text = "Flame Shock in Phase 1." },
                },
            },
            {
                encounterID = 0,
                name        = "Ozumat",
                tip         = "P1: kill small adds near Neptulon first; tank holds Behemoth. P2: Sappers are top priority — if they reach Neptulon the encounter resets. P3: all CDs on Ozumat immediately — hard DPS timer.",
                notes = {
                    { role = "general", text = "P1: kill small adds near Neptulon first; tank holds the Behemoth." },
                    { role = "dps",     text = "P2: Sappers are top priority — if they reach Neptulon the encounter resets." },
                    { role = "dps",     text = "P3: all CDs on Ozumat immediately — Blight of Ozumat is a hard DPS timer." },
                    { role = "healer",  text = "P3: dump full throughput — the stacking dot will outpace healing; Ozumat must die fast." },
                },
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
