-- KwikTip: Dungeon and boss data for World of Warcraft: Midnight
--
-- Two ID systems are used for dungeon detection:
--
--   instanceID : GetInstanceInfo() 8th return — single stable ID per dungeon instance.
--                Used as the PRIMARY lookup. Source: BigWigs/LittleWigs NewBoss declarations.
--                All values are unverified unless noted. IDs marked 0 need to be sourced.
--
--   uiMapID    : C_Map.GetBestMapForUnit("player") — required for position queries.
--                Used as FALLBACK when instanceID lookup fails (e.g., instanceID = 0).
--                Verify in-game: /run print(C_Map.GetBestMapForUnit("player"))
--                IDs marked 0 need to be confirmed in-game.
--
local ADDON_NAME, KwikTip = ...

-- ============================================================
-- Dungeon Data
-- ============================================================
-- Fields per dungeon:
--   instanceID  : GetInstanceInfo() 8th return — primary dungeon identifier
--   uiMapID     : C_Map.GetBestMapForUnit("player") inside the instance
--   altMapIDs   : additional uiMapIDs for entrance/antechamber sub-zones (fallback lookup)
--   name        : display name
--   location    : zone the entrance is in
--   season      : "midnight" = new dungeon  |  "legacy" = returning M+ dungeon
--   type        : "level" = leveling (81-88)  |  "max" = max-level (88-90)
--   mythicPlus  : true if in the Season 1 Mythic+ key rotation, false = Mythic 0 only
--   bosses      : ordered list; each entry has:
--     encounterID    : ENCOUNTER_START event ID (from LittleWigs SetEncounterID). 0 = unknown.
--     altEncounterIDs: (optional) additional encounterIDs that map to the same boss tip (e.g. per-variant
--                      delve bosses that share mechanics but fire different encounterIDs per event type).
--     npcID          : (optional) Wowhead NPC ID — reference data only. In Midnight 12.x hostile NPC GUIDs
--                   are tainted; live detection via targeting is not possible. Retained for cross-referencing.
--     name        : boss name as shown in the game
--     tip         : short contextual tip shown in the HUD during the boss fight (flat string; legacy/fallback)
--     notes       : (optional) structured role-aware notes; if present, replaces `tip` in the HUD.
--   trash       : optional list of notable trash mobs; NPC IDs retained for reference and TRASH_BY_NPCID lookup
--                 NOTE: in Midnight 12.x hostile NPC GUIDs are tainted — tip display via targeting is not possible
--     npcID     : numeric NPC ID from Wowhead
--     name      : mob display name
--     tip       : contextual tip shown in HUD when this mob is targeted (flat string; legacy/fallback)
--     notes     : (optional) structured role-aware notes; same format as boss notes above
--   areas       : optional list; if present, HUD switches to area-based tips
--                 matched against GetSubZoneText() as the player moves through the dungeon
--     subzone   : exact string returned by GetSubZoneText() for this area (verify in-game)
--     mapID     : (optional) uiMapID match via C_Map.GetBestMapForUnit — fallback for areas
--                 with no subzone text (e.g. arena-style dungeons). Fires on ZONE_CHANGED_NEW_AREA.
--     tip       : contextual tip shown in HUD when the player is in this sub-zone
--     bossIndex : (optional) 1-based index into dungeon.bosses; if set, the boss tip is
--                 shown instead of `tip` — use for boss room sub-zones so the tip appears
--                 on entry rather than waiting for ENCOUNTER_START
--
-- Season 1 M+ rotation (8 dungeons total):
--   New Midnight: Magisters' Terrace, Maisara Caverns, Nexus-Point Xenas, Windrunner Spire
--   Legacy:       Algeth'ar Academy, Pit of Saron, Seat of the Triumvirate, Skyreach

KwikTip.DUNGEONS = {

    -- --------------------------------------------------------
    -- NEW MIDNIGHT DUNGEONS — Level-Up (81–88)
    -- --------------------------------------------------------
    {
        instanceID = 2805,  -- confirmed in-game
        uiMapID    = 2492,  -- confirmed in-game
        altMapIDs  = { 2537, 2493, 2494, 2496, 2497, 2498, 2499 },  -- all confirmed in-game
        name       = "Windrunner Spire",
        location   = "Eversong Woods",
        season     = "midnight",
        type       = "level",
        mythicPlus = true,
        bosses = {
            {
                encounterID = 3056,  -- confirmed in-game
                npcID       = 231606,
                name        = "Emberdawn",
                tip         = "Drop Flaming Updraft puddles at the room's outer edges; play close to the boss during Burning Gale (16s) to minimize movement when dodging Twisters and Fire Breath frontals; healer major CDs on Burning Gale. Tank: defensive for Searing Beak — initial hit + DoT.",
                notes = {
                    { role = "general",   text = "Drop Flaming Updraft puddles at the room's outer edges." },
                    { role = "general",   text = "During Burning Gale (16s) stay close to the boss — dodge Twisters and Fire Breath frontals." },
                    { role = "tank",      text = "Defensive for Searing Beak — initial hit + DoT component." },
                    { role = "healer",    text = "Major CDs on Burning Gale." },
                },
            },
            {
                encounterID = 3057,  -- confirmed in-game
                npcID       = 231626,  -- Kalis
                altNpcIDs   = { 231629 },  -- Latch
                name        = "Derelict Duo",
                tip         = "Keep both at equal health — Broken Bond enrages the survivor; interrupt Shadow Bolt; dispel Curse of Darkness to despawn Dark Entity adds; tank defensive for Bone Hack; drop Splattering Spew puddles along walls and overlap them to conserve space; stand behind Kalis so Latch's Heaving Yank pulls her and interrupts Debilitating Shriek.",
                notes = {
                    { role = "general",   text = "Keep both at equal health — Broken Bond enrages the survivor." },
                    { role = "general",   text = "Drop Splattering Spew puddles along walls and overlap them to conserve space." },
                    { role = "general",   text = "Stand behind Kalis so Latch's Heaving Yank interrupts Debilitating Shriek." },
                    { role = "tank",      text = "Defensive for Bone Hack." },
                    { role = "healer",    text = "Dispel Curse of Darkness — despawns Dark Entity adds." },
                    { role = "interrupt", text = "Shadow Bolt." },
                },
            },
            {
                encounterID = 3058,  -- confirmed in-game
                npcID       = 231631,
                name        = "Commander Kroluk",
                tip         = "Stack near melee. Rallying Bellow (66%/33%) gives the boss damage reduction while adds are alive — kill them fast (interrupt Phantasmal Mystic or it enrages). Bladestorm fixates a player — kite the boss. Stay near an ally or Intimidating Shout fears you. Reckless Leap hits the furthest player twice — first hit: ranged DPS use a defensive; second hit: tank runs furthest out to bait it. Tank: defensive for Rampage channel.",
                notes = {
                    { role = "general",   text = "Stack near melee. Stay near an ally or Intimidating Shout fears you." },
                    { role = "general",   text = "Bladestorm fixates a player — kite the boss while killing adds." },
                    { role = "general",   text = "Reckless Leap hits furthest player twice — ranged DPS use defensive on first hit; tank baits second." },
                    { role = "dps",       text = "Kill adds fast — Rallying Bellow (66%/33%) gives boss damage reduction while adds are alive." },
                    { role = "tank",      text = "Defensive for Rampage — sustained channel on the tank." },
                    { role = "interrupt", text = "Phantasmal Mystic adds — interrupt or they enrage." },
                },
            },
            {
                encounterID = 3059,  -- confirmed in-game
                npcID       = 231636,
                name        = "The Restless Heart",
                tip         = "Step on Turbulent Arrows to clear Squall Leap stacks — stacks hit hard, clear them quickly. At 100 energy (Bullseye Windblast), step on arrows to vault over the expanding shockwave. Overlap Gust Shot ground pools to clear space. Tempest Slash knocks you back — try to land near arrows. Bolt Gale: frontal channel on a random player — stand still if targeted, use a defensive or combat drop to stop it.",
                notes = {
                    { role = "general",   text = "Step on Turbulent Arrows to clear Squall Leap stacks; at 100 energy (Bullseye Windblast) step on arrows to vault over the expanding shockwave." },
                    { role = "general",   text = "Overlap Gust Shot ground pools to clear space." },
                    { role = "general",   text = "Bolt Gale: frontal channel on a random player — stand still if targeted; use a defensive or combat drop to stop the channel." },
                    { role = "tank",      text = "Defensive for Tempest Slash — knockback; try to land near arrows to clear your debuff." },
                    { role = "healer",    text = "Squall Leap stacks hit hard — top up anyone building stacks between arrow clears; CDs if multiple players stack up." },
                },
            },
        },
        trash = {
            { npcID = 232070, name = "Restless Steward",      tip = "Interrupt Spirit Bolt; Magic dispel Soul Torment on debuffed players ASAP, then use defensives or focus healing for the remaining player." },
            { npcID = 232113, name = "Spellguard Magus",      tip = "Defensives for Arcane Salvo; at 50% it drops a Spellguard's Protection zone (99% DR) — tank move the mob and any other mobs out of it immediately." },
            { npcID = 232067, name = "Creeping Spindleweb",   tip = "Poison Spray — use a personal defensive." },
            { npcID = 232097, name = "Territorial Dragonhawk", tip = "Fire Spit channels into a random player and deals heavy damage — stop it with an interrupt or CC. Can target the same player twice in a row. Purge Bolstering Flames buff when it applies." },
            { npcID = 232094, name = "Bloated Lasher",         tip = "Interrupt Fungal Bolt — top priority. Spore Dispersal on death buffs nearby mobs' melee damage — position kills away from other packs." },
            { npcID = 231616, name = "Ardent Cutthroat",       tip = "Interrupt every Poison Blades cast — each uninterrupted stack bleeds the tank." },
            { npcID = 231615, name = "Devoted Woebringer",     tip = "CC-immune. Interrupt Shadow Bolt; break the Pulsing Shriek shield to interrupt the channel." },
            { npcID = 232071, name = "Dutiful Groundskeeper",  tip = "Shear Armor stacks on every tank hit — use defensives or kite when stacks get high." },
            { npcID = 232121, name = "Phalanx Breaker",        tip = "Break Ranks charges a random player — bait toward a nearby wall to maximize cleave. Interrupting Screech silences all players mid-cast — watch for it and stop casting." },
            { npcID = 0,      name = "Apex Lynx",              tip = "CC immune. Puncturing Bite applies a bleed on the tank — defensive or bleed cleanse. Ferocious Pounce spreads to 3 players — position loosely to avoid overlap." },
            { npcID = 0,      name = "Loyal Worg",             tip = "Shred Flesh applies a healing absorb — use a defensive or cleanse to remove it." },
            { npcID = 0,      name = "Flesh Behemoth",         tip = "CC immune. Fetid Spew targets multiple players — spread loosely and position puddles away from the pack." },
            { npcID = 232447, name = "Spectral Axethrower",    tip = "Throw Axe bleeds a random player — use a defensive or bleed cleanse; chain CC to delay subsequent casts." },
        },
        areas = {
            { subzone = "The Promenade",       tip = "Interrupt Spirit Bolt from Restless Stewards — dispel Soul Torment on debuffed players immediately. Use a personal defensive for Creeping Spindleweb's Poison Spray." },
            { mapID = 2493, bossIndex = 1 },  -- Emberdawn's wing; confirmed in-game
            { mapID = 2494, bossIndex = 2 },  -- Derelict Duo's wing; confirmed in-game
            { subzone = "Sylvanas's Quarters", tip = "Spellguard Magus drops a 99% damage-reduction zone at 50% — move the pack out immediately. Use defensives for Arcane Salvo." },
            { subzone = "Windrunner Vault",    bossIndex = 3 },  -- Commander Kroluk's arena; confirmed in-game
            { subzone = "The Pinnacle",        bossIndex = 4 },  -- The Restless Heart; confirmed in-game
        },
    },
    {
        instanceID = 2813,  -- confirmed in-game
        uiMapID    = 2433,  -- confirmed in-game
        altMapIDs  = { 2435, 2434, 2393 },  -- confirmed in-game; 2393 = Silvermoon City entrance plaza (pre-zone-in)
        name       = "Murder Row",
        location   = "Silvermoon City",
        season     = "midnight",
        type       = "level",
        mythicPlus = false,
        bosses = {
            {
                encounterID = 3101,  -- confirmed in-game
                npcID       = 252458,
                name        = "Kystia Manaheart",
                tip         = "Dispel Illicit Infusion from Nibbles for 15s stun + 100% dmg window — Kystia radiates Chaos AoE during this phase so healer CDs needed; dodge Nibbles' Fel Spray cone while she's hostile; purge Felshield (80% DR) when Kystia casts it; interrupt Mirror Images.",
                notes = {
                    { role = "healer",    text = "Dispel Illicit Infusion from Nibbles — triggers 15s stun and 100% dmg window; major CDs during this phase (Chaos AoE)." },
                    { role = "general",   text = "Dodge Nibbles' Fel Spray cone while she's hostile; purge Felshield when Kystia casts it (80% DR)." },
                    { role = "interrupt", text = "Mirror Images." },
                },
            },
            {
                encounterID = 3102,  -- confirmed in-game
                npcID       = 234649,
                name        = "Zaen Bladesorrow",
                tip         = "Stand behind Forbidden Freight during Murder in a Row; move Fire Bomb away from freight (it destroys cover); Heartstop Poison halves tank max health — prioritize tank healing.",
                notes = {
                    { role = "general",   text = "Stand behind Forbidden Freight during Murder in a Row; move Fire Bomb away from freight — it destroys cover." },
                    { role = "tank",      text = "Heartstop Poison halves your max health — call for an external." },
                    { role = "healer",    text = "Prioritize tank healing after Heartstop Poison." },
                },
            },
            {
                encounterID = 3103,  -- confirmed in-game
                npcID       = 234647,
                name        = "Xathuux the Annihilator",
                tip         = "At 100 energy, Demonic Rage pulses heavy group AoE and buffs boss attack speed — use defensives and healer CDs. Dodge Axe Toss impact zones (Fel Light persists on ground); avoid Burning Steps hazards. Tank: Legion Strike applies 80% healing reduction — call for an external.",
                notes = {
                    { role = "general",   text = "Dodge Axe Toss impact zones (Fel Light persists); avoid Burning Steps." },
                    { role = "tank",      text = "Legion Strike applies 80% healing reduction — call for an external immediately." },
                    { role = "healer",    text = "Major CDs during Demonic Rage (100 energy) — heavy group AoE + boss attack speed buff." },
                },
            },
            {
                encounterID = 3105,  -- confirmed in-game
                npcID       = 237415,
                name        = "Lithiel Cinderfury",
                tip         = "Kill Wild Imps before Malefic Wave reaches them (they gain haste if hit); use Gateways to avoid the wave; interrupt Chaos Bolt.",
                notes = {
                    { role = "general",   text = "Use Gateways to avoid Malefic Wave." },
                    { role = "dps",       text = "Kill Wild Imps before the wave reaches them — they gain haste if hit." },
                    { role = "interrupt", text = "Chaos Bolt." },
                },
            },
        },
        trash = {
            { npcID = 0, name = "Corrupted Ghoul",      tip = "Interrupt Vile Bite — applies a stacking disease that reduces max HP. Dispel between pulls." },
            { npcID = 0, name = "Hateful Shaper",        tip = "Interrupt Shadow Mend — heals nearby trash for a substantial amount. Spare interrupts on Mind Flay." },
            { npcID = 0, name = "Ghostly Retainer",     tip = "Mind Rend is a long channel on a random player — interrupt it. Use a defensive while it channels." },
            { npcID = 0, name = "Vilethorn Sapling",    tip = "Mass Entanglement roots the whole group — use AoE stops or knockbacks to interrupt the cast. Tenderize marks a player — use a defensive." },
            { npcID = 0, name = "Fel Bat",             tip = "Sonic Screech is a heavy group-wide hit — interrupt it. Interrupt or CC to prevent subsequent casts." },
            { npcID = 0, name = "Shadowmire Attendant", tip = "Shadow Bolt volley is the main threat — use spare interrupts. Avoid Darkspear ground patches." },
            { npcID = 0, name = "Wrathguard Invader",  tip = "Chaos Strike passive cleaves — tank keeps the Wrathguard facing away from the group. Interrupt Fel Bolt." },
            { npcID = 0, name = "Doomguard Sentry",    tip = "Cleave and War Stomp — tank faces away; dodge the War Stomp ground indicator. Interrupt Shadowbolt Volley." },
        },
        areas = {
            { subzone = "Silvermoon Pet Shop", bossIndex = 1 },  -- Kystia Manaheart; confirmed in-game
            { subzone = "The Illicit Rain",    bossIndex = 2 },  -- Zaen Bladesorrow; confirmed in-game
            { subzone = "Augurs' Terrace",     bossIndex = 3 },  -- Xathuux the Annihilator; confirmed in-game
            { subzone = "Lithiel's Landing",   bossIndex = 4 },  -- Lithiel Cinderfury; confirmed in-game
        },
    },
    {
        instanceID = 2825,  -- confirmed in-game
        uiMapID    = 2514,
        altMapIDs  = { 2564, 2513 },  -- 2564 = Dreamer's Passage/Heart of Rage; 2513 = Heart of Rage (confirmed in-game)
        name       = "Den of Nalorakk",
        location   = "Zul'Aman",
        season     = "midnight",
        type       = "level",
        mythicPlus = false,
        bosses = {
            {
                encounterID = 3207,  -- confirmed in-game
                npcID       = 248710,
                name        = "The Hoardmonger",
                tip         = "At 90%/60%/30%, boss retreats to empower; destroy Rotten Mushrooms before burst; healer dispel Toxic Spores; dodge frontals.",
                notes = {
                    { role = "general",   text = "At 90%/60%/30% boss retreats to empower — dodge frontals." },
                    { role = "dps",       text = "Destroy Rotten Mushrooms before each burst phase." },
                    { role = "healer",    text = "Dispel Toxic Spores debuff." },
                },
            },
            {
                encounterID = 3208,  -- confirmed in-game
                npcID       = 261053,
                name        = "Sentinel of Winter",
                tip         = "Dodge Raging Squalls and Snowdrift pools; at 100 energy boss channels Eternal Winter (shields self + heavy group damage) — use damage CDs to break the shield fast, healer CDs to survive.",
                notes = {
                    { role = "general",   text = "Dodge Raging Squalls and Snowdrift pools." },
                    { role = "dps",       text = "At 100 energy, burn the Eternal Winter shield fast with damage CDs." },
                    { role = "healer",    text = "CDs during Eternal Winter — heavy group damage while the shield is active." },
                },
            },
            {
                encounterID = 3209,  -- confirmed in-game
                npcID       = 258877,
                name        = "Nalorakk",
                tip         = "Fury of the War God: intercept charging echoes to protect Zul'jarra — echoes that reach her deal massive group damage; spread when Echoing Maul marks you.",
                notes = {
                    { role = "general",   text = "Intercept charging echoes (Fury of the War God) — echoes reaching Zul'jarra deal massive group damage." },
                    { role = "general",   text = "Spread when Echoing Maul marks you." },
                },
            },
        },
        trash = {
            { npcID = 0, name = "Temporal Titan",         tip = "Infinite Arc is a long frontal beam — sidestep it. Interrupt Temporal Shock to stop the AoE stun." },
            { npcID = 0, name = "Timestream Anomaly",     tip = "Temporal Spit hits the tank hard — use a defensive. Dispel Infusion — it's a heal absorb on a random player." },
            { npcID = 0, name = "Sand Lasher",            tip = "Sandstorm pulses heavy group damage — healer CDs. Burrow drops threat — the Lasher re-emerges on a random player; tank taunt back." },
            { npcID = 0, name = "Var'auk",                tip = "Singed Wounds stacks on the tank — kite or use defensives when stacks get high. Interrupt Cauterize every cast — it heals nearby trash for 40% health over 6s. Top priority interrupt." },
            { npcID = 0, name = "Echo of Winter",         tip = "Chilling Aura slows nearby players. Dodge Rime Bolt ground circles." },
            { npcID = 0, name = "Frozen Berserker",       tip = "Shattering Slash is a frontal cone — tank faces away from group. Kite if Unstable Frost stacks get high." },
            { npcID = 0, name = "Frostweaver",            tip = "Interrupt Icy Binding every cast — roots a player. Dodge Arctic Gale zone." },
            { npcID = 0, name = "Spirit-Touched Jaguar",  tip = "Prowl — stealth detection or AoE to reveal. Spirit Bite applies a bleed that stacks — dispel." },
        },
        areas = {
            { subzone = "Enduring Winter",    bossIndex = 1 },  -- first two bosses share this subzone (Hoardmonger + Sentinel of Winter); confirmed in-game (mapID 2514); bossIndex=1 shows Hoardmonger tip on entry — ENCOUNTER_START overrides for Sentinel of Winter
            { subzone = "The Foraging",       tip = "Beasts patrol this area — pull carefully." },  -- confirmed in-game (mapID 2514); between first two bosses and Dreamer's Passage
            { subzone = "Dreamer's Passage",  bossIndex = 3 },  -- transition to Nalorakk; confirmed in-game (mapID 2564)
            { subzone = "The Heart of Rage",  bossIndex = 3 },  -- Nalorakk's arena; confirmed in-game (mapIDs 2564, 2513)
        },
    },
    {
        instanceID = 2874,  -- confirmed in-game
        uiMapID    = 2501,  -- confirmed in-game
        name       = "Maisara Caverns",
        location   = "Zul'Aman",
        season     = "midnight",
        type       = "level",
        mythicPlus = true,
        bosses = {
            {
                encounterID = 3212,
                npcID       = 247570,  -- Muro'jin
                altNpcIDs   = { 247572 },  -- Nekraxx
                name        = "Muro'jin and Nekraxx",
                tip         = "Keep equal health — if Nekraxx dies first Muro'jin revives him at 35%; if Muro'jin dies first Nekraxx gains 20% dmg every 4s (stacking). Carrion Swoop target: step into a Freezing Trap to block the charge and stun Nekraxx 5s. Barrage: targeted player stand still. Sidestep Fetid Quillstorm circles. Dispel Infected Pinions disease. Tank: defensive or bleed cleanse for Flanking Spear — knockback can push into a Freezing Trap; watch positioning.",
                notes = {
                    { role = "general",   text = "Keep equal health — if Nekraxx dies first Muro'jin revives him at 35%; if Muro'jin dies first Nekraxx gains +20% damage every 4s (continuously stacking)." },
                    { role = "general",   text = "Carrion Swoop target: step into a Freezing Trap to block the charge and stun Nekraxx 5s." },
                    { role = "general",   text = "Barrage targets a player — that player stands still; everyone else moves out of the cone." },
                    { role = "general",   text = "Sidestep Fetid Quillstorm circles." },
                    { role = "tank",      text = "Defensive or bleed cleanse for Flanking Spear — the knockback can push you into a Freezing Trap; watch your positioning." },
                    { role = "healer",    text = "Dispel Infected Pinions disease." },
                },
            },
            {
                encounterID = 3213,
                npcID       = 248595,
                name        = "Vordaza",
                tip         = "Interrupt Necrotic Convergence — if missed, burst the Deathshroud shield with damage CDs. Unstable Phantoms: detonate the first pair ASAP (fixated players run at each other); for the second pair, use hard CC (paralyze, entangling roots, hunter trap) if they'd overlap with Necrotic Convergence — or just detonate fast. Killing phantoms directly applies Lingering Dread; wait for the collision DoT to expire before detonating the second set. Dodge Unmake line. Tank: defensive for Drain Soul channel.",
                notes = {
                    { role = "general",   text = "Detonate the first pair of Unstable Phantoms ASAP — fixated players run toward each other to collide them." },
                    { role = "general",   text = "Second pair: use hard CC (paralyze, roots, hunter trap) to delay them if they'd overlap with Necrotic Convergence; if your CC is poor, just detonate fast instead." },
                    { role = "general",   text = "Killing phantoms directly applies Lingering Dread; wait for the collision DoT to expire before detonating the second set." },
                    { role = "general",   text = "Dodge Unmake line." },
                    { role = "dps",       text = "Burst the Deathshroud shield during Necrotic Convergence with damage CDs." },
                    { role = "tank",      text = "Defensive for Drain Soul channel." },
                    { role = "interrupt", text = "Necrotic Convergence — interrupting prevents the Deathshroud shield entirely." },
                },
            },
            {
                encounterID = 3214,
                npcID       = 248605,
                name        = "Rak'tul, Vessel of Souls",
                tip         = "Soulrending Roar sends the group down to the spirit realm bridge gauntlet — clear it rapidly. Interrupt all 6 Malignant Souls in the spirit realm — each interrupt grants a stacking Spectral Residue buff (+25% dmg/heal/speed) back in the boss phase. Avoid Restless Masses roots; cleave Crush Souls totems before returning. Boss phase: Spiritbreaker — position against braziers to negate knockback.",
                notes = {
                    { role = "interrupt", text = "All 6 Malignant Souls in the spirit realm — interrupt the first 5, then have the tank interrupt the 6th last to extend the buff into the boss phase. Each grants stacking Spectral Residue (+25% dmg/heal/speed)." },
                    { role = "general",   text = "Soulrending Roar triggers the bridge gauntlet (spirit realm) — push through it rapidly to return for the buff window." },
                    { role = "general",   text = "Avoid Restless Masses roots; cleave Crush Souls totems before returning to boss phase." },
                    { role = "tank",      text = "Spiritbreaker combo: channel + puddle + knockback — position against braziers to negate the knockback." },
                },
            },
        },
        trash = {
            { npcID = 242964, name = "Keen Headhunter",   tip = "Interrupt Hooked Snare. If it lands, use a freedom effect to clear the root and bleed. Minimum melee range — if the whole group stacks in melee, they will not use Throw Spear at all (eliminates most of their ranged damage)." },
            { npcID = 248686, name = "Dread Souleater",   tip = "Avoid Rain of Toads pools. Defensives for Necrotic Wave — it leaves a healing absorb on hit players." },
            { npcID = 248685, name = "Ritual Hexxer",     tip = "Interrupt Hex first. Use spare kicks on Shadow Bolt." },
            { npcID = 248678, name = "Hulking Juggernaut", tip = "Defensive before Deafening Roar lands — it spell-locks anyone mid-cast. Tank watch Rending Gore stacks — it's a physical dot, bleed cleanses won't help." },
            { npcID = 249020, name = "Hexbound Eagle",    tip = "Sidestep Shredding Talons — step to the side of the eagle as it winds up." },
            { npcID = 249022, name = "Bramblemaw Bear",   tip = "Crunch Armor stacks per bear — avoid pulling multiple bears simultaneously; rotate defensive cooldowns." },
            { npcID = 248692, name = "Reanimated Warrior", tip = "CC or stop Reanimation at 0 HP or it revives. Any crowd-control effect works." },
            { npcID = 248690, name = "Grim Skirmisher",   tip = "Grim Ward shield: don't purge multiple at once — each break hits the whole group. Stagger dispels." },
            { npcID = 249030, name = "Restless Gnarldin",  tip = "Spectral Strikes passive: autos deal shadow damage to everyone within 60 yards — keep pull size manageable. Staggering Blow hits the tank hard and applies a 50% slow — use a freedom effect to remove the slow." },
            { npcID = 0,      name = "Frenzied Berserker",  tip = "Blood Frenzy enrage triggers at low health — pop a defensive or kite. AoE soothe removes it if you have one; more dangerous when multiple are present." },
            { npcID = 249036, name = "Tormented Shade",   tip = "Interrupt Spirit Rend. Dispel the magic DoT if the kick was missed." },
            { npcID = 253683, name = "Rokh'zal",          tip = "Ritual Sacrifice chains an ally to an altar — a freedom effect instantly frees them without needing to damage the dagger in the room. If no freedom available, DPS the dagger to break the shackles." },
            { npcID = 249025, name = "Bound Defender",    tip = "Attack from behind to bypass Vigilant Defense frontal immunity. Dodge Soulstorm tornadoes." },
            { npcID = 249024, name = "Hollow Soulrender",  tip = "Interrupt Shadowfrost Blast. Step away from allies before Frost Nova hits — it chains to nearby players." },
            { npcID = 0,      name = "Hex Guardian",       tip = "Constantly pulses AoE damage — limit pull size and stack defensive and healing CDs. Dodge Magma Surge line attack; dispel fire debuffs." },
            { npcID = 0,      name = "Umbral Shadow Binder", tip = "Channels Shrink into a random player — interrupt or CC the channel. Full-size players who touch a shrunken player are stunned for 4s." },
            { npcID = 253473, name = "Gloomwing Bat",       tip = "Piercing Screech is a frontal aimed at the tank — point away from the group." },
        },
        areas = {
            { subzone = "Wailing Depths",    bossIndex = 1 },  -- Muro'jin and Nekraxx; confirmed in-game
            { subzone = "Dais of Suffering", bossIndex = 2 },  -- Vordaza's arena; confirmed in-game
            { subzone = "Echoing Span",      bossIndex = 3 },  -- Rak'tul's arena; gauntlet runs during the fight (spirit realm bridge); confirmed in-game
        },
    },

    -- --------------------------------------------------------
    -- NEW MIDNIGHT DUNGEONS — Max Level (88–90)
    -- --------------------------------------------------------
    {
        instanceID = 2811,  -- confirmed in-game
        uiMapID    = 2511,  -- confirmed in-game
        altMapIDs  = { 2424, 2515, 2516, 2517, 2519, 2520 },  -- all confirmed in-game except 2424
        name       = "Magisters' Terrace",
        location   = "Isle of Quel'Danas",
        season     = "midnight",
        type       = "max",
        mythicPlus = true,
        bosses = {
            {
                encounterID = 3071,  -- confirmed in-game
                npcID       = 231861,
                name        = "Arcanotron Custos",
                tip         = "Refueling Protocol (0 energy): pull boss to a room corner before it fires — orbs funnel into one position, making soaks easier, and fewer orbs spawn on the far side. Spread to intercept orbs; each that reaches boss grants a damage buff; save damage CDs for the Refueling Protocol damage amp. Each orb soaked stacks Unstable Energy (DoT) — use defensives if soaking multiple. Arcane Expulsion: AoE hit + knockback that drops a puddle — position to drop puddles at arena edges. Arcane Residue snare/DoT: magic dispel or freedom effect removes it. Tank: stand on stair edges to prevent Repulsing Slam knockback. Magic dispel Ethereal Shackles from two players.",
                notes = {
                    { role = "general",   text = "Refueling Protocol (0 energy): pull boss to a room corner before it fires — orbs funnel into one position for easier soaks; save damage CDs for the damage amp." },
                    { role = "general",   text = "Arcane Expulsion: AoE hit + knockback + puddle — face the boss toward the arena edge so the puddle drops out of the fight area." },
                    { role = "general",   text = "Arcane Residue snare/DoT: magic dispel or freedom effect removes it — reduces overall damage intake significantly." },
                    { role = "general",   text = "Refueling Protocol orbs stack Unstable Energy (DoT) — use defensives if soaking multiple." },
                    { role = "tank",      text = "Stand on stair edges for Repulsing Slam — stops the knockback entirely. Defensive for the slam hit." },
                    { role = "healer",    text = "Magic dispel Ethereal Shackles from two random players." },
                },
            },
            {
                encounterID = 3072,  -- confirmed in-game
                npcID       = 231863,
                name        = "Seranel Sunlash",
                tip         = "Purge Hastening Ward magic buff from the boss when it appears. At 100 energy, step inside a Suppression Zone before Wave of Silence finishes or you're pacified for 8s. Step into a zone to resolve Runic Mark (Feedback) — but zones purge your buffs. Null Reaction: two players targeted take a combo hit — use a defensive.",
                notes = {
                    { role = "general",   text = "At 100 energy, be inside a Suppression Zone before Wave of Silence finishes or you're pacified for 8s." },
                    { role = "general",   text = "Step into a zone to resolve Runic Mark (Feedback) — zones purge your buffs; keep a gap between the two marked players so their zone clears don't clip the raid." },
                    { role = "general",   text = "Purge Hastening Ward from the boss." },
                    { role = "general",   text = "Null Reaction: two players targeted take a combo hit — use a defensive." },
                },
            },
            {
                encounterID = 3073,  -- confirmed in-game
                npcID       = 231864,
                name        = "Gemellus",
                tip         = "Clones spawn at pull AND at 50% health — all copies share health, cleave them. Neural Link: follow the arrow indicator to your correct clone and touch it — Astral Grasp pulls you toward the clones so you must fight the pull-in. Cosmic Sting: move away from the group to drop puddles.",
                notes = {
                    { role = "general",   text = "Clones spawn at pull and again at 50% — all copies share health; cleave them and follow Neural Link's arrow indicator to find your correct clone and touch it." },
                    { role = "general",   text = "Astral Grasp pulls players toward the clones — fight the pull-in while navigating." },
                    { role = "general",   text = "Cosmic Sting: move away from the group to drop puddles." },
                },
            },
            {
                encounterID = 3074,  -- confirmed in-game
                npcID       = 231865,
                name        = "Degentrius",
                tip         = "Void Torrent beam splits the arena — keep one player on each side to soak Unstable Void Essence. Devouring Entropy: random players get debuffs of different durations — use a defensive if your duration is long; aim your orb so allies can intercept it. Entropy Blast: unavoidable group damage regardless of positioning — healer plan CDs. Tank: step back for Hulking Fragment Magic dispel (drops a puddle). Never stand in Void Torrent beams — they stun.",
                notes = {
                    { role = "general",   text = "Void Torrent beam splits the arena — keep one player on each side to soak Unstable Void Essence bounces; missing applies a 40s DoT." },
                    { role = "general",   text = "Devouring Entropy: players get debuffs with different durations — use a defensive if yours is long; aim your orb toward allies." },
                    { role = "general",   text = "Never stand in Void Torrent beams — they stun." },
                    { role = "tank",      text = "Step back out of melee for Hulking Fragment Magic dispel — drops a puddle." },
                    { role = "healer",    text = "Entropy Blast deals unavoidable group damage — plan CDs around it; positioning won't reduce the hit." },
                },
            },
        },
        trash = {
            -- Three Arcane Magister variants across different wings (library, outdoor, void section) — same abilities, different npcIDs
            { npcID = 241326, name = "Arcane Magister",     tip = "Top interrupt priority — Polymorph targets a random player; dispel if it lands." },
            { npcID = 232369, name = "Arcane Magister",     tip = "Top interrupt priority — Polymorph targets a random player; dispel if it lands." },
            { npcID = 257644, name = "Arcane Magister",     tip = "Top interrupt priority — Polymorph targets a random player; dispel if it lands." },
            { npcID = 234486, name = "Lightward Healer",    tip = "Dispel Holy Fire; purge Power Word: Shield the healer casts on nearby enemy mobs." },
            { npcID = 251917, name = "Animated Codex",      tip = "Arcane Volley pulses constant AoE — limit pull size and prepare healing cooldowns." },
            { npcID = 257161, name = "Blazing Pyromancer",  tip = "Interrupt every Pyroblast; use defensives during Ignition; avoid Flamestrike." },
            { npcID = 24761,  name = "Brightscale Wyrm",    tip = "Stagger kills — Energy Release fires on death; killing simultaneously overwhelms the group." },
            { npcID = 234068, name = "Shadowrift Voidcaller", tip = "CC-immune. Line of sight Consuming Shadows — break line before the channel completes; kill spawned adds from Call of the Void." },
            { npcID = 249086, name = "Void Infuser",        tip = "Interrupt Terror Wave every cast — fears the group; can also be LoS'd in a pinch. Dispel or use a defensive for Consuming Void debuff." },
            { npcID = 234066, name = "Devouring Tyrant",    tip = "CC-immune. Tank defensive for Devouring Strike (large healing absorb). Void Bomb targets a random player — that player and nearby allies use defensives for the absorb." },
            { npcID = 0,      name = "Arcane Sentry",       tip = "Ethereal Shackles is a root on the tank — a freedom effect removes it and all its damage entirely; magic dispel also works. Dodge Arcane Beam puddles." },
            { npcID = 241325, name = "Sunblade Enforcer",   tip = "Arcane Blade is a stacking magic buff — purge it immediately; at high stacks (some Enforcers start with 10+) they hit the tank extremely hard. Purging is very high value in this dungeon. Kiting is difficult due to Charge — tank through it rather than trying to disengage." },
            { npcID = 259387, name = "Spellwoven Familiar",  tip = "Blink triggers an AoE group hit — brace when it casts." },
            { npcID = 241444, name = "Runed Spellbreaker",  tip = "CC immune. Runic Glaive targets random players and applies a debuff — use a defensive or meld immediately; cannot be removed with Dwarf racial. Two of these guard the pack before the last boss — do not double-pull that pack. Shield Slam is a line attack toward the tank — point away from the group." },
            { npcID = 0,      name = "Voidling",             tip = "Void Gash passively damages nearby melee players." },
            { npcID = 0,      name = "Dreaded Voidwalker",   tip = "Shadow Bolt — use spare interrupts when available." },
            { npcID = 0,      name = "Unstable Voidling",    tip = "Void Eruption on death — stagger kills to avoid overwhelming group damage." },
        },
        areas = {
            { subzone = "Arcane Atheneum",        tip = "Interrupt Arcane Magisters' Polymorph first — targets a random player. Limit Animated Codex pulls — Arcane Volley is sustained group AoE. Dispel Holy Fire from Lightward Healers." },
            { subzone = "Observation Grounds",    bossIndex = 1 },  -- Arcanotron Custos; confirmed in-game
            { subzone = "Grand Magister Asylum",  bossIndex = 2 },  -- Seranel Sunlash; confirmed in-game
            { subzone = "Tower of Theory",        tip = "Interrupt Terror Wave from Void Infusers every cast. Stagger Brightscale Wyrm kills — simultaneous deaths chain Energy Release through the group. Line of sight Consuming Shadows from Shadowrift Voidcallers." },
            { subzone = "Constellarium",          bossIndex = 3 },  -- Gemellus; confirmed in-game
            { subzone = "Celestial Orrery",       bossIndex = 4 },  -- Degentrius; confirmed in-game
        },
    },
    {
        instanceID = 2915,  -- confirmed in-game
        uiMapID    = 2556,  -- confirmed in-game
        name       = "Nexus-Point Xenas",
        location   = "Voidstorm",
        season     = "midnight",
        type       = "max",
        mythicPlus = true,
        bosses = {
            {
                encounterID = 3328,  -- confirmed in-game
                npcID       = 241539,
                name        = "Chief Corewright Kasreth",
                tip         = "Don't cross Leyline Arrays (damage + slow). When targeted by Reflux Charge, touch an array intersection to destroy it and open space. At full energy: Corespark Detonation — massive knockback + healing absorb DoT on target; party-wide Sparkburn follows — healer CDs. Tank: boss uses instant arcane damage instead of melee swings — defensive timing should match cast windows, not auto-attack swing timers.",
                notes = {
                    { role = "general",   text = "Don't cross Leyline Arrays (damage + slow); if targeted by Reflux Charge, touch an intersection to destroy it and open space." },
                    { role = "general",   text = "At full energy: Corespark Detonation — massive knockback + healing absorb DoT; don't get knocked into puddles." },
                    { role = "tank",      text = "Boss uses instant arcane damage instead of melee swings — defensive timing aligns with casts, not melee swing timers." },
                    { role = "healer",    text = "CDs after Corespark Detonation — party-wide Sparkburn DoT follows immediately." },
                },
            },
            {
                encounterID = 3332,  -- confirmed in-game
                npcID       = 254227,
                name        = "Corewarden Nysarra",
                tip         = "Lightscar Flare: dodge the initial beam, then stand in the light cone for 300% damage amp during the 18s stun. Kill Null Vanguard adds before the stun ends — Dreadflail first (tank face away from group), then interrupt Grand Nullifiers (Nullify), then cleave Haunting Grunts. Eclipsing Step hits two players — spread to avoid cleaving allies, use a defensive. Tank: defensive for Umbral Lash channel.",
                notes = {
                    { role = "general",   text = "Lightscar Flare: dodge the initial beam, then stand in the light cone for 300% damage amp during the 18s stun." },
                    { role = "general",   text = "Eclipsing Step targets two players — spread to avoid cleaving allies; use a defensive for the hit + DoT." },
                    { role = "dps",       text = "Kill adds before stun ends — Dreadflail → interrupt Grand Nullifiers (Nullify) → cleave Haunting Grunts." },
                    { role = "tank",      text = "Defensive for Umbral Lash channel, especially if adds are alive. Face Dreadflail away from group — Void Lash frontal." },
                    { role = "healer",    text = "30% healing amp is active during the stun — use CDs." },
                },
            },
            {
                encounterID = 3333,  -- confirmed in-game
                npcID       = 241546,
                name        = "Lothraxion",
                tip         = "At 100 energy, find and interrupt the real Lothraxion among his images — he's the only one without glowing horns; wrong target = Core Exposure (group damage + 20% Holy taken for 1 min). After a successful interrupt, Lightscorn Flare fires: get INTO this frontal — it deals heavy damage but grants 300% bonus damage amp and a healing boost; use defensive + offensive CDs and Bloodlust here. Step away from Fractured Images (5-yard aura, disorient) just before Lightscorn Flare, then step back in. Brilliant Dispersion: spread 8 yards; cleave Fractured Images. Tank: defensive for Searing Rend — puddles last 10 MINUTES; drop them away from the entire fight area.",
                notes = {
                    { role = "interrupt", text = "At 100 energy, find and interrupt the real Lothraxion — no glowing horns; wrong target = Core Exposure (group damage + 20% Holy taken for 1 min)." },
                    { role = "general",   text = "After successful interrupt, Lightscorn Flare fires — get INTO the frontal; 300% damage amp + healing boost; use defensive + offensive CDs and Bloodlust. Step away from Fractured Images just before it fires to avoid the disorient." },
                    { role = "general",   text = "Brilliant Dispersion: spread 8 yards — spawns Fractured Images (5-yard damage aura, reposition via Flicker); cleave them." },
                    { role = "tank",      text = "Defensive for Searing Rend — puddles last 10 MINUTES; drop them away from the entire fight area." },
                },
            },
        },
        trash = {
            { npcID = 241643, name = "Shadowguard Defender",  tip = "Null Sunder stacks per Defender active — control pull size. Stacks don't fall off until the healing absorb is cleared; use a health potion or self-heal to burn it off." },
            { npcID = 241647, name = "Flux Engineer",          tip = "Suppression Field: spread to avoid cleaving the random target, then move as little as possible (movement increases damage taken). Freedom effect fully removes the dot. Drops a live Mana Battery on death — destroy it before it finishes its 12s cast." },
            { npcID = 248708, name = "Nexus Adept",            tip = "Interrupt Umbra Bolt — high-damage shadow nuke; use a stun or stop if interrupt is on cooldown." },
            { npcID = 248373, name = "Circuit Seer",           tip = "Immune to CC. Pull away from inactive Mana Batteries — circuit seers activate them if you fight nearby. Defensives and healing CDs for Arcing Mana channel; avoid Erratic Zap and Power Flux circles; if a battery activates anyway, swap and destroy it before the 12s cast completes." },
            { npcID = 248706, name = "Cursed Voidcaller",      tip = "On death casts Creeping Void — brace for the hit and use Curse dispels to remove the lingering debuff." },
            { npcID = 251853, name = "Grand Nullifier",        tip = "Interrupt Nullify every cast; avoid Dusk Frights fear zones; turns into a Smudge on death that awakens a nearby Dreadflail in ~1.5s — CC or cleave the Smudge immediately." },
            { npcID = 241660, name = "Duskfright Herald",      tip = "Immune to CC. Entropic Leech channels on a random player and applies a healing absorb — use a combat drop or dispel the absorb to end it. Avoid pulsing projectiles from Dark Beckoning." },
            { npcID = 251024, name = "Dreadflail",             tip = "Tank point away from group — Void Lash frontal tank buster; dodge Flailstorm AoE if fixated on you. Also spawned as a Corewarden Nysarra add — kill before the 18s stun ends." },
            { npcID = 241644, name = "Corewright Arcanist",   tip = "Interrupt Arcane Explosion every cast. Dispel Transference from affected players." },
            { npcID = 0,      name = "Lingering Image",        tip = "Searing Rend: leaps at the tank and lands two heavy physical hits followed by a holy DoT — use a defensive. Drops a puddle that lasts 10 minutes; drop it away from the fight area." },
        },
        areas = {
            { subzone = "The Bazaar",             tip = "Shadowguard Defenders stack Null Sunder — control pull size. Interrupt Umbra Bolt from Nexus Adepts. Cursed Voidcaller casts Creeping Void on death — brace for the hit." },  -- entrance section; subzone confirmed in-game; mob assignments unverified
            { subzone = "Corespark Engineway",    bossIndex = 1 },  -- Chief Corewright Kasreth; confirmed in-game
            { subzone = "Core Defense Nullward",  bossIndex = 2 },  -- Corewarden Nysarra; confirmed in-game
            { subzone = "The Nexus Core",         bossIndex = 3 },  -- Lothraxion's boss room; confirmed in-game
        },
    },
    {
        instanceID = 2859,  -- confirmed in-game
        uiMapID    = 2500,  -- confirmed in-game
        name       = "The Blinding Vale",
        location   = "Harandar",
        season     = "midnight",
        type       = "max",
        mythicPlus = false,
        bosses = {
            {
                encounterID = 3199,  -- confirmed in-game
                npcID       = 243028,  -- Meittik
                altNpcIDs   = { 243029, 243030 },  -- Kezkitt, Lekshi
                name        = "Lightblossom Trinity",
                tip         = "Block Lightblossom Beams to prevent Light-Gorged stacks on flowers before they detonate; all three bosses share damage. Avoid Fertile Loam puddles (50% slow). Interrupt Lightsower Dash and Thornblade (Lekshi bleeds).",
                notes = {
                    { role = "general",   text = "Block Lightblossom Beams to prevent Light-Gorged stacks on flowers; all three bosses share damage." },
                    { role = "general",   text = "Avoid Fertile Loam puddles — 50% movement speed slow." },
                    { role = "interrupt", text = "Lightsower Dash — stops seed planting. Thornblade (Lekshi) — stops bleed application." },
                },
            },
            {
                encounterID = 3200,  -- confirmed in-game
                npcID       = 244887,
                name        = "Ikuzz the Light Hunter",
                tip         = "Destroy Bloodthorn Roots quickly — rooted players are also hit by Crushing Footfalls; Bloodthirsty Gaze fixates Ikuzz on a player for 10s — maintain distance or be Incised.",
                notes = {
                    { role = "general",   text = "Bloodthirsty Gaze fixates Ikuzz on a player for 10s — that player maintains distance." },
                    { role = "dps",       text = "Destroy Bloodthorn Roots quickly — rooted players are also hit by Crushing Footfalls." },
                },
            },
            {
                encounterID = 3201,  -- confirmed in-game
                npcID       = 245912,
                name        = "Lightwarden Ruia",
                tip         = "Heal players to full to clear Grievous Thrash bleeds. Pulverizing Strikes marks several players — spread marked players apart (100% increased damage taken from subsequent strikes). Don't stand in Lightfire Beams (6s silence). At 40%, Ruia enters Haranir form and rapidly cycles all abilities.",
                notes = {
                    { role = "general",   text = "Pulverizing Strikes marks several players — spread marked players apart (100% increased damage taken from subsequent strikes)." },
                    { role = "general",   text = "Don't stand in Lightfire Beams — 6s silence." },
                    { role = "healer",    text = "Heal players to full to clear Grievous Thrash bleeds; at 40% Haranir form cycles all abilities rapidly — use CDs." },
                },
            },
            {
                encounterID = 3202,  -- confirmed in-game
                npcID       = 247676,
                name        = "Ziekett",
                tip         = "Intercept Lightbloom's Essence globules before the boss absorbs them — each absorbed globule grants a Florescent Outburst stack (stacking shield); touching them yourself grants Lightbloom's Might (+dmg/healing). Position boss's Lightbeam sweep over Dormant Lashers to vaporize them; dodge the beam and Lightsap puddles. Tank: defensive on Thornspike — stacking impale + bleed.",
                notes = {
                    { role = "general",   text = "Intercept Lightbloom's Essence globules — each one the boss absorbs grants a stacking shield (Florescent Outburst); touching them yourself grants Lightbloom's Might." },
                    { role = "general",   text = "Position boss's Lightbeam sweep over Dormant Lashers to vaporize them; dodge the beam and Lightsap puddles." },
                    { role = "tank",      text = "Use a defensive on Thornspike — it applies a stacking impale + bleed." },
                },
            },
        },
        trash = {
            { npcID = 0, name = "Ineffable Tormentor",    tip = "Crushing Doubt drops avoidable circles — dodge them. Overwhelming Power channels on a player — interrupt it or LoS behind terrain." },
            { npcID = 0, name = "Time-Lost Stalker",      tip = "Ireful Strike hits the tank hard and slows attack speed — use a defensive. Dispel the lingering debuff." },
            { npcID = 0, name = "Muddled Screamer",       tip = "Wracking Scream fears all players — interrupt this cast above all else. Use CC to chain stops." },
            { npcID = 0, name = "Dormant Lasher",         tip = "These start dormant — don't wake them unless needed. If active, sidestep their lash frontal." },
            { npcID = 0, name = "Lightbloom Harvester",   tip = "Interrupt Lightbloom Channel — it heals nearby mobs. Dodge Flowering Burst petals on death." },
            { npcID = 0, name = "Vale Stalker",           tip = "Prowls between patrols — use stealth detection. Pouncing Strike roots the target — freedom effect removes it." },
            { npcID = 0, name = "Sunblaze Warden",        tip = "Radiant Slash is a frontal cone — tank faces away. Interrupt Gleaming Barrier when possible." },
        },
        areas = {
            { subzone = "The Luminous Garden",  bossIndex = 1 },  -- Lightblossom Trinity; confirmed in-game
            { subzone = "The Gilded Tangle",    bossIndex = 2 },  -- Ikuzz the Light Hunter; confirmed in-game
            { subzone = "Warden's Retreat",     bossIndex = 3 },  -- Lightwarden Ruia; confirmed in-game
            { subzone = "Conviction's Crucible", bossIndex = 4 }, -- Ziekett; confirmed in-game
        },
    },
    {
        instanceID = 2923,  -- confirmed in-game
        uiMapID    = 2572,  -- confirmed in-game
        altMapIDs  = { 2573, 2574 },  -- 2573/2574 = confirmed in-game sub-zones
        name       = "Voidscar Arena",
        location   = "Voidstorm",
        season     = "midnight",
        type       = "max",
        mythicPlus = false,
        bosses = {
            {
                encounterID = 3285,  -- confirmed in-game
                npcID       = 238887,
                name        = "Taz'Rah",
                tip         = "Stay out of Dark Rift gravity pull; kill Ethereal Shades quickly to stop Nether Dash chain lines.",
                notes = {
                    { role = "general",   text = "Stay out of Dark Rift gravity pull." },
                    { role = "dps",       text = "Kill Ethereal Shades quickly — each active shade triggers Nether Dash lines." },
                },
            },
            {
                encounterID = 3286,  -- confirmed in-game
                npcID       = 239008,
                name        = "Atroxus",
                tip         = "Avoid Noxious Breath frontal; when Toxic Creepers fixate on a player, spread out to avoid the 8-yard toxic aura. Tank: defensive for Hulking Claw — applies a 10s nature DoT.",
                notes = {
                    { role = "general",   text = "Avoid Noxious Breath frontal." },
                    { role = "general",   text = "When Toxic Creepers fixate, spread to avoid the 8-yard toxic aura." },
                    { role = "tank",      text = "Defensive for Hulking Claw — applies a 10s nature DoT." },
                },
            },
            {
                encounterID = 3287,  -- confirmed in-game
                npcID       = 248015,
                name        = "Charonus",
                tip         = "Lead Gravitic Orbs into Singularities to consume them before stacks get too high; avoid the gravity well. Cosmic Blast hits the whole group — healer CDs.",
                notes = {
                    { role = "general",   text = "Lead Gravitic Orbs into Singularities to consume them before stacks get too high; avoid the Unstable Singularity gravity well." },
                    { role = "healer",    text = "CDs for Cosmic Blast — group-wide shadow damage + knockback." },
                },
            },
        },
        trash = {
            { npcID = 0, name = "Bloodswarmer",          tip = "Blood Bolt hits hard — use spare interrupts. Tainted Blood leaves a puddle on death; kite the swarm away from existing puddles." },
            { npcID = 0, name = "Festering Rot",         tip = "Bait Vile Eruption by standing in front of it — the frontal cone is well-telegraphed. Don't get hit; it applies a healing absorb." },
            { npcID = 0, name = "Sporecaller Zan'cha",   tip = "Ticking Spider casts a long channel — interrupt or stun it. The spider bomb explodes on death — AoE it down from range to avoid the explosion." },
            { npcID = 0, name = "Void-Touched Berserker", tip = "Enrages at low health — soothe or kite. On death, leaves a void zone that deals shadow damage — move out." },
            { npcID = 0, name = "Ethereal Channeler",    tip = "Interrupt Void Bolt. Void Shift heals the Channeler and damages the group — top interrupt priority." },
            { npcID = 0, name = "Phase Spider",          tip = "Shadowstep blinks to random players — loosely spread. Apply a slow or root if it fixates." },
        },
        areas = {
            { subzone = "The Den", bossIndex = 1 },  -- Taz'Rah's arena; confirmed in-game
            { mapID = 2573,        bossIndex = 2 },  -- Atroxus; confirmed in-game
            { mapID = 2574,        bossIndex = 3 },  -- Charonus; confirmed in-game
        },
    },

    -- --------------------------------------------------------
    -- SEASON 1 MYTHIC+ — Legacy Dungeons
    -- --------------------------------------------------------
    {
        instanceID = 2526,  -- confirmed in-game
        uiMapID    = 2097,  -- confirmed in-game
        altMapIDs  = { 2025, 2098 },  -- 2025 = entrance antechamber; 2098 = upper floor (The Pitch); confirmed in-game
        name       = "Algeth'ar Academy",
        location   = "Thaldraszus",
        season     = "legacy",
        type       = "max",
        mythicPlus = true,
        bosses = {
            {
                encounterID = 2563,  -- confirmed in-game
                npcID       = 196482,
                name        = "Overgrown Ancient",
                tip         = "Interrupt Healing Touch from Ancient Branch adds — top priority. Stand in Abundance circles on add death to auto-cleanse Splinterbark bleeds. Stack during Germinate. At 100 energy, Burst Forth activates Hungry Lashers — tank grabs them; dispel Lasher Toxin stacks. Tank: defensive for Barkbreaker.",
                notes = {
                    { role = "general",   text = "Stand in Abundance circles on add death to auto-cleanse Splinterbark bleeds." },
                    { role = "general",   text = "Stack during Germinate channel; free allies from roots." },
                    { role = "general",   text = "At 100 energy, Burst Forth activates Hungry Lashers — use stuns/slows; dispel Lasher Toxin stacks." },
                    { role = "tank",      text = "Grab Hungry Lashers; defensive for Barkbreaker (physical damage amp)." },
                    { role = "interrupt", text = "Healing Touch (Ancient Branch adds) — highest priority." },
                },
            },
            {
                encounterID = 2564,  -- confirmed in-game
                npcID       = 191736,
                name        = "Crawth",
                tip         = "Ruinous Winds: ALWAYS do the wind goal first (75%) — fire goal now pulses AoE damage the entire time, making fire-first essentially impossible. Wind goal triggers patrolling tornadoes — dodge them. Fire goal (45%) starts Firestorm (12s damage amp) — save offensive CDs and Bloodlust for this phase. Spread loosely for Deafening Screech. Tank: defensive for Savage Peck — it's a heavy physical hit, not a bleed.",
                notes = {
                    { role = "general",   text = "Ruinous Winds: wind goal first (75%), THEN fire goal (45%) — fire goal now pulses AoE the entire time; do not score the fire goal first." },
                    { role = "general",   text = "Spread loosely for Deafening Screech." },
                    { role = "tank",      text = "Defensive for Savage Peck — heavy physical hit, not a bleed." },
                    { role = "dps",       text = "Save offensive CDs and Bloodlust for Firestorm — 12s damage amp phase at 45%." },
                },
            },
            {
                encounterID = 2562,  -- confirmed in-game
                npcID       = 194181,
                name        = "Vexamus",
                tip         = "Spread to soak Arcane Orbs around the arena edges — each applies Oversurge (NOT dispelable); tank soaks 1-2 per cycle, non-tanks stop at 1 stack. Never soak while you have the Mana Bomb dot active. Mana Bombs targets 3 random players — move to room perimeter to drop puddles. At 100 energy, Arcane Fissure — knockback + 3 circles per player; dodge circles. Tank: point Arcane Expulsion away, use a defensive.",
                notes = {
                    { role = "general",   text = "Soak Arcane Orbs — Oversurge is NOT dispelable; tank soaks 1-2 per cycle; non-tanks: never go to a second stack. Never soak when you have the Mana Bomb dot." },
                    { role = "general",   text = "Mana Bombs targets 3 random players — move to room perimeter to drop puddles." },
                    { role = "general",   text = "At 100 energy, Arcane Fissure — knockback + 3 circles per player; dodge the circles." },
                    { role = "tank",      text = "Point Arcane Expulsion away from group; use a defensive for the impact." },
                },
            },
            {
                encounterID = 2565,  -- confirmed in-game
                npcID       = 190609,
                name        = "Echo of Doragosa",
                tip         = "Pull boss toward the entrance — Unleash Energy on pull spawns 2 Arcane Rifts (rifts periodically shoot orbs). At 3 Overwhelming Power stacks (from any ability hit), a new rift spawns beneath you — spread loosely and use defensives to stay under 3 stacks. Energy Bomb targets 2 players — both must drop puddles away from the group. Power Vacuum pulls everyone to boss — use movement abilities to escape the AoE. Tank: defensive for Astral Blast.",
                notes = {
                    { role = "general",   text = "Pull boss toward entrance — Unleash Energy spawns 2 rifts on pull; manage your Overwhelming Power stacks (3 stacks = new rift under you)." },
                    { role = "general",   text = "Spread loosely for Energy Bomb (targets 2 players) and Arcane Missiles — taking any hit stacks Overwhelming Power." },
                    { role = "general",   text = "Use defensives to avoid reaching 3 Overwhelming Power stacks — 3 stacks spawns a new rift under you." },
                    { role = "general",   text = "Power Vacuum pulls everyone to boss — use movement abilities to escape the AoE." },
                    { role = "tank",      text = "Defensive for Astral Blast — it stacks Overwhelming Power, so you'll place the most new rifts; be intentional about where you drop them." },
                },
            },
        },
        trash = {
            { npcID = 196044, name = "Unruly Textbook",       tip = "Monotonous Lecture sleeps a player for 8s — interrupt, CC the channel, or magic dispel if it lands." },
            { npcID = 196202, name = "Spectral Invoker",      tip = "Interrupt Mystic Brand — random target hit that increases arcane damage taken by 50% for 20s. Very dangerous in the arcane-heavy final area." },
            { npcID = 197219, name = "Vile Lasher",           tip = "Vile Bite applies a stacking nature debuff — dispel it." },
            { npcID = 196045, name = "Corrupted Manafiend",   tip = "Interrupt Surge on cooldown." },
            { npcID = 0,      name = "Aggravated Skitterfly", tip = "Agitation enrages it — significant physical damage increase. Pop a defensive when it procs; CC or kite if multiple Skitterflies enrage together." },
            { npcID = 0,      name = "Territorial Eagle",     tip = "Peck applies a short bleed (6s) — not a major threat alone, but watch for overlap with Alpha Eagle enrage." },
            { npcID = 0,      name = "Alpha Eagle",           tip = "Raging Screech enrages all nearby mobs — dangerous when Territorial Eagles or Skitterflies are present; pop a tank defensive or use a soothe immediately." },
            { npcID = 0,      name = "Spellbound Battle Axe", tip = "Spellbound Weapon passive deals arcane damage on every melee — very dangerous when multiple Axes sync up. Limit pull size; use a defensive when facing more than one." },
        },
        areas = {
            { subzone = "Terrace of Lectures",      bossIndex = 3 },  -- Vexamus; confirmed in-game
            { subzone = "The Botanica",              bossIndex = 1 },  -- Overgrown Ancient; confirmed in-game
            { subzone = "The Pitch",                 bossIndex = 2 },  -- Crawth; spans mapIDs 2097+2098; confirmed in-game
            { subzone = "The Headteacher's Enclave", bossIndex = 4 },  -- Echo of Doragosa; confirmed in-game
        },
    },
    {
        instanceID = 658,   -- confirmed in-game
        uiMapID    = 184,   -- confirmed in-game
        name       = "Pit of Saron",
        location   = "Icecrown",
        season     = "legacy",
        type       = "max",
        mythicPlus = true,
        bosses = {
            {
                encounterID = 1999,  -- confirmed in-game
                npcID       = 36494,
                name        = "Forgemaster Garfrost",
                tip         = "Throw Saronite targets 2 players — spread to prevent circle overlap; bait chunks to room edges. Glacial Overload channels toward the CLOSEST forge — position the boss so melee can still cleave while you hide behind a chunk to LoS. Cryostomp: dispel one player's Siphoning Chill immediately; use a freedom effect on another — freedom fully removes the debuff (not just reduces). Tank: defensive for Orebreaker — destroy nearby chunks to avoid the stun.",
                notes = {
                    { role = "general",   text = "Throw Saronite targets 2 players — spread; bait chunks to room edges." },
                    { role = "general",   text = "Glacial Overload channels toward the closest forge — hide behind a remaining chunk to LoS it." },
                    { role = "healer",    text = "Cryostomp: dispel Siphoning Chill stacks immediately (magic: slow + 50% frost damage taken); freedom effect fully removes it from a second player — prioritize clearing both." },
                    { role = "tank",      text = "Defensive for Orebreaker — destroy nearby chunks to avoid the stun." },
                },
            },
            {
                encounterID = 2001,  -- confirmed in-game
                npcID       = 36476,  -- Ick
                altNpcIDs   = { 36477 },  -- Krick
                name        = "Ick & Krick",
                tip         = "Bosses share health (Necrolink) — cleave both. Shade Shift spawns 2 Shades of Krick — interrupt Shadowbind casts and cleave. Death Bolt on Krick is essentially one-shot damage — very long cast, alternate two players kicking near the end to ensure it's always interrupted. Shadowbind is a spare interrupt (also curse dispel or freedom removable). Plague Explosion spawns puddles under 4 players — pre-spread near walls. Tank: defensive for Blight Smash, position puddle away from group. Phase 2 (50%): kite Ick during 'Get 'em, Ick!' fixation.",
                notes = {
                    { role = "general",   text = "Bosses share health (Necrolink) — cleave both whenever possible." },
                    { role = "general",   text = "Shade Shift spawns 2 Shades of Krick — interrupt their Shadowbind casts and cleave down." },
                    { role = "general",   text = "Plague Explosion spawns puddles under 4 players — pre-spread near walls to consolidate." },
                    { role = "general",   text = "Phase 2 (50%): kite Ick during 'Get 'em, Ick!' fixation (7s)." },
                    { role = "tank",      text = "Defensive for Blight Smash — position the puddle away from the group." },
                    { role = "interrupt", text = "Death Bolt (Krick) — essentially one-shot damage; very long cast so two players can alternate kicks near the end. Shadowbind (spare interrupt) — also removable via freedom effect or curse dispel." },
                },
            },
            {
                encounterID = 2000,  -- confirmed in-game
                npcID       = 36658,
                name        = "Scourgelord Tyrannus",
                tip         = "5 green bone piles total; 4 Rime Blasts per rotation — clear 4 of 5. If you are NOT targeted by the first Rime Blast, you are GUARANTEED to be targeted by the second — pre-position near an uncleared pile before the second cast. Tank: drag boss to where 3 piles are clustered together for better positioning. Frozen piles spawn Rotlings or Plaguespreaders during Army of the Dead. Rotlings apply Rotting Strikes disease to the tank — dispel. Kill Plaguespreaders fast (interrupt Plague Bolt) — Festering Pulse pulses AoE every 2s. Avoid Death's Grasp circles. Scourgelord's Brand: knockback + leap — defensive + movement ability.",
                notes = {
                    { role = "general",   text = "5 green bone piles, 4 Rime Blasts — clear 4 of 5. If not targeted by the first blast, you WILL be targeted by the second; pre-position near an uncleared pile. Tank: drag boss toward the pile cluster." },
                    { role = "general",   text = "Frozen piles spawn Rotlings or Plaguespreaders when Army of the Dead activates." },
                    { role = "general",   text = "Avoid Death's Grasp circles. Scourgelord's Brand: knockback + follow-up leap — defensive + save a movement ability." },
                    { role = "healer",    text = "Dispel Rotting Strikes disease from the tank — applied by Rotlings." },
                    { role = "tank",      text = "Defensive for Scourgelord's Brand." },
                    { role = "interrupt", text = "Plague Bolt (Plaguespreader adds) — Festering Pulse pulses AoE every 2s while they live." },
                },
            },
        },
        trash = {
            { npcID = 252603, name = "Arcanist Cadaver",       tip = "Interrupt Netherburst every cast — large AoE hit that reaches oneshot territory quickly. Assign a dedicated interrupter, including ranged." },
            { npcID = 252561, name = "Quarry Tormentor",      tip = "Tormenting Blade adds bonus shadow damage to every melee while the tank is above 65% health — save a defensive for high-HP pulls. Curse of Torment targets a random player — use curse dispels." },
            { npcID = 252563, name = "Dreadpulse Lich",       tip = "Interrupt Icy Blast every cast. At 50%, Dread Pulse pulses AoE damage every 2s — group defensives. Torrent of Misery hits a random player hard — personal defensive." },
            { npcID = 252566, name = "Rimebone Coldwraith",   tip = "Interrupt Icebolt. Permeating Cold debuffs 2 random players — magic dispel or use freedom effects." },
            { npcID = 252606, name = "Plungetalon Gargoyle",  tip = "Plungegrip roots a player — break with root-breaking abilities or destroy the shield. Interrupt Plungegrip as a priority." },
            { npcID = 0,      name = "Glacieth",               tip = "CC immune. Cryoburst targets the group — loosely spread and move away from puddles together. Focused Guard shields itself — avoid the shield and attack from behind for guaranteed crits." },
            { npcID = 0,      name = "Rotting Ghoul",          tip = "Rotting Strikes applies a stacking disease — each stack reduces max HP by 1% for 5s; dispel the disease quickly before stacks accumulate." },
            { npcID = 0,      name = "Wrathbone Enforcer",     tip = "Sunstrike passive: every melee adds bonus physical damage and a 15% physical damage taken increase for 8s (stacks with each hit) — pop a defensive early and control how many Enforcers are active at once." },
            { npcID = 0,      name = "Yumjar Graveblade",      tip = "Frostbane Slash: physical/frost combo hit that leaves the tank taking 100% increased frost damage for 8s — extremely dangerous if Iceborn Proto-Drakes are nearby; use a defensive immediately and move away from frost sources." },
        },
        areas = {
            -- Garfrost and Ick & Krick have no named subzone (empty string throughout).
            -- Only Tyrannus has a distinct boss room subzone.
            { subzone = "Scourgelord's Command", bossIndex = 3 },  -- Scourgelord Tyrannus; confirmed in-game
        },
    },
    {
        instanceID = 1753,  -- confirmed in-game
        uiMapID    = 903,   -- confirmed in-game; single map ID, no alt maps
        name       = "Seat of the Triumvirate",
        location   = "Argus",
        season     = "legacy",
        type       = "max",
        mythicPlus = true,
        bosses = {
            {
                encounterID = 2065,  -- confirmed in-game
                npcID       = 122313,
                name        = "Zuraal the Ascended",
                tip         = "Oozing Slam spawns two Coalesced Void adds — hard CC one immediately (hunter trap, paralyze, roots) and ignore it while killing the other; CC'd adds touching the boss do NOT explode and don't get the Crashing Void speed boost. Decimate: bait the pool near edges. Null Palm is a random-target frontal — everyone dodge. At 100 energy, Crashing Void: pulls players in then explodes — top everyone off before the cast finishes, move to center near boss to avoid outer storm, and CC any remaining un-CC'd adds. Tank: defensive for Void Slash.",
                notes = {
                    { role = "general",   text = "Oozing Slam spawns two adds — hard CC one (hunter trap, paralyze, roots) and only kill one at a time; CC'd slimes touching the boss do NOT explode." },
                    { role = "general",   text = "Decimate: bait the pool near edges — puddles persist and proximity makes the next one worse." },
                    { role = "general",   text = "Null Palm — random-target frontal; everyone dodge." },
                    { role = "general",   text = "Crashing Void (100 energy): pulls players in then explodes — everyone must be topped before it lands. Move to center near the boss to avoid the outer storm; use a defensive." },
                    { role = "dps",       text = "CC one add per pair — CC'd adds won't speed boost or explode on contact; only deal with one at a time." },
                    { role = "tank",      text = "Defensive for Void Slash." },
                },
            },
            {
                encounterID = 2066,  -- confirmed in-game
                npcID       = 122316,
                name        = "Saprish",
                tip         = "Boss and pets share health — stay stacked for cleave. Interrupt Dread Screech (Duskwing) every cast. Phase Dash: overlap and clear all Void Bombs. Overload is a damage check — successive casts hit harder. Shadow Pounce applies a strong 5s bleed.",
                notes = {
                    { role = "general",   text = "Boss and pets share health — stay stacked to cleave all three simultaneously." },
                    { role = "general",   text = "Phase Dash: overlap and clear all Void Bombs — tank soaks any remaining bombs after the group sweep." },
                    { role = "general",   text = "Overload hits harder each successive cast — it's a damage check." },
                    { role = "healer",    text = "Shadow Pounce applies a strong 5s bleed — dispel if possible; Overload damage increases each cast." },
                    { role = "interrupt", text = "Dread Screech (Duskwing) — interrupt every cast." },
                },
            },
            {
                encounterID = 2067,  -- confirmed in-game
                npcID       = 124309,
                name        = "Viceroy Nezhar",
                tip         = "Interrupt Mind Blast — top priority. At 100 energy, Collapsing Void: run under the boss to avoid the storm. Kill Umbral Tentacles fast (Mind Flay fixates a player). Mass Void Infusion cannot be dispelled — use a defensive.",
                notes = {
                    { role = "general",   text = "At 100 energy (Collapsing Void): run under the boss to avoid the storm; if a player is caught, move to them." },
                    { role = "dps",       text = "Kill Umbral Tentacles fast — Mind Flay deals continuous damage to a fixated player." },
                    { role = "tank",      text = "Defensive for Mass Void Infusion — cannot be dispelled." },
                    { role = "interrupt", text = "Mind Blast — top priority." },
                },
            },
            {
                encounterID = 2068,  -- confirmed in-game
                npcID       = 214650,
                name        = "L'ura",
                tip         = "Spread Notes of Despair — Grim Chorus zones stack. Discordant Beam: align with Notes of Despair to silence them. Grim Chorus repositions Notes and drops circles — use the intermission to rush to the new positions while dodging. Once all are silenced, boss casts Siphon Void — interrupt it: boss takes 200% bonus damage for 20s; use Bloodlust here. Disintegrate: rotating beams around the boss — move with them. Tank: defensive for Abyssal Lance at 3 stacks.",
                notes = {
                    { role = "general",   text = "Spread Notes of Despair — Grim Chorus zones stack damage." },
                    { role = "general",   text = "Grim Chorus intermission: Notes get repositioned and circles drop — rush to the new positions while dodging the circles." },
                    { role = "general",   text = "Discordant Beam: align with Notes of Despair to silence them — don't burn the adds directly." },
                    { role = "general",   text = "Disintegrate: rotating beams around the boss — move with them to avoid." },
                    { role = "dps",       text = "Once all Notes are silenced, interrupt Siphon Void — boss takes 200% bonus damage for 20s; use Bloodlust here." },
                    { role = "tank",      text = "Defensive for Abyssal Lance at 3 stacks." },
                },
            },
        },
        trash = {
            { npcID = 122413, name = "Ruthless Riftstalker",   tip = "Jumps away and channels Shadow Mend to heal itself — interrupt or CC the channel immediately." },
            { npcID = 0,      name = "Shadowguard Champion",   tip = "Battle Rage: 50% physical damage increase — use a defensive immediately. Relentless Pursuit: charges and applies a DoT if you leave melee range; stay in melee." },
            { npcID = 0,      name = "Umbral War Adept",       tip = "Void Bash: shadow hit + knockback — dangerous in combination with Shadowguard Champions (knockback can force you out of melee, triggering Relentless Pursuit)." },
            { npcID = 124171, name = "Merciless Subjugator",  tip = "Chains of Subjugation targets all players — use root-breaking abilities to clear it and greatly reduce damage taken. Dispel Leeching Void healing absorb." },
            { npcID = 122412, name = "Bound Voidcaller",      tip = "Constantly pulses moderate group damage — DPS swap to it immediately." },
            { npcID = 0,      name = "Dark Conjuror",         tip = "Interrupt Summon Voidcaller every cast — spawned Voidcallers pulse heavy group damage while alive; focus them immediately. Spare interrupts on Umbral Bolt." },
            { npcID = 0,      name = "Rift Warden",           tip = "Must fight within 30 yards or Stabilize causes lethal group AoE. Interrupt Rift Tear; dispel Rift Essence." },
            { npcID = 0,      name = "Dire Voidbender",       tip = "Interrupt or purge Abyssal Enhancement every cast." },
        },
        areas = {
            { subzone = "Triad's Conservatory",        bossIndex = 1 },  -- Zuraal the Ascended; confirmed in-game
            { subzone = "Shadowguard Incursion",        bossIndex = 2 },  -- Saprish; confirmed in-game
            { subzone = "The Seat of the Triumvirate",  bossIndex = 3 },  -- Viceroy Nezhar; confirmed in-game
            -- L'ura (bossIndex=4) shares this subzone — ENCOUNTER_START overrides the area tip when L'ura's fight begins.
        },
    },
    -- --------------------------------------------------------
    -- MIDNIGHT DELVES
    -- All uiMapIDs are 0 — verify in-game with /run print(C_Map.GetBestMapForUnit("player"))
    -- instanceIDs sourced from LittleWigs Midnight/Delves/ — unverified in-game.
    -- encounterIDs sourced from LittleWigs SetEncounterID() calls — unverified in-game.
    -- Tip content sourced from Icy Veins (primary for non-M+ content).
    -- --------------------------------------------------------
    {
        instanceID = 2933,  -- confirmed in-game
        uiMapID    = 2547,  -- confirmed in-game (Voidscorned Vagrant boss room; primary map ID)
        name       = "Collegiate Calamity",
        location   = "Eversong Woods",
        season     = "midnight",
        type       = "delve",
        mythicPlus = false,
        bosses = {
            {
                encounterID = 3367,
                name        = "Hydrangea",
                tip         = "Interrupt the Wildwood Weed channel to break the root — being rooted when Lightbloom Salvo fires makes the zones unavoidable. Dodge Lightbloom Salvo projectiles.",
                notes = {
                    { role = "interrupt", text = "Wildwood Weed channel — interrupting it removes the root. Being rooted when Lightbloom Salvo fires makes the zones unavoidable." },
                    { role = "general",   text = "Dodge Lightbloom Salvo projectiles." },
                },
            },
            {
                encounterID = 3405,
                name        = "Infiltrator Garand",
                tip         = "Step out of melee range before Shadow Laceration hits to avoid the DoT. When Twilight Crash is cast, move away from your position — Garand leaps to where you were standing.",
                notes = {
                    { role = "general",   text = "Step out of melee range before Shadow Laceration hits to avoid the bleed DoT." },
                    { role = "general",   text = "Move away from your position after Twilight Crash is cast — Garand leaps to your location." },
                },
            },
            {
                encounterID = 3404,
                name        = "Voidscorned Vagrant",
                tip         = "Interrupt Terrifying Power — fears everyone and deals damage. Sidestep Void Eruption zones.",
                notes = {
                    { role = "interrupt", text = "Terrifying Power — fears everyone and deals damage." },
                    { role = "general",   text = "Sidestep Void Eruption zones." },
                },
            },
        },
    },
    {
        instanceID = 2952,
        uiMapID    = 0,  -- TODO: verify in-game
        name       = "The Shadow Enclave",
        location   = "Eversong Woods",
        season     = "midnight",
        type       = "delve",
        mythicPlus = false,
        bosses = {
            {
                encounterID = 3368,
                name        = "Lord Antenorian",
                tip         = "Interrupt Shadow Bolt on cooldown. During Shadowveil Annihilation, Antenorian is immune — kill all three Shadow Orbs before the channel ends to break his shield and increase his damage taken.",
                notes = {
                    { role = "interrupt", text = "Shadow Bolt — priority interrupt, do not let casts land." },
                    { role = "dps",       text = "During Shadowveil Annihilation, kill all three Shadow Orbs before the channel ends — breaks his immunity and increases his damage taken." },
                },
            },
        },
    },
    {
        instanceID = 2953,
        uiMapID    = 0,  -- TODO: verify in-game (Parhelion Plaza activates week of March 31, 2026)
        name       = "Parhelion Plaza",
        location   = "Isle of Quel'Danas",
        season     = "midnight",
        type       = "delve",
        mythicPlus = false,
        bosses = {
            {
                encounterID = 3307,
                name        = "Gladius Slaurna",
                tip         = "Kill Sacrificial Voidcallers before Devouring Nova fires — each add consumed grants Slaurna a permanent 10% damage buff. Keep boss away from platform edges — Devouring Nova knockback near edges is lethal. Interrupt Void Bolt on the adds. Dodge Voidscar Raze line attack.",
                notes = {
                    { role = "dps",       text = "Kill Sacrificial Voidcallers before Devouring Nova fires — each add consumed grants Slaurna a permanent 10% damage buff." },
                    { role = "general",   text = "Keep boss away from platform edges — Devouring Nova has a knockback; near edges it kills." },
                    { role = "interrupt", text = "Void Bolt on Sacrificial Voidcallers." },
                    { role = "general",   text = "Dodge Voidscar Raze directional line attack." },
                },
            },
        },
    },
    {
        instanceID = 2961,
        uiMapID    = 0,  -- TODO: verify in-game
        name       = "Twilight Crypts",
        location   = "Zul'Aman",
        season     = "midnight",
        type       = "delve",
        mythicPlus = false,
        bosses = {
            {
                encounterID = 3360,
                name        = "Blademaster Darza",
                tip         = "Stay in close melee range to prevent Dark Pursuit. Sidestep Shade Cleave cone. Reposition Darza out of Bask in the Twilight void zones — she gains 30% increased damage while standing in them.",
                notes = {
                    { role = "general",   text = "Stay in close melee range — proximity prevents Dark Pursuit." },
                    { role = "general",   text = "Sidestep Shade Cleave cone." },
                    { role = "general",   text = "Reposition Darza out of Bask in the Twilight void zones — she gains 30% increased damage while standing in them." },
                },
            },
        },
    },
    {
        instanceID = 2962,
        uiMapID    = 0,  -- TODO: verify in-game
        name       = "Atal'Aman",
        location   = "Zul'Aman",
        season     = "midnight",
        type       = "delve",
        mythicPlus = false,
        bosses = {
            {
                -- Three encounterIDs — one per event variant (Ritual Interrupted, Toadly Unbecoming, Totem Annihilation)
                encounterID     = 3433,
                altEncounterIDs = { 3434, 3435 },
                name            = "Spiritflayer Jin'Ma",
                tip             = "Collect spirits from Flaying Knife — each gives a 10% damage buff. Prioritise spirits inside Raging Spirits zones before they are destroyed. Collect all before Claim Spirits completes — each uncollected spirit gives Jin'Ma a stacking damage buff.",
                notes = {
                    { role = "general",   text = "Collect spirits spawned by Flaying Knife — each gives a 10% damage buff. Prioritise spirits inside Raging Spirits zones first." },
                    { role = "general",   text = "Collect all spirits before Claim Spirits completes — each uncollected spirit gives Jin'Ma a stacking damage buff." },
                },
            },
        },
    },
    {
        instanceID = 3003,
        uiMapID    = 0,  -- TODO: verify in-game
        name       = "The Darkway",
        location   = "Zul'Aman",
        season     = "midnight",
        type       = "delve",
        mythicPlus = false,
        bosses = {
            {
                encounterID = 3361,
                name        = "Infiltrator Gulkat",
                tip         = "Interrupt Twilight Seekers. Dodge Abyssal Burst cone frontal. Keep distance from Illusory Deceit illusions before they explode.",
                notes = {
                    { role = "interrupt", text = "Twilight Seekers." },
                    { role = "general",   text = "Dodge Abyssal Burst cone frontal." },
                    { role = "general",   text = "Keep distance from Illusory Deceit illusions before they explode." },
                },
            },
        },
    },
    {
        instanceID = 2963,
        uiMapID    = 0,  -- TODO: verify in-game
        name       = "The Grudge Pit",
        location   = "Harandar",
        season     = "midnight",
        type       = "delve",
        mythicPlus = false,
        bosses = {
            {
                encounterID = 3364,
                name        = "Brightthorn",
                tip         = "Interrupt Thorn Burst — heavy single-target hit. Turn away before Binding Burst resolves to avoid disorientation. Tank near arena edges — Solar Charge leaves puddles; hitting a wall minimizes space loss.",
                notes = {
                    { role = "interrupt", text = "Thorn Burst — heavy single-target hit." },
                    { role = "general",   text = "Turn away before Binding Burst resolves to avoid disorientation." },
                    { role = "general",   text = "Tank near arena edges — Solar Charge leaves persistent puddles; hitting a wall minimizes space loss." },
                },
            },
            {
                encounterID = 3363,
                name        = "Gyrospore",
                tip         = "Fungistorm: kite the boss near arena edges while it chases you — after it ends boss is dizzy (25% increased damage taken); save DPS CDs for this window. Sidestep Fungal Charge.",
                notes = {
                    { role = "general",   text = "Fungistorm: boss chases a player while whirlwinding — kite near arena edges to save space." },
                    { role = "dps",       text = "After Fungistorm ends, boss is dizzy (25% increased damage taken) — save DPS CDs for this window." },
                    { role = "general",   text = "Sidestep Fungal Charge." },
                },
            },
            {
                encounterID = 3362,
                name        = "Mycomight",
                tip         = "Rancid Rain: move to arena edges to drop poison clouds away from centre. The Fungi's Fist: dodge the slam and all 5 projectiles — being hit stuns for 3s. Fling Chair: sidestep to avoid knockback and disorientation. No interrupts — pure positioning fight.",
                notes = {
                    { role = "general",   text = "Rancid Rain: move to arena edges to drop poison clouds away from the centre." },
                    { role = "general",   text = "The Fungi's Fist: dodge the slam and all 5 projectiles — being hit stuns for 3s." },
                    { role = "general",   text = "Fling Chair: sidestep to avoid knockback and disorientation." },
                },
            },
        },
    },
    {
        instanceID = 2964,
        uiMapID    = 0,  -- TODO: verify in-game
        name       = "Gulf of Memory",
        location   = "Harandar",
        season     = "midnight",
        type       = "delve",
        mythicPlus = false,
        bosses = {
            {
                encounterID = 3416,
                name        = "Lumenia",
                tip         = "Kill Command Light adds before they reach you — kite them through floor zones to stun them. Turn away from Lumenia's circles before they activate to avoid disorientation. Defensive for Malignant Gleam.",
                notes = {
                    { role = "dps",       text = "Kill Command Light adds before they reach you — kite them through floor zones to stun them." },
                    { role = "general",   text = "Turn away from Lumenia's ground circles before they activate to avoid disorientation." },
                    { role = "general",   text = "Defensive for Malignant Gleam — holy damage hit." },
                },
            },
            {
                encounterID = 3359,
                name        = "Mul'tha'ul",
                tip         = "Interrupt Hopelessness every cast — curse that reduces Haste and Movement Speed; dispel if possible. Tear It Down: tentacles slam after a short delay — reposition to avoid. Unanswered Call fixates a player for 8s — kite the boss away immediately.",
                notes = {
                    { role = "general",   text = "Tear It Down: tentacles slam after a short delay — keep moving to avoid the impact." },
                    { role = "general",   text = "Unanswered Call fixates a player for 8s — use a movement ability to kite the boss away." },
                    { role = "healer",    text = "Dispel Hopelessness if missed — curse reducing Haste and Movement Speed on all players." },
                    { role = "interrupt", text = "Hopelessness — every cast; reduced movement speed combined with fixate is lethal at higher tiers." },
                },
            },
        },
    },
    {
        instanceID = 2965,
        uiMapID    = 0,  -- TODO: verify in-game
        name       = "Sunkiller Sanctum",
        location   = "Harandar",
        season     = "midnight",
        type       = "delve",
        mythicPlus = false,
        bosses = {
            {
                encounterID = 3398,
                name        = "Esuritus",
                tip         = "Interrupt Calling Bolt to prevent Voidcaller spawns. Dodge Crushing Rift — being hit spawns 4 Voidcallers. Kill all Voidcallers before Gorge — each consumed gives Esuritus a damage buff. Interrupt their Commune with the Void channel.",
                notes = {
                    { role = "interrupt", text = "Calling Bolt — spawns a Voidcaller if it lands." },
                    { role = "general",   text = "Dodge Crushing Rift — being hit spawns 4 Voidcallers at once." },
                    { role = "dps",       text = "Kill all Voidcallers before Gorge — each consumed gives Esuritus a damage buff. Interrupt their Commune with the Void channel." },
                },
            },
        },
    },
    {
        instanceID = 2979,
        uiMapID    = 0,  -- TODO: verify in-game
        name       = "Shadowguard Point",
        location   = "Voidstorm",
        season     = "midnight",
        type       = "delve",
        mythicPlus = false,
        bosses = {
            {
                encounterID = 3365,
                name        = "Chief-Arcanist Patram",
                tip         = "Interrupt Submit to the Void — stacking magic DoT. Kill the Dark Harbinger before Dark Prayer finishes — success grants you 20% Versatility + 30% CDR; failure gives Patram a damage buff. Dodge Discordant Hymn void zones.",
                notes = {
                    { role = "interrupt", text = "Submit to the Void — stacking magic DoT." },
                    { role = "dps",       text = "Kill the Dark Harbinger before Dark Prayer finishes (15s) — success grants 20% Versatility + 30% CDR; failure gives Patram a damage buff." },
                    { role = "general",   text = "Dodge Discordant Hymn void zones — heavy damage if caught." },
                },
            },
        },
    },

    {
        instanceID = 1209,  -- confirmed in-game
        uiMapID    = 601,   -- confirmed in-game
        altMapIDs  = { 602 },  -- upper tier; confirmed in-game
        name       = "Skyreach",
        location   = "Spires of Arak",
        season     = "legacy",
        type       = "max",
        mythicPlus = true,
        bosses = {
            {
                encounterID = 1698,  -- confirmed in-game
                npcID       = 75964,
                name        = "Ranjit",
                tip         = "Fan of Blades: 360° attack applying a bleed to all players — healers use cleanses if available. Dodge Wind Chakram and the Chakram Vortex tornadoes it creates. Gale Surge: bait wind orbs away from your path — knockback near edges is lethal.",
                notes = {
                    { role = "general",   text = "Fan of Blades: 360° attack applying a bleed to all players." },
                    { role = "healer",    text = "Fan of Blades bleeds all players — use cleanses if available." },
                    { role = "general",   text = "Dodge Wind Chakram and the Chakram Vortex tornadoes it spawns." },
                    { role = "general",   text = "Gale Surge: bait wind orbs away from your path — knockback near platform edges is lethal." },
                    { role = "dps",       text = "Soothe Raging Squalls adds to remove Wrathful Wind and reduce party-wide damage." },
                },
            },
            {
                encounterID = 1699,  -- confirmed in-game
                npcID       = 76141,
                name        = "Araknath",
                tip         = "Tank stays in melee range to prevent Blast Wave. Non-tanks intercept Energize beams from Lesser Constructs using defensives — prevents boss buff; 12s later dodge Heart Exhaustion frontal. Tank: point Fiery Smash away from beam-interceptors. Avoid Defensive Protocol — the 5-yard AoE beneath the boss. Group defensives for Supernova if any Energize beam reached the boss.",
                notes = {
                    { role = "tank",      text = "Stay in melee range to prevent Blast Wave; point Fiery Smash away from players intercepting beams." },
                    { role = "general",   text = "Intercept Energize beams from Lesser Constructs using defensives — prevents boss buff. 12s later dodge Heart Exhaustion frontal." },
                    { role = "general",   text = "Move away from Defensive Protocol — the 5-yard AoE beneath the boss." },
                    { role = "healer",    text = "Group defensives for Supernova if any Energize beam reached the boss (i.e., a beam went unblocked)." },
                },
            },
            {
                encounterID = 1700,  -- confirmed in-game
                npcID       = 76379,
                name        = "Rukhran",
                tip         = "Swap to Sunwing adds (Sunbreak/Burning Pursuit) and kill them away from eggs — adds killed on eggs respawn. Searing Quills: all players hide behind the central pillar, then return immediately. Tank: stay in melee range except during Searing Quills; defensive for every Burning Claws.",
                notes = {
                    { role = "dps",       text = "Swap to Sunwing adds from Sunbreak/Burning Pursuit — kill them away from eggs or they respawn." },
                    { role = "general",   text = "Searing Quills: hide behind the central pillar — return to boss immediately after." },
                    { role = "tank",      text = "Stay in melee range except during Searing Quills. Defensive for every Burning Claws cast." },
                },
            },
            {
                encounterID = 1701,  -- confirmed in-game
                npcID       = 76266,
                name        = "High Sage Viryx",
                tip         = "Scorching Ray targets 3 players each turn — healers monitor for repeated targets and use defensives. Cast Down drags a player toward the edge — targeted player runs toward entrance to maximize distance; group swaps to the mob and stuns immediately. Lens Flare: chasing beam — run to platform sides using movement cooldowns. Interrupt Solar Blast to reduce tank damage.",
                notes = {
                    { role = "general",   text = "Cast Down drags a player toward the edge — run toward entrance; group stuns the mob immediately." },
                    { role = "general",   text = "Lens Flare: chasing beam — run to platform sides using movement cooldowns." },
                    { role = "healer",    text = "Scorching Ray targets 3 players each turn — monitor for repeated targets and use defensives." },
                    { role = "interrupt", text = "Solar Blast — reduces tank damage." },
                },
            },
        },
        trash = {
            { npcID = 79303, name = "Adorned Bladetalon",    tip = "CC immune. Always focus this mob first. Blade Rush ALWAYS ends on the tank — applies a 20s armor reduction AND a bleed; use a defensive immediately. The armor debuff combos lethally with other damage in the pull. Watch for Blade Rush overlapping with other abilities." },
            { npcID = 0,     name = "Solar Elemental",       tip = "CC immune. Swap to the Solar Orb immediately and destroy it. Avoid Solar Fire circles." },
            { npcID = 78932, name = "Driving Gale-Caller",   tip = "Interrupt Repel every cast." },
            { npcID = 0,     name = "Adept of the Dawn",     tip = "Fiery Talon applies a fire DoT on every melee — manage with CC or kiting if the DoT stacks too high. Rotate defensives on prolonged fights." },
            { npcID = 79462, name = "Blinding Sun Priestess", tip = "Interrupt Blinding Light — disorients all players." },
        },
        areas = {
            -- "Grand Spire" appears on both mapID 601 (Araknath) and 602 (High Sage Viryx).
            -- mapID=602 entry must come first — it matches only on that specific map.
            -- The subzone-only entry below it catches mapID 601 without ambiguity.
            { mapID = 602,                    bossIndex = 4 },  -- High Sage Viryx; confirmed in-game
            { subzone = "Lower Quarter",      bossIndex = 1 },  -- Ranjit; confirmed in-game
            { subzone = "Grand Spire",        bossIndex = 2 },  -- Araknath (mapID 601); confirmed in-game
            { subzone = "The Overlook",       bossIndex = 3 },  -- Rukhran; confirmed in-game
        },
    },

    -- --------------------------------------------------------
    -- MIDNIGHT SEASON 1 RAID — Three wings, same season
    -- instanceIDs: Voidspire + Dreamrift confirmed in-game; March on Quel'Danas from BigWigs (unverified).
    -- encounterIDs: Voidspire + Dreamrift confirmed in-game; March on Quel'Danas from BigWigs (unverified).
    -- uiMapIDs: Voidspire + Dreamrift confirmed in-game; March on Quel'Danas still 0 (TODO: verify).
    -- Mechanic data from BigWigs Lua + Wowhead + method.gg (pre-launch sourcing).
    -- --------------------------------------------------------

    -- Wing 1: The Voidspire (6 bosses)
    {
        instanceID = 2912,  -- confirmed in-game
        uiMapID    = 2529,  -- confirmed in-game
        altMapIDs  = { 2530 },  -- The Bazaar (entrance); confirmed in-game
        name       = "The Voidspire",
        location   = "Quel'Thalas",
        season     = "midnight",
        type       = "raid",
        mythicPlus = false,
        areas = {
            { subzone = "The Approach",        bossIndex = 1 },  -- Imperator Averzian; confirmed in-game
            { subzone = "Behemoth's Rise",     bossIndex = 2 },  -- Vorasius; confirmed in-game
            { subzone = "The Riftlabs",        bossIndex = 3 },  -- Fallen-King Salhadaar; confirmed in-game
            { subzone = "Devouring Stronghold", bossIndex = 4 }, -- Vaelgor & Ezzorak approach corridor; confirmed in-game (fight room has no subzone)
            { subzone = "Celestial Orrery",    bossIndex = 6 },  -- Crown of the Cosmos approach corridor; confirmed in-game (fight room has no subzone)
        },
        bosses = {
            {
                encounterID = 3176,  -- confirmed in-game
                npcID       = 240435,
                name        = "Imperator Averzian",
                tip         = "Stack to soak Umbral Collapse near Abyssal Voidshapers — soaking near a voidshaper blocks its tile claim. 3 adjacent claimed tiles triggers March of the Endless (wipe). Avoid claimed tiles — boss gains near-immunity (Imperator's Glory) near them. Tanks: Blackening Wounds stacks reduce max HP and draw adds — swap before stacks peak.",
                notes = {
                    { role = "general",   text = "Stack to soak Umbral Collapse near Abyssal Voidshapers — blocks their tile claim. 3 adjacent tiles triggers March of the Endless." },
                    { role = "general",   text = "Avoid claimed tiles — Imperator's Glory grants near-immunity near claimed territory. Dodge Oblivion's Wrath ground zones." },
                    { role = "dps",       text = "Kill Abyssal Voidshapers before 100 energy — at max energy they transform into Obsidian Endwalkers (permanent, empowered)." },
                    { role = "tank",      text = "Swap on Blackening Wounds — stacks reduce max HP and the highest-stack tank draws adds." },
                    { role = "interrupt", text = "Pitch Bulwark from Stalwart/Annihilator adds. Kill Voidmaws before 35% HP — below that threshold they flee to portals for healing." },
                },
            },
            {
                encounterID = 3177,  -- confirmed in-game
                npcID       = 240434,
                name        = "Vorasius",
                tip         = "Dodge Void Breath — identify which hand fires and run the opposite direction; walls must be broken first to open escape lanes. Kill Blistercreep adds near crystal walls — Blisterburst destroys walls but leaves a 30s +50% shadow damage taken debuff; avoid taking Void Breath while debuffed. Aftershock expanding rings: melee step into the slam crater (safe zone). Primordial Roar pulls in then knocks back — brace with a personal. Tanks: Tank 1 intentionally takes 2 Shadowclaw Slam stacks (Smashed = 150% phys damage taken), then swap; wait for Smashed to fall off before swapping back.",
                notes = {
                    { role = "general",   text = "Void Breath: identify which hand initiates and run the opposite direction — walls must already be broken to have escape space." },
                    { role = "general",   text = "Kill Blistercreep adds near walls — Blisterburst destroys walls (melee left, ranged right) but applies a 30s +50% shadow damage debuff; avoid Void Breath while debuffed." },
                    { role = "general",   text = "Aftershock: expanding rings from slam impact — melee step into the crater immediately (origin is safe zone)." },
                    { role = "general",   text = "Primordial Roar pulls in then knocks back — brace with a personal. Primordial Power stacks up — healing pressure escalates." },
                    { role = "healer",    text = "Dispel Parasite (magic debuff) promptly." },
                    { role = "tank",      text = "Tank 1 intentionally takes 2 Shadowclaw Slam stacks (Smashed = 150% phys damage taken), then swap. Tank 2 holds until Smashed falls off." },
                },
            },
            {
                encounterID = 3179,  -- confirmed in-game
                npcID       = 240432,
                name        = "Fallen-King Salhadaar",
                tip         = "Intercept Void Convergence orbs — boss absorbing one (Void Infusion) wipes the raid. Kill first orb, then wait for Dark Radiation DoT to fall off the raid before killing the second. At 100 energy: Entropic Unraveling — dodge rotating beams; boss takes 25% increased damage for 20s. Interrupt Shadow Fracture from Fractured Images. Tanks: swap on Destabilizing Strikes; aim Shattering Twilight away from the raid.",
                notes = {
                    { role = "general",   text = "Intercept Void Convergence orbs — boss absorbing one (Void Infusion) wipes the raid." },
                    { role = "general",   text = "Kill first orb, then wait for Dark Radiation DoT to fall off the raid before killing the second." },
                    { role = "general",   text = "Despotic Command: place timed puddle circles at room edges." },
                    { role = "dps",       text = "At 100 energy: Entropic Unraveling — dodge rotating beams; boss takes 25% increased damage for 20s. Use cooldowns and Bloodlust here." },
                    { role = "healer",    text = "Dispel Twisting Obscurity (magic DoT) — it jumps between players." },
                    { role = "tank",      text = "Swap on Destabilizing Strikes stacks. Aim Shattering Twilight arrows away from raid and boss." },
                    { role = "interrupt", text = "Shadow Fracture cast by Fractured Images adds." },
                },
            },
            {
                encounterID = 3178,  -- confirmed in-game
                npcID       = 242056,
                altNpcIDs   = { 244552 },  -- Ezzorak
                name        = "Vaelgor & Ezzorak",
                tip         = "Keep both within 10% HP and within 15 yards — Twilight Bond gives 100% increased damage if either condition fails. Don't stand behind either boss — Tail Lash knockback. Vaelgor: Dread Breath fears — targeted player steps to the side, then dispel. Gloom (Ezzorak): 5 players soak; soakers gain a 1-min debuff — rotate groups. Midnight Flames intermission: stack in Radiant Barrier; kill Manifestation of Midnight. Tanks: Nullbeam (Vaelgor) is intentional — stack ~8 stacks then reposition. Swap on Vaelwing and Rakfang (Ezzorak — Impale stuns).",
                notes = {
                    { role = "general",   text = "Keep both within 10% HP and within 15 yards — Twilight Bond: 100% increased damage if either condition fails." },
                    { role = "general",   text = "Don't stand behind either boss — Tail Lash knockback." },
                    { role = "general",   text = "Dread Breath (Vaelgor): targeted player steps to the side, face away from raid — dispel the fear." },
                    { role = "general",   text = "Gloom (Ezzorak): 5 players soak to shrink the puddle — soakers gain a 1-min debuff; rotate soak groups." },
                    { role = "healer",    text = "Midnight Flames intermission: stack in Radiant Barrier; kill Manifestation of Midnight before it empowers the dragons." },
                    { role = "tank",      text = "Nullbeam (Vaelgor): intentional soak — stack ~8 stacks then reposition. Swap on Vaelwing (Vaelgor) and Rakfang (Ezzorak — Impale stuns)." },
                    { role = "interrupt", text = "Voidbolt from Voidorbs (spawned by Void Howl) — Mass Grip, stun, or interrupt; free casts deal heavy sustained damage." },
                },
            },
            {
                encounterID = 3180,  -- confirmed in-game
                npcID       = 240431,
                altNpcIDs   = { 240437, 240438 },  -- Lightblood, Senn
                name        = "Lightblinded Vanguard",
                tip         = "Three paladins: Bellamy (Devotion), Venel (Wrath), Senn (Peace). At 100 energy: boss applies aura buffing the other two — pull boss to edge; consecration drops when aura ends. Execution Sentence: each marked player forms their own separate stack — do NOT merge circles. Senn: burn Sacred Shield then interrupt Blinding Light. Tanks: swap immediately after Judgment lands (follow-up hits 200% harder).",
                notes = {
                    { role = "general",   text = "Aura order: Bellamy → Venel → Senn. Each aura buffs the other two — tank the near-100-energy boss to the arena edge." },
                    { role = "general",   text = "Do NOT attack inside Aura of Devotion (75% damage reduction) or Aura of Peace (pacifies attackers)." },
                    { role = "general",   text = "Execution Sentence: each marked player needs their own separate stack — do NOT merge the circles." },
                    { role = "general",   text = "Senn: burn Sacred Shield fast, then interrupt Blinding Light — missed interrupt = raid-wide disorientation." },
                    { role = "tank",      text = "Swap immediately after Judgment lands — the follow-up hit deals 200% more damage." },
                },
            },
            {
                encounterID = 3181,  -- confirmed in-game
                npcID       = 240430,
                altNpcIDs   = { 243805, 243810, 243811 },  -- Morium, Demiar, Vorelus
                name        = "Crown of the Cosmos",
                tip         = "Stage 1: kill Undying Sentinels in order — Demiar first, Vorelus second, Morium last. Silverstrike Arrow makes Sentinels vulnerable — take the arrow to damage them. Keep each within 25 yd of its void portal or it teleports. Devouring Cosmos = 99% healing reduction — move out immediately. Destroy Rift Simulacrum (Stage 2) — reduces Alleria's damage taken. Kill Undying Voidspawn before 100 energy. Tanks: Rift Slash stacks reduce all stats — swap proactively. Healers: heal through Null Corona absorbs — dispelling jumps the absorb to a new player.",
                notes = {
                    { role = "general",   text = "Stage 1: kill Sentinels in order — Demiar, Vorelus, Morium. Silverstrike Arrow makes them vulnerable — take the arrow." },
                    { role = "general",   text = "Keep each Sentinel within 25 yd of its void portal or it teleports." },
                    { role = "general",   text = "Devouring Cosmos = 99% healing reduction zone — move out immediately." },
                    { role = "dps",       text = "Kill Undying Voidspawn before 100 energy — at max energy gains CC immunity and 500% damage. Stage 2: destroy Rift Simulacrum — reduces Alleria's damage taken while active." },
                    { role = "tank",      text = "Rift Slash stacks reduce all stats by 10% per stack (20s) — swap before stacks cripple mitigation." },
                    { role = "healer",    text = "Heal through Null Corona absorbs — dispelling jumps the absorb to a new player. Heavy healing during Devouring Cosmos." },
                    { role = "interrupt", text = "Void Barrage from Voidspawn adds. Tremor from Demiar (sentinel add)." },
                },
            },
        },
    },

    -- Wing 2: March on Quel'Danas (2 bosses)
    {
        instanceID = 2913,  -- BigWigs Midnight/MarchOnQuelDanas/; unverified in-game
        uiMapID    = 0,     -- TODO: verify in-game
        name       = "March on Quel'Danas",
        location   = "Isle of Quel'Danas",
        season     = "midnight",
        type       = "raid",
        mythicPlus = false,
        areas = {
            { subzone = "Court of the Phoenix", bossIndex = 1 },  -- Belo'ren; sourced from warcraft.wiki.gg; verify in-game
            { subzone = "The Darkwell",          bossIndex = 2 },  -- Midnight Falls; sourced from warcraft.wiki.gg; verify in-game
        },
        bosses = {
            {
                encounterID = 3182,  -- BigWigs; unverified in-game
                npcID       = 240387,
                name        = "Belo'ren, Child of Al'ar",
                tip         = "You receive Light or Void feather — soak only matching-color dives, intercept matching-color quills; wrong color = severe debuff. Embers: kill the Ember add, then immediately hard-swap to its egg. Interrupt Light/Void Eruption — matching-color players only. Stage 2 (Ashen Shell): use Heroism here; burn the egg before the 30s rebirth timer. Each rebirth stacks Ashen Benediction (10% healing reduction).",
                notes = {
                    { role = "general",   text = "You receive Light or Void feather — only soak matching-color dives and intercept matching-color quills. Cross-color exposure = severe debuff." },
                    { role = "general",   text = "Embers: kill the Ember add first, then immediately hard-swap to its egg and destroy it." },
                    { role = "interrupt", text = "Light/Void Eruption from Embers — only matching-color players can interrupt." },
                    { role = "dps",       text = "Stage 2: use Heroism; burn the egg before the 30s rebirth timer. Each Ashen Benediction stack = 10% healing reduction." },
                    { role = "healer",    text = "Burning Heart pulses every 3s; doubles during egg phase. Each Ashen Benediction stack reduces healing 10%." },
                },
            },
            {
                encounterID = 3183,  -- BigWigs; unverified in-game
                npcID       = 240391,
                name        = "Midnight Falls",
                tip         = "Grim Symphony: boss flashes 4 symbols in sequence, then marks 4 players with those symbols — marked players must line up left-to-right in the exact order the symbols were shown or it triggers Dissonance (heavy damage). Destroy Midnight Crystals before they explode (Cosmic Fracture). Heal Dusk Crystals to create Dawn Crystals — Torchbearers carry them for a 12-yd aura and Dawnlight Barrier (99% DR, 6s). Intermission: dodge Extinction Rays reflecting off Oblivion's Mirrors.",
                notes = {
                    { role = "general",   text = "Grim Symphony: boss flashes 4 symbols, then marks 4 players — line up left-to-right in the exact order the symbols were shown; wrong order = Dissonance (heavy damage)." },
                    { role = "general",   text = "Destroy Midnight Crystals before they detonate (Cosmic Fracture — massive AoE + DoT)." },
                    { role = "general",   text = "Heal Dusk Crystals to Dawn Crystals; Torchbearers provide 12-yd protective aura and Dawnlight Barrier (99% DR dome, 6s)." },
                    { role = "general",   text = "Intermission: dodge Extinction Rays reflecting off Oblivion's Mirrors." },
                },
            },
        },
    },

    -- Wing 3: The Dreamrift (1 boss)
    {
        instanceID = 2939,  -- confirmed in-game
        uiMapID    = 2531,  -- confirmed in-game
        altMapIDs  = { 2532 },  -- Den of the Undreamt; confirmed in-game
        name       = "The Dreamrift",
        location   = "The Dreamrift",
        season     = "midnight",
        type       = "raid",
        mythicPlus = false,
        areas = {
            { subzone = "Den of the Undreamt", bossIndex = 1 },  -- Chimaerus; confirmed in-game
        },
        bosses = {
            {
                encounterID = 3306,  -- confirmed in-game
                npcID       = 245569,
                name        = "Chimaerus the Undreamt God",
                tip         = "Alndust Upheaval targets the tank — split into two groups to alternate soaks; soaked group gains Alnsight (40s) and must break Alnshroud shields on Manifestations; then they get Rift Vulnerability (90s) — can't soak again. Manifestations reaching the boss = massive damage + full heal + 100% damage buff. Rending Tear — frontal cone; sidestep immediately. Dispel Consuming Miasma while standing near ground puddles to remove both. Intermission (To the Skies): dodge Corrupted Devastation breath lines; kill all Manifestations before Ravenous Dive.",
                notes = {
                    { role = "general",   text = "Alndust Upheaval targets the tank — two groups alternate soaks. Soaked group gains Alnsight (40s): only they can break Alnshroud shields on Manifestations. After Alnsight expires, they gain Rift Vulnerability (90s) — cannot re-soak." },
                    { role = "general",   text = "Manifestations must never reach the boss — Insatiable: raid damage + 200% HP heal + 100% damage buff per add eaten." },
                    { role = "general",   text = "Rending Tear — frontal cone; sidestep immediately to avoid the bleed." },
                    { role = "healer",    text = "Dispel Consuming Miasma (player debuff) while standing near ground puddles — dispelling removes the puddle. Avoid stacking dispel splash." },
                    { role = "general",   text = "Intermission (To the Skies): dodge Corrupted Devastation breath lines; all Manifestations must die before Ravenous Dive." },
                    { role = "interrupt", text = "Fearsome Cry and Essence Bolt from Colossal Horror adds (Haunting Essence channel)." },
                },
            },
        },
    },
}

-- ============================================================
-- M+ Affix Data
-- ============================================================
-- tip fields: concise strategic callouts for the HUD.
-- Affixes not listed here fall back to C_ChallengeMode.GetAffixInfo() description.
-- IDs are stable across expansions. Season 1 specific affix IDs should be added
-- once confirmed in-game via keystoneLog.
KwikTip.AFFIXES = {
    [3]   = { name = "Volcanic",     tip = "Volcanic plumes erupt under players — move immediately; never stand still while casting." },
    [6]   = { name = "Raging",       tip = "Trash enrages at 30% HP — use Enrage dispels or kite; save a defensive for the enrage window." },
    [7]   = { name = "Bolstering",   tip = "Nearby trash gains 20% HP when any mob dies — stagger kills; never let multiple mobs die simultaneously." },
    [8]   = { name = "Sanguine",     tip = "Dead trash leaves healing pools — tank kite surviving mobs out of pools immediately." },
    [9]   = { name = "Tyrannical",   tip = "Bosses have 30% more HP and deal 15% more damage. Save major CDs for bosses." },
    [10]  = { name = "Fortified",    tip = "Trash has 20% more HP and deals 30% more damage. Control pull size carefully." },
    [11]  = { name = "Bursting",     tip = "Trash explodes on death — stagger kills and dispel Burst stacks; never chain-kill multiple mobs." },
    [12]  = { name = "Grievous",     tip = "Grievous Wound stacks during combat — heal players to full to remove; dispel early." },
    [13]  = { name = "Explosive",    tip = "Explosive Orbs spawn during combat — kill within 6s or they deal lethal group damage." },
    [14]  = { name = "Quaking",      tip = "Quake interrupts casters and silences — spread during big pulls to reduce overlap damage." },
    [123] = { name = "Spiteful",     tip = "Spiteful Shades fixate a random player on mob death — CC, kite, or burst before they reach their target." },
    [124] = { name = "Storming",     tip = "Tornadoes move randomly — dodge on sight; contact silences for 3s." },
    [134] = { name = "Entangling",   tip = "Vines root random players — break free immediately; don't let roots lock you in AoE zones." },
    [135] = { name = "Afflicted",    tip = "Afflicted Souls spawn — instantly dispel their Poison, Curse, or Disease; missing reduces healer output for 10s." },
    [136] = { name = "Incorporeal",  tip = "Incorporeal Beings spawn — CC immediately (Banish, Imprison, Freeze, etc.); they reduce all stats while active." },
}

-- Runtime lookups are built in DungeonData_Timewalking.lua, which loads after
-- this file, so that timewalking dungeon entries are included in all tables.
