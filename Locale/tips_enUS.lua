-- Locale/tips_enUS.lua — Empty detection overlay for English locale.
-- Strategy prose is user-authored; these tables retain only the locale-aware
-- names and aliases used by the structural dungeon catalog.
local ADDON_NAME, KwikTip = ...

-- Localized boss names keyed by encounterID.
KwikTip.TIP_OVERRIDE_BY_ENCOUNTERID = KwikTip.TIP_OVERRIDE_BY_ENCOUNTERID or {}

-- Reserved localized trash names keyed by npcID.
KwikTip.TIP_OVERRIDE_BY_NPCID = KwikTip.TIP_OVERRIDE_BY_NPCID or {}

-- Reserved localized area names keyed by stable area ID.
KwikTip.AREA_OVERRIDE_BY_ID = KwikTip.AREA_OVERRIDE_BY_ID or {}

-- Subzone locale aliases: keyed by stable area ID → array of localized subzone strings
KwikTip.SUBZONE_LOCALE_BY_AREA_ID = KwikTip.SUBZONE_LOCALE_BY_AREA_ID or {}
