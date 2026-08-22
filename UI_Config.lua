-- KwikTip: Config window & minimap button
local ADDON_NAME, KwikTip = ...
local L = KwikTip.L

-- ============================================================
-- Minimap Button
-- ============================================================
function KwikTip:_PlaceMinimapBtn()
    if self.MinimapBtn then return end
    if not KwikTipCNDB.showMinimapBtn then return end

    local btn = CreateFrame("Button", "KwikTipCNMinimapButton", Minimap)
    btn:SetSize(24, 24)
    btn:SetFrameStrata("MEDIUM")
    btn:SetFrameLevel(Minimap:GetFrameLevel() + 5)
    btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    btn:RegisterForDrag("LeftButton")

    local tex = btn:CreateTexture(nil, "OVERLAY")
    tex:SetTexture("Interface\\AddOns\\KwikTip_CN\\assets\\ktmini.tga")
    tex:SetBlendMode("BLEND")
    tex:SetAllPoints(btn)

    local function UpdatePosition()
        local angle  = KwikTipCNDB.minimapAngle or 0
        local radius = (Minimap:GetWidth() / 2) + 5  -- edge of minimap + 5px; matches LibDBIcon behaviour
        btn:ClearAllPoints()
        btn:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle) * radius, math.sin(angle) * radius)
    end

    btn:SetScript("OnShow", UpdatePosition)

    btn:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            KwikTip:ToggleConfig()
        elseif button == "RightButton" then
            KwikTip:ToggleMoveMode()
        end
    end)

    btn:SetScript("OnDragStart", function(self)
        self:LockHighlight()
        self:SetScript("OnUpdate", function(frame)
            local mx, my = Minimap:GetCenter()
            local px, py = GetCursorPosition()
            local scale  = UIParent:GetEffectiveScale()  -- GetCenter() is in UIParent virtual space
            local dx = px / scale - mx
            local dy = py / scale - my
            KwikTipCNDB.minimapAngle = math.atan2(dy, dx)
            UpdatePosition()
        end)
    end)

    btn:SetScript("OnDragStop", function(self)
        self:UnlockHighlight()
        self:SetScript("OnUpdate", nil)
    end)

    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("KwikTip_CN", 1, 1, 1)
        GameTooltip:AddLine(L.TOOLTIP_MINIMAP_LEFT, 0.7, 0.7, 0.7)
        GameTooltip:AddLine(L.TOOLTIP_MINIMAP_RIGHT, 0.7, 0.7, 0.7)
        GameTooltip:AddLine(L.TOOLTIP_MINIMAP_DRAG, 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)

    btn:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    UpdatePosition()
    self.MinimapBtn = btn
end

-- Called when showMinimapBtn setting changes.
function KwikTip:_UpdateMinimapButton()
    if not self.MinimapBtn then return end
    if KwikTipCNDB.showMinimapBtn then
        self.MinimapBtn:Show()
    else
        self.MinimapBtn:Hide()
    end
end

-- ============================================================
-- Config Window
-- ============================================================

function KwikTip:CreateConfigWindow()
    if self.Config then return end

    local cfg = CreateFrame("Frame", "KwikTipCNConfig", UIParent, "BasicFrameTemplate")
    local CFG_W, CFG_H = 700, 560
    cfg:SetSize(CFG_W, CFG_H)
    cfg:SetPoint("CENTER")
    cfg:SetFrameStrata("HIGH")
    cfg:SetMovable(true)
    cfg:EnableMouse(true)
    cfg:RegisterForDrag("LeftButton")
    cfg:SetScript("OnDragStart", cfg.StartMoving)
    cfg:SetScript("OnDragStop",  cfg.StopMovingOrSizing)
    cfg:SetClampedToScreen(true)
    cfg:SetScript("OnHide", function()
        if KwikTip.moveMode then
            KwikTip:ToggleMoveMode()
        end
        KwikTip:ClearPreview()
    end)
    cfg:Hide()

    cfg.TitleText:SetText(L.SETTINGS_TITLE)

    local titleIcon = cfg:CreateTexture(nil, "OVERLAY")
    titleIcon:SetTexture("Interface\\AddOns\\KwikTip_CN\\assets\\ktmini.tga")
    titleIcon:SetBlendMode("BLEND")
    titleIcon:SetSize(16, 16)
    titleIcon:SetPoint("RIGHT", cfg.TitleText, "LEFT", -4, 0)

    -- ============================================================
    -- Layout constants
    -- ============================================================
    local NAV_W     = 140
    local TITLE_H   = 28
    local CONTENT_W = CFG_W - NAV_W - 5
    local INNER_W   = CONTENT_W - 24    -- ~381px (12px margin each side)
    local MARGIN    = 12

    -- ============================================================
    -- Nav pane
    -- ============================================================
    local navPane = CreateFrame("Frame", nil, cfg, "BackdropTemplate")
    navPane:SetPoint("TOPLEFT",    cfg, "TOPLEFT",    0, -TITLE_H)
    navPane:SetPoint("BOTTOMLEFT", cfg, "BOTTOMLEFT", 0, 4)
    navPane:SetWidth(NAV_W)
    navPane:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
        insets   = { left = 0, right = 0, top = 0, bottom = 0 },
    })
    navPane:SetBackdropColor(0.06, 0.06, 0.08, 1)
    navPane:SetBackdropBorderColor(0, 0, 0, 0)

    -- Vertical divider between nav and content
    local navDivider = cfg:CreateTexture(nil, "OVERLAY")
    navDivider:SetColorTexture(0.22, 0.22, 0.25, 1)
    navDivider:SetWidth(1)
    navDivider:SetPoint("TOPLEFT",    cfg, "TOPLEFT",    NAV_W, -TITLE_H)
    navDivider:SetPoint("BOTTOMLEFT", cfg, "BOTTOMLEFT", NAV_W, 4)

    -- Content pane (logical container — tab frames fill this)
    local contentPane = CreateFrame("Frame", nil, cfg)
    contentPane:SetPoint("TOPLEFT",     cfg, "TOPLEFT",     NAV_W + 1, -TITLE_H)
    contentPane:SetPoint("BOTTOMRIGHT", cfg, "BOTTOMRIGHT", -4, 4)

    -- Logo at bottom of nav pane
    local navLogo = navPane:CreateTexture(nil, "ARTWORK")
    navLogo:SetTexture("Interface\\AddOns\\KwikTip_CN\\assets\\ktlogo.tga")
    navLogo:SetBlendMode("BLEND")
    navLogo:SetSize(110, 60)
    navLogo:SetPoint("BOTTOM", navPane, "BOTTOM", 0, 12)

    -- ============================================================
    -- Shared helpers
    -- ============================================================

    -- parent: frame that owns the created textures/fontstrings
    -- anchor: frame/fontstring the header is positioned relative to
    local function MakeSectionHeader(text, parent, anchor, yOffset, xOffset)
        local gap  = yOffset or -14
        local xOff = xOffset or 0
        local div = parent:CreateTexture(nil, "OVERLAY")
        div:SetColorTexture(0.25, 0.25, 0.28, 0.8)
        div:SetSize(INNER_W - math.abs(xOff), 1)
        div:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", xOff, math.floor(gap / 2))
        local h = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        h:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", xOff, gap)
        h:SetText(text)
        h:SetTextColor(0.9, 0.75, 0.3, 1)
        return h
    end

    local function MakeCheckbox(name, parent, anchor, labelText, yGap)
        local cb = CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate")
        cb:SetSize(24, 24)
        cb:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, yGap or -2)
        local lbl = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        lbl:SetPoint("LEFT", cb, "RIGHT", 2, 0)
        lbl:SetText(labelText)
        return cb
    end

    local function AddTooltip(frame, text)
        frame:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:ClearLines()
            GameTooltip:AddLine(text)
            GameTooltip:Show()
        end)
        frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
    end

    local function MakeNudgeRow(label, parent, anchor)
        local wrap = CreateFrame("Frame", nil, parent)
        wrap:SetSize(320, 24)
        wrap:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -6)

        local lbl = wrap:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        lbl:SetPoint("LEFT", wrap, "LEFT", 0, 0)
        lbl:SetText(label)
        lbl:SetWidth(18)

        local minusBtn = CreateFrame("Button", nil, wrap, "UIPanelButtonTemplate")
        minusBtn:SetSize(24, 22)
        minusBtn:SetPoint("LEFT", lbl, "RIGHT", 4, 0)
        minusBtn:SetText("-")

        local ebBg = CreateFrame("Frame", nil, wrap, "BackdropTemplate")
        ebBg:SetSize(72, 22)
        ebBg:SetPoint("LEFT", minusBtn, "RIGHT", 2, 0)
        ebBg:SetBackdrop({
            bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
            insets   = { left = 2, right = 2, top = 2, bottom = 2 },
        })
        ebBg:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
        ebBg:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)

        local eb = CreateFrame("EditBox", nil, ebBg)
        eb:SetSize(66, 18)
        eb:SetPoint("CENTER", ebBg, "CENTER")
        eb:SetFontObject(GameFontNormal)
        eb:SetAutoFocus(false)
        eb:SetMaxLetters(8)
        eb:SetJustifyH("CENTER")

        local plusBtn = CreateFrame("Button", nil, wrap, "UIPanelButtonTemplate")
        plusBtn:SetSize(24, 22)
        plusBtn:SetPoint("LEFT", ebBg, "RIGHT", 2, 0)
        plusBtn:SetText("+")

        return wrap, eb, minusBtn, plusBtn
    end

    -- sliderWidth: optional override; defaults to full inner content width
    local function MakeSlider(name, parent, anchor, minVal, maxVal, step, initLabel, lowText, highText, sliderWidth)
        local W = sliderWidth or (INNER_W - 10)

        local wrap = CreateFrame("Frame", nil, parent)
        wrap:SetSize(W + 20, 40)
        wrap:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 8, -14)

        local lbl = wrap:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        lbl:SetPoint("TOPLEFT", wrap, "TOPLEFT", 0, 0)
        lbl:SetText(initLabel)

        local s = CreateFrame("Slider", name, wrap)
        s:SetSize(W, 12)
        s:SetPoint("TOPLEFT", lbl, "BOTTOMLEFT", 0, -4)
        s:SetOrientation("HORIZONTAL")
        s:SetMinMaxValues(minVal, maxVal)
        s:SetValueStep(step)
        s:SetObeyStepOnDrag(true)
        s:EnableMouseWheel(true)

        local track = s:CreateTexture(nil, "BACKGROUND")
        track:SetColorTexture(0.2, 0.2, 0.2, 0.9)
        track:SetAllPoints(s)

        local thumb = s:CreateTexture(nil, "OVERLAY")
        thumb:SetColorTexture(0.75, 0.75, 0.75, 1)
        thumb:SetSize(10, 20)
        s:SetThumbTexture(thumb)

        local lo = wrap:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        lo:SetPoint("TOPLEFT", s, "BOTTOMLEFT", 0, -2)
        lo:SetText(lowText)

        local hi = wrap:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        hi:SetPoint("TOPRIGHT", s, "BOTTOMRIGHT", 0, -2)
        hi:SetText(highText)

        s:SetScript("OnMouseWheel", function(self, delta)
            self:SetValue(self:GetValue() + delta * self:GetValueStep())
        end)

        s._lbl  = lbl
        s._wrap = wrap
        return s
    end

    -- ============================================================
    -- Tab system
    -- ============================================================
    local TAB_NAMES  = { L.TAB_GENERAL, L.TAB_LAYOUT, L.TAB_APPEARANCE, L.TAB_TIP_EDITOR }
    local TAB_BTN_H  = 34
    local TAB_BTN_W  = NAV_W - 2
    local tabButtons = {}
    local tabFrames  = {}

    -- Hoisted so SelectTab can close them when switching tabs
    local chatDropList, fontDropList, outlineDropList, editorDungeonList, editorEntryList

    -- Gold accent bar that slides to the active tab button
    local accentBar = navPane:CreateTexture(nil, "OVERLAY")
    accentBar:SetColorTexture(0.9, 0.75, 0.3, 1)
    accentBar:SetSize(3, TAB_BTN_H)

    local function SelectTab(index)
        if chatDropList then chatDropList:Hide() end
        if fontDropList then fontDropList:Hide() end
        if outlineDropList then outlineDropList:Hide() end
        if editorDungeonList then editorDungeonList:Hide() end
        if editorEntryList then editorEntryList:Hide() end
        for i = 1, #tabFrames do
            tabFrames[i]:SetShown(i == index)
            if i == index then
                tabButtons[i]:SetBackdropColor(0.18, 0.18, 0.22, 1)
                tabButtons[i]._lbl:SetTextColor(1, 1, 1)
            else
                tabButtons[i]:SetBackdropColor(0.09, 0.09, 0.11, 1)
                tabButtons[i]._lbl:SetTextColor(0.6, 0.6, 0.6)
            end
        end
        accentBar:ClearAllPoints()
        accentBar:SetPoint("TOPLEFT", tabButtons[index], "TOPLEFT", 0, 0)
    end

    for i, name in ipairs(TAB_NAMES) do
        local btn = CreateFrame("Button", nil, navPane, "BackdropTemplate")
        btn:SetSize(TAB_BTN_W, TAB_BTN_H)
        btn:SetPoint("TOPLEFT", navPane, "TOPLEFT", 1, -(i - 1) * (TAB_BTN_H + 3) - 12)
        btn:SetBackdrop({
            bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
            insets   = { left = 0, right = 0, top = 0, bottom = 0 },
        })
        btn:SetBackdropColor(0.09, 0.09, 0.11, 1)
        btn:SetBackdropBorderColor(0, 0, 0, 0)

        local lbl = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        lbl:SetPoint("LEFT", btn, "LEFT", 14, 0)
        lbl:SetText(name)
        lbl:SetTextColor(0.6, 0.6, 0.6)
        btn._lbl = lbl

        local hl = btn:CreateTexture(nil, "HIGHLIGHT")
        hl:SetColorTexture(1, 1, 1, 0.05)
        hl:SetAllPoints(btn)

        local idx = i
        btn:SetScript("OnClick", function() SelectTab(idx) end)

        tabButtons[i] = btn

        local tf = CreateFrame("Frame", nil, contentPane)
        tf:SetAllPoints(contentPane)
        tf:Hide()
        tabFrames[i] = tf
    end

    -- Preview button: centered in nav pane, 16px below the last tab button
    local previewBtn = CreateFrame("Button", "KwikTipCNConfigPreviewBtn", navPane, "UIPanelButtonTemplate")
    previewBtn:SetSize(120, 22)
    previewBtn:SetPoint("TOP", navPane, "TOP", 0, -(#TAB_NAMES * (TAB_BTN_H + 3) + 12 + 16))
    previewBtn:SetText(L.PREVIEW_BTN)
    previewBtn:SetScript("OnClick", function() KwikTip:TogglePreview() end)

    -- ============================================================
    -- TAB 1: General
    -- ============================================================
    local tf1 = tabFrames[1]

    local t1Top = CreateFrame("Frame", nil, tf1)
    t1Top:SetSize(1, 1)
    t1Top:SetPoint("TOPLEFT", tf1, "TOPLEFT", MARGIN, 0)

    local displayHeader = MakeSectionHeader(L.SECTION_DISPLAY, tf1, t1Top, -12)

    local hideHUDCB       = MakeCheckbox("KwikTipCNHideHUDCB",       tf1, displayHeader,   L.CHECK_DISABLE,               -6)
    local minimapBtnCB    = MakeCheckbox("KwikTipCNMinimapBtnCB",    tf1, hideHUDCB,       L.CHECK_MINIMAP)
    local showInDungeonCB = MakeCheckbox("KwikTipCNShowInDungeonCB", tf1, minimapBtnCB,    L.CHECK_PERSISTENT)
    minimapBtnCB:SetScript("OnClick", function(self)
        KwikTipCNDB.showMinimapBtn = self:GetChecked()
        if KwikTip._PlaceMinimapBtn     then KwikTip:_PlaceMinimapBtn()     end
        if KwikTip._UpdateMinimapButton then KwikTip:_UpdateMinimapButton() end
    end)
    hideHUDCB:SetScript("OnClick", function(self)
        KwikTipCNDB.persistentHide = self:GetChecked()
        KwikTip:UpdateVisibility()
    end)
    AddTooltip(hideHUDCB, L.TOOLTIP_HIDE)
    showInDungeonCB:SetScript("OnClick", function(self)
        KwikTipCNDB.showInDungeon = self:GetChecked()
        KwikTip:UpdateContent()
        KwikTip:UpdateVisibility()
    end)
    AddTooltip(showInDungeonCB, L.TOOLTIP_PERSISTENT)
    local showNoteBtnCB = MakeCheckbox("KwikTipCNShowNoteBtnCB", tf1, showInDungeonCB, L.CHECK_NOTES)
    showNoteBtnCB:SetScript("OnClick", function(self)
        KwikTipCNDB.showNoteBtn = self:GetChecked()
        if KwikTip._UpdateNoteBtn then KwikTip:_UpdateNoteBtn() end
    end)
    AddTooltip(showNoteBtnCB, L.TOOLTIP_NOTES)

    local enableDelvesCB = MakeCheckbox("KwikTipCNEnableDelvesCB", tf1, showNoteBtnCB, L.CHECK_DELVES)
    enableDelvesCB:SetScript("OnClick", function(self)
        KwikTipCNDB.delves = self:GetChecked()
        KwikTip:UpdateContent()
        KwikTip:UpdateVisibility()
    end)
    AddTooltip(enableDelvesCB, L.TOOLTIP_DELVES)

    local chatHeader = MakeSectionHeader(L.SECTION_CHAT, tf1, enableDelvesCB, -14)

    local CHAT_OPTIONS = {
        { label = L.LABEL_NONE,     value = "NONE"          },
        { label = L.CHAT_SAY,      value = "SAY"           },
        { label = L.CHAT_INSTANCE, value = "INSTANCE_CHAT" },
        { label = L.CHAT_PARTY,    value = "PARTY"         },
        { label = L.CHAT_RAID,     value = "RAID"          },
    }

    local chatDropBtn

    local function SetChatChannel(value)
        KwikTipCNDB.printChannel = value
        for _, opt in ipairs(CHAT_OPTIONS) do
            if opt.value == value then
                if chatDropBtn then chatDropBtn:SetText(opt.label) end
                break
            end
        end
        if KwikTip._UpdatePrintBtn then KwikTip:_UpdatePrintBtn() end
    end

    chatDropBtn = CreateFrame("Button", nil, tf1, "UIPanelButtonTemplate")
    chatDropBtn:SetSize(180, 22)
    chatDropBtn:SetPoint("TOPLEFT", chatHeader, "BOTTOMLEFT", 0, -6)

    chatDropList = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    chatDropList:SetSize(180, #CHAT_OPTIONS * 22)
    chatDropList:SetFrameStrata("TOOLTIP")
    chatDropList:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
        insets   = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    chatDropList:SetBackdropColor(0.08, 0.08, 0.08, 0.97)
    chatDropList:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
    chatDropList:Hide()

    for i, opt in ipairs(CHAT_OPTIONS) do
        local row = CreateFrame("Button", nil, chatDropList)
        row:SetSize(178, 20)
        row:SetPoint("TOPLEFT", chatDropList, "TOPLEFT", 1, -(i - 1) * 20 - 1)

        local hl = row:CreateTexture(nil, "HIGHLIGHT")
        hl:SetColorTexture(1, 1, 1, 0.08)
        hl:SetAllPoints(row)

        local rowLbl = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        rowLbl:SetPoint("LEFT", row, "LEFT", 6, 0)
        rowLbl:SetText(opt.label)

        local value = opt.value
        row:SetScript("OnClick", function()
            SetChatChannel(value)
            chatDropList:Hide()
        end)
    end

    chatDropBtn:SetScript("OnClick", function()
        if chatDropList:IsShown() then
            chatDropList:Hide()
        else
            chatDropList:ClearAllPoints()
            chatDropList:SetPoint("TOPLEFT", chatDropBtn, "BOTTOMLEFT", 0, -2)
            chatDropList:Show()
        end
    end)


    -- ============================================================
    -- TAB 2: Layout
    -- ============================================================
    local tf2 = tabFrames[2]

    local t2Top = CreateFrame("Frame", nil, tf2)
    t2Top:SetSize(1, 1)
    t2Top:SetPoint("TOPLEFT", tf2, "TOPLEFT", MARGIN, 0)

    local posHeader = MakeSectionHeader(L.SECTION_POSITION, tf2, t2Top, -12)

    local moveBtn = CreateFrame("Button", "KwikTipCNConfigMoveBtn", tf2, "UIPanelButtonTemplate")
    moveBtn:SetSize(130, 22)
    moveBtn:SetPoint("TOPLEFT", posHeader, "BOTTOMLEFT", 0, -6)
    moveBtn:SetText(L.BTN_MOVE)
    moveBtn:SetScript("OnClick", function() KwikTip:ToggleMoveMode() end)

    local sizingHeader = MakeSectionHeader(L.SECTION_SIZING, tf2, moveBtn, -14)

    local widthEdit, heightEdit

    local function ApplySize(w, h)
        w = math.max(100, math.min(600, math.floor(tonumber(w) or KwikTipCNDB.width  or 220)))
        h = math.max(40,  math.min(400, math.floor(tonumber(h) or KwikTipCNDB.height or 80)))
        KwikTipCNDB.width  = w
        KwikTipCNDB.height = h
        if KwikTip.HUD then KwikTip.HUD:SetSize(w, h) end
        widthEdit:SetText(tostring(w))
        heightEdit:SetText(tostring(h))
    end

    local widthRow, widthMinus, widthPlus
    widthRow, widthEdit, widthMinus, widthPlus = MakeNudgeRow(L.LABEL_WIDTH, tf2, sizingHeader)
    widthEdit:SetScript("OnEnterPressed",  function(self) ApplySize(self:GetText(), KwikTipCNDB.height) self:ClearFocus() end)
    widthEdit:SetScript("OnEscapePressed", function(self) self:SetText(tostring(KwikTipCNDB.width or 220)) self:ClearFocus() end)
    widthMinus:SetScript("OnClick", function() ApplySize((KwikTipCNDB.width  or 220) - 1, KwikTipCNDB.height) end)
    widthPlus:SetScript("OnClick",  function() ApplySize((KwikTipCNDB.width  or 220) + 1, KwikTipCNDB.height) end)

    local heightRow, heightMinus, heightPlus
    heightRow, heightEdit, heightMinus, heightPlus = MakeNudgeRow(L.LABEL_HEIGHT, tf2, widthRow)
    heightEdit:SetScript("OnEnterPressed",  function(self) ApplySize(KwikTipCNDB.width, self:GetText()) self:ClearFocus() end)
    heightEdit:SetScript("OnEscapePressed", function(self) self:SetText(tostring(KwikTipCNDB.height or 80)) self:ClearFocus() end)
    heightMinus:SetScript("OnClick", function() ApplySize(KwikTipCNDB.width, (KwikTipCNDB.height or 80) - 1) end)
    heightPlus:SetScript("OnClick",  function() ApplySize(KwikTipCNDB.width, (KwikTipCNDB.height or 80) + 1) end)

    local autoExpandCB = MakeCheckbox("KwikTipCNAutoExpandCB", tf2, heightRow, L.CHECK_AUTOEXPAND, -6)
    autoExpandCB:SetScript("OnClick", function(self)
        KwikTipCNDB.autoExpand = self:GetChecked()
        KwikTip:UpdateContent()
    end)

    -- ============================================================
    -- TAB 3: Appearance
    -- ============================================================
    local tf3 = tabFrames[3]

    local t3Top = CreateFrame("Frame", nil, tf3)
    t3Top:SetSize(1, 1)
    t3Top:SetPoint("TOPLEFT", tf3, "TOPLEFT", MARGIN, 0)

    local windowHeader = MakeSectionHeader(L.SECTION_WINDOW, tf3, t3Top, -12)

    local opacitySlider = MakeSlider("KwikTipCNOpacitySlider", tf3, windowHeader, 0, 100, 5, L.SLIDER_OPACITY, "0%", "100%")
    opacitySlider:SetScript("OnValueChanged", function(self, value)
        KwikTipCNDB.alpha = value / 100
        if KwikTip.HUD then KwikTip.HUD:SetBackdropColor(0, 0, 0, KwikTipCNDB.alpha) end
        self._lbl:SetText(string.format(L.FMT_OPACITY, value))
    end)

    local borderEnabledCB = MakeCheckbox("KwikTipCNBorderEnabledCB", tf3, opacitySlider._wrap, L.CHECK_BORDER, -4)
    borderEnabledCB:SetScript("OnClick", function(self)
        KwikTipCNDB.borderEnabled = self:GetChecked()
        KwikTip:ApplySettings()
    end)

    local borderColorLabel = tf3:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    borderColorLabel:SetPoint("TOPLEFT", borderEnabledCB, "BOTTOMLEFT", 0, -8)
    borderColorLabel:SetText(L.LABEL_BORDER_COLOR)

    local borderSwatchBtn = CreateFrame("Button", nil, tf3, "BackdropTemplate")
    borderSwatchBtn:SetSize(20, 20)
    borderSwatchBtn:SetPoint("LEFT", borderColorLabel, "RIGHT", 6, 0)
    borderSwatchBtn:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
        insets   = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    borderSwatchBtn:SetBackdropColor(0, 0, 0, 1)
    borderSwatchBtn:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)

    local function ApplyBorderColor(r, g, b)
        KwikTipCNDB.borderColorR = r
        KwikTipCNDB.borderColorG = g
        KwikTipCNDB.borderColorB = b
        borderSwatchBtn:SetBackdropColor(r, g, b, 1)
        if KwikTip.HUD and KwikTipCNDB.borderEnabled ~= false then
            KwikTip.HUD:SetBackdropBorderColor(r, g, b, KwikTipCNDB.borderColorA or 1)
        end
    end

    borderSwatchBtn:SetScript("OnClick", function()
        local db = KwikTipCNDB
        ColorPickerFrame:SetupColorPickerAndShow({
            swatchFunc = function()
                local r, g, b = ColorPickerFrame:GetColorRGB()
                ApplyBorderColor(r, g, b)
            end,
            cancelFunc = function(prev)
                ApplyBorderColor(prev.r, prev.g, prev.b)
            end,
            hasOpacity = false,
            r = db.borderColorR or 0,
            g = db.borderColorG or 0,
            b = db.borderColorB or 0,
        })
    end)

    -- xOffset = -8: compensates for the 8px slider indent so TEXT header aligns with WINDOW header
    local textHeader = MakeSectionHeader(L.SECTION_TEXT, tf3, borderColorLabel, -14, -8)

    -- Font selector (LibSharedMedia-3.0 aware; falls back to 3 built-in fonts)
    local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)

    local FONT_FALLBACK = {
        ["Friz Quadrata"] = "Fonts\\FRIZQT__.TTF",
        ["Arial Narrow"]  = "Fonts\\ARIALN.TTF",
        ["Morpheus"]      = "Fonts\\MORPHEUS.TTF",
    }

    local fontNames
    if LSM then
        fontNames = LSM:List("font")
        table.sort(fontNames)
    else
        fontNames = { "Arial Narrow", "Friz Quadrata", "Morpheus" }
    end

    local function ResolveFontPath(name)
        if LSM then return LSM:Fetch("font", name) or FONT_FALLBACK[name] or "Fonts\\FRIZQT__.TTF" end
        return FONT_FALLBACK[name] or "Fonts\\FRIZQT__.TTF"
    end

    local fontDropBtn

    local function SetFont(name)
        KwikTipCNDB.fontName = name
        KwikTipCNDB.fontPath = ResolveFontPath(name)
        if fontDropBtn then fontDropBtn:SetText(name) end
        KwikTip:ApplySettings()
    end

    local DROP_W   = 200
    local ROW_H    = 20
    local MAX_ROWS = 10

    fontDropBtn = CreateFrame("Button", nil, tf3, "UIPanelButtonTemplate")
    fontDropBtn:SetSize(DROP_W, 22)
    fontDropBtn:SetPoint("TOPLEFT", textHeader, "BOTTOMLEFT", 0, -6)

    fontDropList = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    fontDropList:SetSize(DROP_W, math.min(#fontNames, MAX_ROWS) * ROW_H + 2)
    fontDropList:SetFrameStrata("TOOLTIP")
    fontDropList:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
        insets   = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    fontDropList:SetBackdropColor(0.08, 0.08, 0.08, 0.97)
    fontDropList:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
    fontDropList:Hide()

    local fontScroll = CreateFrame("ScrollFrame", nil, fontDropList)
    fontScroll:SetPoint("TOPLEFT",     fontDropList, "TOPLEFT",     1, -1)
    fontScroll:SetPoint("BOTTOMRIGHT", fontDropList, "BOTTOMRIGHT", -1, 1)

    local fontScrollChild = CreateFrame("Frame")
    fontScrollChild:SetSize(DROP_W - 2, #fontNames * ROW_H)
    fontScroll:SetScrollChild(fontScrollChild)

    for i, name in ipairs(fontNames) do
        local row = CreateFrame("Button", nil, fontScrollChild)
        row:SetSize(DROP_W - 2, ROW_H)
        row:SetPoint("TOPLEFT", fontScrollChild, "TOPLEFT", 0, -(i - 1) * ROW_H)

        local hl = row:CreateTexture(nil, "HIGHLIGHT")
        hl:SetColorTexture(1, 1, 1, 0.08)
        hl:SetAllPoints(row)

        local rowLbl = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        rowLbl:SetPoint("LEFT", row, "LEFT", 6, 0)
        rowLbl:SetText(name)

        local n = name
        row:SetScript("OnClick", function()
            SetFont(n)
            fontDropList:Hide()
        end)
    end

    fontDropList:EnableMouseWheel(true)
    fontDropList:SetScript("OnMouseWheel", function(self, delta)
        local cur = fontScroll:GetVerticalScroll()
        local max = fontScroll:GetVerticalScrollRange()
        fontScroll:SetVerticalScroll(math.max(0, math.min(max, cur - delta * ROW_H)))
    end)

    fontDropBtn:SetScript("OnClick", function()
        if fontDropList:IsShown() then
            fontDropList:Hide()
        else
            fontDropList:ClearAllPoints()
            fontDropList:SetPoint("TOPLEFT", fontDropBtn, "BOTTOMLEFT", 0, -2)
            fontDropList:Show()
        end
    end)

    -- Font size slider matches the dropdown width so they visually pair up
    local fontSizeSlider = MakeSlider("KwikTipCNFontSizeSlider", tf3, fontDropBtn, 9, 18, 1, string.format(L.FMT_SIZE, 11), "9", "18", DROP_W)
    fontSizeSlider:SetScript("OnValueChanged", function(self, value)
        KwikTipCNDB.fontSize = value
        KwikTip:ApplySettings()
        self._lbl:SetText(string.format(L.FMT_SIZE, value))
    end)

    local shadowCB = MakeCheckbox("KwikTipCNShadowCB", tf3, fontSizeSlider._wrap, L.CHECK_SHADOW, -4)
    shadowCB:SetScript("OnClick", function(self)
        KwikTipCNDB.textShadow = self:GetChecked()
        KwikTip:ApplySettings()
    end)

    local outlineLabel = tf3:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    outlineLabel:SetPoint("TOPLEFT", shadowCB, "BOTTOMLEFT", 0, -8)
    outlineLabel:SetText(L.LABEL_OUTLINE)

    local OUTLINE_OPTIONS = {
        { label = L.LABEL_NONE,          value = ""             },
        { label = L.OUTLINE_OUTLINE,       value = "OUTLINE"      },
        { label = L.OUTLINE_THICK, value = "THICKOUTLINE" },
    }

    local outlineDropBtn

    local function SetOutline(value)
        KwikTipCNDB.textOutline = value
        for _, opt in ipairs(OUTLINE_OPTIONS) do
            if opt.value == value then
                if outlineDropBtn then outlineDropBtn:SetText(opt.label) end
                break
            end
        end
        KwikTip:ApplySettings()
    end

    outlineDropBtn = CreateFrame("Button", nil, tf3, "UIPanelButtonTemplate")
    outlineDropBtn:SetSize(180, 22)
    outlineDropBtn:SetPoint("TOPLEFT", outlineLabel, "BOTTOMLEFT", 0, -4)

    outlineDropList = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    outlineDropList:SetSize(180, #OUTLINE_OPTIONS * 22)
    outlineDropList:SetFrameStrata("TOOLTIP")
    outlineDropList:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
        insets   = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    outlineDropList:SetBackdropColor(0.08, 0.08, 0.08, 0.97)
    outlineDropList:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
    outlineDropList:Hide()

    for i, opt in ipairs(OUTLINE_OPTIONS) do
        local row = CreateFrame("Button", nil, outlineDropList)
        row:SetSize(178, 20)
        row:SetPoint("TOPLEFT", outlineDropList, "TOPLEFT", 1, -(i - 1) * 20 - 1)

        local hl = row:CreateTexture(nil, "HIGHLIGHT")
        hl:SetColorTexture(1, 1, 1, 0.08)
        hl:SetAllPoints(row)

        local rowLbl = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        rowLbl:SetPoint("LEFT", row, "LEFT", 6, 0)
        rowLbl:SetText(opt.label)

        local value = opt.value
        row:SetScript("OnClick", function()
            SetOutline(value)
            outlineDropList:Hide()
        end)
    end

    outlineDropBtn:SetScript("OnClick", function()
        if outlineDropList:IsShown() then
            outlineDropList:Hide()
        else
            outlineDropList:ClearAllPoints()
            outlineDropList:SetPoint("TOPLEFT", outlineDropBtn, "BOTTOMLEFT", 0, -2)
            outlineDropList:Show()
        end
    end)

    -- ============================================================
    -- TAB 4: User-authored Mythic+ rich-text tips
    -- ============================================================
    local tf4 = tabFrames[4]
    local editorDungeonBtn, editorEntryBtn, editorEditBox
    local editorPreviewText, editorStatus
    local editorDungeon, editorEntry, editorEntries
    local editorLoading, editorDirty = false, false
    local editorDungeonRows, editorEntryRows = {}, {}

    local editorTitle = tf4:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    editorTitle:SetPoint("TOPLEFT", tf4, "TOPLEFT", MARGIN, -14)
    editorTitle:SetText(L.TAB_TIP_EDITOR)
    editorTitle:SetTextColor(0.9, 0.75, 0.3, 1)

    local editorHelp = tf4:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    editorHelp:SetPoint("TOPLEFT", editorTitle, "BOTTOMLEFT", 0, -7)
    editorHelp:SetPoint("RIGHT", tf4, "RIGHT", -MARGIN, 0)
    editorHelp:SetJustifyH("LEFT")
    editorHelp:SetTextColor(0.72, 0.72, 0.72, 1)
    editorHelp:SetText(L.EDITOR_HELP)

    local dungeonLabel = tf4:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dungeonLabel:SetPoint("TOPLEFT", editorHelp, "BOTTOMLEFT", 0, -14)
    dungeonLabel:SetText(L.EDITOR_DUNGEON)

    editorDungeonBtn = CreateFrame("Button", nil, tf4, "UIPanelButtonTemplate")
    editorDungeonBtn:SetSize(245, 24)
    editorDungeonBtn:SetPoint("TOPLEFT", dungeonLabel, "BOTTOMLEFT", 0, -4)

    local entryLabel = tf4:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    entryLabel:SetPoint("TOPLEFT", editorDungeonBtn, "TOPRIGHT", 12, 20)
    entryLabel:SetText(L.EDITOR_SECTION)

    editorEntryBtn = CreateFrame("Button", nil, tf4, "UIPanelButtonTemplate")
    editorEntryBtn:SetSize(245, 24)
    editorEntryBtn:SetPoint("TOPLEFT", entryLabel, "BOTTOMLEFT", 0, -4)

    local function MakeEditorMenu(width)
        local menu = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
        menu:SetWidth(width)
        menu:SetFrameStrata("TOOLTIP")
        menu:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
        menu:SetBackdropColor(0.06, 0.06, 0.07, 0.98)
        menu:SetBackdropBorderColor(0.45, 0.45, 0.48, 1)
        menu:Hide()
        return menu
    end

    editorDungeonList = MakeEditorMenu(245)
    editorEntryList = MakeEditorMenu(245)

    local function PopulateEditorMenu(menu, rows, items, labelFunc, onClick)
        for _, row in ipairs(rows) do row:Hide() end
        local rowHeight = 23
        for index, item in ipairs(items) do
            local row = rows[index]
            if not row then
                row = CreateFrame("Button", nil, menu)
                row:SetSize(243, rowHeight)
                local hl = row:CreateTexture(nil, "HIGHLIGHT")
                hl:SetColorTexture(1, 1, 1, 0.08)
                hl:SetAllPoints(row)
                row._text = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                row._text:SetPoint("LEFT", row, "LEFT", 7, 0)
                row._text:SetPoint("RIGHT", row, "RIGHT", -5, 0)
                row._text:SetJustifyH("LEFT")
                rows[index] = row
            end
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", menu, "TOPLEFT", 1, -1 - (index - 1) * rowHeight)
            row._text:SetText(labelFunc(item))
            local selectedItem = item
            row:SetScript("OnClick", function()
                menu:Hide()
                onClick(selectedItem)
            end)
            row:Show()
        end
        menu:SetHeight(math.max(2, #items * rowHeight + 2))
    end

    local toolbar = CreateFrame("Frame", nil, tf4)
    toolbar:SetSize(INNER_W, 25)
    toolbar:SetPoint("TOPLEFT", editorDungeonBtn, "BOTTOMLEFT", 0, -12)

    local function EditorButton(textValue, tooltip, insertText, closeText)
        local button = CreateFrame("Button", nil, toolbar, "UIPanelButtonTemplate")
        button:SetSize(46, 23)
        button:SetText(textValue)
        AddTooltip(button, tooltip)
        button:SetScript("OnClick", function()
            if not editorEditBox or not editorEntry then return end
            local cursor = editorEditBox:GetCursorPosition()
            editorEditBox:Insert(insertText .. (closeText or ""))
            if closeText then editorEditBox:SetCursorPosition(cursor + #insertText) end
            editorEditBox:SetFocus()
        end)
        return button
    end

    local tools = {
        EditorButton("|cffffcc00金|r", L.EDITOR_COLOR_GOLD, "|cffffcc00", "|r"),
        EditorButton("|cffffffff白|r", L.EDITOR_COLOR_WHITE, "|cffffffff", "|r"),
        EditorButton("|cffbbbbbb灰|r", L.EDITOR_COLOR_GRAY, "|cffbbbbbb", "|r"),
        EditorButton("|cffff5555红|r", L.EDITOR_COLOR_RED, "|cffff5555", "|r"),
        EditorButton("坦", L.EDITOR_ROLE_TANK, "|TInterface\\Icons\\Ability_Warrior_DefensiveStance:13:13|t "),
        EditorButton("疗", L.EDITOR_ROLE_HEALER, "|TInterface\\Icons\\Spell_Holy_Renew:13:13|t "),
        EditorButton("输", L.EDITOR_ROLE_DPS, "|TInterface\\Icons\\Ability_DualWield:13:13|t "),
        EditorButton("断", L.EDITOR_ROLE_INTERRUPT, "|TInterface\\Icons\\Ability_Kick:13:13|t "),
        EditorButton("•", L.EDITOR_BULLET, "\n• "),
        EditorButton("↵", L.EDITOR_NEWLINE, "\n"),
    }
    for index, button in ipairs(tools) do
        button:SetPoint("LEFT", toolbar, "LEFT", (index - 1) * 49, 0)
    end

    local editBg = CreateFrame("Frame", nil, tf4, "BackdropTemplate")
    editBg:SetPoint("TOPLEFT", toolbar, "BOTTOMLEFT", 0, -7)
    editBg:SetPoint("RIGHT", tf4, "RIGHT", -MARGIN, 0)
    editBg:SetHeight(175)
    editBg:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    editBg:SetBackdropColor(0.035, 0.035, 0.045, 0.96)
    editBg:SetBackdropBorderColor(0.35, 0.35, 0.38, 1)

    local editScroll = CreateFrame("ScrollFrame", nil, editBg, "UIPanelScrollFrameTemplate")
    editScroll:SetPoint("TOPLEFT", editBg, "TOPLEFT", 7, -7)
    editScroll:SetPoint("BOTTOMRIGHT", editBg, "BOTTOMRIGHT", -27, 7)

    editorEditBox = CreateFrame("EditBox", nil, editScroll)
    editorEditBox:SetMultiLine(true)
    editorEditBox:SetAutoFocus(false)
    editorEditBox:SetFontObject(GameFontNormal)
    editorEditBox:SetWidth(470)
    editorEditBox:SetHeight(160)
    editorEditBox:SetMaxLetters(8000)
    editorEditBox:SetTextInsets(2, 2, 2, 2)
    editorEditBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    editScroll:SetScrollChild(editorEditBox)

    local previewHeader = tf4:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    previewHeader:SetPoint("TOPLEFT", editBg, "BOTTOMLEFT", 0, -11)
    previewHeader:SetText(L.EDITOR_PREVIEW)
    previewHeader:SetTextColor(0.9, 0.75, 0.3, 1)

    local previewBg = CreateFrame("Frame", nil, tf4, "BackdropTemplate")
    previewBg:SetPoint("TOPLEFT", previewHeader, "BOTTOMLEFT", 0, -4)
    previewBg:SetPoint("RIGHT", tf4, "RIGHT", -MARGIN, 0)
    previewBg:SetHeight(90)
    previewBg:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background" })
    previewBg:SetBackdropColor(0, 0, 0, 0.72)

    editorPreviewText = previewBg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    editorPreviewText:SetPoint("TOPLEFT", previewBg, "TOPLEFT", 8, -7)
    editorPreviewText:SetPoint("BOTTOMRIGHT", previewBg, "BOTTOMRIGHT", -8, 7)
    editorPreviewText:SetJustifyH("LEFT")
    editorPreviewText:SetJustifyV("TOP")

    local saveBtn = CreateFrame("Button", nil, tf4, "UIPanelButtonTemplate")
    saveBtn:SetSize(110, 24)
    saveBtn:SetPoint("TOPLEFT", previewBg, "BOTTOMLEFT", 0, -9)
    saveBtn:SetText(L.EDITOR_SAVE)

    local clearBtn = CreateFrame("Button", nil, tf4, "UIPanelButtonTemplate")
    clearBtn:SetSize(110, 24)
    clearBtn:SetPoint("LEFT", saveBtn, "RIGHT", 8, 0)
    clearBtn:SetText(L.EDITOR_CLEAR)

    editorStatus = tf4:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    editorStatus:SetPoint("LEFT", clearBtn, "RIGHT", 10, 0)
    editorStatus:SetTextColor(0.7, 0.7, 0.7, 1)

    local function UpdateEditorPreview()
        local textValue = editorEditBox:GetText() or ""
        editorPreviewText:SetText(textValue ~= "" and textValue or ("|cff777777" .. L.EDITOR_EMPTY .. "|r"))
        local lines = editorEditBox.GetNumLines and editorEditBox:GetNumLines()
        if not lines then
            local _, newlineCount = textValue:gsub("\n", "\n")
            lines = newlineCount + 1
        end
        editorEditBox:SetHeight(math.max(160, lines * 15 + 12))
    end

    local function SaveEditorText(statusText)
        if not editorEntry then return end
        KwikTip:SetCustomTip(editorEntry.key, editorEditBox:GetText())
        editorDirty = false
        editorStatus:SetText(statusText or L.EDITOR_SAVED)
        editorStatus:SetTextColor(0.35, 0.9, 0.45, 1)
        KwikTip:UpdateContent()
    end

    local function LoadEditorEntry(entry)
        if editorDirty then SaveEditorText() end
        editorEntry = entry
        editorEntryBtn:SetText(entry and entry.label or "—")
        editorLoading = true
        editorEditBox:SetText((entry and KwikTip:GetCustomTip(entry.key)) or "")
        editorEditBox:SetCursorPosition(editorEditBox:GetNumLetters())
        editorLoading = false
        editorDirty = false
        editorStatus:SetText("")
        UpdateEditorPreview()
    end

    local function LoadEditorDungeon(dungeon)
        if editorDirty then SaveEditorText() end
        editorDungeon = dungeon
        editorDungeonBtn:SetText(dungeon and KwikTip:GetLocalizedDungeonName(dungeon) or L.EDITOR_NO_DUNGEONS)
        editorEntries = dungeon and KwikTip:GetTipEditorEntries(dungeon) or {}
        PopulateEditorMenu(editorEntryList, editorEntryRows, editorEntries,
            function(entry) return entry.label end,
            LoadEditorEntry)
        LoadEditorEntry(editorEntries[1])
    end

    local editorDungeons = KwikTip:GetEditableMythicPlusDungeons()
    PopulateEditorMenu(editorDungeonList, editorDungeonRows, editorDungeons,
        function(dungeon) return KwikTip:GetLocalizedDungeonName(dungeon) end,
        LoadEditorDungeon)

    editorDungeonBtn:SetScript("OnClick", function()
        editorEntryList:Hide()
        editorDungeonList:ClearAllPoints()
        editorDungeonList:SetPoint("TOPLEFT", editorDungeonBtn, "BOTTOMLEFT", 0, -2)
        editorDungeonList:SetShown(not editorDungeonList:IsShown())
    end)
    editorEntryBtn:SetScript("OnClick", function()
        editorDungeonList:Hide()
        editorEntryList:ClearAllPoints()
        editorEntryList:SetPoint("TOPLEFT", editorEntryBtn, "BOTTOMLEFT", 0, -2)
        editorEntryList:SetShown(not editorEntryList:IsShown())
    end)

    editorEditBox:SetScript("OnTextChanged", function()
        UpdateEditorPreview()
        if not editorLoading and editorEntry then
            editorDirty = true
            editorStatus:SetText(L.EDITOR_DIRTY)
            editorStatus:SetTextColor(1, 0.75, 0.2, 1)
        end
    end)
    editorEditBox:SetScript("OnCursorChanged", function(_, _, cursorY, _, cursorHeight)
        if not cursorY or not cursorHeight then return end
        local offset = editScroll:GetVerticalScroll()
        local height = editScroll:GetHeight()
        if -cursorY < offset then
            editScroll:SetVerticalScroll(math.max(0, -cursorY))
        elseif -cursorY + cursorHeight > offset + height then
            editScroll:SetVerticalScroll(-cursorY + cursorHeight - height)
        end
    end)
    saveBtn:SetScript("OnClick", function() SaveEditorText(L.EDITOR_SAVED) end)
    clearBtn:SetScript("OnClick", function()
        editorLoading = true
        editorEditBox:SetText("")
        editorLoading = false
        SaveEditorText(L.EDITOR_CLEARED)
        UpdateEditorPreview()
    end)

    LoadEditorDungeon(editorDungeons[1])

    -- Hide all floating dropdowns when the config window closes
    cfg:HookScript("OnHide", function()
        if editorDirty then SaveEditorText() end
        chatDropList:Hide()
        fontDropList:Hide()
        outlineDropList:Hide()
        editorDungeonList:Hide()
        editorEntryList:Hide()
    end)

    -- Initialise tab state (tab 1 shown, others hidden)
    SelectTab(1)

    -- ============================================================
    -- Internal helpers bound to KwikTip namespace
    -- ============================================================
    function self:_UpdateConfigMoveBtn()
        if not moveBtn then return end
        moveBtn:SetText(self.moveMode and L.BTN_LOCK or L.BTN_MOVE)
    end

    function self:PopulateConfig()
        local db = KwikTipCNDB
        minimapBtnCB:SetChecked(db.showMinimapBtn ~= false)
        hideHUDCB:SetChecked(db.persistentHide)
        showInDungeonCB:SetChecked(db.showInDungeon)
        autoExpandCB:SetChecked(db.autoExpand ~= false)
        showNoteBtnCB:SetChecked(db.showNoteBtn ~= false)
        enableDelvesCB:SetChecked(db.delves == true)
        SetChatChannel(db.printChannel or "NONE")
        opacitySlider:SetValue(math.floor(db.alpha * 100 + 0.5))
        SetFont(db.fontName or "Friz Quadrata")
        fontSizeSlider:SetValue(db.fontSize or 11)
        widthEdit:SetText(tostring(db.width or 220))
        heightEdit:SetText(tostring(db.height or 80))
        shadowCB:SetChecked(db.textShadow)
        SetOutline(db.textOutline or "")
        borderEnabledCB:SetChecked(db.borderEnabled ~= false)
        borderSwatchBtn:SetBackdropColor(db.borderColorR or 0, db.borderColorG or 0, db.borderColorB or 0, 1)
        self:_UpdateConfigMoveBtn()
    end

    -- Assigned last so a construction failure leaves self.Config nil and allows retry
    self.Config = cfg
end

-- ============================================================
-- Public API
-- ============================================================

-- Register a native Blizzard Settings > AddOns entry.  The full editor stays
-- in KwikTip's own resizable window; this canvas panel makes the addon
-- discoverable from the standard settings list and opens that window.
function KwikTip:RegisterSettingsPanel()
    if self.SettingsCategory or not Settings
        or not Settings.RegisterCanvasLayoutCategory
        or not Settings.RegisterAddOnCategory
    then
        return
    end

    local panel = CreateFrame("Frame", "KwikTipCNSettingsPanel", UIParent)
    panel.name = "KwikTip_CN"

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    title:SetPoint("TOPLEFT", panel, "TOPLEFT", 16, -16)
    title:SetText(L.SETTINGS_TITLE)

    local description = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -12)
    description:SetPoint("RIGHT", panel, "RIGHT", -24, 0)
    description:SetJustifyH("LEFT")
    description:SetText(L.SETTINGS_NATIVE_DESCRIPTION)

    local openButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    openButton:SetSize(220, 28)
    openButton:SetPoint("TOPLEFT", description, "BOTTOMLEFT", 0, -18)
    openButton:SetText(L.SETTINGS_OPEN_EDITOR)
    openButton:SetScript("OnClick", function()
        if SettingsPanel and SettingsPanel:IsShown() then SettingsPanel:Hide() end
        if not KwikTip.Config or not KwikTip.Config:IsShown() then
            KwikTip:ToggleConfig()
        end
    end)

    local hint = panel:CreateFontString(nil, "ARTWORK", "GameFontDisable")
    hint:SetPoint("TOPLEFT", openButton, "BOTTOMLEFT", 0, -12)
    hint:SetPoint("RIGHT", panel, "RIGHT", -24, 0)
    hint:SetJustifyH("LEFT")
    hint:SetText(L.SETTINGS_NATIVE_HINT)

    local category = Settings.RegisterCanvasLayoutCategory(panel, "KwikTip_CN")
    Settings.RegisterAddOnCategory(category)
    self.SettingsPanel = panel
    self.SettingsCategory = category
end

function KwikTip:ToggleConfig()
    if not self.Config then
        self:CreateConfigWindow()
    end
    if self.Config:IsShown() then
        self.Config:Hide()
    else
        self:PopulateConfig()
        self.Config:Show()
    end
end
