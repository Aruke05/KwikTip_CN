-- KwikTip: Core.lua (Event tracking, logging, commands, detection)
local ADDON_NAME, KwikTip = ...

local frame = CreateFrame("Frame", "KwikTipCoreFrame", UIParent)
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("ZONE_CHANGED")
frame:RegisterEvent("ENCOUNTER_START")
frame:RegisterEvent("ENCOUNTER_END")
-- PLAYER_TARGET_CHANGED and UPDATE_MOUSEOVER_UNIT are registered dynamically
-- inside UpdateContent() only while the player is inside a supported instance.
frame:SetScript("OnEvent", function(self, event, ...)     if event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" or event == "ZONE_CHANGED" then         KwikTip:UpdateContent()         KwikTip:UpdateVisibility()         KwikTip:LogMapID()     elseif event == "ENCOUNTER_START" then         local encounterID = ...         KwikTip:OnEncounterStart(encounterID)     elseif event == "ENCOUNTER_END" then         KwikTip:OnEncounterEnd()     elseif event == "PLAYER_TARGET_CHANGED" then         KwikTip:OnTargetChanged()     elseif event == "UPDATE_MOUSEOVER_UNIT" then         KwikTip:OnMouseoverUnit()     end end)

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

-- Build the HUD string for the current sub-zone area.
-- Matches GetSubZoneText() against dungeon.areas[].subzone.
-- If the area entry has a bossIndex field, the boss tip is shown instead
-- of a generic area tip — used for boss room sub-zones so the tip appears
-- as the group enters, before ENCOUNTER_START fires.
-- Returns nil if the current sub-zone has no defined tip.
local function FormatAreaContent(dungeon)
    local subzone = GetSubZoneText()
    if not subzone or subzone == "" then return nil end
    for _, a in ipairs(dungeon.areas) do
        if a.subzone == subzone then
            if a.bossIndex then
                local boss = dungeon.bosses[a.bossIndex]
                if boss then
                    return FormatBossContent(dungeon, boss)
                end
            end
            return GOLD .. dungeon.name .. RESET .. "\n"
                .. WHITE .. subzone .. RESET .. "\n"
                .. GRAY .. a.tip .. RESET
        end
    end
    return nil
end

-- ============================================================
-- Debug sub-zone ticker
-- Logs when the player enters a new sub-zone inside an instance.
-- Fires on a 2 s poll as a safety net; ZONE_CHANGED events handle
-- most transitions and drive UpdateContent directly.
-- Gated on the debugLog setting.
-- ============================================================

local debugTicker
local _lastLoggedSubzone = nil

local function StopDebugTicker()
    if debugTicker then
        debugTicker:Cancel()
        debugTicker = nil
    end
    _lastLoggedSubzone = nil
end

local function StartDebugTicker()
    if not KwikTipDB or not KwikTipDB.debugLog then return end
    if debugTicker then return end
    _lastLoggedSubzone = nil
    debugTicker = C_Timer.NewTicker(2, function()
        local subzone = GetSubZoneText() or ""
        if subzone == _lastLoggedSubzone then return end
        _lastLoggedSubzone = subzone
        local instanceName, instanceType, _, _, _, _, _, instanceID = GetInstanceInfo()
        local mapID  = C_Map.GetBestMapForUnit("player")
        local dungeon = instanceID and KwikTip.DUNGEON_BY_INSTANCEID[instanceID]
        print(string.format("|cff00ff00KwikTip|r subzone=%q  %s  mapID=%s  instanceID=%s",
            subzone,
            dungeon and dungeon.name or (instanceName or "unknown"),
            tostring(mapID),
            tostring(instanceID)))
        table.insert(KwikTipDB.mapIDLog, {
            mapID        = mapID,
            instanceID   = instanceID,
            instanceName = instanceName,
            instanceType = instanceType,
            subzone      = subzone,
            time         = date("%Y-%m-%d %H:%M:%S"),
        })
        if #KwikTipDB.mapIDLog > 2000 then
            KwikTipDB.mapIDLog = KwikTip:PruneArray(KwikTipDB.mapIDLog, 2000)
        end
    end)
end

-- ============================================================
-- Boss encounter state
-- ============================================================

-- Called by ENCOUNTER_START. Locks the HUD to the boss tip for the fight duration.
function KwikTip:OnEncounterStart(encounterID)
    self.bossActive = true
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
    self:UpdateContent()
    self:UpdateVisibility()
end

-- ============================================================
-- Mob logging
-- ============================================================
-- Logs the NPC name, sub-zone, and instance context when targeting or
-- mousing over a hostile NPC, for future trash tip data collection.

local _lastLoggedNpcID = nil  -- deduplicate mouseover spam

local function LogMobPosition(npcID, unitToken)
    if not KwikTipDB or not KwikTipDB.debugLog then return end
    local instanceName, _, _, _, _, _, _, instanceID = GetInstanceInfo()
    table.insert(KwikTipDB.mobLog, {
        npcID        = npcID,
        npcName      = UnitName(unitToken),
        mapID        = C_Map.GetBestMapForUnit("player"),
        instanceID   = instanceID,
        instanceName = instanceName,
        subzone      = GetSubZoneText(),
        time         = date("%Y-%m-%d %H:%M:%S"),
    })
    if #KwikTipDB.mobLog > 5000 then
        KwikTipDB.mobLog = KwikTip:PruneArray(KwikTipDB.mobLog, 5000)
    end
    _lastLoggedNpcID = npcID
end

-- ============================================================
-- Trash target state
-- ============================================================

-- Called by PLAYER_TARGET_CHANGED. Logs the mob and shows a tip if known.
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

-- Called by UPDATE_MOUSEOVER_UNIT. Logs NPC; deduplicates against last logged npcID.
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
    if npcID == _lastLoggedNpcID then return end

    LogMobPosition(npcID, "mouseover")
end

-- ============================================================
-- Detection
-- ============================================================

-- Identify the current dungeon and update HUD content.
-- Area detection uses GetSubZoneText() matched against dungeon.areas[].subzone.
-- ZONE_CHANGED fires on sub-zone transitions so no polling ticker is needed
-- for area updates — events drive UpdateContent directly.
function KwikTip:UpdateContent()
    if self.bossActive then return end

    local inInstance, instanceType = IsInInstance()
    if not inInstance or (instanceType ~= "party" and instanceType ~= "raid" and instanceType ~= "scenario") then
        StopDebugTicker()
        self.areaActive    = false
        self.dungeonActive = false
        self.trashActive   = false
        self:SetContent("")
        if self._targetEventsRegistered then
            frame:UnregisterEvent("PLAYER_TARGET_CHANGED")
            frame:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
            self._targetEventsRegistered = false
        end
        return
    end

    if not self._targetEventsRegistered then
        frame:RegisterEvent("PLAYER_TARGET_CHANGED")
        frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
        self._targetEventsRegistered = true
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

    -- Trash target takes priority over area/dungeon content.
    if self.trashActive then return end

    local prevAreaActive    = self.areaActive
    local prevDungeonActive = self.dungeonActive

    local areaContent = dungeon and dungeon.areas and FormatAreaContent(dungeon)

    if areaContent then
        self.areaActive    = true
        self.dungeonActive = false
        self:SetContent(areaContent)
    elseif dungeon and KwikTipDB.showInDungeon and dungeon.bosses and dungeon.bosses[1] then
        -- No area match — default to first boss tip when showInDungeon is on.
        self.areaActive    = false
        self.dungeonActive = true
        self:SetContent(FormatBossContent(dungeon, dungeon.bosses[1]))
    else
        self.areaActive    = false
        self.dungeonActive = false
        self:SetContent("")
    end

    if prevAreaActive ~= self.areaActive or prevDungeonActive ~= self.dungeonActive then
        self:UpdateVisibility()
    end
end

-- ============================================================
-- Debug logging
-- ============================================================

function KwikTip:LogMapID()
    if not KwikTipDB or not KwikTipDB.debugLog then return end
    local inInstance, instanceType = IsInInstance()
    if not inInstance or (instanceType ~= "party" and instanceType ~= "raid" and instanceType ~= "scenario") then return end
    
    local mapID = C_Map.GetBestMapForUnit("player")
    local instanceName, _, _, _, _, _, _, instanceID = GetInstanceInfo()
    local subzone = GetSubZoneText()
    
    -- Deduplication to prevent redundant GC thrashing on ZONE_CHANGED
    if self._lastMapID == mapID and self._lastInstanceID == instanceID and self._lastSubzone == subzone then
        return
    end
    self._lastMapID = mapID
    self._lastInstanceID = instanceID
    self._lastSubzone = subzone

    table.insert(KwikTipDB.mapIDLog, {
        mapID        = mapID,
        instanceID   = instanceID,
        instanceName = instanceName,
        instanceType = instanceType,
        subzone      = subzone,
        time         = date("%Y-%m-%d %H:%M:%S"),
    })
    
    -- Cap log size to avoid SavedVariables bloat
    if #KwikTipDB.mapIDLog > 2000 then
        KwikTipDB.mapIDLog = self:PruneArray(KwikTipDB.mapIDLog, 2000)
    end
end

-- ============================================================
-- Utility: PruneArray
-- O(N) array slicing to avoid catastrophic O(N^2) from table.remove(arr, 1) in loops
-- ============================================================
function KwikTip:PruneArray(arr, maxLen)
    local len = #arr
    local over = len - maxLen
    if over > 0 then
        local newArr = {}
        for i = over + 1, len do
            newArr[i - over] = arr[i]
        end
        return newArr
    end
    return arr
end

-- ============================================================
-- Export / Import
-- ============================================================

-- Serialize mapIDLog to a compact shareable string.
-- Format: KT1|instanceID:mapID:x,y;x,y;...|...
-- Deduplicates positions (rounded to 3 decimal places) and groups by dungeon.
-- Returns: str, pointCount  (nil, 0 if nothing to export)
function KwikTip:ExportLog()
    if not KwikTipDB.mapIDLog or #KwikTipDB.mapIDLog == 0 then
        return nil, 0
    end

    local groups    = {}  -- gKey → { instanceID, mapID, posSet, positions }
    local groupOrder = {}

    for _, entry in ipairs(KwikTipDB.mapIDLog) do
        if entry.x and entry.y then
            -- Use workingMapID when available: x/y are in that map's coordinate space.
            local posMapID = entry.workingMapID or entry.mapID or 0
            local gKey = (entry.instanceID or 0) .. ":" .. posMapID
            if not groups[gKey] then
                groups[gKey] = {
                    instanceID = entry.instanceID or 0,
                    mapID      = posMapID,
                    posSet     = {},
                    positions  = {},
                }
                table.insert(groupOrder, gKey)
            end
            local g  = groups[gKey]
            local rx = string.format("%.3f", tonumber(entry.x))
            local ry = string.format("%.3f", tonumber(entry.y))
            local pk = rx .. "," .. ry
            if not g.posSet[pk] then
                g.posSet[pk] = true
                table.insert(g.positions, pk)
            end
        end
    end

    local totalPoints = 0
    local parts       = { "KT1" }
    for _, gKey in ipairs(groupOrder) do
        local g = groups[gKey]
        if #g.positions > 0 then
            table.insert(parts, g.instanceID .. ":" .. g.mapID .. ":" .. table.concat(g.positions, ";"))
            totalPoints = totalPoints + #g.positions
        end
    end

    if #parts == 1 then return nil, 0 end
    return table.concat(parts, "|"), totalPoints
end

-- Parse an export string and merge new positions into mapIDLog.
-- Returns: added (number), errMsg (string or nil)
function KwikTip:ImportLog(str)
    if not str or str == "" then return 0, "Empty string." end

    local rest = str:match("^KT1|(.+)$")
    if not rest then return 0, "Unrecognised format — expected a KT1 export string." end

    -- Build a set of existing positions for deduplication
    local existingSet = {}
    for _, entry in ipairs(KwikTipDB.mapIDLog) do
        if entry.x and entry.y then
            local k = (entry.instanceID or 0) .. ":" .. (entry.mapID or 0) .. ":" .. entry.x .. ":" .. entry.y
            existingSet[k] = true
        end
    end

    local added = 0
    for segment in rest:gmatch("[^|]+") do
        local iID, mID, posPart = segment:match("^(%d+):(%d+):(.+)$")
        if iID and mID and posPart then
            iID = tonumber(iID)
            mID = tonumber(mID)
            for pos in posPart:gmatch("[^;]+") do
                local x, y = pos:match("^([%d%.]+),([%d%.]+)$")
                if x and y then
                    local k = iID .. ":" .. mID .. ":" .. x .. ":" .. y
                    if not existingSet[k] then
                        existingSet[k] = true
                        table.insert(KwikTipDB.mapIDLog, {
                            mapID        = mID,
                            instanceID   = iID,
                            instanceName = "imported",
                            instanceType = "party",
                            time         = "imported",
                            x            = x,
                            y            = y,
                        })
                        added = added + 1
                    end
                end
            end
        end
    end

    -- Honour the existing cap using efficient slice
    if #KwikTipDB.mapIDLog > 2000 then
        KwikTipDB.mapIDLog = self:PruneArray(KwikTipDB.mapIDLog, 2000)
    end

    return added, nil
end

-- ============================================================
-- Slash commands
-- ============================================================
SLASH_KWIKTIP1 = "/kwiktip"
SLASH_KWIKTIP2 = "/kwik"

SlashCmdList["KWIKTIP"] = function(msg)
    local cmd = (msg or ""):lower():match("^%s*(.-)%s*$")
    if cmd == "move" then
        KwikTip:ToggleMoveMode()
    elseif cmd == "debug" then
        local inInstance, instanceType = IsInInstance()
        local mapID = C_Map.GetBestMapForUnit("player")
        local _, _, _, _, _, _, _, instanceID = GetInstanceInfo()
        local dungeon = (instanceID and KwikTip.DUNGEON_BY_INSTANCEID[instanceID])
            or (mapID and KwikTip.DUNGEON_BY_UIMAPID[mapID])
        local subzone = GetSubZoneText()
        print("|cff00ff00KwikTip|r debug:")
        print(string.format("  inInstance=%s  type=%s  boss=%s  trash=%s  area=%s  dungeon=%s",
            tostring(inInstance), tostring(instanceType),
            tostring(KwikTip.bossActive), tostring(KwikTip.trashActive),
            tostring(KwikTip.areaActive), tostring(KwikTip.dungeonActive)))
        print(string.format("  instanceID=%s  mapID=%s  dungeon=%s",
            tostring(instanceID), tostring(mapID), dungeon and dungeon.name or "none"))
        print(string.format("  subzone=%q", subzone or ""))
        print(string.format("  mapIDLog=%d  mobLog=%d",
            KwikTipDB.mapIDLog and #KwikTipDB.mapIDLog or 0,
            KwikTipDB.mobLog   and #KwikTipDB.mobLog   or 0))
    elseif cmd == "export" then
        KwikTip:ShowDataDialog()
    elseif cmd == "clearlog" then
        KwikTipDB.mapIDLog = {}
        KwikTipDB.mobLog   = {}
        print("|cff00ff00KwikTip|r mapIDLog and mobLog cleared.")
    elseif cmd == "config" or cmd == "" then
        KwikTip:ToggleConfig()
    else
        print("|cff00ff00KwikTip|r commands:")
        print("  /kwik          — open settings")
        print("  /kwik move     — toggle move/lock mode")
        print("  /kwik debug    — print detection state and position")
        print("  /kwik export   — open position data export/import dialog")
        print("  /kwik clearlog — clear mapIDLog and mobLog")
    end
end
