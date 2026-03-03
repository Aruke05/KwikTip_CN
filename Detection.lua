-- KwikTip: Dungeon detection and HUD content engine
local ADDON_NAME, KwikTip = ...

-- ============================================================
-- Content formatting
-- ============================================================

local GOLD  = "|cffffcc00"
local WHITE = "|cffffffff"
local GRAY  = "|cff999999"
local RESET = "|r"

-- Build the string shown inside the HUD for a known dungeon.
local function FormatDungeonContent(dungeon)
    local lines = {}

    -- Header: dungeon name in gold
    lines[#lines + 1] = GOLD .. dungeon.name .. RESET

    -- Boss list
    for i, boss in ipairs(dungeon.bosses) do
        local entry
        if boss.tip and boss.tip ~= "" then
            entry = string.format("%s%d. %s%s  " .. GRAY .. "%s" .. RESET,
                WHITE, i, boss.name, RESET, boss.tip)
        else
            entry = string.format("%s%d. %s%s", WHITE, i, boss.name, RESET)
        end
        lines[#lines + 1] = entry
    end

    return table.concat(lines, "\n")
end

-- ============================================================
-- Area content
-- ============================================================

-- Build the string shown inside the HUD for a specific area.
-- Falls back to FormatDungeonContent if the player's position doesn't match any area.
local function FormatAreaContent(dungeon, mapID)
    local pos = C_Map.GetPlayerMapPosition(mapID, "player")
    local area
    if pos then
        for _, a in ipairs(dungeon.areas) do
            if pos.x >= a.x1 and pos.x <= a.x2 and pos.y >= a.y1 and pos.y <= a.y2 then
                area = a
                break
            end
        end
    end
    if area then
        return GOLD .. dungeon.name .. RESET .. "\n"
            .. WHITE .. area.name .. RESET .. "\n"
            .. area.tip
    end
    return FormatDungeonContent(dungeon)
end

-- ============================================================
-- Area ticker — polls position every 2 s when in an area-mapped dungeon
-- ============================================================

local areaTicker

local function StartAreaTicker()
    if not areaTicker then
        areaTicker = C_Timer.NewTicker(2, function()
            KwikTip:UpdateContent()
        end)
    end
end

local function StopAreaTicker()
    if areaTicker then
        areaTicker:Cancel()
        areaTicker = nil
    end
end

-- ============================================================
-- Debug position ticker — auto-prints position to chat when the
-- player moves significantly; only active while debugLog is on.
-- Threshold: 0.05 normalised units (~5 % of map width/height).
-- ============================================================

local debugTicker
local _lastLogX, _lastLogY = -1, -1
local DEBUG_DIST_SQ = 0.05 * 0.05  -- compare squared to avoid sqrt

local function StopDebugTicker()
    if debugTicker then
        debugTicker:Cancel()
        debugTicker = nil
    end
    _lastLogX, _lastLogY = -1, -1
end

local function StartDebugTicker()
    if debugTicker then return end
    _lastLogX, _lastLogY = -1, -1
    debugTicker = C_Timer.NewTicker(2, function()
        if not KwikTipDB or not KwikTipDB.debugLog then return end
        local mapID = C_Map.GetBestMapForUnit("player")
        if not mapID then return end
        local pos = C_Map.GetPlayerMapPosition(mapID, "player")
        if not pos then return end
        local dx = pos.x - _lastLogX
        local dy = pos.y - _lastLogY
        if (dx * dx + dy * dy) < DEBUG_DIST_SQ then return end
        _lastLogX, _lastLogY = pos.x, pos.y
        local dungeon = KwikTip.DUNGEON_BY_UIMAPID[mapID]
        print(string.format("|cff00ff00KwikTip|r pos=%.4f, %.4f  %s  mapID=%d",
            pos.x, pos.y,
            dungeon and dungeon.name or "unknown",
            mapID))
    end)
end

-- ============================================================
-- Detection
-- ============================================================

-- Identify the current dungeon and push content to the HUD.
-- Called on zone transitions and login.
function KwikTip:UpdateContent()
    local inInstance, instanceType = IsInInstance()
    if not inInstance or (instanceType ~= "party" and instanceType ~= "raid" and instanceType ~= "scenario") then
        StopAreaTicker()
        StopDebugTicker()
        self:SetContent("")
        return
    end

    local mapID  = C_Map.GetBestMapForUnit("player")
    local dungeon = mapID and KwikTip.DUNGEON_BY_UIMAPID[mapID]

    StartDebugTicker()  -- no-op if already running; ticker body gates on debugLog

    if dungeon then
        if dungeon.areas then
            StartAreaTicker()
            self:SetContent(FormatAreaContent(dungeon, mapID))
        else
            StopAreaTicker()
            self:SetContent(FormatDungeonContent(dungeon))
        end
    else
        StopAreaTicker()
        -- Inside an instance we don't have data for yet.
        self:SetContent(GRAY .. "No data for this instance." .. RESET)
    end
end
