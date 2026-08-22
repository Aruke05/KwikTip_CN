-- KwikTip: HUD frame and layout API
local ADDON_NAME, KwikTip = ...
local L = KwikTip.L

-- ============================================================
-- HUD Frame
-- ============================================================
local hud
local contentText
local scrollFrame
local scrollChild
local scrollBar
local scrollThumb
local hoverOverlay
local noteBtn
local notePopup
local noteEditBox
local notePopupTarget
local printBtn
local cornerHandles = {}
local _scrollFadeTimer

-- Single reusable frame for deferring SendChatMessage past combat lockdown.
-- Allocated once on first use; re-registered each time a send is queued.
-- Multiple clicks during combat overwrite _pendingSend* — last content wins.
local _combatSendFrame
local _pendingSendLines
local _pendingSendChannel

-- ============================================================
-- Drag and resize support
-- ============================================================

local function SaveHUDLayout()
    KwikTipCNDB.width  = math.floor(hud:GetWidth()  + 0.5)
    KwikTipCNDB.height = math.floor(hud:GetHeight() + 0.5)
    KwikTipCNDB.x      = math.floor(hud:GetLeft()   + hud:GetWidth()  / 2 - UIParent:GetWidth()  / 2 + 0.5)
    KwikTipCNDB.y      = math.floor(hud:GetBottom()  + hud:GetHeight() / 2 - UIParent:GetHeight() / 2 + 0.5)
end

local function UpdateScrollBar()
    if not scrollFrame or not scrollBar then return end
    local maxScroll = scrollFrame:GetVerticalScrollRange()
    if not maxScroll or maxScroll <= 0 then
        if scrollBar:IsShown() then
            scrollBar:Hide()
            scrollBar:SetAlpha(0)
        end
        scrollFrame:SetVerticalScroll(0)
        return
    end
    if not scrollBar:IsShown() then
        scrollBar:Show()
        scrollBar:SetAlpha(0)  -- fades in on hover
    end
    local trackH  = scrollBar:GetHeight()
    local viewH   = scrollFrame:GetHeight()
    local contentH = scrollChild:GetHeight()
    if contentH <= 0 then return end
    local thumbH  = math.max(20, trackH * math.min(1, viewH / contentH))
    scrollThumb:SetHeight(thumbH)
    local scrollOffset = scrollFrame:GetVerticalScroll()
    local thumbRange   = trackH - thumbH
    scrollThumb:ClearAllPoints()
    scrollThumb:SetPoint("TOP", scrollBar, "TOP", 0,
        thumbRange > 0 and -(scrollOffset / maxScroll) * thumbRange or 0)
end

function KwikTip:InitHUD()
    if self.HUD then return end

    hud = CreateFrame("Frame", "KwikTipCNHUD", UIParent, "BackdropTemplate")
    self.HUD = hud

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

    -- ---- Scroll frame + content text ----
    scrollFrame = CreateFrame("ScrollFrame", nil, hud)
    scrollFrame:SetPoint("TOPLEFT",     hud, "TOPLEFT",      6,   -6)
    scrollFrame:SetPoint("BOTTOMRIGHT", hud, "BOTTOMRIGHT", -14,   6)
    scrollFrame:SetClipsChildren(true)

    scrollChild = CreateFrame("Frame")
    scrollChild:SetWidth(1)   -- updated in SetContent / OnSizeChanged
    scrollChild:SetHeight(1)
    scrollFrame:SetScrollChild(scrollChild)

    scrollFrame:SetScript("OnSizeChanged", function(self)
        local w = self:GetWidth()
        if w and w > 0 then scrollChild:SetWidth(w) end
        UpdateScrollBar()
    end)

    contentText = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    contentText:SetPoint("TOPLEFT",  scrollChild, "TOPLEFT",  0, 0)
    contentText:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, 0)
    contentText:SetJustifyH("LEFT")
    contentText:SetJustifyV("TOP")
    contentText:SetWordWrap(true)
    contentText:SetText("")
    KwikTip.HUDText = contentText

    -- ---- Scrollbar (right edge, 8 px wide) ----
    scrollBar = CreateFrame("Frame", nil, hud)
    scrollBar:SetWidth(6)
    scrollBar:SetPoint("TOPRIGHT",    hud, "TOPRIGHT",    -3,  -6)
    scrollBar:SetPoint("BOTTOMRIGHT", hud, "BOTTOMRIGHT", -3,   6)
    scrollBar:SetFrameLevel(hud:GetFrameLevel() + 3)
    scrollBar:EnableMouse(true)
    scrollBar:Hide()
    scrollBar:SetAlpha(0)

    local scrollTrackTex = scrollBar:CreateTexture(nil, "BACKGROUND")
    scrollTrackTex:SetColorTexture(0.15, 0.15, 0.15, 0.8)
    scrollTrackTex:SetAllPoints(scrollBar)

    scrollThumb = CreateFrame("Frame", nil, scrollBar)
    scrollThumb:SetWidth(6)
    scrollThumb:SetHeight(20)
    scrollThumb:SetPoint("TOP", scrollBar, "TOP", 0, 0)
    scrollThumb:SetFrameLevel(hud:GetFrameLevel() + 4)
    scrollThumb:EnableMouse(true)

    local thumbTex = scrollThumb:CreateTexture(nil, "OVERLAY")
    thumbTex:SetColorTexture(0.65, 0.65, 0.65, 0.9)
    thumbTex:SetAllPoints(scrollThumb)

    -- Thumb drag
    scrollThumb:SetScript("OnMouseDown", function(self, button)
        if button ~= "LeftButton" then return end
        self._dragging   = true
        self._dragY0     = select(2, GetCursorPosition()) / UIParent:GetEffectiveScale()
        self._dragScroll = scrollFrame:GetVerticalScroll()
    end)
    scrollThumb:SetScript("OnMouseUp", function(self)
        self._dragging = false
    end)
    scrollThumb:SetScript("OnUpdate", function(self)
        if not self._dragging then return end
        local curY = select(2, GetCursorPosition()) / UIParent:GetEffectiveScale()
        local dy   = self._dragY0 - curY
        local trackH = scrollBar:GetHeight()
        local thumbH = self:GetHeight()
        local range  = trackH - thumbH
        if range <= 0 then return end
        local maxScroll = scrollFrame:GetVerticalScrollRange()
        local newScroll = math.max(0, math.min(maxScroll,
            self._dragScroll + (dy / range) * maxScroll))
        scrollFrame:SetVerticalScroll(newScroll)
        UpdateScrollBar()
    end)

    -- ---- Hover overlay: captures wheel + OnEnter/OnLeave for scrollbar fade ----
    -- EnableMouse(true) + SetPassThroughButtons lets left/right clicks reach the game world.
    hoverOverlay = CreateFrame("Frame", nil, hud)
    hoverOverlay:SetAllPoints(hud)
    hoverOverlay:SetFrameLevel(hud:GetFrameLevel() + 1)
    hoverOverlay:EnableMouse(true)
    hoverOverlay:SetPassThroughButtons("LeftButton", "RightButton", "MiddleButton", "Button4", "Button5")
    hoverOverlay:EnableMouseWheel(true)

    local function FadeInBar()
        if not scrollBar:IsShown() then return end
        if _scrollFadeTimer then _scrollFadeTimer:Cancel(); _scrollFadeTimer = nil end
        UIFrameFadeIn(scrollBar, 0.25, scrollBar:GetAlpha(), 1)
    end
    local function ScheduleFadeOutBar()
        if _scrollFadeTimer then _scrollFadeTimer:Cancel() end
        _scrollFadeTimer = C_Timer.NewTimer(0.15, function()
            _scrollFadeTimer = nil
            UIFrameFadeOut(scrollBar, 0.6, scrollBar:GetAlpha(), 0)
        end)
    end

    hoverOverlay:SetScript("OnEnter", FadeInBar)
    hoverOverlay:SetScript("OnLeave", ScheduleFadeOutBar)
    scrollBar:SetScript("OnEnter", FadeInBar)
    scrollBar:SetScript("OnLeave", ScheduleFadeOutBar)
    scrollThumb:SetScript("OnEnter", FadeInBar)
    scrollThumb:SetScript("OnLeave", ScheduleFadeOutBar)

    hoverOverlay:SetScript("OnMouseWheel", function(self, delta)
        local cur = scrollFrame:GetVerticalScroll()
        local max = scrollFrame:GetVerticalScrollRange()
        if not max or max <= 0 then return end
        scrollFrame:SetVerticalScroll(math.max(0, math.min(max, cur - delta * 20)))
        UpdateScrollBar()
        FadeInBar()
    end)

    -- Print-to-chat button — small, sits in the bottom-right corner of the HUD.
    -- Always has EnableMouse(true) independently of the parent's mouse passthrough state.
    printBtn = CreateFrame("Button", "KwikTipCNPrintBtn", hud)
    printBtn:SetSize(16, 16)
    printBtn:SetPoint("BOTTOMRIGHT", hud, "BOTTOMRIGHT", -3, 3)
    printBtn:SetFrameLevel(hud:GetFrameLevel() + 3)
    printBtn:EnableMouse(true)
    printBtn:Hide()
    KwikTip.PrintBtn = printBtn

    local printBtnTex = printBtn:CreateTexture(nil, "OVERLAY")
    printBtnTex:SetTexture("Interface\\GossipFrame\\GossipGossipIcon")
    printBtnTex:SetAllPoints(printBtn)
    printBtnTex:SetAlpha(0.7)

    local printBtnHL = printBtn:CreateTexture(nil, "HIGHLIGHT")
    printBtnHL:SetColorTexture(1, 1, 1, 0.2)
    printBtnHL:SetAllPoints(printBtn)

    printBtn:SetScript("OnClick", function()
        local content = KwikTip._lastContent
        if not content or content == "" then return end

        -- Replace role icon textures with text labels, then strip remaining escapes.
        -- SendChatMessage requires plain text — the server strips everything else.
        local plain = content
        plain = plain:gsub("|T[^|]*Ability_Warrior_DefensiveStance[^|]*|t%s*", "[Tank] ")
        plain = plain:gsub("|T[^|]*Spell_Holy_Renew[^|]*|t%s*",               "[Heal] ")
        plain = plain:gsub("|T[^|]*Ability_DualWield[^|]*|t%s*",               "[DPS] ")
        plain = plain:gsub("|T[^|]*Ability_Kick[^|]*|t%s*",                    "[INT] ")
        plain = plain:gsub("|T.-|t", "")
        plain = plain:gsub("|c%x%x%x%x%x%x%x%x", "")
        plain = plain:gsub("|r", "")

        -- Collect non-empty lines and skip only the first (dungeon name); keep boss/entity name.
        local lines = {}
        for rawLine in plain:gmatch("[^\n]+") do
            local line = rawLine:match("^%s*(.-)%s*$")
            if line ~= "" then
                lines[#lines + 1] = line
            end
        end
        local channel = KwikTipCNDB.printChannel or "NONE"
        if channel == "NONE" then return end
        if InCombatLockdown() then
            -- SendChatMessage is protected during combat; defer until PLAYER_REGEN_ENABLED.
            -- Reuse a single module-level frame to avoid permanent per-click allocations.
            -- Multiple clicks during combat overwrite the pending data — last content wins.
            _pendingSendLines   = lines
            _pendingSendChannel = channel
            if not _combatSendFrame then
                _combatSendFrame = CreateFrame("Frame")
                _combatSendFrame:SetScript("OnEvent", function(self)
                    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
                    if _pendingSendLines and _pendingSendChannel then
                        for i = 2, #_pendingSendLines do
                            SendChatMessage(_pendingSendLines[i], _pendingSendChannel)
                        end
                        _pendingSendLines   = nil
                        _pendingSendChannel = nil
                    end
                end)
            end
            _combatSendFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
        else
            for i = 2, #lines do
                SendChatMessage(lines[i], channel)
            end
        end
    end)

    printBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText(L.TOOLTIP_PRINT, 1, 1, 1)
        GameTooltip:Show()
    end)

    printBtn:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    -- ---- Rich-text edit button (pencil icon, bottom-left) ----
    noteBtn = CreateFrame("Button", "KwikTipCNNoteBtn", hud)
    noteBtn:SetSize(16, 16)
    noteBtn:SetPoint("BOTTOMLEFT", hud, "BOTTOMLEFT", 3, 3)
    noteBtn:SetFrameLevel(hud:GetFrameLevel() + 3)
    noteBtn:EnableMouse(true)
    noteBtn:Hide()
    KwikTip.NoteBtn = noteBtn

    local noteBtnTex = noteBtn:CreateTexture(nil, "OVERLAY")
    noteBtnTex:SetTexture("Interface\\Icons\\inv_misc_1h_scribesquill_b_01_silver")
    noteBtnTex:SetAllPoints(noteBtn)
    noteBtnTex:SetAlpha(0.7)

    local noteBtnHL = noteBtn:CreateTexture(nil, "HIGHLIGHT")
    noteBtnHL:SetColorTexture(1, 1, 1, 0.2)
    noteBtnHL:SetAllPoints(noteBtn)

    -- ---- HUD rich-text editor popup ----
    notePopup = CreateFrame("Frame", "KwikTipCNNotePopup", UIParent, "BackdropTemplate")
    notePopup:SetSize(440, 340)
    notePopup:SetFrameStrata("DIALOG")
    notePopup:SetMovable(true)
    notePopup:EnableMouse(true)
    notePopup:RegisterForDrag("LeftButton")
    notePopup:SetScript("OnDragStart", notePopup.StartMoving)
    notePopup:SetScript("OnDragStop",  notePopup.StopMovingOrSizing)
    notePopup:SetClampedToScreen(true)
    notePopup:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
        insets   = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    notePopup:SetBackdropColor(0.05, 0.05, 0.05, 0.95)
    notePopup:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
    notePopup:Hide()

    local notePopupTitle = notePopup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    notePopupTitle:SetPoint("TOPLEFT", notePopup, "TOPLEFT", 8, -8)
    notePopupTitle:SetPoint("RIGHT", notePopup, "RIGHT", -8, 0)
    notePopupTitle:SetJustifyH("LEFT")
    notePopupTitle:SetWordWrap(false)
    notePopupTitle:SetText(L.BTN_NOTE_ADD)
    KwikTip._notePopupTitle = notePopupTitle

    local noteToolbar = CreateFrame("Frame", nil, notePopup)
    noteToolbar:SetPoint("TOPLEFT", notePopup, "TOPLEFT", 8, -28)
    noteToolbar:SetSize(424, 22)

    local function MakeRichInsertButton(label, tooltip, prefix, suffix)
        local button = CreateFrame("Button", nil, noteToolbar, "UIPanelButtonTemplate")
        button:SetSize(38, 22)
        button:SetText(label)
        button:SetScript("OnClick", function()
            local cursor = noteEditBox:GetCursorPosition()
            noteEditBox:Insert(prefix .. (suffix or ""))
            if suffix then noteEditBox:SetCursorPosition(cursor + #prefix) end
            noteEditBox:SetFocus()
        end)
        button:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:SetText(tooltip, 1, 1, 1)
            GameTooltip:Show()
        end)
        button:SetScript("OnLeave", function() GameTooltip:Hide() end)
        return button
    end

    local noteTools = {
        MakeRichInsertButton("|cffffcc00金|r", L.EDITOR_COLOR_GOLD, "|cffffcc00", "|r"),
        MakeRichInsertButton("|cffffffff白|r", L.EDITOR_COLOR_WHITE, "|cffffffff", "|r"),
        MakeRichInsertButton("|cffbbbbbb灰|r", L.EDITOR_COLOR_GRAY, "|cffbbbbbb", "|r"),
        MakeRichInsertButton("|cffff5555红|r", L.EDITOR_COLOR_RED, "|cffff5555", "|r"),
        MakeRichInsertButton("坦", L.EDITOR_ROLE_TANK, "|TInterface\\Icons\\Ability_Warrior_DefensiveStance:13:13|t "),
        MakeRichInsertButton("疗", L.EDITOR_ROLE_HEALER, "|TInterface\\Icons\\Spell_Holy_Renew:13:13|t "),
        MakeRichInsertButton("输", L.EDITOR_ROLE_DPS, "|TInterface\\Icons\\Ability_DualWield:13:13|t "),
        MakeRichInsertButton("断", L.EDITOR_ROLE_INTERRUPT, "|TInterface\\Icons\\Ability_Kick:13:13|t "),
        MakeRichInsertButton("•", L.EDITOR_BULLET, "\n• "),
        MakeRichInsertButton("↵", L.EDITOR_NEWLINE, "\n"),
    }
    for index, button in ipairs(noteTools) do
        button:SetPoint("LEFT", noteToolbar, "LEFT", (index - 1) * 41, 0)
    end

    local noteEditBg = CreateFrame("Frame", nil, notePopup, "BackdropTemplate")
    noteEditBg:SetPoint("TOPLEFT",     notePopup, "TOPLEFT",      8, -56)
    noteEditBg:SetPoint("BOTTOMRIGHT", notePopup, "BOTTOMRIGHT",  -8, 126)
    noteEditBg:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
        insets   = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    noteEditBg:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
    noteEditBg:SetBackdropBorderColor(0.35, 0.35, 0.35, 1)

    local noteScroll = CreateFrame("ScrollFrame", nil, noteEditBg, "UIPanelScrollFrameTemplate")
    noteScroll:SetPoint("TOPLEFT", noteEditBg, "TOPLEFT", 6, -6)
    noteScroll:SetPoint("BOTTOMRIGHT", noteEditBg, "BOTTOMRIGHT", -26, 6)

    noteEditBox = CreateFrame("EditBox", nil, noteScroll)
    noteEditBox:SetWidth(386)
    noteEditBox:SetHeight(146)
    noteEditBox:SetFontObject(GameFontNormal)
    noteEditBox:SetAutoFocus(false)
    noteEditBox:SetMaxLetters(8000)
    noteEditBox:SetMultiLine(true)
    noteEditBox:SetTextInsets(2, 2, 2, 2)
    noteEditBox:SetScript("OnEscapePressed", function() notePopup:Hide() end)
    noteScroll:SetScrollChild(noteEditBox)

    local notePreviewBg = CreateFrame("Frame", nil, notePopup, "BackdropTemplate")
    notePreviewBg:SetPoint("BOTTOMLEFT", notePopup, "BOTTOMLEFT", 8, 38)
    notePreviewBg:SetPoint("BOTTOMRIGHT", notePopup, "BOTTOMRIGHT", -8, 38)
    notePreviewBg:SetHeight(78)
    notePreviewBg:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background" })
    notePreviewBg:SetBackdropColor(0, 0, 0, 0.72)

    local notePreviewText = notePreviewBg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    notePreviewText:SetPoint("TOPLEFT", notePreviewBg, "TOPLEFT", 7, -6)
    notePreviewText:SetPoint("BOTTOMRIGHT", notePreviewBg, "BOTTOMRIGHT", -7, 6)
    notePreviewText:SetJustifyH("LEFT")
    notePreviewText:SetJustifyV("TOP")

    local function UpdateNotePreview()
        local text = noteEditBox:GetText() or ""
        notePreviewText:SetText(text ~= "" and text or ("|cff777777" .. L.EDITOR_EMPTY .. "|r"))
        local lines = noteEditBox.GetNumLines and noteEditBox:GetNumLines()
        if not lines then
            local _, count = text:gsub("\n", "\n")
            lines = count + 1
        end
        noteEditBox:SetHeight(math.max(146, lines * 15 + 12))
    end
    noteEditBox:SetScript("OnTextChanged", UpdateNotePreview)
    noteEditBox:SetScript("OnCursorChanged", function(_, _, cursorY, _, cursorHeight)
        if not cursorY or not cursorHeight then return end
        local offset = noteScroll:GetVerticalScroll()
        local height = noteScroll:GetHeight()
        if -cursorY < offset then
            noteScroll:SetVerticalScroll(math.max(0, -cursorY))
        elseif -cursorY + cursorHeight > offset + height then
            noteScroll:SetVerticalScroll(-cursorY + cursorHeight - height)
        end
    end)

    local noteSaveBtn = CreateFrame("Button", nil, notePopup, "UIPanelButtonTemplate")
    noteSaveBtn:SetSize(80, 22)
    noteSaveBtn:SetPoint("BOTTOMLEFT", notePopup, "BOTTOMLEFT", 8, 6)
    noteSaveBtn:SetText(L.BTN_NOTE_SAVE)

    local noteClearBtn = CreateFrame("Button", nil, notePopup, "UIPanelButtonTemplate")
    noteClearBtn:SetSize(80, 22)
    noteClearBtn:SetPoint("BOTTOMRIGHT", notePopup, "BOTTOMRIGHT", -8, 6)
    noteClearBtn:SetText(L.BTN_NOTE_CLEAR)

    local function SaveNote()
        local target = notePopupTarget
        if not target then notePopup:Hide(); return end
        KwikTip:SetCustomTip(target.key, noteEditBox:GetText())
        notePopup:Hide()
        KwikTip:UpdateContent()
    end

    noteSaveBtn:SetScript("OnClick", SaveNote)
    noteEditBox:SetScript("OnEnterPressed", function(self)
        -- Ctrl+Enter saves; Enter remains available for multi-line editing.
        if IsControlKeyDown() then
            SaveNote()
        else
            self:Insert("\n")
        end
    end)

    noteClearBtn:SetScript("OnClick", function()
        local target = notePopupTarget
        if target then KwikTip:SetCustomTip(target.key, nil) end
        notePopup:Hide()
        KwikTip:UpdateContent()
    end)

    noteBtn:SetScript("OnClick", function()
        if notePopup:IsShown() then
            notePopup:Hide()
            return
        end
        local target = KwikTip:GetCurrentTipEditTarget()
        if not target then return end
        notePopupTarget = { key = target.key, label = target.label }
        local existing = KwikTip:GetCustomTip(target.key) or ""
        noteEditBox:SetText(existing)
        noteEditBox:SetCursorPosition(noteEditBox:GetNumLetters())
        local titleStr = L.LABEL_NOTE .. ": " .. (target.label or target.key)
        KwikTip._notePopupTitle:SetText(titleStr)
        notePopup:ClearAllPoints()
        notePopup:SetPoint("BOTTOM", hud, "TOP", 0, 4)
        notePopup:Show()
        UpdateNotePreview()
        noteEditBox:SetFocus()
    end)

    noteBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(L.TOOLTIP_NOTE, 1, 1, 1)
        GameTooltip:Show()
    end)
    noteBtn:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

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
end

-- ============================================================
-- Public API
-- ============================================================

-- Apply saved settings to the HUD (size, opacity, position).
function KwikTip:ApplySettings()
    if not hud then return end
    local db = KwikTipCNDB
    hud:SetSize(db.width, db.height)
    hud:SetBackdropColor(0, 0, 0, db.alpha)
    hud:ClearAllPoints()
    hud:SetPoint("CENTER", UIParent, "CENTER", db.x or 0, db.y or 0)
    if db.borderEnabled ~= false then
        hud:SetBackdropBorderColor(db.borderColorR or 0, db.borderColorG or 0, db.borderColorB or 0, db.borderColorA or 1)
    else
        hud:SetBackdropBorderColor(0, 0, 0, 0)
    end
    if contentText then
        local LSM  = LibStub and LibStub("LibSharedMedia-3.0", true)
        local path = (LSM and db.fontName and LSM:Fetch("font", db.fontName))
                  or db.fontPath or "Fonts\\FRIZQT__.TTF"
        contentText:SetFont(path, db.fontSize or 11, db.textOutline or "")
        if db.textShadow then
            contentText:SetShadowOffset(1, -1)
            contentText:SetShadowColor(0, 0, 0, 1)
        else
            contentText:SetShadowOffset(0, 0)
            contentText:SetShadowColor(0, 0, 0, 0)
        end
    end
end

-- Show or hide the print button based on the showPrintBtn setting and HUD visibility.
function KwikTip:_UpdatePrintBtn()
    if not printBtn then return end
    if KwikTipCNDB.printChannel and KwikTipCNDB.printChannel ~= "NONE" and hud and hud:IsShown() then
        printBtn:Show()
    else
        printBtn:Hide()
    end
end

-- Show or hide the note (pencil) button based on the showNoteBtn setting and HUD visibility.
function KwikTip:_UpdateNoteBtn()
    if not noteBtn then return end
    local target = self.GetCurrentTipEditTarget and self:GetCurrentTipEditTarget()
    if KwikTipCNDB.showNoteBtn ~= false and target and hud and hud:IsShown() then
        noteBtn:Show()
    else
        noteBtn:Hide()
        if notePopup then notePopup:Hide() end
    end
end

-- Show the HUD when any active state warrants it, or when move mode is active.
--   bossActive    : ENCOUNTER_START is in progress
--   areaActive    : player is inside a named sub-zone with a defined tip
--   dungeonActive : player is in a known dungeon with showInDungeon enabled
-- Respects the persistentHide flag set from the config window.
function KwikTip:UpdateVisibility()
    if KwikTipCNDB.persistentHide and not self.moveMode then
        if hud then hud:Hide() end
        return
    end

    if self.moveMode or self.previewActive or self.bossActive or self.areaActive or self.dungeonActive then
        self:InitHUD()
        hud:Show()
    else
        if hud then hud:Hide() end
    end
    self:_UpdatePrintBtn()
    self:_UpdateNoteBtn()
end

-- Toggle between move mode (draggable, gold border) and locked mode.
-- Config.lua defines _UpdateConfigMoveBtn; it will be a no-op until that file loads.
function KwikTip:ToggleMoveMode()
    self:InitHUD()
    self.moveMode = not self.moveMode

    if self.moveMode then
        hud:EnableMouse(true)
        hud:Show()
        hud:SetBackdropBorderColor(1, 0.82, 0, 1)  -- gold outline = move mode active
    else
        hud:EnableMouse(false)
        local db = KwikTipCNDB
        if db.borderEnabled ~= false then
            hud:SetBackdropBorderColor(db.borderColorR or 0, db.borderColorG or 0, db.borderColorB or 0, db.borderColorA or 1)
        else
            hud:SetBackdropBorderColor(0, 0, 0, 0)
        end
        SaveHUDLayout()
        self:UpdateContent()
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
-- Set the text displayed inside the HUD box.
-- Guards against redundant SetText calls when content hasn't changed.
-- Auto-expands the frame height if the rendered text is taller than the
-- user's saved height, then restores it when content fits again.
-- SaveHUDLayout is NOT called here — the auto-expansion is transient.
function KwikTip:SetContent(str)
    str = str or ""
    if self._lastContent == str then return end
    self._lastContent = str
    if not contentText then self:InitHUD() end

    -- Ensure scrollChild width matches scrollFrame before measuring text height.
    local sw = scrollFrame:GetWidth()
    if sw and sw > 0 then scrollChild:SetWidth(sw) end

    contentText:SetText(str)

    local savedH = KwikTipCNDB.height or 80
    local textH  = contentText:GetStringHeight() + 12  -- 6px top + 6px bottom inset
    textH = math.max(textH, 1)
    scrollChild:SetHeight(textH)

    if KwikTipCNDB.autoExpand ~= false then
        -- Expand HUD to fit content; shrink back to savedH when content is short.
        hud:SetHeight(math.max(savedH, textH))
    else
        -- Fixed height: content scrolls within the saved viewport.
        hud:SetHeight(savedH)
    end

    -- Reset scroll to top when content changes (new area/boss).
    scrollFrame:SetVerticalScroll(0)
    UpdateScrollBar()
end
