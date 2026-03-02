-- KwikTip: Config window and minimap button
local ADDON_NAME, KwikTip = ...

local MINIMAP_RADIUS = 80

-- ============================================================
-- Minimap Button
-- ============================================================
local minimapBtn = CreateFrame("Button", "KwikTipMinimapBtn", Minimap)
minimapBtn:SetSize(31, 31)
minimapBtn:SetFrameStrata("MEDIUM")
minimapBtn:SetFrameLevel(8)
minimapBtn:SetClampedToScreen(true)
minimapBtn:RegisterForDrag("LeftButton")
minimapBtn:Hide()
KwikTip.MinimapBtn = minimapBtn

local mmIcon = minimapBtn:CreateTexture(nil, "BACKGROUND")
mmIcon:SetTexture("Interface\\AddOns\\KwikTip\\assets\\ktmini.tga")
mmIcon:SetBlendMode("BLEND")
mmIcon:SetSize(31, 31)
mmIcon:SetPoint("CENTER")


local mmHighlight = minimapBtn:CreateTexture(nil, "HIGHLIGHT")
mmHighlight:SetColorTexture(1, 1, 1, 0.2)
mmHighlight:SetAllPoints(minimapBtn)

minimapBtn:SetScript("OnClick", function(self, btn)
    if btn == "LeftButton" then
        KwikTip:ToggleConfig()
    end
end)

minimapBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("KwikTip")
    GameTooltip:AddLine("Click to open settings", 1, 1, 1)
    GameTooltip:Show()
end)

minimapBtn:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

-- Drag around the minimap edge
minimapBtn:SetScript("OnDragStart", function(self)
    self:SetScript("OnUpdate", function()
        local cx, cy   = Minimap:GetCenter()
        local scale    = UIParent:GetEffectiveScale()
        local px, py   = GetCursorPosition()
        px, py         = px / scale, py / scale
        KwikTipDB.minimapAngle = math.deg(math.atan2(py - cy, px - cx))
        KwikTip:_PlaceMinimapBtn()
    end)
end)

minimapBtn:SetScript("OnDragStop", function(self)
    self:SetScript("OnUpdate", nil)
end)

local function _PlaceMinimapBtn()
    local angle = KwikTipDB and KwikTipDB.minimapAngle or 225
    local x = math.cos(math.rad(angle)) * MINIMAP_RADIUS
    local y = math.sin(math.rad(angle)) * MINIMAP_RADIUS
    minimapBtn:ClearAllPoints()
    minimapBtn:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

function KwikTip:_PlaceMinimapBtn()
    _PlaceMinimapBtn()
end

-- ============================================================
-- Config Window
-- ============================================================
local cfg = CreateFrame("Frame", "KwikTipConfig", UIParent, "BasicFrameTemplate")
cfg:SetSize(280, 490)
cfg:SetPoint("CENTER")
cfg:SetFrameStrata("HIGH")
cfg:SetMovable(true)
cfg:EnableMouse(true)
cfg:RegisterForDrag("LeftButton")
cfg:SetScript("OnDragStart", cfg.StartMoving)
cfg:SetScript("OnDragStop",  cfg.StopMovingOrSizing)
cfg:SetClampedToScreen(true)
cfg:Hide()
KwikTip.Config = cfg

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

-- ---- DISPLAY section -----------------------------------------
local dispHeader = cfg:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
dispHeader:SetPoint("TOPLEFT", moveBtn, "BOTTOMLEFT", 0, -14)
dispHeader:SetText("DISPLAY")
dispHeader:SetTextColor(0.6, 0.6, 0.6)

-- Checkbox: Show Minimap Button
local showMinimapCB = CreateFrame("CheckButton", "KwikTipShowMinimapCB", cfg, "UICheckButtonTemplate")
showMinimapCB:SetSize(24, 24)
showMinimapCB:SetPoint("TOPLEFT", dispHeader, "BOTTOMLEFT", 0, -4)

local showMinimapLbl = cfg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
showMinimapLbl:SetPoint("LEFT", showMinimapCB, "RIGHT", 2, 0)
showMinimapLbl:SetText("Show Minimap Button")

showMinimapCB:SetScript("OnClick", function(self)
    KwikTipDB.showMinimapButton = self:GetChecked()
    KwikTip:UpdateMinimapButton()
end)

-- Checkbox: Hide Info Window
local hideHUDCB = CreateFrame("CheckButton", "KwikTipHideHUDCB", cfg, "UICheckButtonTemplate")
hideHUDCB:SetSize(24, 24)
hideHUDCB:SetPoint("TOPLEFT", showMinimapCB, "BOTTOMLEFT", 0, -2)

local hideHUDLbl = cfg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
hideHUDLbl:SetPoint("LEFT", hideHUDCB, "RIGHT", 2, 0)
hideHUDLbl:SetText("Hide Info Window")

hideHUDCB:SetScript("OnClick", function(self)
    KwikTipDB.persistentHide = self:GetChecked()
    KwikTip:UpdateVisibility()
end)

-- ---- APPEARANCE section ---------------------------------------
local appHeader = cfg:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
appHeader:SetPoint("TOPLEFT", hideHUDCB, "BOTTOMLEFT", 0, -14)
appHeader:SetText("APPEARANCE")
appHeader:SetTextColor(0.6, 0.6, 0.6)

-- Slider factory — no Blizzard template dependencies.
-- Each slider is wrapped in an invisible frame so the whole group
-- (label + track + low/high text) anchors as a single unit.
-- Pass the previous slider's ._wrap as the anchor for subsequent sliders.
local function MakeSlider(name, parent, anchor, minVal, maxVal, step, initLabel, lowText, highText)
    local W = 230

    local wrap = CreateFrame("Frame", nil, parent)
    wrap:SetSize(W + 20, 40)
    wrap:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 8, -14)

    -- Dynamic label (updated with current value in OnValueChanged)
    local lbl = wrap:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    lbl:SetPoint("TOPLEFT", wrap, "TOPLEFT", 0, 0)
    lbl:SetText(initLabel)

    -- Slider track
    local s = CreateFrame("Slider", name, wrap)
    s:SetSize(W, 12)
    s:SetPoint("TOPLEFT", lbl, "BOTTOMLEFT", 0, -4)
    s:SetOrientation("HORIZONTAL")
    s:SetMinMaxValues(minVal, maxVal)
    s:SetValueStep(step)
    s:SetObeyStepOnDrag(true)
    s:EnableMouseWheel(true)

    -- Track fill
    local track = s:CreateTexture(nil, "BACKGROUND")
    track:SetColorTexture(0.2, 0.2, 0.2, 0.9)
    track:SetAllPoints(s)

    -- Thumb
    local thumb = s:CreateTexture(nil, "OVERLAY")
    thumb:SetColorTexture(0.75, 0.75, 0.75, 1)
    thumb:SetSize(10, 20)
    s:SetThumbTexture(thumb)

    -- Range labels
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

-- Opacity slider (10–100, stored as 0.10–1.00)
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

-- Width slider
local widthSlider = MakeSlider(
    "KwikTipWidthSlider", cfg, opacitySlider._wrap,
    100, 500, 10, "Width", "100", "500"
)
widthSlider:SetScript("OnValueChanged", function(self, value)
    KwikTipDB.width = value
    KwikTip.HUD:SetWidth(value)
    self._lbl:SetText("Width: " .. value)
end)

-- Height slider
local heightSlider = MakeSlider(
    "KwikTipHeightSlider", cfg, widthSlider._wrap,
    40, 300, 10, "Height", "40", "300"
)
heightSlider:SetScript("OnValueChanged", function(self, value)
    KwikTipDB.height = value
    KwikTip.HUD:SetHeight(value)
    self._lbl:SetText("Height: " .. value)
end)

-- ---- DEBUG section -------------------------------------------
local debugHeader = cfg:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
debugHeader:SetPoint("TOPLEFT", heightSlider._wrap, "BOTTOMLEFT", -8, -14)
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
end)

-- Logo at the bottom of the config window (477×200 source → 220×92 display)
local cfgLogo = cfg:CreateTexture(nil, "ARTWORK")
cfgLogo:SetTexture("Interface\\AddOns\\KwikTip\\assets\\ktlogo.tga")
cfgLogo:SetBlendMode("BLEND")
cfgLogo:SetSize(220, 120)
cfgLogo:SetPoint("BOTTOM", cfg, "BOTTOM", 0, 16)

-- ============================================================
-- Internal helpers
-- ============================================================

-- Sync the Move button label with the current move mode state.
function KwikTip:_UpdateConfigMoveBtn()
    if self.moveMode then
        moveBtn:SetText("Lock Window")
    else
        moveBtn:SetText("Move Window")
    end
end

-- Populate all controls from KwikTipDB before showing the config.
local function PopulateConfig()
    local db = KwikTipDB
    showMinimapCB:SetChecked(db.showMinimapButton)
    hideHUDCB:SetChecked(db.persistentHide)
    opacitySlider:SetValue(math.floor(db.alpha * 100 + 0.5))
    widthSlider:SetValue(db.width)
    heightSlider:SetValue(db.height)
    debugLogCB:SetChecked(db.debugLog)
    KwikTip:_UpdateConfigMoveBtn()
end

-- ============================================================
-- Public API
-- ============================================================

function KwikTip:ToggleConfig()
    if cfg:IsShown() then
        cfg:Hide()
    else
        PopulateConfig()
        cfg:Show()
    end
end

-- Show or hide the minimap button based on KwikTipDB.showMinimapButton.
function KwikTip:UpdateMinimapButton()
    if KwikTipDB.showMinimapButton then
        _PlaceMinimapBtn()
        minimapBtn:Show()
    else
        minimapBtn:Hide()
    end
end

-- Called once on login to position and conditionally show the minimap button.
function KwikTip:InitMinimapButton()
    _PlaceMinimapBtn()
    if KwikTipDB.showMinimapButton then
        minimapBtn:Show()
    end
end
