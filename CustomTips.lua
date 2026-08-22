-- KwikTip_CN: user-authored rich-text tips
--
-- DungeonData.lua remains the source of stable dungeon/area/encounter IDs, but
-- its bundled strategy prose is deliberately removed here.  The HUD only reads
-- text saved by the player in KwikTipCNDB.customTips.
local ADDON_NAME, KwikTip = ...

KwikTip.CUSTOM_TIPS_ONLY = true

local function Trim(text)
    if type(text) ~= "string" then return nil end
    text = text:match("^%s*(.-)%s*$")
    return text ~= "" and text or nil
end

local function DungeonID(dungeon)
    return dungeon and tonumber(dungeon.instanceID) or 0
end

function KwikTip:GetDungeonTipKey(dungeon)
    return "dungeon:" .. tostring(DungeonID(dungeon))
end

function KwikTip:GetBossTipKey(dungeon, boss)
    if boss and boss.encounterID and boss.encounterID ~= 0 then
        return "boss:" .. tostring(boss.encounterID)
    end
    -- A few not-yet-confirmed encounters have encounterID=0.  Use their
    -- position inside the dungeon instead of creating one shared "boss:0" key.
    for index, candidate in ipairs((dungeon and dungeon.bosses) or {}) do
        if candidate == boss then
            return string.format("boss:%d:%d", DungeonID(dungeon), index)
        end
    end
    return nil
end

function KwikTip:GetAreaTipKey(dungeon, area)
    if area and area.id and area.id ~= "" then
        return "area:" .. tostring(area.id)
    end
    for index, candidate in ipairs((dungeon and dungeon.areas) or {}) do
        if candidate == area then
            return string.format("area:%d:%d", DungeonID(dungeon), index)
        end
    end
    return nil
end

function KwikTip:GetCustomTip(key)
    if not key or not KwikTipCNDB or not KwikTipCNDB.customTips then return nil end
    return Trim(KwikTipCNDB.customTips[key])
end

function KwikTip:SetCustomTip(key, text)
    if not key or not KwikTipCNDB then return end
    KwikTipCNDB.customTips = KwikTipCNDB.customTips or {}
    KwikTipCNDB.customTips[key] = Trim(text)
    self._lastContent = nil
end

function KwikTip:GetCustomBossTip(dungeon, boss)
    return self:GetCustomTip(self:GetBossTipKey(dungeon, boss))
end

function KwikTip:GetCustomAreaTip(dungeon, area)
    return self:GetCustomTip(self:GetAreaTipKey(dungeon, area))
end

function KwikTip:GetCustomDungeonTip(dungeon)
    return self:GetCustomTip(self:GetDungeonTipKey(dungeon))
end

function KwikTip:SetCurrentTipEditTarget(key, label)
    if key then
        self._currentTipEditTarget = { key = key, label = label or key }
    else
        self._currentTipEditTarget = nil
    end
    if self._UpdateNoteBtn then self:_UpdateNoteBtn() end
end

function KwikTip:GetCurrentTipEditTarget()
    return self._currentTipEditTarget
end

-- The editor intentionally lists only the current Mythic+ rotation.  Sorting
-- keeps the menu stable even if DungeonData order changes during an update.
function KwikTip:GetEditableMythicPlusDungeons()
    local result = {}
    for _, dungeon in ipairs(self.DUNGEONS or {}) do
        if dungeon.mythicPlus == true then result[#result + 1] = dungeon end
    end
    table.sort(result, function(a, b)
        return (a.name or "") < (b.name or "")
    end)
    return result
end

function KwikTip:GetTipEditorEntries(dungeon)
    local L = self.L
    local entries = {
        {
            key = self:GetDungeonTipKey(dungeon),
            label = L.EDITOR_DUNGEON_OVERVIEW,
            kind = "dungeon",
            dungeon = dungeon,
        },
    }
    for _, boss in ipairs((dungeon and dungeon.bosses) or {}) do
        local localized = boss.encounterID and self.TIP_OVERRIDE_BY_ENCOUNTERID
            and self.TIP_OVERRIDE_BY_ENCOUNTERID[boss.encounterID]
        local bossName = (localized and localized.name and localized.name ~= "" and localized.name)
            or boss.name or "?"
        entries[#entries + 1] = {
            key = self:GetBossTipKey(dungeon, boss),
            label = string.format(L.EDITOR_BOSS_FMT, bossName),
            kind = "boss",
            dungeon = dungeon,
            boss = boss,
        }
    end
    for index, area in ipairs((dungeon and dungeon.areas) or {}) do
        -- bossIndex areas already render their boss entry, so a second editor
        -- row would be misleading and is intentionally omitted.
        if not area.bossIndex then
            local areaName = area.subzone
            if not areaName or areaName == "" then
                areaName = string.format(L.EDITOR_AREA_NUMBER, index)
            end
            entries[#entries + 1] = {
                key = self:GetAreaTipKey(dungeon, area),
                label = string.format(L.EDITOR_AREA_FMT, areaName),
                kind = "area",
                dungeon = dungeon,
                area = area,
            }
        end
    end
    return entries
end

-- Remove every bundled strategy body while retaining IDs, names, aliases and
-- encounter ordering needed for detection and for the settings editor.
local function ClearLevel(level)
    if not level then return end
    level.tip = nil
    level.notes = nil
end

for _, dungeon in ipairs(KwikTip.DUNGEONS or {}) do
    for _, boss in ipairs(dungeon.bosses or {}) do
        ClearLevel(boss)
        for _, difficulty in pairs(boss.difficulties or {}) do ClearLevel(difficulty) end
    end
    for _, mob in ipairs(dungeon.trash or {}) do ClearLevel(mob) end
    for _, area in ipairs(dungeon.areas or {}) do ClearLevel(area) end
end

-- Keep localized names and sub-zone aliases, but remove prose supplied by the
-- locale overlays as well.
for _, boss in pairs(KwikTip.TIP_OVERRIDE_BY_ENCOUNTERID or {}) do
    ClearLevel(boss)
    for _, difficulty in pairs(boss.difficulties or {}) do ClearLevel(difficulty) end
end
for _, area in pairs(KwikTip.AREA_OVERRIDE_BY_ID or {}) do ClearLevel(area) end
for _, affix in pairs(KwikTip.AFFIXES or {}) do affix.tip = nil end
