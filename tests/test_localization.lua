-- Run from any working directory with: lua5.1 tests/test_localization.lua
-- Production-path checks for the custom-only rich-text edition.

local PASS, FAIL = 0, 0
local function ok(condition, message)
    if condition then
        PASS = PASS + 1
        io.write("  PASS  ", message, "\n")
    else
        FAIL = FAIL + 1
        io.write("  FAIL  ", message, "\n")
    end
end

local function contains(value, expected)
    return value and value:find(expected, 1, true) ~= nil
end

local source = debug.getinfo(1, "S").source
local testFile = source:sub(1, 1) == "@" and source:sub(2) or source
local testDir = testFile:match("^(.*[/\\])") or "./"
local repoDir = testDir .. ".."
local function loadAddonFile(relative, addon)
    local chunk, err = loadfile(repoDir .. "/" .. relative)
    assert(chunk, err)
    return chunk("KwikTip_CN", addon)
end

local state = {
    instanceID = 2993,
    mapID = 2588,
    instanceName = "测试大秘境",
    difficultyID = 8,
    subzone = "",
}

UIParent = {}
SlashCmdList = {}
GetLocale = function() return "zhCN" end
CreateFrame = function()
    return {
        RegisterEvent = function() end,
        UnregisterEvent = function() end,
        SetScript = function() end,
    }
end
C_Timer = { After = function(_, callback) callback() end }
C_Map = { GetBestMapForUnit = function() return state.mapID end }
C_ChallengeMode = nil
UnitGroupRolesAssigned = function() return "DAMAGER" end
IsInInstance = function() return true, "party" end
GetSubZoneText = function() return state.subzone end
GetInstanceInfo = function()
    return state.instanceName, "party", state.difficultyID,
        "Mythic", 5, 0, false, state.instanceID
end
UnitCanAttack = function() return false end
UnitIsPlayer = function() return false end
date = function() return "test-time" end
print = function() end

local addon = {}
loadAddonFile("Locale/enUS.lua", addon)
loadAddonFile("Locale/Locales.lua", addon)
loadAddonFile("Locale/deDE.lua", addon)
loadAddonFile("Locale/zhCN.lua", addon)
loadAddonFile("Init.lua", addon)
loadAddonFile("DungeonData.lua", addon)
loadAddonFile("DungeonData_Timewalking.lua", addon)
loadAddonFile("Locale/tips_enUS.lua", addon)
loadAddonFile("Locale/tips_deDE.lua", addon)
loadAddonFile("Locale/tips_zhCN.lua", addon)
loadAddonFile("CustomTips.lua", addon)

KwikTipCNDB = {
    showInDungeon = true,
    delves = false,
    notes = {},
    customTips = {},
    mapIDLog = {}, encounterLog = {}, keystoneLog = {}, spellLog = {}, debugSnapshots = {},
}

io.write("\n--- custom-only catalog ---\n")
local editable = addon:GetEditableMythicPlusDungeons()
ok(#editable == 8, "settings catalog contains the eight current Mythic+ dungeons")

local proseFound = false
for _, dungeon in ipairs(addon.DUNGEONS) do
    for _, boss in ipairs(dungeon.bosses or {}) do
        if boss.tip or boss.notes then proseFound = true end
    end
    for _, mob in ipairs(dungeon.trash or {}) do
        if mob.tip or mob.notes then proseFound = true end
    end
    for _, area in ipairs(dungeon.areas or {}) do
        if area.tip or area.notes then proseFound = true end
    end
end
ok(not proseFound, "bundled boss, trash, and area strategy prose is absent")

local dungeon = addon.DUNGEON_BY_INSTANCEID[state.instanceID]
local entries = addon:GetTipEditorEntries(dungeon)
ok(entries[1].key == "dungeon:2993", "editor exposes a stable dungeon-overview key")
ok(#entries == 1 + #dungeon.bosses, "editor exposes overview and every boss for Altar of Fangs")

addon:SetCustomTip(entries[1].key, "  |cffffcc00我的富文本|r  ")
ok(addon:GetCustomDungeonTip(dungeon) == "|cffffcc00我的富文本|r",
    "custom rich text is trimmed, saved, and returned unchanged")
addon:SetCustomTip(entries[1].key, "   ")
ok(addon:GetCustomDungeonTip(dungeon) == nil, "blank editor text clears the saved entry")

local zeroBossDungeon = { instanceID = 9999, bosses = { { encounterID = 0 }, { encounterID = 0 } } }
ok(addon:GetBossTipKey(zeroBossDungeon, zeroBossDungeon.bosses[1]) ~=
   addon:GetBossTipKey(zeroBossDungeon, zeroBossDungeon.bosses[2]),
   "unconfirmed encounter IDs receive distinct fallback keys")

io.write("\n--- production HUD rendering ---\n")
function addon:SetContent(content) self.captured = content end
function addon:UpdateVisibility() end
function addon:InitHUD() end
loadAddonFile("Core.lua", addon)

local boss = dungeon.bosses[1]
addon:OnEncounterStart(boss.encounterID, boss.name, state.difficultyID, 5)
ok(contains(addon.captured, state.instanceName), "empty custom entry still renders the detected header")
ok(not contains(addon.captured, "我的攻略"), "no built-in strategy body is injected")
ok(addon:GetCurrentTipEditTarget().key == addon:GetBossTipKey(dungeon, boss),
    "HUD pencil target follows the currently rendered boss")

addon:SetCustomTip(addon:GetBossTipKey(dungeon, boss),
    "|cffffcc00我的攻略|r\n• 自定义机制")
addon:OnEncounterStart(boss.encounterID, boss.name, state.difficultyID, 5)
ok(contains(addon.captured, "我的攻略"), "saved rich-text boss content reaches the HUD")
ok(contains(addon.captured, "自定义机制"), "multi-line custom content reaches the HUD")

io.write(string.format("\n=== RESULTS: %d passed, %d failed (of %d total) ===\n",
    PASS, FAIL, PASS + FAIL))
if FAIL > 0 then os.exit(1) end
