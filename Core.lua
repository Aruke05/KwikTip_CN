-- KwikTip: Core.lua (Event tracking, logging, commands, detection)
local ADDON_NAME, KwikTip = ...

local frame = CreateFrame("Frame", "KwikTipCoreFrame", UIParent)
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("ZONE_CHANGED")
frame:RegisterEvent("ENCOUNTER_START")
frame:RegisterEvent("ENCOUNTER_END")
frame:RegisterEvent("PLAYER_ROLES_ASSIGNED")
frame:RegisterEvent("CHALLENGE_MODE_START")
frame:RegisterEvent("CHALLENGE_MODE_RESET")
frame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
-- NOTE: In Midnight 12.x, UnitGUID() for hostile NPCs returns a tainted "secret value" —
-- COMBAT_LOG_EVENT_UNFILTERED is also a protected event and cannot be registered.
-- NPC-based trash tip detection is impossible; detection uses subzone/area events only.
-- UNIT_SPELLCAST_START is registered dynamically for debug spell logging only.
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" or event == "ZONE_CHANGED" then
        KwikTip:UpdateContent()
        KwikTip:UpdateVisibility()
        KwikTip:LogMapID()
    elseif event == "ENCOUNTER_START" then
        local encounterID, encounterName = ...
        KwikTip:OnEncounterStart(encounterID, encounterName)
    elseif event == "ENCOUNTER_END" then
        local _, _, _, _, success = ...
        KwikTip:OnEncounterEnd(success)
    elseif event == "PLAYER_ROLES_ASSIGNED" then
        KwikTip:UpdateContent()
    elseif event == "CHALLENGE_MODE_START" then
        KwikTip:OnChallengeModeStart()
    elseif event == "CHALLENGE_MODE_RESET" or event == "CHALLENGE_MODE_COMPLETED" then
        KwikTip:UpdateContent()
        KwikTip:UpdateVisibility()
    elseif event == "UNIT_SPELLCAST_START" then
        local unit, _, spellID = ...
        KwikTip:OnSpellCastStart(unit, spellID)
    end
end)

-- Returns true if the current instance type should be handled by KwikTip.
-- Delves return instanceType "scenario" and are opt-in via KwikTipDB.delves.
local function IsSupportedInstance(inInstance, instanceType)
    if not inInstance then return false end
    if instanceType == "party" or instanceType == "raid" then return true end
    if instanceType == "scenario" and KwikTipDB and KwikTipDB.delves then return true end
    return false
end

local GOLD  = "|cffffcc00"
local WHITE = "|cffffffff"
local GRAY  = "|cffbbbbbb"
local RESET = "|r"

-- Returns the player's current assigned role as a lowercase string matching the
-- notes role keys ("tank", "healer", "dps"), or nil if unassigned/solo.
local function GetPlayerRole()
    local r = UnitGroupRolesAssigned("player")
    if r == "TANK"    then return "tank"   end
    if r == "HEALER"  then return "healer" end
    if r == "DAMAGER" then return "dps"    end
    return nil
end

-- Role note rendering
-- Colors
local TANK_COLOR = "|cff0099ff"
local HEAL_COLOR = "|cff33cc33"
local DPS_COLOR  = "|cffff6633"
-- Icons: Interface\Icons\ texture paths — same format as the confirmed-working interrupt icon
local TANK_ICON = "|TInterface\\Icons\\Ability_Warrior_DefensiveStance:13:13|t"
local HEAL_ICON = "|TInterface\\Icons\\Spell_Holy_Renew:13:13|t"
local DPS_ICON  = "|TInterface\\Icons\\Ability_DualWield:13:13|t"
local INT_ICON  = "|TInterface\\Icons\\Ability_Kick:13:13|t"

local ROLE_FMT = {
    tank      = { icon = TANK_ICON, color = TANK_COLOR },
    healer    = { icon = HEAL_ICON, color = HEAL_COLOR },
    dps       = { icon = DPS_ICON,  color = DPS_COLOR  },
    interrupt = { icon = INT_ICON,  color = GOLD       },
    general   = { icon = nil,       color = GRAY       },
}

-- Render a structured notes array into HUD text.
-- Each entry: { role = "general"|"tank"|"healer"|"dps"|"interrupt", text = "..." }
-- filterRole: if provided, only notes of that role + "general" + "interrupt" are shown.
-- Pass nil to show all notes (used for preview and flat-tip fallback).
-- Returns nil if notes is nil, empty, or all entries are filtered out.
local function FormatNotes(notes, filterRole)
    if not notes or #notes == 0 then return nil end
    local lines = {}
    for _, note in ipairs(notes) do
        if not filterRole
            or note.role == "general"
            or note.role == "interrupt"
            or note.role == filterRole
        then
            local fmt = ROLE_FMT[note.role] or ROLE_FMT.general
            if fmt.icon then
                table.insert(lines, fmt.icon .. " " .. fmt.color .. note.text .. RESET)
            else
                table.insert(lines, fmt.color .. note.text .. RESET)
            end
        end
    end
    if #lines == 0 then return nil end
    return table.concat(lines, "\n")
end

-- Shared header: "Dungeon Name\nEntity Name"
local function FormatHeader(dungeonName, entityName)
    return GOLD .. dungeonName .. RESET .. "\n" .. WHITE .. entityName .. RESET
end

-- Build a compact single-line affix bar for appending to boss/area tips.
-- Returns nil when not in an active M+ run.
-- Format: "+7  Tyrannical  ·  Bolstering"
local function FormatAffixBar()
    if not C_ChallengeMode then return nil end
    local level, affixes = C_ChallengeMode.GetActiveKeystoneInfo()
    if not level or not affixes or #affixes == 0 then return nil end
    local names = {}
    for _, id in ipairs(affixes) do
        local data = KwikTip.AFFIXES and KwikTip.AFFIXES[id]
        local info = C_ChallengeMode.GetAffixInfo(id)
        local name = (data and data.name) or (info and info.name) or ("Affix#"..id)
        table.insert(names, name)
    end
    return GRAY .. "+" .. level .. "  " .. GOLD .. table.concat(names, "  ·  ") .. RESET
end

-- Build the full affix tip block for the M+ holding screen.
-- Returns nil when not in an active M+ run.
local function FormatAffixDetails()
    if not C_ChallengeMode then return nil end
    local level, affixes = C_ChallengeMode.GetActiveKeystoneInfo()
    if not level or not affixes or #affixes == 0 then return nil end
    local lines = { GOLD .. "+" .. level .. " Active Affixes" .. RESET }
    for _, id in ipairs(affixes) do
        local data = KwikTip.AFFIXES and KwikTip.AFFIXES[id]
        local info = C_ChallengeMode.GetAffixInfo(id)
        local name = (data and data.name) or (info and info.name) or ("Affix#"..id)
        local tip  = data and data.tip
        if tip then
            table.insert(lines, GOLD .. name .. RESET .. ": " .. GRAY .. tip .. RESET)
        else
            -- Fall back to in-game description; truncate if long
            local desc = info and info.description
            if desc and #desc > 80 then desc = desc:sub(1, 77) .. "..." end
            table.insert(lines, GOLD .. name .. RESET .. (desc and (": " .. GRAY .. desc .. RESET) or ""))
        end
    end
    return table.concat(lines, "\n")
end

-- Build the HUD string for an active boss encounter.
-- Filters structured notes to the player's assigned role (+ general + interrupt).
-- Falls back to the flat tip string if no notes are defined.
local function FormatBossContent(dungeon, boss)
    local role = GetPlayerRole()
    local body = FormatNotes(boss.notes, role)
    if not body and boss.tip and boss.tip ~= "" then
        body = GRAY .. boss.tip .. RESET
    end
    local header = FormatHeader(dungeon.name, boss.name)
    return body and (header .. "\n" .. body) or header
end

-- Build the HUD string for the current sub-zone area.
-- Matches GetSubZoneText() against dungeon.areas[].subzone.
-- If the area entry has a bossIndex field, the boss tip is shown instead
-- of a generic area tip — used for boss room sub-zones so the tip appears
-- as the group enters, before ENCOUNTER_START fires.
-- Returns nil if the current sub-zone has no defined tip.
local function FormatAreaContent(dungeon)
    local subzone = GetSubZoneText()
    local mapID   = C_Map.GetBestMapForUnit("player")
    for _, a in ipairs(dungeon.areas) do
        local match = (a.subzone and subzone ~= "" and a.subzone == subzone)
                   or (a.mapID  and a.mapID  == mapID)
        if match then
            if a.bossIndex then
                local boss = dungeon.bosses[a.bossIndex]
                if boss then
                    return FormatBossContent(dungeon, boss)
                end
            end
            return GOLD .. dungeon.name .. RESET .. "\n"
                .. WHITE .. (subzone ~= "" and subzone or "") .. RESET .. "\n"
                .. GRAY .. (a.tip or "") .. RESET
        end
    end
    return nil
end

-- ============================================================
-- Boss encounter state
-- ============================================================

-- Called by ENCOUNTER_START. Locks the HUD to the boss tip for the fight duration.
-- Always logs the encounterID to encounterLog (not gated on debugLog) so legacy
-- dungeon encounter IDs can be collected without enabling full debug mode.
function KwikTip:OnEncounterStart(encounterID, encounterName)
    -- Always-on encounter logging — used to resolve encounterID = 0 stubs in DungeonData.
    if KwikTipDB then
        local instanceName, _, _, _, _, _, _, instanceID = GetInstanceInfo()
        table.insert(KwikTipDB.encounterLog, {
            encounterID   = encounterID,
            encounterName = encounterName,
            instanceID    = instanceID,
            instanceName  = instanceName,
            mapID         = C_Map.GetBestMapForUnit("player"),
            time          = date("%Y-%m-%d %H:%M:%S"),
        })
        if #KwikTipDB.encounterLog > 500 then
            KwikTipDB.encounterLog = self:PruneArray(KwikTipDB.encounterLog, 500)
        end
    end

    local entry = KwikTip.BOSS_BY_ENCOUNTERID[encounterID]
    if not entry then return end

    self.bossActive = true
    local content = FormatBossContent(entry.dungeon, entry.boss)
    local bar = entry.dungeon.mythicPlus and FormatAffixBar()
    self:SetContent(bar and (content .. "\n" .. bar) or content)
    self:UpdateVisibility()
end

-- Called by ENCOUNTER_END. On a kill, leaves the boss tip visible until the
-- next natural tip trigger (area change, trash target, or new encounter).
-- On a wipe/reset, restores normal area/trash detection immediately.
function KwikTip:OnEncounterEnd(success)
    self.bossActive = false
    if success == 1 then
        -- Boss killed — leave current tip up until next natural trigger.
        self:UpdateVisibility()
    else
        -- Wipe or reset — clear and return to normal detection.
        self:SetContent("")
        self:UpdateContent()
        self:UpdateVisibility()
    end
end

-- Called by CHALLENGE_MODE_START. Logs the keystone and refreshes content so
-- the affix bar/details appear in the HUD immediately on entering the key.
function KwikTip:OnChallengeModeStart()
    if KwikTipDB and C_ChallengeMode then
        local level, affixes = C_ChallengeMode.GetActiveKeystoneInfo()
        if level then
            local _, _, _, _, _, _, _, instanceID = GetInstanceInfo()
            local affixData = {}
            if affixes then
                for _, id in ipairs(affixes) do
                    local info = C_ChallengeMode.GetAffixInfo(id)
                    table.insert(affixData, { id = id, name = info and info.name or "unknown" })
                end
            end
            table.insert(KwikTipDB.keystoneLog, {
                level      = level,
                affixes    = affixData,
                instanceID = instanceID,
                time       = date("%Y-%m-%d %H:%M:%S"),
            })
            if #KwikTipDB.keystoneLog > 200 then
                KwikTipDB.keystoneLog = self:PruneArray(KwikTipDB.keystoneLog, 200)
            end
        end
    end
    self:UpdateContent()
    self:UpdateVisibility()
end

-- ============================================================
-- Spell cast logging
-- ============================================================
-- Logs hostile NPC spell casts from the current target.
-- Gated on debugLog. Deduplicates per (npcID, spellID) pair so each unique
-- cast is only recorded once per session.
-- Purpose: surface interrupt priorities and dangerous mechanics for tip writing.

local _loggedSpells = {}  -- [npcID..":"..spellID] = true; reset on /kwik clearlog

function KwikTip:OnSpellCastStart(unit, spellID)
    if not KwikTipDB or not KwikTipDB.debugLog then return end
    if unit ~= "target" then return end
    local inInstance, instanceType = IsInInstance()
    if not IsSupportedInstance(inInstance, instanceType) then return end
    if not spellID then return end
    if not UnitCanAttack("player", "target") then return end
    if UnitIsPlayer("target") then return end

    local guid = UnitGUID("target")
    if not guid then return end
    -- pcall required: in Midnight 12.x hostile NPC GUIDs are tainted secret values — GetCreatureID rejects them at the C level.
    local ok, npcID = pcall(C_CreatureInfo.GetCreatureID, guid)
    if not ok then return end
    if not npcID or npcID == 0 then return end

    local key = npcID .. ":" .. spellID
    if _loggedSpells[key] then return end
    _loggedSpells[key] = true

    local spellInfo = C_Spell.GetSpellInfo(spellID)
    local spellName = spellInfo and spellInfo.name or ("spell:"..spellID)
    local instanceName, _, _, _, _, _, _, instanceID = GetInstanceInfo()
    table.insert(KwikTipDB.spellLog, {
        spellID      = spellID,
        spellName    = spellName,
        npcID        = npcID,
        npcName      = UnitName("target"),
        instanceID   = instanceID,
        instanceName = instanceName,
        mapID        = C_Map.GetBestMapForUnit("player"),
        subzone      = GetSubZoneText(),
        time         = date("%Y-%m-%d %H:%M:%S"),
    })
    if #KwikTipDB.spellLog > 2000 then
        KwikTipDB.spellLog = self:PruneArray(KwikTipDB.spellLog, 2000)
    end
end

-- ============================================================
-- Detection
-- ============================================================

-- Identify the current dungeon and update HUD content.
-- Area detection uses GetSubZoneText() matched against dungeon.areas[].subzone.
-- ZONE_CHANGED fires on sub-zone transitions so no polling ticker is needed
-- for area updates — events drive UpdateContent directly.
function KwikTip:UpdateContent()
    if self.bossActive or self.previewActive then return end

    local inInstance, instanceType = IsInInstance()
    if not IsSupportedInstance(inInstance, instanceType) then
        self.areaActive    = false
        self.dungeonActive = false
        self:SetContent("")
        if self._targetEventsRegistered then
            frame:UnregisterEvent("UNIT_SPELLCAST_START")
            self._targetEventsRegistered = false
        end
        return
    end

    if not self._targetEventsRegistered then
        frame:RegisterEvent("UNIT_SPELLCAST_START")
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

    local prevAreaActive    = self.areaActive
    local prevDungeonActive = self.dungeonActive

    local areaContent = dungeon and dungeon.areas and FormatAreaContent(dungeon)

    if areaContent then
        self.areaActive    = true
        self.dungeonActive = false
        local bar = dungeon.mythicPlus and FormatAffixBar()
        self:SetContent(bar and (areaContent .. "\n" .. bar) or areaContent)
    elseif dungeon and KwikTipDB.showInDungeon then
        -- No area match — show M+ affix details if active, otherwise a holding message.
        self.areaActive    = false
        self.dungeonActive = true
        local affixDetails = dungeon.mythicPlus and FormatAffixDetails()
        if affixDetails then
            self:SetContent(GOLD .. dungeon.name .. RESET .. "\n" .. affixDetails)
        else
            self:SetContent(GRAY .. "Waiting for relevant encounter..." .. RESET)
        end
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
    if not IsSupportedInstance(inInstance, instanceType) then return end

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

    local pos = mapID and C_Map.GetPlayerMapPosition(mapID, "player")
    table.insert(KwikTipDB.mapIDLog, {
        mapID        = mapID,
        x            = pos and pos.x,
        y            = pos and pos.y,
        instanceID   = instanceID,
        instanceName = instanceName,
        instanceType = instanceType,
        subzone      = subzone,
        noSubzone    = (subzone == "") or nil,  -- flag transitions where subzone text is absent; omitted when false to keep log tidy
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
-- Preview (settings demo)
-- ============================================================

-- Static demo notes — module-scoped so ShowPreview doesn't reallocate on every call.
local DEMO_NOTES = {
    { role = "general",   text = "Avoid the red zones; use a personal defensive on the big hit." },
    { role = "tank",      text = "Tank swap at 3 stacks of the debuff." },
    { role = "healer",    text = "Major healing CDs after every Cataclysm cast." },
    { role = "dps",       text = "Kill adds before switching back to the boss." },
    { role = "interrupt", text = "Shadowbolt — interrupt every cast, no exceptions." },
}

-- Show a demo tip in the HUD with one note of every role category.
-- Sets previewActive so UpdateContent won't override it while config is open.
-- Call ClearPreview() (or close the config window) to dismiss.
function KwikTip:ShowPreview()
    self.previewActive = true
    self:InitHUD()
    self:SetContent(FormatHeader("Demo Dungeon", "Example Boss") .. "\n" .. FormatNotes(DEMO_NOTES))
    self:UpdateVisibility()
end

-- Dismiss the preview and restore normal HUD state.
function KwikTip:ClearPreview()
    if not self.previewActive then return end
    self.previewActive = false
    self:SetContent("")
    self:UpdateContent()
    self:UpdateVisibility()
end

-- Toggle preview on/off — single entry point for UI callers.
function KwikTip:TogglePreview()
    if self.previewActive then
        self:ClearPreview()
    else
        self:ShowPreview()
    end
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
        local instanceName, _, _, _, _, _, _, instanceID = GetInstanceInfo()
        local dungeon = (instanceID and KwikTip.DUNGEON_BY_INSTANCEID[instanceID])
            or (mapID and KwikTip.DUNGEON_BY_UIMAPID[mapID])
        local subzone = GetSubZoneText()
        local dungeonName = dungeon and dungeon.name or "none"
        local mapIDCount     = KwikTipDB.mapIDLog     and #KwikTipDB.mapIDLog     or 0
        local mobCount       = KwikTipDB.mobLog       and #KwikTipDB.mobLog       or 0
        local encounterCount = KwikTipDB.encounterLog and #KwikTipDB.encounterLog or 0
        local keystoneCount  = KwikTipDB.keystoneLog  and #KwikTipDB.keystoneLog  or 0
        local spellCount     = KwikTipDB.spellLog     and #KwikTipDB.spellLog     or 0
        local snapshotCount  = KwikTipDB.debugSnapshots and #KwikTipDB.debugSnapshots or 0
        local keyLevel, keyAffixes
        if C_ChallengeMode then keyLevel, keyAffixes = C_ChallengeMode.GetActiveKeystoneInfo() end
        print("|cff00ff00KwikTip|r debug:")
        print(string.format("  inInstance=%s  type=%s  boss=%s  area=%s  dungeon=%s",
            tostring(inInstance), tostring(instanceType),
            tostring(KwikTip.bossActive),
            tostring(KwikTip.areaActive), tostring(KwikTip.dungeonActive)))
        print(string.format("  instanceID=%s  mapID=%s  dungeon=%s",
            tostring(instanceID), tostring(mapID), dungeonName))
        print(string.format("  subzone=%q  role=%s", subzone or "", tostring(GetPlayerRole())))
        if keyLevel then
            print(string.format("  keystone=+%d  affixes=%d", keyLevel, keyAffixes and #keyAffixes or 0))
        end
        print(string.format("  mapIDLog=%d  mobLog=%d  encounterLog=%d  keystoneLog=%d  spellLog=%d  snapshots=%d",
            mapIDCount, mobCount, encounterCount, keystoneCount, spellCount, snapshotCount))
        -- Save snapshot to SavedVariables for post-session inspection.
        if KwikTipDB then
            table.insert(KwikTipDB.debugSnapshots, {
                time              = date("%Y-%m-%d %H:%M:%S"),
                inInstance        = inInstance,
                instanceType      = instanceType,
                instanceID        = instanceID,
                instanceName      = instanceName,
                mapID             = mapID,
                dungeon           = dungeonName,
                subzone           = subzone,
                role              = GetPlayerRole(),
                keystoneLevel     = keyLevel,
                bossActive        = KwikTip.bossActive,
                areaActive        = KwikTip.areaActive,
                dungeonActive     = KwikTip.dungeonActive,
                mapIDLogCount     = mapIDCount,
                mobLogCount       = mobCount,
                encounterLogCount = encounterCount,
                keystoneLogCount  = keystoneCount,
                spellLogCount     = spellCount,
            })
            if #KwikTipDB.debugSnapshots > 100 then
                KwikTipDB.debugSnapshots = KwikTip:PruneArray(KwikTipDB.debugSnapshots, 100)
            end
        end
    elseif cmd == "debuglog" then
        KwikTipDB.debugLog = not KwikTipDB.debugLog
        KwikTip:UpdateContent()
        print(string.format("|cff00ff00KwikTip|r debug logging %s.", KwikTipDB.debugLog and "enabled" or "disabled"))
    elseif cmd == "preview" then
        KwikTip:TogglePreview()
    elseif cmd == "clearlog" then
        KwikTipDB.mapIDLog       = {}
        KwikTipDB.mobLog         = {}
        KwikTipDB.encounterLog   = {}
        KwikTipDB.keystoneLog    = {}
        KwikTipDB.spellLog       = {}
        KwikTipDB.debugSnapshots = {}
        _loggedSpells = {}
        print("|cff00ff00KwikTip|r mapIDLog, mobLog, encounterLog, keystoneLog, spellLog, and debugSnapshots cleared.")
    elseif cmd == "feedback" then
        print("|cff00ff00KwikTip|r Tips feel off? Open an issue at: https://github.com/postblink/KwikTip/issues")
    elseif cmd == "config" or cmd == "" then
        KwikTip:ToggleConfig()
    elseif cmd == "help" then
        print("|cff00ff00KwikTip|r commands:")
        print("  /kwik           — open settings")
        print("  /kwik move      — toggle move/lock mode")
        print("  /kwik preview   — toggle role notes preview in the HUD")
        print("  /kwik debug     — print current detection state to chat")
        print("  /kwik debuglog  — toggle map/mob ID logging to SavedVariables")
        print("  /kwik clearlog  — clear all debug logs from SavedVariables")
        print("  /kwik feedback  — print the feedback/issue link")
        print("  /kwik help      — show this command list")
    else
        print("|cff00ff00KwikTip|r unknown command. Type /kwik help for a list of commands.")
    end
end
