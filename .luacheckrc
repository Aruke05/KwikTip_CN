-- luacheck configuration for KwikTip (WoW: Midnight addon)
std = "lua51"

-- Suppress line-length warnings — WoW addon tip strings are intentionally long
max_line_length = false

-- Globals set (assigned) by this addon
globals = {
    "KwikTipDB",      -- SavedVariable; assigned in Init.lua OnLoad
    "SLASH_KWIKTIP1", -- slash command registration
    "SLASH_KWIKTIP2",
    "SlashCmdList",   -- WoW dispatch table; we assign SlashCmdList["KWIKTIP"]
}

-- WoW API globals read by the addon (never assigned at the top level)
read_globals = {
    -- Frame factory & parent
    "CreateFrame",
    "UIParent",
    "Minimap",

    -- Tooltip & color picker
    "GameTooltip",
    "ColorPickerFrame",

    -- Chat / combat
    "InCombatLockdown",
    "SendChatMessage",

    -- Input
    "GetCursorPosition",

    -- Zone / instance detection
    "GetSubZoneText",
    "GetInstanceInfo",
    "IsInInstance",

    -- Unit API
    "UnitName",
    "UnitLevel",
    "UnitClassification",
    "UnitGUID",
    "UnitCanAttack",
    "UnitIsPlayer",

    -- C_* namespace objects
    "C_Map",
    "C_CreatureInfo",
    "C_Spell",
    "C_ChallengeMode",

    -- Role / group API
    "UnitGroupRolesAssigned",

    -- Font objects used as SetFontObject arguments
    "GameFontNormal",

    -- WoW Lua extensions (not in standard lua51)
    "date",

    -- Optional third-party lib
    "LibStub",
}

-- Suppress intentional WoW callback patterns:
--   212/self  — SetScript callbacks receive `self` (the frame) but often don't use it
--   212/frame — same for OnUpdate handlers where the frame arg is unused
--   421/self  — nested SetScript callbacks shadow the outer method's `self`; intentional
--   211/ADDON_NAME — declared in every file via `...` but only consumed in Init.lua
ignore = { "212/self", "212/frame", "432/self", "211/ADDON_NAME" }
