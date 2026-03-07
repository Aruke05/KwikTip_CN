-- KwikTip: Config window & minimap button
local ADDON_NAME, KwikTip = ...

-- ============================================================
-- Minimap Button
-- ============================================================
local RADIUS = 80  -- orbit radius from minimap center

function KwikTip:_PlaceMinimapBtn()
    if self.MinimapBtn then return end
    if not KwikTipDB.showMinimapBtn then return end

    local btn = CreateFrame("Button", "KwikTipMinimapBtn", Minimap)
    btn:SetSize(24, 24)
    btn:SetFrameStrata("MEDIUM")
    btn:SetFrameLevel(Minimap:GetFrameLevel() + 5)
    btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    btn:RegisterForDrag("LeftButton")

    local tex = btn:CreateTexture(nil, "OVERLAY")
    tex:SetTexture("Interface\\AddOns\\KwikTip\\assets\\ktmini.tga")
    tex:SetBlendMode("BLEND")
    tex:SetAllPoints(btn)

    local function UpdatePosition()
        local angle = KwikTipDB.minimapAngle or 0
        local x = math.cos(angle) * RADIUS
        local y = math.sin(angle) * RADIUS
        btn:ClearAllPoints()
        btn:SetPoint("CENTER", Minimap, "CENTER", x, y)
    end

    btn:SetScript("OnLoad", UpdatePosition)
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
            local scale = Minimap:GetEffectiveScale()
            local dx = (px / scale - mx) / Minimap:GetWidth()
            local dy = (py / scale - my) / Minimap:GetHeight()
            KwikTipDB.minimapAngle = math.atan2(dy, dx)
            UpdatePosition()
        end)
    end)

    btn:SetScript("OnDragStop", function(self)
        self:UnlockHighlight()
        self:SetScript("OnUpdate", nil)
    end)

    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("KwikTip", 1, 1, 1)
        GameTooltip:AddLine("Left-click: Settings", 0.7, 0.7, 0.7)
        GameTooltip:AddLine("Right-click: Move HUD", 0.7, 0.7, 0.7)
        GameTooltip:AddLine("Drag: Reposition", 0.7, 0.7, 0.7)
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
    if KwikTipDB.showMinimapBtn then
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

    local cfg = CreateFrame("Frame", "KwikTipConfig", UIParent, "BasicFrameTemplate")
    cfg:SetSize(280, 520)
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
    end)
    cfg:Hide()
    self.Config = cfg

    cfg.TitleText:SetText("KwikTip Settings")

    local titleIcon = cfg:CreateTexture(nil, "OVERLAY")
    titleIcon:SetTexture("Interface\\AddOns\\KwikTip\\assets\\ktmini.tga")
    titleIcon:SetBlendMode("BLEND")
    titleIcon:SetSize(16, 16)
    titleIcon:SetPoint("RIGHT", cfg.TitleText, "LEFT", -4, 0)

    -- ---- POSITION section ----------------------------------------
    local posHeader = cfg:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    posHeader:SetPoint("TOPLEFT", cfg, "TOPLEFT", 12, -32)
    posHeader:SetText("POSITION")
    posHeader:SetTextColor(0.6, 0.6, 0.6)

    local moveBtn = CreateFrame("Button", "KwikTipConfigMoveBtn", cfg, "UIPanelButtonTemplate")
    moveBtn:SetSize(110, 22)
    moveBtn:SetPoint("TOPLEFT", posHeader, "BOTTOMLEFT", 0, -6)
    moveBtn:SetText("Move Window")

    moveBtn:SetScript("OnClick", function()
        KwikTip:ToggleMoveMode()
    end)

    local function MakeNudgeRow(label, parent, anchor)
        local wrap = CreateFrame("Frame", nil, parent)
        wrap:SetSize(256, 24)
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

    -- ---- DISPLAY section -----------------------------------------
    local dispHeader = cfg:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    dispHeader:SetPoint("TOPLEFT", moveBtn, "BOTTOMLEFT", 0, -14)
    dispHeader:SetText("DISPLAY")
    dispHeader:SetTextColor(0.6, 0.6, 0.6)

    -- Checkbox: Show Minimap Button
    local minimapBtnCB = CreateFrame("CheckButton", "KwikTipMinimapBtnCB", cfg, "UICheckButtonTemplate")
    minimapBtnCB:SetSize(24, 24)
    minimapBtnCB:SetPoint("TOPLEFT", dispHeader, "BOTTOMLEFT", 0, -4)

    local minimapBtnLbl = cfg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    minimapBtnLbl:SetPoint("LEFT", minimapBtnCB, "RIGHT", 2, 0)
    minimapBtnLbl:SetText("Show Minimap Button")

    minimapBtnCB:SetScript("OnClick", function(self)
        KwikTipDB.showMinimapBtn = self:GetChecked()
        if KwikTip._PlaceMinimapBtn then KwikTip:_PlaceMinimapBtn() end
        if KwikTip._UpdateMinimapButton then KwikTip:_UpdateMinimapButton() end
    end)

    -- Checkbox: Hide Info Window
    local hideHUDCB = CreateFrame("CheckButton", "KwikTipHideHUDCB", cfg, "UICheckButtonTemplate")
    hideHUDCB:SetSize(24, 24)
    hideHUDCB:SetPoint("TOPLEFT", minimapBtnCB, "BOTTOMLEFT", 0, -2)

    local hideHUDLbl = cfg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    hideHUDLbl:SetPoint("LEFT", hideHUDCB, "RIGHT", 2, 0)
    hideHUDLbl:SetText("Hide Info Window")

    hideHUDCB:SetScript("OnClick", function(self)
        KwikTipDB.persistentHide = self:GetChecked()
        KwikTip:UpdateVisibility()
    end)

    -- Checkbox: Keep Open Through Instance
    local showInDungeonCB = CreateFrame("CheckButton", "KwikTipShowInDungeonCB", cfg, "UICheckButtonTemplate")
    showInDungeonCB:SetSize(24, 24)
    showInDungeonCB:SetPoint("TOPLEFT", hideHUDCB, "BOTTOMLEFT", 0, -2)

    local showInDungeonLbl = cfg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    showInDungeonLbl:SetPoint("LEFT", showInDungeonCB, "RIGHT", 2, 0)
    showInDungeonLbl:SetText("Keep Open Through Instance")

    showInDungeonCB:SetScript("OnClick", function(self)
        KwikTipDB.showInDungeon = self:GetChecked()
        KwikTip:UpdateContent()
        KwikTip:UpdateVisibility()
    end)

    -- ---- APPEARANCE section ---------------------------------------
    local appHeader = cfg:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    appHeader:SetPoint("TOPLEFT", showInDungeonCB, "BOTTOMLEFT", 0, -14)
    appHeader:SetText("APPEARANCE")
    appHeader:SetTextColor(0.6, 0.6, 0.6)

    local function MakeSlider(name, parent, anchor, minVal, maxVal, step, initLabel, lowText, highText)
        local W = 230

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

    local opacitySlider = MakeSlider(
        "KwikTipOpacitySlider", cfg, appHeader,
        10, 100, 5, "Opacity", "10%", "100%"
    )
    opacitySlider:SetScript("OnValueChanged", function(self, value)
        local alpha = value / 100
        KwikTipDB.alpha = alpha
        KwikTip.HUD:SetBackdropColor(0, 0, 0, alpha)
        self._lbl:SetText(string.format("Opacity: %d%%", value))
    end)

    local widthEdit, heightEdit

    local function ApplySize(w, h)
        w = math.max(100, math.min(600, math.floor(tonumber(w) or KwikTipDB.width or 220)))
        h = math.max(40,  math.min(400, math.floor(tonumber(h) or KwikTipDB.height or 80)))
        KwikTipDB.width  = w
        KwikTipDB.height = h
        if KwikTip.HUD then KwikTip.HUD:SetSize(w, h) end
        widthEdit:SetText(tostring(w))
        heightEdit:SetText(tostring(h))
    end

    local widthRow, widthMinus, widthPlus
    widthRow, widthEdit, widthMinus, widthPlus = MakeNudgeRow("W:", cfg, opacitySlider._wrap)
    widthEdit:SetScript("OnEnterPressed", function(self)
        ApplySize(self:GetText(), KwikTipDB.height)
        self:ClearFocus()
    end)
    widthEdit:SetScript("OnEscapePressed", function(self)
        self:SetText(tostring(KwikTipDB.width or 220))
        self:ClearFocus()
    end)
    widthMinus:SetScript("OnClick", function() ApplySize((KwikTipDB.width or 220) - 1, KwikTipDB.height) end)
    widthPlus:SetScript("OnClick",  function() ApplySize((KwikTipDB.width or 220) + 1, KwikTipDB.height) end)

    local heightRow, heightMinus, heightPlus
    heightRow, heightEdit, heightMinus, heightPlus = MakeNudgeRow("H:", cfg, widthRow)
    heightEdit:SetScript("OnEnterPressed", function(self)
        ApplySize(KwikTipDB.width, self:GetText())
        self:ClearFocus()
    end)
    heightEdit:SetScript("OnEscapePressed", function(self)
        self:SetText(tostring(KwikTipDB.height or 80))
        self:ClearFocus()
    end)
    heightMinus:SetScript("OnClick", function() ApplySize(KwikTipDB.width, (KwikTipDB.height or 80) - 1) end)
    heightPlus:SetScript("OnClick",  function() ApplySize(KwikTipDB.width, (KwikTipDB.height or 80) + 1) end)

    -- ---- DEBUG section -------------------------------------------
    local debugHeader = cfg:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    debugHeader:SetPoint("TOPLEFT", heightRow, "BOTTOMLEFT", -8, -14)
    debugHeader:SetText("DEBUG")
    debugHeader:SetTextColor(0.6, 0.6, 0.6)

    local debugLogCB = CreateFrame("CheckButton", "KwikTipDebugLogCB", cfg, "UICheckButtonTemplate")
    debugLogCB:SetSize(24, 24)
    debugLogCB:SetPoint("TOPLEFT", debugHeader, "BOTTOMLEFT", 0, -4)

    local debugLogLbl = cfg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    debugLogLbl:SetPoint("LEFT", debugLogCB, "RIGHT", 2, 0)
    debugLogLbl:SetText("Log Map IDs to SavedVariables")

    debugLogCB:SetScript("OnClick", function(self)
        KwikTipDB.debugLog = self:GetChecked()
        KwikTip:UpdateContent()
    end)

    local cfgLogo = cfg:CreateTexture(nil, "ARTWORK")
    cfgLogo:SetTexture("Interface\\AddOns\\KwikTip\\assets\\ktlogo.tga")
    cfgLogo:SetBlendMode("BLEND")
    cfgLogo:SetSize(220, 120)
    cfgLogo:SetPoint("BOTTOM", cfg, "BOTTOM", 0, 16)

    -- Internal helpers bound to KwikTip namespace
    function self:_UpdateConfigMoveBtn()
        if not moveBtn then return end
        if self.moveMode then
            moveBtn:SetText("Lock Window")
        else
            moveBtn:SetText("Move Window")
        end
    end

    function self:PopulateConfig()
        local db = KwikTipDB
        minimapBtnCB:SetChecked(db.showMinimapBtn ~= false)
        hideHUDCB:SetChecked(db.persistentHide)
        showInDungeonCB:SetChecked(db.showInDungeon)
        opacitySlider:SetValue(math.floor(db.alpha * 100 + 0.5))
        widthEdit:SetText(tostring(db.width or 220))
        heightEdit:SetText(tostring(db.height or 80))
        debugLogCB:SetChecked(db.debugLog)
        self:_UpdateConfigMoveBtn()
    end
end

-- ============================================================
-- Public API
-- ============================================================

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
