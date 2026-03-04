-- KwikTip: Dungeon detection and HUD content engine
local ADDON_NAME, KwikTip = ...

-- ============================================================
-- Content formatting
-- ============================================================

local GOLD  = "|cffffcc00"
local WHITE = "|cffffffff"
local GRAY  = "|cff999999"
local RESET = "|r"

-- Build the HUD string for an active boss encounter.
local function FormatBossContent(dungeon, boss)
    local header = GOLD .. dungeon.name .. RESET .. "\n" .. WHITE .. boss.name .. RESET
    if boss.tip and boss.tip ~= "" then
        return header .. "\n" .. GRAY .. boss.tip .. RESET
    end
    return header
end

-- Build the HUD string for a trash mob target.
local function FormatTrashContent(dungeon, mob)
    local header = GOLD .. dungeon.name .. RESET .. "\n" .. WHITE .. mob.name .. RESET
    if mob.tip and mob.tip ~= "" then
        return header .. "\n" .. GRAY .. mob.tip .. RESET
    end
    return header
end

-- Build the HUD string for a named area. Returns nil if the player isn't in any defined area.
local function FormatAreaContent(dungeon, mapID)
    local pos = C_Map.GetPlayerMapPosition(mapID, "player")
    if not pos then return nil end
    for _, a in ipairs(dungeon.areas) do
        if pos.x >= a.x1 and pos.x <= a.x2 and pos.y >= a.y1 and pos.y <= a.y2 then
            return GOLD .. dungeon.name .. RESET .. "\n"
                .. WHITE .. a.name .. RESET .. "\n"
                .. a.tip
        end
    end
    return nil
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
-- Debug position ticker — auto-logs position when the player
-- moves significantly (>5% of map width). Gated on debugLog setting.
-- ============================================================

local debugTicker
local _lastLogX, _lastLogY = -1, -1
local DEBUG_DIST_SQ = 0.05 * 0.05

local function StopDebugTicker()
    if debugTicker then
        debugTicker:Cancel()
        debugTicker = nil
    end
    _lastLogX, _lastLogY = -1, -1
end

local function StartDebugTicker()
    if not KwikTipDB or not KwikTipDB.debugLog then return end
    if debugTicker then return end
    _lastLogX, _lastLogY = -1, -1
    debugTicker = C_Timer.NewTicker(2, function()
        local mapID = C_Map.GetBestMapForUnit("player")
        if not mapID then return end
        local pos = C_Map.GetPlayerMapPosition(mapID, "player")
        if not pos then return end
        local dx = pos.x - _lastLogX
        local dy = pos.y - _lastLogY
        if (dx * dx + dy * dy) < DEBUG_DIST_SQ then return end
        _lastLogX, _lastLogY = pos.x, pos.y
        local instanceName, instanceType, _, _, _, _, _, instanceID = GetInstanceInfo()
        local dungeon = instanceID and KwikTip.DUNGEON_BY_INSTANCEID[instanceID]
        print(string.format("|cff00ff00KwikTip|r pos=%.4f, %.4f  %s  mapID=%d  instanceID=%s",
            pos.x, pos.y,
            dungeon and dungeon.name or (instanceName or "unknown"),
            mapID,
            tostring(instanceID)))
        table.insert(KwikTipDB.mapIDLog, {
            mapID        = mapID,
            instanceID   = instanceID,
            instanceName = instanceName,
            instanceType = instanceType,
            time         = date("%Y-%m-%d %H:%M:%S"),
            x            = string.format("%.4f", pos.x),
            y            = string.format("%.4f", pos.y),
        })
        if #KwikTipDB.mapIDLog > 2000 then
            table.remove(KwikTipDB.mapIDLog, 1)
        end
    end)
end

-- ============================================================
-- Boss encounter state
-- ============================================================

-- Called by ENCOUNTER_START. Locks the HUD to boss tip for the fight duration.
function KwikTip:OnEncounterStart(encounterID)
    self.bossActive = true
    StopAreaTicker()
    StopDebugTicker()
    local entry = KwikTip.BOSS_BY_ENCOUNTERID[encounterID]
    if entry then
        self:SetContent(FormatBossContent(entry.dungeon, entry.boss))
    else
        self:SetContent(GRAY .. "No tip for this boss." .. RESET)
    end
    self:UpdateVisibility()
end

-- Called by ENCOUNTER_END. Restores normal area/trash detection.
function KwikTip:OnEncounterEnd()
    self.bossActive = false
    self:SetContent("")
    self:UpdateContent()   -- refreshes areaActive and tickers
    self:UpdateVisibility()
end

-- ============================================================
-- Mob position logging
-- ============================================================
-- Logs the player's position when targeting or mousing over a hostile NPC inside
-- an instance, for later use in proximity-based trash tip triggering.

local _lastLoggedNpcID = nil  -- deduplicate mouseover spam

local function LogMobPosition(npcID, unitToken)
    if not KwikTipDB or not KwikTipDB.debugLog then return end
    local mapID = C_Map.GetBestMapForUnit("player")
    if not mapID then return end
    local pos = C_Map.GetPlayerMapPosition(mapID, "player")
    if not pos then return end
    local instanceName, _, _, _, _, _, _, instanceID = GetInstanceInfo()
    table.insert(KwikTipDB.mobLog, {
        npcID        = npcID,
        npcName      = UnitName(unitToken),
        mapID        = mapID,
        instanceID   = instanceID,
        instanceName = instanceName,
        x            = string.format("%.4f", pos.x),
        y            = string.format("%.4f", pos.y),
        time         = date("%Y-%m-%d %H:%M:%S"),
    })
    if #KwikTipDB.mobLog > 5000 then
        table.remove(KwikTipDB.mobLog, 1)
    end
    _lastLoggedNpcID = npcID
end

-- ============================================================
-- Trash target state
-- ============================================================

-- Called by PLAYER_TARGET_CHANGED. Logs mob position and shows a tip if known.
function KwikTip:OnTargetChanged()
    if self.bossActive then return end

    local inInstance, instanceType = IsInInstance()
    if not inInstance or (instanceType ~= "party" and instanceType ~= "raid" and instanceType ~= "scenario") then
        if self.trashActive then
            self.trashActive = false
            self:UpdateVisibility()
        end
        return
    end

    local guid = UnitGUID("target")
    if guid then
        local npcID = tonumber(guid:match("-(%d+)-%x+$"))
        if npcID and UnitCanAttack("player", "target") then
            LogMobPosition(npcID, "target")
            local entry = KwikTip.TRASH_BY_NPCID[npcID]
            if entry then
                self.trashActive = true
                self:SetContent(FormatTrashContent(entry.dungeon, entry.mob))
                self:UpdateVisibility()
                return
            end
        end
    end

    -- No known trash target — clear trash state and let area detection take over.
    if self.trashActive then
        self.trashActive = false
        self:SetContent("")
        self:UpdateContent()
        self:UpdateVisibility()
    end
end

-- Called by UPDATE_MOUSEOVER_UNIT. Logs mob position; deduplicates against last logged npcID.
function KwikTip:OnMouseoverUnit()
    if not KwikTipDB or not KwikTipDB.debugLog then return end
    if self.bossActive then return end

    local inInstance, instanceType = IsInInstance()
    if not inInstance or (instanceType ~= "party" and instanceType ~= "raid" and instanceType ~= "scenario") then return end

    local guid = UnitGUID("mouseover")
    if not guid then return end
    local npcID = tonumber(guid:match("-(%d+)-%x+$"))
    if not npcID then return end
    if not UnitCanAttack("player", "mouseover") then return end
    if npcID == _lastLoggedNpcID then return end  -- already logged from target or recent mouseover

    LogMobPosition(npcID, "mouseover")
end

-- ============================================================
-- Detection
-- ============================================================

-- Identify the current dungeon and manage area/ticker state.
-- No-op during boss encounters or while a trash mob is targeted.
function KwikTip:UpdateContent()
    if self.bossActive then return end

    local inInstance, instanceType = IsInInstance()
    if not inInstance or (instanceType ~= "party" and instanceType ~= "raid" and instanceType ~= "scenario") then
        StopAreaTicker()
        StopDebugTicker()
        self.areaActive = false
        self:SetContent("")
        return
    end

    -- Primary lookup: instanceID from GetInstanceInfo()
    local _, _, _, _, _, _, _, instanceID = GetInstanceInfo()
    local dungeon = instanceID and KwikTip.DUNGEON_BY_INSTANCEID[instanceID]

    -- Fallback: uiMapID for dungeons with instanceID = 0
    if not dungeon then
        local mapID = C_Map.GetBestMapForUnit("player")
        dungeon = mapID and KwikTip.DUNGEON_BY_UIMAPID[mapID]
    end

    -- Manage debug ticker
    if KwikTipDB and KwikTipDB.debugLog then
        StartDebugTicker()
    else
        StopDebugTicker()
    end

    -- Trash target takes priority over area content; still manage area ticker.
    if self.trashActive then
        if dungeon and dungeon.areas then StartAreaTicker() else StopAreaTicker() end
        return
    end

    -- Area detection
    if dungeon and dungeon.areas then
        StartAreaTicker()
        local mapID = C_Map.GetBestMapForUnit("player")
        local content = mapID and FormatAreaContent(dungeon, mapID)
        local prevAreaActive = self.areaActive
        self.areaActive = (content ~= nil)
        self:SetContent(content or "")
        if prevAreaActive ~= self.areaActive then
            self:UpdateVisibility()
        end
    else
        StopAreaTicker()
        if self.areaActive then
            self.areaActive = false
            self:SetContent("")
            self:UpdateVisibility()
        end
    end
end
