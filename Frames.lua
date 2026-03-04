-- KwikTip: HUD frame and layout API
local ADDON_NAME, KwikTip = ...

-- ============================================================
-- HUD Frame
-- ============================================================
local hud = CreateFrame("Frame", "KwikTipHUD", UIParent, "BackdropTemplate")
KwikTip.HUD = hud

hud:SetFrameStrata("MEDIUM")
hud:SetClampedToScreen(true)
hud:SetMovable(true)
hud:SetResizable(true)
hud:SetResizeBounds(100, 40, 600, 400)
hud:EnableMouse(false)  -- mouse passthrough by default; enabled only in move mode
hud:Hide()

hud:SetBackdrop({
    bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 1,
    insets   = { left = 1, right = 1, top = 1, bottom = 1 },
})
hud:SetBackdropColor(0, 0, 0, 0.75)
hud:SetBackdropBorderColor(0, 0, 0, 1)

-- Content text label
local contentText = hud:CreateFontString(nil, "OVERLAY", "GameFontNormal")
contentText:SetPoint("TOPLEFT",     hud, "TOPLEFT",     6, -6)
contentText:SetPoint("BOTTOMRIGHT", hud, "BOTTOMRIGHT", -6,  6)
contentText:SetJustifyH("LEFT")
contentText:SetJustifyV("TOP")
contentText:SetWordWrap(true)
contentText:SetText("")
KwikTip.HUDText = contentText

-- ============================================================
-- Drag and resize support
-- ============================================================

local function SaveHUDLayout()
    KwikTipDB.width  = math.floor(hud:GetWidth()  + 0.5)
    KwikTipDB.height = math.floor(hud:GetHeight() + 0.5)
    KwikTipDB.x      = math.floor(hud:GetLeft()   + hud:GetWidth()  / 2 - UIParent:GetWidth()  / 2 + 0.5)
    KwikTipDB.y      = math.floor(hud:GetBottom()  + hud:GetHeight() / 2 - UIParent:GetHeight() / 2 + 0.5)
end

hud:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" then
        self:StartMoving()
    end
end)

hud:SetScript("OnMouseUp", function(self)
    self:StopMovingOrSizing()
    SaveHUDLayout()
end)

-- Corner resize handles — small gold squares, visible only in move mode.
local cornerHandles = {}
for _, c in ipairs({
    { point = "TOPLEFT",     dir = "TOPLEFT"     },
    { point = "TOPRIGHT",    dir = "TOPRIGHT"    },
    { point = "BOTTOMLEFT",  dir = "BOTTOMLEFT"  },
    { point = "BOTTOMRIGHT", dir = "BOTTOMRIGHT" },
}) do
    local handle = CreateFrame("Frame", nil, hud)
    handle:SetSize(7, 7)
    handle:SetPoint(c.point)
    handle:SetFrameLevel(hud:GetFrameLevel() + 2)
    handle:EnableMouse(true)
    handle:Hide()

    local tex = handle:CreateTexture(nil, "OVERLAY")
    tex:SetColorTexture(1, 0.82, 0, 0.9)
    tex:SetAllPoints(handle)

    local dir = c.dir
    handle:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            hud:StartSizing(dir)
        end
    end)
    handle:SetScript("OnMouseUp", function()
        hud:StopMovingOrSizing()
        SaveHUDLayout()
    end)

    table.insert(cornerHandles, handle)
end

-- ============================================================
-- Public API
-- ============================================================

-- Apply saved settings to the HUD (size, opacity, position).
function KwikTip:ApplySettings()
    local db = KwikTipDB
    hud:SetSize(db.width, db.height)
    hud:SetBackdropColor(0, 0, 0, db.alpha)
    hud:ClearAllPoints()
    hud:SetPoint("CENTER", UIParent, "CENTER", db.x or 0, db.y or 0)
end

-- Show the HUD when any active state warrants it, or when move mode is active.
--   bossActive  : ENCOUNTER_START is in progress
--   trashActive : player is targeting a known trash mob
--   areaActive  : player is inside a named area bounding box
-- Respects the persistentHide flag set from the config window.
function KwikTip:UpdateVisibility()
    if KwikTipDB.persistentHide and not self.moveMode then
        hud:Hide()
        return
    end

    if self.moveMode or self.bossActive or self.trashActive or self.areaActive or self.dungeonActive then
        hud:Show()
    else
        hud:Hide()
    end
end

-- Toggle between move mode (draggable, gold border) and locked mode.
-- Config.lua defines _UpdateConfigMoveBtn; it will be a no-op until that file loads.
function KwikTip:ToggleMoveMode()
    self.moveMode = not self.moveMode

    if self.moveMode then
        hud:EnableMouse(true)
        hud:Show()
        hud:SetBackdropBorderColor(1, 0.82, 0, 1)  -- gold outline = move mode active
    else
        hud:EnableMouse(false)
        hud:SetBackdropBorderColor(0, 0, 0, 1)
        SaveHUDLayout()
        self:UpdateVisibility()
    end

    for _, handle in ipairs(cornerHandles) do
        if self.moveMode then handle:Show() else handle:Hide() end
    end

    -- Sync the button label in the config window if it is open
    if self._UpdateConfigMoveBtn then
        self:_UpdateConfigMoveBtn()
    end
end

-- ============================================================
-- Export / Import dialog
-- ============================================================

local dataDialog

function KwikTip:ShowDataDialog()
    if not dataDialog then
        dataDialog = CreateFrame("Frame", "KwikTipDataDialog", UIParent, "BackdropTemplate")
        dataDialog:SetSize(500, 320)
        dataDialog:SetPoint("CENTER")
        dataDialog:SetMovable(true)
        dataDialog:EnableMouse(true)
        dataDialog:RegisterForDrag("LeftButton")
        dataDialog:SetScript("OnDragStart", dataDialog.StartMoving)
        dataDialog:SetScript("OnDragStop",  dataDialog.StopMovingOrSizing)
        dataDialog:SetFrameStrata("DIALOG")
        dataDialog:SetBackdrop({
            bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 },
        })
        dataDialog:SetBackdropColor(0, 0, 0, 0.9)

        local title = dataDialog:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOP", 0, -12)
        title:SetText("KwikTip — Position Data")

        local sub = dataDialog:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        sub:SetPoint("TOP", 0, -34)
        sub:SetText("Copy the string below to share, or paste a string and click Import.")
        sub:SetTextColor(0.8, 0.8, 0.8)

        -- Scroll frame + EditBox
        local scroll = CreateFrame("ScrollFrame", "KwikTipDataScroll", dataDialog, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT",     dataDialog, "TOPLEFT",     10, -56)
        scroll:SetPoint("BOTTOMRIGHT", dataDialog, "BOTTOMRIGHT", -28, 40)

        local eb = CreateFrame("EditBox", "KwikTipDataEditBox", scroll)
        eb:SetMultiLine(true)
        eb:SetAutoFocus(false)
        eb:SetFontObject(ChatFontNormal)
        eb:SetWidth(450)
        eb:SetScript("OnEscapePressed", function() dataDialog:Hide() end)
        scroll:SetScrollChild(eb)
        dataDialog.editBox = eb

        -- Buttons
        local closeBtn = CreateFrame("Button", nil, dataDialog, "UIPanelButtonTemplate")
        closeBtn:SetSize(80, 22)
        closeBtn:SetPoint("BOTTOMRIGHT", -8, 8)
        closeBtn:SetText("Close")
        closeBtn:SetScript("OnClick", function() dataDialog:Hide() end)

        local importBtn = CreateFrame("Button", nil, dataDialog, "UIPanelButtonTemplate")
        importBtn:SetSize(80, 22)
        importBtn:SetPoint("RIGHT", closeBtn, "LEFT", -4, 0)
        importBtn:SetText("Import")
        importBtn:SetScript("OnClick", function()
            local text = dataDialog.editBox:GetText()
            local added, err = KwikTip:ImportLog(text)
            if err then
                print("|cff00ff00KwikTip|r import error: " .. err)
            else
                print(string.format("|cff00ff00KwikTip|r Imported %d new position entries.", added))
                local str = KwikTip:ExportLog()
                dataDialog.editBox:SetText(str or "")
            end
        end)

        local selectBtn = CreateFrame("Button", nil, dataDialog, "UIPanelButtonTemplate")
        selectBtn:SetSize(80, 22)
        selectBtn:SetPoint("RIGHT", importBtn, "LEFT", -4, 0)
        selectBtn:SetText("Select All")
        selectBtn:SetScript("OnClick", function()
            dataDialog.editBox:SetFocus()
            dataDialog.editBox:HighlightText()
        end)
    end

    local str, count = KwikTip:ExportLog()
    dataDialog.editBox:SetText(str or "")
    dataDialog:Show()
    if str then
        dataDialog.editBox:SetFocus()
        dataDialog.editBox:HighlightText()
        print(string.format("|cff00ff00KwikTip|r %d unique positions ready to export.", count))
    else
        print("|cff00ff00KwikTip|r No position data yet — enable Debug Logging and walk around a dungeon.")
    end
end

-- ============================================================
-- Set the text displayed inside the HUD box.
-- Guards against redundant SetText calls when content hasn't changed.
function KwikTip:SetContent(str)
    str = str or ""
    if self._lastContent == str then return end
    self._lastContent = str
    contentText:SetText(str)
end
