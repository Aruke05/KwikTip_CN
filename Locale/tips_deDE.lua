-- Locale/tips_deDE.lua — German tip prose overrides
-- Loaded after DungeonData.lua tables exist but before Core.lua runs.
-- All overrides keyed by stable numeric Blizzard IDs, never by English display names.
-- Schema matches the lookup table that FormatBossContent/FormatAreaContent reads.
--
-- BOSS OVERRIDE FORMAT:
--   KwikTip.TIP_OVERRIDE_BY_ENCOUNTERID[encounterID] = {
--       tip = "Translated flat tip string (optional, if notes absent)",
--       notes = {
--           { role = "general"|"tank"|"healer"|"dps"|"interrupt", text = "..." },
--       },
--       difficulties = {
--           [difficultyID] = {
--               tip = "Difficulty-specific tip override (optional)",
--               notes = { ... },
--           },
--       },
--   }
--
-- AREA OVERRIDE FORMAT:
--   KwikTip.AREA_OVERRIDE_BY_ID["instanceID:areaIndex"] = {
--       tip = "Translated area tip text",
--   }
--
-- SUBZONE LOCALE ALIAS FORMAT:
--   KwikTip.SUBZONE_LOCALE_BY_AREA_ID["instanceID:areaIndex"] = {
--       "GermanSubzoneName1", "GermanSubzoneName2",
--   }
--
-- NOTE: Field-level fallback is automatic. If a German note exists for
-- "tank" but not for "healer", the "healer" role falls back to English.
-- Difficulty-specific overrides fall back to base override → English.
--

local ADDON_NAME, KwikTip = ...

if GetLocale() ~= "deDE" then return end

-- Ensure the override tables exist (they may be empty on enUS)
if not KwikTip.TIP_OVERRIDE_BY_ENCOUNTERID then
    KwikTip.TIP_OVERRIDE_BY_ENCOUNTERID = {}
end
if not KwikTip.AREA_OVERRIDE_BY_ID then
    KwikTip.AREA_OVERRIDE_BY_ID = {}
end
if not KwikTip.SUBZONE_LOCALE_BY_AREA_ID then
    KwikTip.SUBZONE_LOCALE_BY_AREA_ID = {}
end

-- ============================================================
-- Boss tip overrides — keyed by encounterID
-- Populate as translations are written.
-- ============================================================
local boss = KwikTip.TIP_OVERRIDE_BY_ENCOUNTERID

-- Example (commented out until actual translations exist):
-- boss[3056] = {  -- Emberdawn
--     tip = "Flaming Updraft-Pfützen an den äußeren Rand des Raumes legen; ...",
--     notes = {
--         { role = "general", text = "Flaming Updraft-Pfützen an den äußeren Rand des Raumes legen." },
--         { role = "tank",    text = "Schutzschild für Searing Beak — initialer Treffer + DoT." },
--     },
-- }

-- ============================================================
-- Area tip overrides — keyed by "instanceID:areaIndex"
-- Populate as translations are written.
-- ============================================================
local area = KwikTip.AREA_OVERRIDE_BY_ID

-- Example:
-- area["2805:1"] = {  -- Windrunner Spire, area 1 (The Promenade)
--     tip = "Unterbrecht Geisterbolzen von rastlosen Verwaltern...",
-- }

-- ============================================================
-- Subzone locale aliases — keyed by stable area ID ("instanceID:areaIndex")
-- Makes subzone-based area matching work on non-English clients
-- without mutating the English DungeonData table.
-- Verified German subzone names from WoW client AreaTable.db2.
-- ============================================================
local sz = KwikTip.SUBZONE_LOCALE_BY_AREA_ID

-- Windrunner Spire (instanceID 2805)
sz["2805:1"] = { "Die Promenade" }          -- The Promenade
sz["2805:4"] = { "Königin Sylvanas' Gemächer" }  -- Sylvanas's Quarters
sz["2805:5"] = { "Windrunner-Gruft" }       -- Windrunner Vault
sz["2805:6"] = { "Der Gipfel" }             -- The Pinnacle

-- Murder Row (instanceID 2813)
sz["2813:1"] = { "Silbermond-Tierhandlung" }  -- Silvermoon Pet Shop
sz["2813:2"] = { "Der Illegale Regen" }       -- The Illicit Rain
sz["2813:3"] = { "Terrasse der Auguren" }     -- Augurs' Terrace
sz["2813:4"] = { "Lithiels Anlegestelle" }    -- Lithiel's Landing

-- Den of Nalorakk (instanceID 2825)
sz["2825:1"] = { "Anhaltender Winter" }       -- Enduring Winter
sz["2825:2"] = { "Die Nahrungssuche" }        -- The Foraging
sz["2825:3"] = { "Traumwandler-Passage" }     -- Dreamer's Passage
sz["2825:4"] = { "Das Herz der Wut" }         -- The Heart of Rage

-- Magisters' Terrace (instanceID 2811)
sz["2811:1"] = { "Arkane Bibliothek" }        -- Arcane Atheneum
sz["2811:2"] = { "Beobachtungsgelände" }      -- Observation Grounds
sz["2811:3"] = { "Großmagistrix' Asyl" }      -- Grand Magister Asylum
sz["2811:4"] = { "Turm der Theorie" }         -- Tower of Theory
sz["2811:5"] = { "Konstellarium" }            -- Constellarium
sz["2811:6"] = { "Himmelsorrery" }            -- Celestial Orrery

-- Nexus-Point Xenas (instanceID 2915)
sz["2915:1"] = { "Der Basar" }                -- The Bazaar
sz["2915:2"] = { "Corespark-Triebwerk" }      -- Corespark Engineway
sz["2915:3"] = { "Kernverteidigung Nullfeld" } -- Core Defense Nullward
sz["2915:4"] = { "Der Nexus-Kern" }           -- The Nexus Core