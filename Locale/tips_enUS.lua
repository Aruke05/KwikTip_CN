-- Locale/tips_enUS.lua — Empty tip overlay for English locale.
-- Exists so the TIP_OVERRIDE table is always available (even when empty),
-- preventing nil-reference checks in the runtime lookup path.
-- loading this file initialises the override tables to empty, so
-- GetTipOverride() always returns nil (English default) on enUS clients.
local ADDON_NAME, KwikTip = ...

-- Boss tip overrides: keyed by encounterID
-- Populated by locale overlay files (e.g. tips_deDE.lua) for non-English clients.
KwikTip.TIP_OVERRIDE_BY_ENCOUNTERID = KwikTip.TIP_OVERRIDE_BY_ENCOUNTERID or {}

-- Trash tip overrides: keyed by npcID
KwikTip.TIP_OVERRIDE_BY_NPCID = KwikTip.TIP_OVERRIDE_BY_NPCID or {}

-- Area tip overrides: keyed by stable area ID ("instanceID:areaIndex")
KwikTip.AREA_OVERRIDE_BY_ID = KwikTip.AREA_OVERRIDE_BY_ID or {}

-- Subzone locale aliases: keyed by stable area ID → array of localized subzone strings
KwikTip.SUBZONE_LOCALE_BY_AREA_ID = KwikTip.SUBZONE_LOCALE_BY_AREA_ID or {}